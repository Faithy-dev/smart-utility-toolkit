import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:solar_icons/solar_icons.dart';

class NotesScreen extends StatefulWidget {
  final VoidCallback onBack;

  const NotesScreen({super.key, required this.onBack});

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
        contentController.text.trim().isEmpty) return;

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

  void editNote(Note note) {
    titleController.text = note.title;
    contentController.text = note.content;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Edit Note",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: contentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: "Content",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                      ),
                      onPressed: () {
                        setState(() {
                          note.title = titleController.text;
                          note.content = contentController.text;
                        });

                        saveNotes();
                        titleController.clear();
                        contentController.clear();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: !isAdding
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF4F46E5),
              onPressed: () => setState(() => isAdding = true),
              child: const Icon(SolarIconsOutline.addCircle),
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: widget.onBack,
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Notes Tool",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
                onPressed: () => setState(() => isAdding = false),
                child: const Text("Cancel"),
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
                  "Save",
                  style: TextStyle(color: Colors.white),
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
            SizedBox(
              width: 220,
              height: 220,
              child: Lottie.network(
                "https://assets9.lottiefiles.com/packages/lf20_t24tpvcu.json",
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "No notes yet",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              const SizedBox(height: 6),
              Text(
                note.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateTime.fromMillisecondsSinceEpoch(note.createdAt)
                        .toLocal()
                        .toString()
                        .split(" ")[0],
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(SolarIconsOutline.pen),
                        onPressed: () => editNote(note),
                      ),
                      IconButton(
                        icon: const Icon(SolarIconsOutline.trashBinTrash),
                        onPressed: () => deleteNote(note.id),
                      ),
                    ],
                  ),
                ],
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
  String title;
  String content;
  final int createdAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "createdAt": createdAt,
      };

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json["id"],
      title: json["title"],
      content: json["content"],
      createdAt: json["createdAt"],
    );
  }
}
