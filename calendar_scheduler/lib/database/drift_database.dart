import 'package:drift/drift.dart';
import 'package:calendar_scheduler/model/schedule.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
part 'drift_database.g.dart';

@DriftDatabase(
  tables : [
    Schedules,
  ],
)
class LocalDatabase extends _$LocalDatabase{
  @override
  int get schemaVersion => 1;

  LocalDatabase() : super(_openConnection());
  Stream<List<Schedule>> watchSchedules(DateTime date) =>
      (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();

  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);
  Future<int> removeSchedules(int id) =>
      (delete(schedules)..where((tbl) => tbl.id.equals(id))).go();
}
LazyDatabase _openConnection(){
  return LazyDatabase(() async{
    final dbFolder = await getApplicationCacheDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlike'));
    return NativeDatabase(file);
  });
}