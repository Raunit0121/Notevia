import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoteEditorPage extends StatefulWidget {
  final String? noteId;
  final String? existingTitle;
  final String? existingText;
  final String? existingLabel;
  final bool? isPinned;

  const NoteEditorPage({
    super.key,
    this.noteId,
    this.existingTitle,
    this.existingText,
    this.existingLabel,
    this.isPinned,
  });

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  final _titleController = TextEditingController();
  final _textController = TextEditingController();
  final _labelController = TextEditingController();

  bool _isPinned = false;

  final List<String> _labels = [
    'Personal 👤',
    'Work 💼',
    'Important 🌟',
    'Idea 💡',
  ];

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.existingTitle ?? '';
    _textController.text = widget.existingText ?? '';
    _labelController.text = widget.existingLabel ?? '';
    _isPinned = widget.isPinned ?? false;
  }

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final text = _textController.text.trim();
    final label = _labelController.text.trim();

    if (title.isEmpty && text.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final noteData = {
      'title': title,
      'text': text,
      'label': label,
      'isPinned': _isPinned,
      'timestamp': Timestamp.now(),
    };

    final notesRef = FirebaseFirestore.instance.collection('notes');

    if (widget.noteId != null) {
      await notesRef.doc(widget.noteId).update(noteData);
    } else {
      await notesRef.add(noteData);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDA6A00),
        elevation: 0,
        title: const Text("Note Editor"),
        actions: [
          IconButton(
            icon: Icon(
              _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
              color: Colors.white,
            ),
            onPressed: () => setState(() => _isPinned = !_isPinned),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// Title Field in White Container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: TextField(
                  controller: _titleController,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4E342E),
                  ),
                  decoration: const InputDecoration(
                    hintText: "Title",
                    hintStyle: TextStyle(color: Color(0xFF8D6E63)),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              /// Label Dropdown & Manual Input
              Row(
                children: [
                  /// Dropdown
                  Expanded(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: const Color(0xFFFFF3E9),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _labels.contains(_labelController.text)
                            ? _labelController.text
                            : null,
                        items: _labels.map((label) {
                          return DropdownMenuItem(
                            value: label,
                            child: Text(
                              label,
                              style: const TextStyle(
                                color: Color(0xFF4E342E),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                        hint: const Text(
                          "Select label",
                          style: TextStyle(color: Color(0xFF6D4C41)),
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFFFE0B2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFDA6A00),
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFFDA6A00),
                        ),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _labelController.text = value);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  /// Manual Label Entry
                  Expanded(
                    child: TextField(
                      controller: _labelController,
                      decoration: InputDecoration(
                        hintText: 'Or type label',
                        hintStyle: const TextStyle(color: Color(0xFF6D4C41)),
                        filled: true,
                        fillColor: const Color(0xFFFFE0B2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFFDA6A00),
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// Note Body in White Container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: TextField(
                  controller: _textController,
                  maxLines: null,
                  minLines: 10,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4E342E),
                  ),
                  decoration: const InputDecoration(
                    hintText: "Write your note here...",
                    hintStyle: TextStyle(color: Color(0xFF8D6E63)),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// Save Button
              ElevatedButton(
                onPressed: _saveNote,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDA6A00),
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
