import 'package:isar/isar.dart';
import 'package:missa_maa_oon/entities/position.dart';

class IsarService {
  late Future<Isar> _db;

  IsarService() {
    _db = openDb();
  }

  Future<void> savePosition(Position position) async {
    final isar = await _db;
    isar.writeTxnSync<int>(() => isar.positions.putSync(position));
  }

  Future<List<Position>> getAllPositions() async {
    final isar = await _db;
    return await isar.positions.where().findAll();
  }

  Stream<List<Position>> listenToPositions() async* {
    final isar = await _db;
    yield* isar.positions.where().watch(fireImmediately: true);
  }

  Future<void> cleanDb() async {
    final isar = await _db;
    await isar.writeTxn(() => isar.clear());
  }

  Future<Isar> openDb() async {
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([PositionSchema], inspector: true);
    }
    return Future.value(Isar.getInstance());
  }
}