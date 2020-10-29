import 'package:flutter/material.dart';

import 'package:sqlite_tut/database_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      title: "SQLITE Database",
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SqLite Database"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () async {
                int i = await DatabaseHelper.instance.insert(
                  {DatabaseHelper.columnName: 'Aftab'},
                );
                print('Insert Return value : $i');
              },
              child: Text("Insert"),
            ),
            RaisedButton(
              onPressed: () async {
                List<Map<String, dynamic>> data =
                    await DatabaseHelper.instance.queryAll();
                print(data);
              },
              child: Text("Query All"),
            ),
            RaisedButton(
              onPressed: () async {
                int i = await DatabaseHelper.instance.update({
                  DatabaseHelper.columnId: 2,
                  DatabaseHelper.columnName: "My name is khan",
                });
                print('Update return value : $i');
              },
              child: Text("Update"),
            ),
            RaisedButton(
              onPressed: () async {
                int i = await DatabaseHelper.instance.delete(2);
                print(i);
              },
              child: Text("Delete"),
            ),
          ],
        ),
      ),
    );
  }
}
