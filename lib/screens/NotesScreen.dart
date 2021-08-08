import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_file_utils/flutter_file_utils.dart';
import 'package:noted/models/note.dart';
import 'package:noted/widgets/NoteList.dart';

import 'NoteEditScreen.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          MaterialButton(
            onPressed: () => setState(() {}),
            child: Icon(
              Icons.update,
              color: Theme.of(context).appBarTheme.iconTheme!.color,
            ),
          )
        ],
      ),
      body: NoteList(
        files: _files(),
        onNoteTapped: _openNote,
      ),
      floatingActionButton: FloatingActionButton(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                Theme.of(context).floatingActionButtonTheme.backgroundColor
                    as Color,
                Theme.of(context).floatingActionButtonTheme.focusColor as Color,
              ])),
          child: Icon(Icons.create),
        ),
        onPressed: _createNote,
      ),
    );
  }

  Future<List<Note>> _files() async {
    // var root = await getExternalStorageDirectory();
    var root = Directory('/storage/emulated/0/Sync/Notes');
    print(root);
    // var files = await FileManager(root: root).walk().toList();
    var files = root.list(followLinks: false, recursive: false).toList();
    var res = (await files)
        .where((FileSystemEntity f) => f is File && f.extension() == ".txt")
        .map((FileSystemEntity f) {
      // TODO: support names with . in them
      var file = f as File;
      return Note(
        file.path,
        file.basename().split('.').first,
        file.readAsLinesSync().take(10).join("\n"),
        file.lastModifiedSync(),
      );
    }).toList();

    res.sort((Note a, Note b) => b.updated.compareTo(a.updated));

    return res;
  }

  void _createNote() async {
    var root = Directory('/storage/emulated/0/Sync/Notes');
    print(root);
    // var files = await FileManager(root: root).walk().toList();
    var files = await root
        .list(followLinks: false, recursive: false)
        .where((FileSystemEntity f) => f is File && f.extension() == ".txt")
        .map((FileSystemEntity f) => f.basename())
        .toList();

    var i = 1;
    String noteTitle;
    do {
      noteTitle = "New note " + i.toString() + ".txt";
      i++;
    } while (files.contains(noteTitle));

    print("note title: " + noteTitle);

    var notePath = '/storage/emulated/0/Sync/Notes' + "/" + noteTitle;
    File(notePath).createSync();
    _openNote(notePath);
  }

  void _openNote(String path) async {
    await Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext b) => NoteEditScreen(path)));
    // Update notes list when we return
    setState(() {});
  }
}
