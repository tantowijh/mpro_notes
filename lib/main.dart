import 'package:flutter/material.dart';
import 'package:mpro_notes/screens/notes_screen.dart';
import 'package:mpro_notes/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const NotesApp(),
    ),
  );
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const NotesScreen(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
