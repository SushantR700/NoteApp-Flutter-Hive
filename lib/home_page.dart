import 'package:flutter/material.dart';
import 'package:flutter_hive/Boxes/boxes.dart';
import 'package:flutter_hive/model/notes_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

final titleController = TextEditingController();
final subtitleController = TextEditingController();

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notes App"),
          backgroundColor: Colors.blue[500],
        ),
        body: ValueListenableBuilder<Box<Notesmodel>>(
            valueListenable: Boxes.addOrgetData().listenable(),
            builder: (context, box, _) {
              var data = box.values.toList().cast<Notesmodel>();
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(data[index].title),
                    subtitle: Text(data[index].subtitle),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                            onTap: () {
                              editTheDialog(context, data[index],
                                  title: data[index].title,
                                  subtitle: data[index].subtitle);
                            },
                            child: const Icon(Icons.edit)),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            delete(data[index]);
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showtheDialog(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> editTheDialog(BuildContext context, Notesmodel note,
      {required String title, required String subtitle}) async {
    titleController.text = title;
    subtitleController.text = subtitle;
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Edit Note'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(hintText: "Title"),
              ),
              TextFormField(
                controller: subtitleController,
                decoration: const InputDecoration(hintText: "Subtitle"),
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              note.title = titleController.text;
              note.subtitle = subtitleController.text;

              note.save();
              titleController.clear();
              subtitleController.clear();

              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> showtheDialog(BuildContext context) async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Add Note'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(hintText: "Title"),
              ),
              TextFormField(
                controller: subtitleController,
                decoration: const InputDecoration(hintText: "Subtitle"),
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final data = Notesmodel(
                  title: titleController.text,
                  subtitle: subtitleController.text);
              final box = Boxes.addOrgetData();
              box.add(data);
              titleController.clear();
              subtitleController.clear();

              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void delete(Notesmodel note) async {
    await note.delete();
  }
}
