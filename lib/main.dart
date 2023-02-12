import 'package:flutter/material.dart';
import 'package:missa_maa_oon/add_modal.dart';
import 'package:missa_maa_oon/entities/position.dart';
import 'package:missa_maa_oon/isar_service.dart';

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
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Clean database',
              onPressed: () async {
                await service.cleanDb();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Database cleaned'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        body: StreamBuilder<List<Position>>(
          stream: service.listenToPositions(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final position = snapshot.data![index];
                  return ListTile(
                    title: Text(
                        'Latitude: ${position.latitude}, longtitude: ${position.longitude}'),
                    subtitle: Text(
                        'Created: ${position.created}, updated: ${position.updated}'),
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
