import 'package:flutter/material.dart';
import 'package:missa_maa_oon/static.dart';

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
            title: Text('Vie kaikki tietokannasta'),
          ),
        ),
        const PopupMenuItem<AppBarValues>(
          value: AppBarValues.deleteAll,
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text('Poista kaikki tietokannasta'),
          ),
        ),
        const PopupMenuItem<AppBarValues>(
          value: AppBarValues.about,
          child: ListTile(
            leading: Icon(Icons.info),
            title: Text('Tietoja sovelluksesta'),
          ),
        ),
      ],
    ),
  ];
}
