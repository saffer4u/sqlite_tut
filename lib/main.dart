import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:sqlite_tut/database_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          accentColor: Colors.amberAccent, primaryColor: Colors.amber),
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
  String _name;
  int _phNum;

  Future<dynamic> fatchData() async {
    return data = await DatabaseHelper.instance.queryAll();
  }

  void addEntryInDb() async {
    if (_formKey.currentState.validate()) {
      // print(_name);
      // print(_phNum);
      var i = await DatabaseHelper.instance.insert(
        {
          DatabaseHelper.columnName: _name,
          DatabaseHelper.columnPhoneNum: _phNum,
        },
      );
      // print(i);
      setState(() {});
      Navigator.pop(context);
    }
  }

  final _formKey = GlobalKey<FormState>();

  void addButtonPress(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        context: context,
        builder: (_) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Wrap(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "New Entry",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextFormField(
                                validator: (value) {
                                  if (value.length < 5) {
                                    return "Name must be more then 4 character";
                                  } else
                                    return null;
                                },
                                onChanged: (String val) {
                                  _name = val;
                                },
                                decoration: InputDecoration(
                                  labelText: "Enter Name",
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value.length < 10) {
                                    return "Phone No. can't be less then 10";
                                  } else
                                    return null;
                                },
                                onChanged: (String val) {
                                  _phNum = int.parse(val);
                                },
                                decoration: InputDecoration(
                                  labelText: "Phone No.",
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: Colors.amber,
                                onPressed: addEntryInDb,
                                child: Text("Add"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void deleteRow(int id) async {
    await DatabaseHelper.instance.delete(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.wrap_text),
          onPressed: () {
            showAboutDialog(
              context: context,
              applicationVersion: "1.0",
              children: [
                Text("Designed and developed by : "),
                Text(
                  "Er.Aftab",
                  style: TextStyle(
                      fontSize: 30,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                ),
              ],
            );
          },
        ),
        centerTitle: true,
        elevation: 10,
        title: Text("SqLite Database"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              FutureBuilder(
                future: fatchData(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: Text('Please wait its loading...'));
                  } else if (!snapshot.hasData) {
                    print("No data");
                    return Center(
                      child: Column(
                        children: [
                          Image.asset('assets/empty.png'),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Empty List...",
                            style: TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error Occured'),
                    );
                  } else if (snapshot.hasData) {
                    return Column(
                      children: [
                        ...data
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 20,
                                ),
                                child: Material(
                                  borderRadius: BorderRadius.circular(10),
                                  elevation: 8,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      decoration:
                                          BoxDecoration(color: Colors.amber),
                                      child: Dismissible(
                                        onDismissed: (dir) => deleteRow(
                                            e[DatabaseHelper.columnId]),
                                        direction: DismissDirection.endToStart,
                                        key: Key(e[DatabaseHelper.columnName]),
                                        background: Container(
                                          color: Colors.white,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              Text(
                                                "Delete",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                            ],
                                          ),
                                        ),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.black,
                                            child: Text(
                                                e[DatabaseHelper.columnId]
                                                    .toString()),
                                          ),
                                          subtitle: Text(
                                              e[DatabaseHelper.columnPhoneNum]
                                                  .toString()),
                                          tileColor: Colors.black12,
                                          title: Text(
                                            e[DatabaseHelper.columnName],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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
              // RaisedButton(
              //   onPressed: () async {
              //     int i = await DatabaseHelper.instance.insert(
              //       {
              //         DatabaseHelper.columnName: 'khan',
              //         DatabaseHelper.columnPhoneNum: 09876544221,
              //       },
              //     );
              //     print('Insert Return value : $i');
              //   },
              //   child: Text("Insert"),
              // ),
              // RaisedButton(
              //   onPressed: () async {
              //     List<Map<String, dynamic>> data =
              //         await DatabaseHelper.instance.queryAll();
              //     print(data);
              //   },
              //   child: Text("Query All"),
              // ),
              // RaisedButton(
              //   onPressed: () async {
              //     int i = await DatabaseHelper.instance.update({
              //       DatabaseHelper.columnId: 2,
              //       DatabaseHelper.columnName: "My name is khan",
              //     });
              //     print('Update return value : $i');
              //   },
              //   child: Text("Update"),
              // ),
              // RaisedButton(
              //   onPressed: () async {
              //     await DatabaseHelper.instance.delete(2);
              //   },
              //   child: Text("Delete"),
              // ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => addButtonPress(context),
        // onPressed: () {
        //   DatabaseHelper.instance
        //       .insert({DatabaseHelper.columnName: "Hello World"});
        // },
      ),
    );
  }
}
