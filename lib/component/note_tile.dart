import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mpro_notes/database/database.dart';
import 'package:mpro_notes/screens/details_screen.dart';
import 'package:mpro_notes/utils/date_utils.dart';

class NoteTile extends StatefulWidget {
  final Note note;
  final VoidCallback? onSaved;
  final VoidCallback? onDeleted;

  const NoteTile(
      {super.key,
      required this.note,
      required this.onSaved,
      required this.onDeleted});

  @override
  State<NoteTile> createState() => _NoteTileState();
}

class _NoteTileState extends State<NoteTile> {
  Future<void> deleteNote(BuildContext context) async {
    await NoteDatabase().deleteNote(widget.note);
    widget.onDeleted?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
      child: Slidable(
        endActionPane: ActionPane(
            // extentRatio: .25,
            motion: const BehindMotion(),
            children: [
              const SizedBox(width: 20),
              Builder(
                builder: (cont) {
                  return ElevatedButton(
                    onPressed: () {
                      Slidable.of(cont)!.close();
                      deleteNote(cont);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Theme.of(context).colorScheme.error,
                      padding: const EdgeInsets.all(10),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 25,
                    ),
                  );
                },
              ),
            ]),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.note.title.isNotEmpty ? widget.note.title : 'Untitled',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: widget.note.title.isNotEmpty
                          ? Theme.of(context).colorScheme.inversePrimary
                          : Theme.of(context).colorScheme.secondary),
                ),
                const SizedBox(height: 5),
                Text(formatDate(widget.note.createdAt),
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.secondary)),
              ],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotesDetailPage(
                          note: widget.note,
                          onSaved: widget.onSaved,
                          onDeleted: widget.onDeleted)));
            },
          ),
        ),
      ),
    );
  }
}
