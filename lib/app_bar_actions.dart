import 'dart:io';

import 'package:flutter/material.dart';
import 'package:missa_maa_oon/about_route.dart';
import 'package:missa_maa_oon/isar_service.dart';
import 'package:missa_maa_oon/static.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

void confirmDeletionDialog(BuildContext context, IsarService service) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Haluatko varmasti poistaa kaikki tiedot?'),
        actions: [
          TextButton(
            child: const Text('Peruuta'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Poista'),
            onPressed: () {
              service.cleanDb();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Kaikki tiedot poistettu'),
                ),
              );
            },
          ),
        ],
      );
    },
  );
}

Future<void> onSelectedAppBarValues(
    AppBarValues result, BuildContext context, IsarService service) async {
  switch (result) {
    case AppBarValues.export:
      var tempPath = (await getTemporaryDirectory()).path;
      var positionsAsTxt = await service.getAllPositionsAsTxt();

      var tempFile = File('$tempPath/$tempFileName');
      await tempFile.writeAsString(positionsAsTxt);

      Share.shareXFiles([XFile(tempFile.path)]);
      break;
    case AppBarValues.deleteAll:
      confirmDeletionDialog(context, service);
      break;
    case AppBarValues.about:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AboutRoute()),
      );
      break;
    default:
      throw Exception('Unknown AppBarValues');
  }
}

List<Widget> appBarActions(Function(AppBarValues) onSelectedAppBarValues) {
  return [
    PopupMenuButton<AppBarValues>(
      onSelected: onSelectedAppBarValues,
      tooltip: 'Valikko',
      icon: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<AppBarValues>>[
        const PopupMenuItem<AppBarValues>(
          value: AppBarValues.export,
          child: ListTile(
            leading: Icon(Icons.save),
            title: Text('Vie kaikki'),
          ),
        ),
        const PopupMenuItem<AppBarValues>(
          value: AppBarValues.deleteAll,
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text('Poista kaikki'),
          ),
        ),
        const PopupMenuItem<AppBarValues>(
          value: AppBarValues.about,
          child: ListTile(
            leading: Icon(Icons.info),
            title: Text('Tietoja'),
          ),
        ),
      ],
    ),
  ];
}
