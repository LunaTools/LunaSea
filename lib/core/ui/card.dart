import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';

class LunaCard extends Card {
    LunaCard({
        Key key,
        @required BuildContext context,
        @required Widget child,
        EdgeInsets margin = LunaUI.MARGIN_CARD,
        Color color,
        Decoration decoration,
        double height,
    }) : super(
        key: key,
        child: Container(child: child, decoration: decoration, height: height),
        margin: margin,
        color: color == null ? Theme.of(context).primaryColor : color,
        shape: LunaUI.shapeBorder,
        elevation: LunaUI.ELEVATION,
        clipBehavior: Clip.antiAlias,
    ) {
        assert(context != null);
        assert(child != null);
    }
}
