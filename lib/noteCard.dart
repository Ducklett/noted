import 'package:flutter/material.dart';
import 'note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final void Function() onTap;

  const NoteCard(this.note, this.onTap);

  // Color bg = Color.fromARGB(255, 255, 255, 255);
  // Color bg2 = Color.fromARGB(255, 230, 230, 230);
// background: linear-gradient(-110deg, var(--bg-2), var(--bg));

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          onTap: onTap,
          child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: FractionalOffset.topLeft,
                    end: FractionalOffset.bottomRight,
                    colors: [
                      Theme.of(context).backgroundColor,
                      Theme.of(context).dialogBackgroundColor,
                    ]),
              ),
              child: Container(
                margin: EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text(note.title),
                      subtitle: Text(note.updated.toString()),
                    ),
                    Hero(
                      tag: note.title,
                      child: Material(
                        color: Colors.transparent,
                        child: Text(note.body),
                      ),
                    ),
                  ],
                ),
              )),
        ));
  }
}
