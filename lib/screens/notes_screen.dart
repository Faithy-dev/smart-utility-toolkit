import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:solar_icons/solar_icons.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Note> notes = [];

  bool isAdding = false;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('smart_toolkit_notes');

    if (saved != null) {
      final List decoded = jsonDecode(saved);
      setState(() {
        notes = decoded.map((e) => Note.fromJson(e)).toList();
      });
    }
  }

  Future<void> saveNotes() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'smart_toolkit_notes',
      jsonEncode(notes.map((e) => e.toJson()).toList()),
    );
  }

  void addNote() {
    if (titleController.text.trim().isEmpty ||
        contentController.text.trim().isEmpty) {
      return;
    }

    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: titleController.text,
      content: contentController.text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    setState(() {
      notes.insert(0, note);
      isAdding = false;
    });

    titleController.clear();
    contentController.clear();

    saveNotes();
  }

  void deleteNote(String id) {
    setState(() {
      notes.removeWhere((n) => n.id == id);
    });

    saveNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: !isAdding
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF4F46E5),
              onPressed: () {
                setState(() {
                  isAdding = true;
                });
              },
              child: const Icon(SolarIconsOutline.addCircle),
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                "Notes Tool",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              if (isAdding) buildAddNote(),
              if (!isAdding) Expanded(child: buildNotesList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAddNote() {
    return Column(
      children: [
        TextField(
          controller: titleController,
          decoration: const InputDecoration(
            hintText: "Note title...",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: contentController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: "Note content...",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    isAdding = false;
                  });
                },
                child: const Text("Cancel",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                ),
                onPressed: addNote,
                child: const Text(
                  "Save Note",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget buildNotesList() {
    if (notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
              "https://assets9.lottiefiles.com/packages/lf20_t24tpvcu.json",
              width: 220,
              repeat: true,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const Text(
              "No notes yet",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Tap + to create your first note",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              )
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      DateTime.fromMillisecondsSinceEpoch(note.createdAt)
                          .toLocal()
                          .toString()
                          .split(" ")[0],
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => deleteNote(note.id),
              )
            ],
          ),
        );
      },
    );
  }
}

class Note {
  final String id;
  final String title;
  final String content;
  final int createdAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "content": content,
      "createdAt": createdAt,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json["id"],
      title: json["title"],
      content: json["content"],
      createdAt: json["createdAt"],
    );
  }
}
