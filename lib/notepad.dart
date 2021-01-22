import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_file_utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotePad extends StatefulWidget {
  final String path;
  NotePad(this.path);

  @override
  _NotePadState createState() => _NotePadState(path);
}

class _NotePadState extends State<NotePad> {
  final String path;
  String tag;

  bool _deleted = false;
  TextEditingController txt = TextEditingController(text: "");
  TextEditingController title = TextEditingController(text: "");

  @override
  void initState() {
    File f = File(path);
    txt.text = f.readAsStringSync();
    title.text = getBaseName(path).split('.').first;
    print(title.text);
    super.initState();
  }

  void _saveNote() {
    if (_deleted) return;

    var f = File(path);
    var dir = f.parent.path;
    var newfilename = title.text + ".txt";
    var oldFilename = getBaseName(path);

    if (newfilename != oldFilename) {
      f.deleteSync();
    }

    var newPath = dir + "/" + newfilename;
    print("Save note in " + newPath);

    var newFile = File(newPath);
    newFile.createSync();
    newFile.writeAsStringSync(txt.text);

    Fluttertoast.showToast(
        msg: "Note saved",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
  }

  _NotePadState(this.path) {
    tag = getBaseName(path).split('.').first;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _saveNote();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            style: TextStyle(
              fontSize: 20,
            ),
            controller: title,
          ),
          actions: [
            MaterialButton(
              child: Icon(
                Icons.delete,
                color: Theme.of(context).appBarTheme.iconTheme.color,
              ),
              onPressed: () {
                var dialog = AlertDialog(
                  content: Text("Are you sure you want to delete \"" +
                      title.text +
                      "\"?"),
                  actions: [
                    FlatButton(
                      child: Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text("Yes"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        File(path).deleteSync();
                        _deleted = true;
                        Navigator.of(context).pop();
                        Fluttertoast.showToast(
                            msg: "Note deleted",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            fontSize: 16.0);
                      },
                    ),
                  ],
                );

                showDialog(
                  context: context,
                  builder: (BuildContext b) => dialog,
                  barrierDismissible: true,
                );
              },
            ),
          ],
        ),
        body: Container(
          child: Hero(
            tag: tag,
            child: Material(
              color: Colors.transparent,
              child: TextField(
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2.color,
                  fontSize: 18.0,
                ),
                autocorrect: false,
                controller: txt,
                maxLines: 999,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
