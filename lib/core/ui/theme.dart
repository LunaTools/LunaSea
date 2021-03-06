import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lunasea/core.dart';

class LunaTheme {
    /// Returns the active [ThemeData] by checking the theme database value.
    ThemeData activeTheme() {
        return LunaDatabaseValue.THEME_AMOLED.data ? _pureBlackTheme() : _midnightTheme();
    }

    /// Midnight theme (Default)
    ThemeData _midnightTheme() {
        return ThemeData(
            brightness: Brightness.dark,
            canvasColor: LunaColours.primary,
            primaryColor: LunaColours.secondary,
            accentColor: LunaColours.accent,
            highlightColor: LunaColours.splash.withOpacity(0.15),
            cardColor: LunaColours.secondary,
            splashColor: LunaColours.accent.withOpacity(0.30),
            dialogBackgroundColor: LunaColours.secondary,
            toggleableActiveColor: LunaColours.accent,
            iconTheme: IconThemeData(
                color: Colors.white,
            ),
            unselectedWidgetColor: Colors.white,
            textTheme: _sharedTextTheme,
            textButtonTheme: _sharedTextButtonThemeData,
            visualDensity: VisualDensity.adaptivePlatformDensity,
        );
    }

    /// AMOLED/Pure black theme
    ThemeData _pureBlackTheme() {
        return ThemeData(
            brightness: Brightness.dark,
            canvasColor: Colors.black,
            primaryColor: Colors.black,
            accentColor: LunaColours.accent,
            highlightColor: LunaColours.splash.withOpacity(0.15),
            cardColor: Colors.black,
            splashColor: LunaColours.accent.withOpacity(0.30),
            dialogBackgroundColor: Colors.black,
            toggleableActiveColor: LunaColours.accent,
            iconTheme: IconThemeData(
                color: Colors.white,
            ),
            unselectedWidgetColor: Colors.white,
            textTheme: _sharedTextTheme,
            textButtonTheme: _sharedTextButtonThemeData,
            visualDensity: VisualDensity.adaptivePlatformDensity,
        );
    }

    TextTheme get _sharedTextTheme {
        const textStyle = TextStyle(color: Colors.white);
        return TextTheme(
            bodyText1: textStyle,
            bodyText2: textStyle,
            headline1: textStyle,
            headline2: textStyle,
            headline3: textStyle,
            headline4: textStyle,
            headline5: textStyle,
            headline6: textStyle,
            button: textStyle,
            caption: textStyle,
            subtitle1: textStyle,
            subtitle2: textStyle,
            overline: textStyle,
        );
    }

    TextButtonThemeData get _sharedTextButtonThemeData {
        return TextButtonThemeData(
            style: ButtonStyle(
                overlayColor: MaterialStateProperty.all<Color>(LunaColours.splash.withOpacity(0.30)),
            ),
        );
    }
}
