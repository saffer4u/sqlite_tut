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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> data;

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> fatchData() async {
    return data = await DatabaseHelper.instance.queryAll();
  }

  void addButtonPress(context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            child: Text("Hello"),
            color: Colors.red,
          );
        });
  }

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
            FutureBuilder(
              future: fatchData(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text('Please wait its loading...'));
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error Occured'),
                  );
                } else if (snapshot.hasData) {
                  return Column(
                    children: [
                      ...data
                          .map(
                            (e) => Text(e[DatabaseHelper.columnName]),
                          )
                          .toList(),
                    ],
                  );
                }
              },
            ),

            // Column(
            //   children: [
            //     ...data
            //         .map(
            //           (e) => Text(e[DatabaseHelper.columnName]),
            //         )
            //         .toList()
            //   ],
            // ),
            RaisedButton(
              onPressed: () async {
                int i = await DatabaseHelper.instance.insert(
                  {
                    DatabaseHelper.columnName: 'khan',
                    DatabaseHelper.columnPhoneNum: 09876544221,
                  },
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
                await DatabaseHelper.instance.delete(2);
              },
              child: Text("Delete"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => addButtonPress(context),
      ),
    );
  }
}
