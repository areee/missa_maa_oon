import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:missa_maa_oon/determine_position.dart';
import 'package:missa_maa_oon/entities/position.dart';
import 'package:missa_maa_oon/isar_service.dart';

class AddModal extends StatefulWidget {
  const AddModal(this.service, {super.key});
  final IsarService service;

  @override
  State<AddModal> createState() => _AddModalState();
}

class _AddModalState extends State<AddModal> {
  var _position = Position();
  var _loading = false;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  void _determinePosition() async {
    try {
      setState(() {
        _loading = true;
      });
      var position = await determinePosition();

      setState(() {
        _position = Position()
          ..latitude = position.latitude
          ..longitude = position.longitude;

        _loading = false;
      });
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Virhe: $e'),
        ),
      );
      if (kDebugMode) {
        print(e);
      }
    }
  }

  _savePosition() async {
    await widget.service.savePosition(_position);
    if (context.mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sijainti tallennettu'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: _loading ? null : _determinePosition,
            child: const Text('Hae sijainti'),
          ),
          _loading
              ? const CircularProgressIndicator()
              : Column(
                  children: [
                    Text(
                      'Leveysaste: ${_position.latitude ?? 'Ei tiedossa'}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      'Pituusaste: ${_position.longitude ?? 'Ei tiedossa'}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
          ElevatedButton(
            onPressed: _loading ? null : _savePosition,
            child: const Text('Tallenna'),
          ),
        ],
      ),
    );
  }
}
