import 'package:flutter/foundation.dart';
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
  late BuildContext buildContext;

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
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
                if (kDebugMode) {
                  print('TODO: Poista kaikki tietokannasta');
                  service.cleanDb();
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void onSelectedAppBarValues(AppBarValues result) async {
    switch (result) {
      case AppBarValues.export:
        if (kDebugMode) {
          print('TODO: Vie kaikki tietokannasta');
          var positions = await service.getAllPositions();
          print(positions);
        }
        break;
      case AppBarValues.deleteAll:
        _showMyDialog(buildContext);

        break;
      case AppBarValues.about:
        if (kDebugMode) {
          print('TODO: Tietoja sovelluksesta');
        }
        break;
      default:
        throw Exception('Unknown AppBarValues');
    }
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: appBarActions(onSelectedAppBarValues),
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
          tooltip: 'Add a position',
          child: const Icon(Icons.add),
        ));
  }
}

// class _MyHomePageState extends State<MyHomePage> {
//   var _location = 'Ei tiedossa';
//   var _loading = false;

//   void _determinePosition() async {
//     try {
//       setState(() {
//         _loading = true;
//       });
//       var position = await determinePosition();

//       setState(() {
//         _location = '${position.latitude} ${position.longitude}';
//         _loading = false;
//       });
//     } on Exception catch (e) {
//       _location = 'Virhe: $e';
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//   }

//   void _shareLocation() {
//     Share.share(_location);
//   }

//   void _showHistory() {
//     if (kDebugMode) {
//       print('Show history');
//     }
//   }

//   void _saveLocation() {
//     if (kDebugMode) {
//       print('Save location');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.history),
//             onPressed: _loading ? null : _showHistory,
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton.icon(
//               onPressed: _loading ? null : _determinePosition,
//               icon: const Icon(Icons.location_searching),
//               label: const Text(
//                 'Paikanna minut',
//                 style: TextStyle(fontSize: 24),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: _loading
//                   ? const CircularProgressIndicator()
//                   : Text(
//                       _location,
//                       style: Theme.of(context).textTheme.headlineMedium,
//                     ),
//             ),
//             ElevatedButton.icon(
//               onPressed: _loading ? null : _shareLocation,
//               icon: const Icon(Icons.share),
//               label: const Text(
//                 'Jaa sijaintini',
//                 style: TextStyle(fontSize: 24),
//               ),
//             ),
//             ElevatedButton.icon(
//               onPressed: _loading ? null : _saveLocation,
//               icon: const Icon(Icons.save),
//               label: const Text(
//                 'Tallenna sijaintini',
//                 style: TextStyle(fontSize: 24),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
