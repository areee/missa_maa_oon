import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:missa_maa_oon/determine_position.dart';
import 'package:share_plus/share_plus.dart';

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
      home: const MyHomePage(title: appName),
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
  var _location = 'Ei tiedossa';
  var _loading = false;

  void _determinePosition() async {
    try {
      setState(() {
        _loading = true;
      });
      var position = await determinePosition();

      setState(() {
        _location = '${position.latitude} ${position.longitude}';
        _loading = false;
      });
    } on Exception catch (e) {
      _location = 'Virhe: $e';
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _shareLocation() {
    Share.share(_location);
  }

  void _showHistory() {
    if (kDebugMode) {
      print('Show history');
    }
  }

  void _saveLocation() {
    if (kDebugMode) {
      print('Save location');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _loading ? null : _showHistory,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: _loading ? null : _determinePosition,
              icon: const Icon(Icons.location_searching),
              label: const Text(
                'Paikanna minut',
                style: TextStyle(fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _loading
                  ? const CircularProgressIndicator()
                  : Text(
                      _location,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
            ),
            ElevatedButton.icon(
              onPressed: _loading ? null : _shareLocation,
              icon: const Icon(Icons.share),
              label: const Text(
                'Jaa sijaintini',
                style: TextStyle(fontSize: 24),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _loading ? null : _saveLocation,
              icon: const Icon(Icons.save),
              label: const Text(
                'Tallenna sijaintini',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
