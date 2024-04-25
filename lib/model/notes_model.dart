import 'package:hive/hive.dart';
part 'notes_model.g.dart';

@HiveType(typeId: 0)
class Notesmodel extends HiveObject {
  @HiveField(0)
   String title;

  @HiveField(1)
   String subtitle;

  Notesmodel({required this.title, required this.subtitle});
}
