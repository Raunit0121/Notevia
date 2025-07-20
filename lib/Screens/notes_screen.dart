import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import 'add_notes_screen.dart';
import 'homescreen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final List<Color> noteColors = const [
    Color(0xFFFFF9C4),
    Color(0xFFC8E6C9),
    Color(0xFFBBDEFB),
    Color(0xFFFFCCBC),
    Color(0xFFD7CCC8),
    Color(0xFFFFF59D),
    Color(0xFFB2EBF2),
  ];

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final notes = FirebaseFirestore.instance.collection('notes');

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: SafeArea(
        child: Column(
          children: [
            // Orange Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              decoration: const BoxDecoration(
                color: Color(0xFFDA6A00),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Row(
                children: const [
                  SizedBox(width: 10),
                  Expanded(
                    child: Center(
                      child: Text(
                        "📝 My Notes List",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  setState(() => _searchQuery = query);
                },
                decoration: InputDecoration(
                  hintText: 'Search notes...',
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Notes Stream
            Expanded(
              child: StreamBuilder(
                stream: notes.orderBy('timestamp', descending: true).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong!'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.requireData;
                  final filteredNotes = data.docs.where((note) {
                    return note['title']
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()) ||
                        note['text']
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase());
                  }).toList();

                  final pinnedNotes =
                  filteredNotes.where((n) => n['isPinned'] == true).toList();
                  final otherNotes =
                  filteredNotes.where((n) => n['isPinned'] != true).toList();

                  if (filteredNotes.isEmpty) {
                    return const Center(
                      child: Text("No notes found.",
                          style:
                          TextStyle(fontSize: 18, color: Colors.black54)),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (pinnedNotes.isNotEmpty) ...[
                            _buildSectionLabel("📌 Pinned"),
                            _buildNoteGrid(pinnedNotes),
                          ],
                          if (otherNotes.isNotEmpty) ...[
                            _buildSectionLabel("📂 Others"),
                            _buildNoteGrid(otherNotes),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // FAB
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFDA6A00),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NoteEditorPage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),

      // Bottom Tab Switcher
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              colors: [Color(0xFFFF9800), Color(0xFFE65100)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.deepOrange.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // To-Do Tab
              Expanded(
                child: InkWell(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    bottomLeft: Radius.circular(28),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const Homescreen()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check_circle_outline, color: Colors.white),
                      SizedBox(width: 6),
                      Text("To-Do",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              Container(width: 1, height: 32, color: Colors.white38),
              // Notes Tab
              Expanded(
                child: InkWell(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                  onTap: () {}, // Already on Notes
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.note_alt_outlined, color: Colors.white),
                      SizedBox(width: 6),
                      Text("Notes",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 6),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildNoteGrid(List<QueryDocumentSnapshot> notesList) {
    return MasonryGridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemCount: notesList.length,
      itemBuilder: (context, index) {
        final note = notesList[index];
        final color = noteColors[index % noteColors.length];
        final timestamp = note['timestamp']?.toDate();
        final label = note['label'] ?? '';

        return GestureDetector(
          onTap: () {
            // Navigate to editor with existing note
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NoteEditorPage(
                  noteId: note.id,
                  existingTitle: note['title'],
                  existingText: note['text'],
                  existingLabel: note['label'],
                  isPinned: note['isPinned'] ?? false,
                ),
              ),
            );
          },
          onLongPress: () {
            // Show bottom sheet on long press
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (_) => Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  children: [
                    ListTile(
                      leading: Icon(
                        note['isPinned'] == true
                            ? Icons.push_pin
                            : Icons.push_pin_outlined,
                      ),
                      title: Text(note['isPinned'] == true
                          ? 'Unpin Note'
                          : 'Pin Note'),
                      onTap: () async {
                        Navigator.pop(context);
                        await FirebaseFirestore.instance
                            .collection('notes')
                            .doc(note.id)
                            .update({'isPinned': !(note['isPinned'] == true)});
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete, color: Colors.red),
                      title: const Text('Delete Note'),
                      onTap: () async {
                        Navigator.pop(context);
                        await FirebaseFirestore.instance
                            .collection('notes')
                            .doc(note.id)
                            .delete();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.share),
                      title: const Text('Share Note'),
                      onTap: () {
                        Navigator.pop(context);
                        final title = note['title'] ?? '';
                        final text = note['text'] ?? '';
                        final label = note['label'] ?? '';
                        final shareText = '📝 $title\n\n$text\n\n🔖 Label: $label';
                        Share.share(shareText);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note['title'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (label.isNotEmpty)
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: const EdgeInsets.only(top: 6, bottom: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      label,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                Text(
                  note['text'],
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(fontSize: 16),
                ),
                const SizedBox(height: 6),
                if (timestamp != null)
                  Text(
                    DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp),
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
