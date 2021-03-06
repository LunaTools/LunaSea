import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/tautulli.dart';

class TautulliLogsTautulliTile extends StatelessWidget {
    @override
    Widget build(BuildContext context) => LSCardTile(
        title: LSTitle(text: 'Tautulli'),
        subtitle: LSSubtitle(text: 'Tautulli Logs'),
        trailing: LSIconButton(
            icon: LunaIcons.tautulli,
            color: LunaColours.list(5),
        ),
        onTap: () async => _onTap(context),
    );

    Future<void> _onTap(BuildContext context) async => TautulliLogsTautulliRouter.navigateTo(context);
}
