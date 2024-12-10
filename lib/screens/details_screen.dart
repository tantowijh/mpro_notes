import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mpro_notes/database/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:mpro_notes/utils/date_utils.dart';

class NotesDetailPage extends StatefulWidget {
  final Note? note;
  final VoidCallback? onSaved;
  final VoidCallback? onDeleted;

  const NotesDetailPage(
      {super.key, this.note, required this.onSaved, this.onDeleted});

  @override
  NotesDetailPageState createState() => NotesDetailPageState();
}

class NotesDetailPageState extends State<NotesDetailPage> {
  final database = NoteDatabase();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  String? initialTitle;
  String? initialContent;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      initialTitle = widget.note!.title;
      initialContent = widget.note!.content;
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
    }
    titleController.addListener(_onTextChanged);
    contentController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    titleController.removeListener(_onTextChanged);
    contentController.removeListener(_onTextChanged);
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  bool _isModified() {
    if (widget.note == null) return false;
    return titleController.text != initialTitle ||
        contentController.text != initialContent;
  }

  FloatingActionButton? showSaveButton() {
    if (widget.note != null) {
      return _isModified() ? floatingSaveButton : null;
    } else {
      if (titleController.text.isNotEmpty ||
          contentController.text.isNotEmpty) {
        return floatingSaveButton;
      } else {
        return null;
      }
    }
  }

  FloatingActionButton get floatingSaveButton {
    return FloatingActionButton(
      onPressed: () {
        if (widget.note != null) {
          updateNote();
        } else {
          saveNote();
        }
        Navigator.pop(context);
      },
      backgroundColor: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      child: const Icon(
        Icons.save,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Future<void> saveNote() async {
    final title = titleController.text;
    final content = contentController.text;

    if (title.isNotEmpty || content.isNotEmpty) {
      final note = NotesCompanion(
        title: drift.Value(title),
        content: drift.Value(content),
      );
      await database.createNote(note);
      widget.onSaved?.call();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: Text('Title or content cannot be empty',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> updateNote() async {
    final title = titleController.text;
    final content = contentController.text;

    if (title.isNotEmpty || content.isNotEmpty) {
      final note = widget.note!.copyWith(
        title: title,
        content: content,
      );
      await database.updateNote(note);
      widget.onSaved?.call();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: Text('Title or content cannot be empty',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> deleteNote() async {
    if (widget.note != null) {
      await database.deleteNote(widget.note!);
      widget.onDeleted?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (widget.note != null)
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: IconButton(
                onPressed: () {
                  deleteNote();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete),
              ),
            ),
        ],
      ),
      floatingActionButton: showSaveButton(),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
                hintStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            widget.note != null
                ? Text(
                    formatDate(widget.note!.createdAt),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  )
                : StreamBuilder(
                    stream: Stream.periodic(const Duration(seconds: 1)),
                    builder: (context, snapshot) {
                      return Text(
                        DateFormat('MM/dd/yyyy, hh:mm a')
                            .format(DateTime.now()),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      );
                    },
                  ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: contentController,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Write your note here...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
