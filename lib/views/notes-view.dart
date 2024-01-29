import 'dart:ui'; // Import dart:ui for BoxShadow
import "navbar_view.dart";
import 'package:flutter/material.dart';

class Note {
  final String title;
  final String content;

  Note(this.title, this.content);
}

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesComponentState();
}

class _NotesComponentState extends State<NotesView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  int editingIndex = -1; // Track the index of the note being edited
  List<Note> notes = [];

  void _saveNote() {
    setState(() {
      final title = _titleController.text;
      final content = _contentController.text;

      if (title.isNotEmpty && content.isNotEmpty) {
        if (editingIndex == -1) {
          // If not editing an existing note, add a new note
          notes.add(Note(title, content));
        } else {
          // If editing an existing note, update it
          notes[editingIndex] = Note(title, content);
          editingIndex = -1; // Reset editingIndex
        }
      }

      _titleController.clear();
      _contentController.clear();
    });
    Navigator.of(context).pop();
  }

  void _editNote(int index) {
    setState(() {
      final note = notes[index];
      _titleController.text = note.title;
      _contentController.text = note.content;
      editingIndex = index;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Note"),
          content: SizedBox(
            width: 300,
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
                        editingIndex = -1; // Reset editingIndex
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
  }

  void _deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Notes'),
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
                final note = notes[index];
                return Dismissible(
                  key: Key(note.title),
                  onDismissed: (direction) {
                    _deleteNote(index);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      _editNote(index);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.lightBlue,
                          width: 1,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.red,
                            offset: Offset(3, 3),
                          ),
                          BoxShadow(
                            color: Colors.lime,
                            offset: Offset(-1, 0),
                            blurRadius: 0.4,
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          note.title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          note.content,
                          style: const TextStyle(height: 2),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          editingIndex = -1; // Reset editingIndex
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
      drawer: DrowerWidgets().appBarDrow(context),
    );
  }
}
