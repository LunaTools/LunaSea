import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
export 'ui/appbar.dart';
export 'ui/bottom_modal_sheet.dart';
export 'ui/bottom_navigation_bar.dart';
export 'ui/button.dart';
export 'ui/card.dart';
export 'ui/colors.dart';
export 'ui/containers.dart';
export 'ui/controllers.dart';
export 'ui/decoration.dart';
export 'ui/deprecated.dart';
export 'ui/divider.dart';
export 'ui/drawer.dart';
export 'ui/header.dart';
export 'ui/highlighted_node.dart';
export 'ui/icons.dart';
export 'ui/input_bar.dart';
export 'ui/invalid_route.dart';
export 'ui/list_tile.dart';
export 'ui/list_view.dart';
export 'ui/loader.dart';
export 'ui/message.dart';
export 'ui/network_image.dart';
export 'ui/popup_menu_button.dart';
export 'ui/refresh_indicator.dart';
export 'ui/shape.dart';
export 'ui/sliver_sticky_header.dart';
export 'ui/snackbar.dart';
export 'ui/switch.dart';
export 'ui/table.dart';
export 'ui/text.dart';
export 'ui/theme.dart';

class LunaUI {
    // Text Constants
    static const String         TEXT_ARROW_LEFT = '←';
    static const String         TEXT_ARROW_RIGHT = '→';
    static const String         TEXT_BULLET = '•';
    static const String         TEXT_ELLIPSIS = '…';
    static const String         TEXT_EMDASH = '—';
    // Font-Related
    static const double         FONT_SIZE_APP_BAR = 18.0;
    static const double         FONT_SIZE_BUTTON = 14.0;
    static const double         FONT_SIZE_GRAPH_LEGEND = 10.0;
    static const double         FONT_SIZE_HEADER = 18.0;
    static const double         FONT_SIZE_HIGHLIGHTED_NODE = 12.0;
    static const double         FONT_SIZE_MESSAGES = 16.0;
    static const double         FONT_SIZE_NAVIGATION_BAR = 13.0;
    static const double         FONT_SIZE_SUBHEADER = 12.0;
    static const double         FONT_SIZE_SUBTITLE = 13.0;
    static const double         FONT_SIZE_TITLE = 16.0;
    static const FontWeight     FONT_WEIGHT_BOLD = FontWeight.w600;
    // UI-Related
    static const int            ANIMATION_SPEED = 250;
    static const int            ANIMATION_IMAGE_FADE_IN_SPEED = 125;
    static const double         BORDER_RADIUS = 10.0;
    static const double         ELEVATION = 0.0;
    static const EdgeInsets     MARGIN_CARD = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0);
    // Border-Related
    static bool get shouldUseBorder => LunaDatabaseValue.THEME_AMOLED.data && LunaDatabaseValue.THEME_AMOLED_BORDER.data;
    static ShapeBorder get shapeBorder => shouldUseBorder ? LunaShapeBorder.roundedWithBorder() : LunaShapeBorder.rounded();
}
