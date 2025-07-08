import 'package:dancer_ranking_app/database/database.dart';
import 'package:dancer_ranking_app/services/dancer/dancer_crud_service.dart';
import 'package:drift/native.dart';

Future<void> main() async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  final crud = DancerCrudService(db);
  final id1 = await crud.createDancer(name: 'D1');
  await crud.archiveDancer(id1);
  await Future.delayed(const Duration(milliseconds: 500));
  final id2 = await crud.createDancer(name: 'D2');
  await crud.archiveDancer(id2);
  final archived = await crud.getArchivedDancers();
  for (var d in archived) {
    print('${d.id} -> ${d.archivedAt}');
  }
  print('isAfter: \
      ${archived[0].archivedAt!.isAfter(archived[1].archivedAt!)}');
  await db.close();
}