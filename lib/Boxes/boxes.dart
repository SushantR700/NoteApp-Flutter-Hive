import 'package:flutter_hive/model/notes_model.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<Notesmodel> addOrgetData() => Hive.box<Notesmodel>("notes");
}
