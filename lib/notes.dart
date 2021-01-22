import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_file_utils/flutter_file_utils.dart';
import 'package:noted/note.dart';
import 'package:noted/noteCard.dart';

import 'notepad.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  List<Note> notes;

  @override
  void initState() {
    super.initState();
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
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext b) => NotePad(path)));
    // Update notes list when we return
    setState(() {});
  }

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
              color: Theme.of(context).appBarTheme.iconTheme.color,
            ),
          )
        ],
      ),
      body: _notesList(),
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
                Theme.of(context).floatingActionButtonTheme.backgroundColor,
                Theme.of(context).floatingActionButtonTheme.focusColor,
              ])),
          child: Icon(Icons.create),
        ),
        onPressed: _createNote,
      ),
    );
  }

  Widget _notesList() {
    // TODO: request storage permission
    return FutureBuilder(
      future: _files(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              var note = snapshot.data[index];
              return NoteCard(
                note,
                () => _openNote(note.path),
              );
            },
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text("Loading"));
        } else
          return Text("This should never happen..");
      },
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
}
