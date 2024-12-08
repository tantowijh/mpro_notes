import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text()();
}

@DriftDatabase(tables: [Notes])
class NoteDatabase extends _$NoteDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  NoteDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    // `driftDatabase` from `package:drift_flutter` stores the database in
    // `getApplicationDocumentsDirectory()`.
    return driftDatabase(name: 'notes');
  }

  // Get all notes
  Future<List<Note>> fetchNotes() async {
    return await select(notes).get();
  }

  // Create a note
  Future<int> createNote(NotesCompanion note) async {
    return await into(notes).insert(note);
  }

  // Update a note
  Future<bool> updateNote(Note note) async {
    return await update(notes).replace(note);
  }

  // Delete a note
  Future<int> deleteNote(Note note) async {
    return await delete(notes).delete(note);
  }
}
