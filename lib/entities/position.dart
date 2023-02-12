import 'package:isar/isar.dart';

part 'position.g.dart';

@collection
class Position {
  Id id = Isar.autoIncrement;

  late double latitude;

  late double longitude;

  DateTime created = DateTime.now();

  DateTime updated = DateTime.now();
}
