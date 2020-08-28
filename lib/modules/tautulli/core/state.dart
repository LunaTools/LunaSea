import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/tautulli.dart' hide Tautulli;
import 'package:tautulli/tautulli.dart';

class TautulliState extends ChangeNotifier {
    TautulliState() {
        reset(initialize: true);
    }
    
    /// Reset the state of Tautulli back to the default
    /// 
    /// If `initialize` is true, resets everything, else it resets the profile + data.
    /// If false, the navigation index, etc. are not reset.
    void reset({ bool initialize = false }) {
        resetProfile();
        resetActivity();
        resetUsers();
        resetHistory();
        resetSyncedItems();
        if(initialize) {
            _navigationIndex = TautulliDatabaseValue.NAVIGATION_INDEX.data;
            _userDetailsNavigationIndex = 0;
        }
        notifyListeners();
    }

    /**********
    * PROFILE *
    **********/

    /// API handler instance
    Tautulli _api;
    Tautulli get api => _api;

    /// Is the API enabled?
    bool _enabled;
    bool get enabled => _enabled;

    /// Tautulli host
    String _host;
    String get host => _host;

    /// Tautulli API key
    String _apiKey;
    String get apiKey => _apiKey;

    /// Is strict TLS enabled?
    bool _strictTLS;
    bool get strictTLS => _strictTLS;

    /// Headers to attach to all requests
    Map<dynamic, dynamic> _headers;
    Map<dynamic, dynamic> get headers => _headers;

    /// Reset the profile data, reinitializes API instance
    void resetProfile() {
        ProfileHiveObject _profile = Database.currentProfileObject;
        // Copy profile into state
        _enabled = _profile.tautulliEnabled ?? false;
        _host = _profile.tautulliHost ?? '';
        _apiKey = _profile.tautulliKey ?? '';
        _strictTLS = _profile.tautulliStrictTLS ?? true;
        _headers = _profile.tautulliHeaders ?? {};
        // Create the API instance if Tautulli is enabled
        _api = _enabled
            ? Tautulli(
                host: _host,
                apiKey: _apiKey,
                strictTLS: _strictTLS,
                headers: Map<String, dynamic>.from(_headers),
            )
            : null;
    }

    /*************
    * NAVIGATION *
    *************/

    /// Index for the main page navigation bar
    int _navigationIndex;
    int get navigationIndex => _navigationIndex;
    set navigationIndex(int navigationIndex) {
        assert(navigationIndex != null);
        _navigationIndex = navigationIndex;
        notifyListeners();
    }

    int _userDetailsNavigationIndex;
    int get userDetailsNavigationIndex => _userDetailsNavigationIndex;
    set userDetailsNavigationIndex(int userDetailsNavigationIndex) {
        assert(userDetailsNavigationIndex != null);
        _userDetailsNavigationIndex = userDetailsNavigationIndex;
        notifyListeners();
    }

    /***********
    * ACTIVITY *
    ************/
    
    /// Timer to handle refreshing activity data
    Timer _getActivityTimer;

    /// Create the periodic timer to handle refreshing activity data
    void createActivityTimer() => _getActivityTimer = Timer.periodic(
        Duration(seconds: TautulliDatabaseValue.REFRESH_RATE.data),
        (_) => activity = _api.activity.getActivity(),
    );

    /// Cancel the periodic timer
    void cancelActivityTimer() => _getActivityTimer?.cancel();

    /// Storing activity data
    Future<TautulliActivity> _activity;
    Future<TautulliActivity> get activity => _activity;
    set activity(Future<TautulliActivity> activity) {
        assert(activity != null);
        _activity = activity;
        notifyListeners();
    }

    /// Reset the activity by:
    /// - Cancelling the timer
    /// - Recreating the timer
    /// - Setting the initial state of the future to an instance of the API call
    void resetActivity() {
        cancelActivityTimer();
        _activity = null;
        if(_api != null) {
            _activity = _api.activity.getActivity();
            createActivityTimer();
        }
        notifyListeners();
    }

    /********
    * USERS *
    ********/

    /// Storing the user table
    Future<TautulliUsersTable> _users;
    Future<TautulliUsersTable> get users => _users;
    set users(Future<TautulliUsersTable> users) {
        assert(users != null);
        _users = users;
        notifyListeners();
    }

    /// Storing individual user profile data
    Map<int, Future<TautulliUser>> _userProfile;
    Map<int, Future<TautulliUser>> get userProfile => _userProfile;
    void setUserProfile(int userId, Future<TautulliUser> data) {
        assert(userId != null);
        assert(data != null);
        _userProfile[userId] = data;
        notifyListeners();
    }

    /// Storing individual user synced items
    Map<int, Future<List<TautulliSyncedItem>>> _userSyncedItems;
    Map<int, Future<List<TautulliSyncedItem>>> get userSyncedItems => _userSyncedItems;
    void setUserSyncedItems(int userId, Future<List<TautulliSyncedItem>> data) {
        assert(userId != null);
        assert(data != null);
        _userSyncedItems[userId] = data;
        notifyListeners();
    }

    /// Storing individual user IP addresses
    Map<int, Future<TautulliUserIPs>> _userIPs;
    Map<int, Future<TautulliUserIPs>> get userIPs => _userIPs;
    void setUserIPs(int userId, Future<TautulliUserIPs> data) {
        assert(userId != null);
        assert(data != null);
        _userIPs[userId] = data;
        notifyListeners();
    }

    /// Storing individual user watch time stats
    Map<int, Future<List<TautulliUserWatchTimeStats>>> _userWatchStats;
    Map<int, Future<List<TautulliUserWatchTimeStats>>> get userWatchStats => _userWatchStats;
    void setUserWatchStats(int userId, Future<List<TautulliUserWatchTimeStats>> data) {
        assert(userId != null);
        assert(data != null);
        _userWatchStats[userId] = data;
        notifyListeners();
    }

    /// Storing individual user player stats
    Map<int, Future<List<TautulliUserPlayerStats>>> _userPlayerStats;
    Map<int, Future<List<TautulliUserPlayerStats>>> get userPlayerStats => _userPlayerStats;
    void setUserPlayerStats(int userId, Future<List<TautulliUserPlayerStats>> data) {
        assert(userId != null);
        assert(data != null);
        _userPlayerStats[userId] = data;
        notifyListeners();
    }

    Map<int, Future<TautulliHistory>> _userHistory;
    Map<int, Future<TautulliHistory>> get userHistory => _userHistory;
    void setUserHistory(int userId, Future<TautulliHistory> data) {
        assert(userId != null);
        assert(data != null);
        _userHistory[userId] = data;
        notifyListeners();
    }

    /// Reset the users by:
    /// - Setting the intial state of the future to an instance of the API call
    /// - Resets individual user data maps
    void resetUsers({ bool hardReset = true }) {
        // Clear if hard reset
        if(hardReset) {
            _users = null;
            _userProfile = {};
            _userSyncedItems = {};
            _userIPs = {};
            _userWatchStats = {};
            _userPlayerStats = {};
            _userHistory = {};
        }
        // Reset user table
        if(_api != null) {
            _users = _api.users.getUsersTable(
                length: TautulliDatabaseValue.CONTENT_LOAD_LENGTH.data,
                orderDirection: TautulliOrderDirection.ASCENDING,
                orderColumn: TautulliUsersOrderColumn.FRIENDLY_NAME,
            );
        }
        notifyListeners();
    }

    /**********
    * HISTORY *
    **********/

    /// Storing the history table
    Future<TautulliHistory> _history;
    Future<TautulliHistory> get history => _history;
    set history(Future<TautulliHistory> history) {
        assert(history != null);
        _history = history;
        notifyListeners();
    }

    /// Reset the history by:
    /// - Setting the intial state of the future to an instance of the API call
    void resetHistory() {
        // Reset user table
        if(_api != null) {
            _history = _api.history.getHistory(
                length: TautulliDatabaseValue.CONTENT_LOAD_LENGTH.data,
                orderDirection: TautulliOrderDirection.ASCENDING,
            );
        }
        notifyListeners();
    }

    /***************
    * SYNCED ITEMS *
    ***************/

    /// Storing the synced items table
    Future<List<TautulliSyncedItem>> _syncedItems;
    Future<List<TautulliSyncedItem>> get syncedItems => _syncedItems;
    set syncedItems(Future<List<TautulliSyncedItem>> syncedItems) {
        assert(syncedItems != null);
        _syncedItems = syncedItems;
        notifyListeners();
    }

    void resetSyncedItems() {
        // Reset the synced items table
        if(_api != null) {
            _syncedItems = _api.libraries.getSyncedItems();
        }
        notifyListeners();
    }

    /*********
    * IMAGES *
    *********/

    /// Get the direct URL to an image via `pms_image_proxy` using a rating key.
    String getImageURLFromRatingKey(int ratingKey) => host.endsWith('/')
        ? '${host}api/v2?apikey=$apiKey&cmd=pms_image_proxy&rating_key=$ratingKey'
        : '$host/api/v2?apikey=$apiKey&cmd=pms_image_proxy&rating_key=$ratingKey';

    /// Get the direct URL to an image via `pms_image_proxy` using an image path.
    String getImageURLFromPath(String path) => host.endsWith('/')
        ? '${host}api/v2?apikey=$apiKey&cmd=pms_image_proxy&img=$path'
        : '$host/api/v2?apikey=$apiKey&cmd=pms_image_proxy&img=$path';
}
