import 'package:flutter/material.dart';
import 'package:mpro_notes/component/note_settings.dart';
import 'package:popover/popover.dart';

class NoteTile extends StatelessWidget {
  final String text;
  final void Function()? onEditPressed;
  final void Function()? onDeletePressed;

  const NoteTile(
      {super.key,
      required this.text,
      this.onEditPressed,
      this.onDeletePressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
      child: ListTile(
        title: Text(text),
        trailing: (onEditPressed != null || onDeletePressed != null)
            ? Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => showPopover(
                    width: 100,
                    height: 100,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    context: context,
                    bodyBuilder: (context) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: NoteSettings(
                        onEditTap: onEditPressed,
                        onDeleteTap: onDeletePressed,
                      ),
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
