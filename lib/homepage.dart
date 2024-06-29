import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'settingpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('notes');
  final _noteController = TextEditingController();

  void _addNote() {
    if (_noteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note cannot be empty')),
      );
      return;
    }

    final timestamp = DateTime.now().toString();
    _myBox.put(timestamp, {
      'note': _noteController.text,
      'created_at': timestamp,
      'modified_at': timestamp,
    });
    _noteController.clear();
    setState(() {}); //agar halaman bisa reload untuk menunjukkan note yang baru
  }

  void _editNote(String key) {
    final note = _myBox.get(key);
    final editController = TextEditingController(text: note?['note']); //menampilkan isi notes berdasarkan disimpan di hive

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Note'),
          content: SizedBox(
            width: double.maxFinite,
            height: 200,
            child: SingleChildScrollView(
              child: Container(
                width: 300,
                height: 200,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  controller: editController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Enter note',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final editedNoteText = editController.text.trim();
                if (editedNoteText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Note cannot be empty')),
                  );
                  return;
                }

              
                // Cek apakah user mengubah catatan
                if (note?['note'] != editedNoteText) {
                  // update wsi catatan
                  note?['note'] = editedNoteText;
                  // update waktu modifikasi
                  note?['modified_at'] = DateTime.now().toString();

                  _myBox.put(key, note!);
                  setState(() {});
                }

                Navigator.pop(context);
              },
              style:  ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 217, 163, 70)),
              ),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    ).then((value) {
      // Posisi kursor terakhir disimpan
      editController.selection = TextSelection.fromPosition(
        TextPosition(offset: editController.text.length),
      );
    });
  }

  void _deleteNote(String key) {
    _myBox.delete(key);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final notes = _myBox.toMap();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _noteController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Enter note',
                contentPadding: EdgeInsets.all(10.0),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: _addNote,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 217, 163, 70)),
                    ),
                    child: const Text(
                      'Add Note',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: notes.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final key = notes.keys.elementAt(index);
                  final note = notes[key];
                  final createdAt = note?['created_at'] ?? '';
                  final updatedAt = note?['modified_at'] ?? '';

                  String subtitle = '';
                  if (createdAt.isNotEmpty) {
                    subtitle += 'Created: $createdAt';
                  }
                  if (updatedAt.isNotEmpty) {
                    if (subtitle.isNotEmpty) {
                      subtitle += '\n';
                    }
                    subtitle += 'Modified: $updatedAt';
                  }

                  return Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          255, 255, 241, 173), //  notes berwarna kuning
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        note?['note'] ?? '',
                        maxLines:
                            3, // notes di tampilan depan hanya menampilkan 3 baris pertama
                      ),
                      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
                      isThreeLine: subtitle.contains('\n'),
                      trailing: note != null &&
                              note['note'] != null &&
                              note['note'].isNotEmpty
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editNote(key),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _deleteNote(key),
                                ),
                              ],
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
