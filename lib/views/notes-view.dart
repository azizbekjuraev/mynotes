import 'package:flutter/material.dart';
import 'dart:ui'; // Import dart:ui for BoxShadow

class Note {
  final String title;
  final String content;

  Note(this.title, this.content);
}

class NotesView extends StatefulWidget {
  const NotesView({Key? key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  List<Note> notes = [];

  @override
  void initState() {
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    setState(() {
      final title = _titleController.text;
      final content = _contentController.text;
      if (title.isNotEmpty && content.isNotEmpty) {
        notes.add(Note(title, content));
      }
      _titleController.clear();
      _contentController.clear();
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    const redShadow = BoxShadow(
      color: Colors.red,
      offset: Offset(3, 3),
    );
    const oliveShadow = BoxShadow(
      color: Colors.lime,
      offset: Offset(-1, 0),
      blurRadius: 0.4,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: notes.isEmpty
          ? const Center(
              child: Text(
                'You do not have notes yet!',
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.lightBlue,
                      width: 1,
                    ),
                    boxShadow: const [
                      redShadow,
                      oliveShadow,
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      notes[index].title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      notes[index].content,
                      style: const TextStyle(height: 2),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Add a New Note"),
                content: SizedBox(
                  width: 300,
                  height: 200,
                  child: Column(
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _contentController,
                        decoration: const InputDecoration(
                          labelText: 'Content',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: _saveNote,
                            child: const Text('Save'),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
