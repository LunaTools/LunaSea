import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lunasea/core.dart';

class LunaFirebaseMessaging {
    /// Returns an instance of [FirebaseMessaging].
    /// 
    /// Throws an error if [LunaFirebase.initialize] has not been called.
    static FirebaseMessaging get instance => FirebaseMessaging.instance;

    /// Returns a [Stream] to handle any new messages that are received while the application is in the open and in foreground.
    Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;

    /// Returns a [Stream] to handle any notifications that are tapped while the application is in the background (not terminated).
    Stream<RemoteMessage> get onMessageOpenedApp => FirebaseMessaging.onMessageOpenedApp;

    /// Returns the Firebase Cloud Messaging device token for this device.
    Future<String> get token async => instance.getToken();

    /// Request for permission to send a user notifications.
    /// 
    /// Returns true if permissions are allowed at either a full or provisional level.
    /// Returns false if permissions are denied or not determined.
    Future<bool> requestNotificationPermissions() async {
        NotificationSettings settings = await instance.requestPermission();
        switch(settings.authorizationStatus) {
            case AuthorizationStatus.authorized:
            case AuthorizationStatus.provisional: return true;
            case AuthorizationStatus.denied:
            case AuthorizationStatus.notDetermined:
            default: return false;
        }
    }

    /// Return a [StreamSubscription] that will show a notification banner on a newly received notification.
    /// 
    /// This listens on [FirebaseMessaging.onMessage], where the application must be open and in the foreground.
    StreamSubscription<RemoteMessage> onMessageListener() {
        return onMessage.listen((message) {
            if(message == null) return;
            LunaModule module = (message.data ?? {}).isNotEmpty ? LunaModule.DASHBOARD.fromKey(message.data['module']) : null;
            showLunaSnackBar(
                title: message.notification?.title ?? 'Unknown Content',
                message: message.notification?.body ?? LunaUI.TEXT_EMDASH,
                type: LunaSnackbarType.INFO,
                position: FlashPosition.top,
                duration: Duration(seconds: 6, milliseconds: 750),
                showButton: module != null,
                buttonOnPressed: () async => _handleWebhook(message),
            );
        });
    }

    /// Returns a [StreamSubscription] that will handle messages/notifications that are opened while LunaSea is running in the background.
    /// 
    /// This listens on [FirebaseMessaging.onMessageOpenedApp], where the application must be open but in the background.
    StreamSubscription<RemoteMessage> onMessageOpenedAppListener() => onMessageOpenedApp.listen(_handleWebhook);

    /// Check to see if there was an initial [RemoteMessage] available to be accessed.
    /// 
    /// If so, handles the notification webhook.
    Future<void> checkAndHandleInitialMessage() async {
        RemoteMessage message = await FirebaseMessaging.instance.getInitialMessage();
        _handleWebhook(message);
    }

    /// Shared webhook handler.
    Future<void> _handleWebhook(RemoteMessage message) async {
        if(message == null || (message.data ?? {}).isEmpty) return;
        // Extract module
        LunaModule module = LunaModule.DASHBOARD.fromKey(message.data['module']);
        if(module == null) {
            LunaLogger().warning(
                'LunaFirebaseMessaging',
                '_handleWebhook',
                'Unknown module found inside of RemoteMessage: ${message.data['module'] ?? 'null'}',
            );
            return;
        }
        String profile = message.data['profile'];
        if(profile?.isEmpty ?? true) {
            LunaLogger().warning(
                'LunaFirebaseMessaging',
                '_handleWebhook',
                'Invalid profile received in webhook: ${message.data['profile'] ?? 'null'}',
            );
            return;
        }
        bool result = await LunaProfile().safelyChangeProfiles(profile);
        if(result) {
            module?.handleWebhook(message.data);
        } else {
            showLunaErrorSnackBar(title: 'Unknown Profile', message: '"$profile" does not exist in LunaSea');
        }
    }
}
