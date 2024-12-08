import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpro_notes/component/drawer.dart';
import 'package:mpro_notes/component/note_tile.dart';
import 'package:mpro_notes/database/database.dart';
import 'package:drift/drift.dart' as drift;

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final database = NoteDatabase();

  Future<List<Note>> fetchNotes() async {
    return await database.fetchNotes();
  }

  void refresh() {
    setState(() {});
  }

  Future _insertNote(NotesCompanion note) async {
    await database.createNote(note).then((_) {
      refresh();
    });
  }

  Future _editNote(Note note) async {
    await database.updateNote(note).then((_) {
      refresh();
    });
  }

  Future _deleteNote(Note note) async {
    await database.deleteNote(note).then((_) {
      refresh();
    });
  }

  final textController = TextEditingController();

  // create note
  void createNote() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.surface,
              content: TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: 'Enter your note here',
                ),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    _insertNote(NotesCompanion(
                      content: drift.Value(textController.text),
                    ));
                    // clear the text field
                    textController.clear();
                    // close the dialog
                    Navigator.pop(context);
                  },
                  child: const Text('Create'),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            )).then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        textController.clear();
      });
    });
  }

  // update note
  void updateNote(Note note) {
    textController.text = note.content;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: const Text('Update Note'),
              content: TextField(controller: textController),
              actions: [
                MaterialButton(
                  onPressed: () {
                    _editNote(note.copyWith(content: textController.text));
                    textController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('Update'),
                )
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            )).then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        textController.clear();
      });
    });
  }

  // delete note
  void deleteNoteWithConfirmation(Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          MaterialButton(
            onPressed: () {
              // delete note
              _deleteNote(note);
              // Close the dialog
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
          size: 30,
        ),
      ),
      drawer: const MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Text(
              'Notes',
              style: GoogleFonts.dmSerifText(
                fontSize: 48,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),

          // List of notes
          Expanded(
            child: FutureBuilder<List<Note>>(
              future: fetchNotes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data!.isEmpty) {
                  return ListView(
                    children: const [
                      NoteTile(
                        text: 'Try adding a note by clicking the + button.',
                      ),
                    ],
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      // get individual note
                      final note = snapshot.data![index];

                      // List tile UI
                      return NoteTile(
                          text: note.content,
                          onEditPressed: () {
                            updateNote(note);
                          },
                          onDeletePressed: () {
                            deleteNoteWithConfirmation(note);
                          });
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
