import 'package:flutter/material.dart';
import 'package:missa_maa_oon/add_modal.dart';
import 'package:missa_maa_oon/app_bar_actions.dart';
import 'package:missa_maa_oon/date_helper.dart';
import 'package:missa_maa_oon/entities/position.dart';
import 'package:missa_maa_oon/isar_service.dart';
import 'package:missa_maa_oon/static.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appName = 'Missä mää oon?';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: MyHomePage(title: appName),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title});
  final String title;
  final service = IsarService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
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
