import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpro_notes/component/drawer.dart';
import 'package:mpro_notes/component/note_tile.dart';
import 'package:mpro_notes/database/database.dart';
import 'package:mpro_notes/screens/details_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final database = NoteDatabase();
  Future<List<Note>>? notesFuture;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<List<Note>> fetchNotes() async {
    return await database.fetchNotes();
  }

  void refresh() {
    setState(() {
      notesFuture = fetchNotes();
    });
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
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NotesDetailPage(
                        onSaved: () => refresh(),
                      )));
        },
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
              future: notesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data!.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Text('Try adding a note by clicking the + button.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 18,
                        )),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      // get individual note
                      final note = snapshot.data![index];

                      // List tile UI
                      return NoteTile(
                          note: note, onSaved: refresh, onDeleted: refresh);
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
