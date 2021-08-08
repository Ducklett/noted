import 'package:flutter/material.dart';
import 'package:noted/models/note.dart';
import 'package:noted/widgets/noteCard.dart';

class NoteList extends StatelessWidget {
  final Future<List<Note>> files;
  final Function(String path) onNoteTapped;

  const NoteList({
    Key? key,
    required this.files,
    required this.onNoteTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: files,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              var note = snapshot.data[index];
              return NoteCard(
                note,
                () => onNoteTapped(note.path),
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
}
