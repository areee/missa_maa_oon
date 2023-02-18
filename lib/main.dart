import 'dart:io';

import 'package:flutter/material.dart';
import 'package:missa_maa_oon/add_modal.dart';
import 'package:missa_maa_oon/app_bar_actions.dart';
import 'package:missa_maa_oon/date_helper.dart';
import 'package:missa_maa_oon/entities/position.dart';
import 'package:missa_maa_oon/isar_service.dart';
import 'package:missa_maa_oon/static.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static const appName = 'Missä mää oon?';

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: MyApp.appName,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: const MyHomePage(title: MyApp.appName),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final service = IsarService();

  @override
  void dispose() async {
    await service.close();
    await deleteTemporaryFile();
    super.dispose();
  }

  Future<void> deleteTemporaryFile() async {
    var tempPath = (await getTemporaryDirectory()).path;
    var tempFile = File('$tempPath/$tempFileName');
    await tempFile.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: appBarActions(
            (AppBarValues result) async {
              await onSelectedAppBarValues(result, context, service);
            },
          ),
        ),
        body: StreamBuilder<List<Position>>(
          stream: service.listenToPositions(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final position = snapshot.data![index];
                  return Card(
                    child: ListTile(
                      title: Text(
                          'Leveysaste: ${position.latitude}, pituusaste: ${position.longitude}'),
                      subtitle:
                          Text('Lisätty: ${formatDateTime(position.created)}'),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context, builder: (context) => AddModal(service));
          },
          tooltip: 'Lisää sijainti',
          child: const Icon(Icons.add),
        ));
  }
}
