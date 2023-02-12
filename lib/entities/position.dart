import 'package:isar/isar.dart';

part 'position.g.dart';

@collection
class Position {
  Id id = Isar.autoIncrement;

  double? latitude;

  double? longitude;

  DateTime created = DateTime.now();

  DateTime updated = DateTime.now();

  @override
  String toString() {
    return 'Position{id: $id, latitude: $latitude, longitude: $longitude, created: $created, updated: $updated}';
  }
}
