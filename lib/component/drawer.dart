import 'package:flutter/material.dart';
import 'package:mpro_notes/component/drawer_tile.dart';
import 'package:mpro_notes/screens/settings_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // Drawer header
          DrawerHeader(
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: AspectRatio(
                  aspectRatio: 362.17 / 125.63,
                  child: Image.asset("assets/images/logo.png",
                      fit: BoxFit.contain),
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          // Notes tiles
          DrawerTile(
            title: "Notes",
            leading: const Icon(Icons.home),
            onTap: () => Navigator.pop(context),
          ),
          // Settings tiles
          DrawerTile(
            title: "Settings",
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()));
            },
          ),
        ],
      ),
    );
  }
}
