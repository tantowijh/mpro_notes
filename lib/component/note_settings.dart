import 'package:flutter/material.dart';

class NoteSettings extends StatelessWidget {
  final Function()? onEditTap;
  final Function()? onDeleteTap;

  const NoteSettings({super.key, this.onEditTap, this.onDeleteTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Edit
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            onEditTap!();
          },
          child: Container(
            height: 40,
            color: Theme.of(context).colorScheme.surface,
            child: Center(
                child: Text("Edit",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold))),
          ),
        ),

        // Delete
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            onDeleteTap!();
          },
          child: Container(
            height: 40,
            color: Theme.of(context).colorScheme.surface,
            child: Center(
                child: Text("Delete",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold))),
          ),
        ),
      ],
    );
  }
}
