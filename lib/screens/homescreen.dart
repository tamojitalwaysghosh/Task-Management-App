import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tasks/models/task.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _newTaskContent;
  Box? _box;

  _HomePageState();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _deviceWidth = MediaQuery.of(context).size.width;
    var _deviceHeight = MediaQuery.of(context).size.height;
    double _flor = _deviceWidth / 2;
    return Scaffold(
      appBar: AppBar(
        //centerTitle: true,
        toolbarHeight: _deviceHeight * .1225,
        title: Text(
          'TaskX',
          style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 82, 113, 255),
        /*actions: [
          GestureDetector(
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => SplashScreen())),
            child: Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.more_vert,
                color: Colors.black,
                size: 32,
              ),
            ),
          ),
        ],*/
      ),
      body: Container(
        // padding: EdgeInsets.only(top: 10),
        child: _tasksView(),
      ),
      floatingActionButton: Container(child: _floatTask()),
    );
  }

  Widget _tasksView() {
    return FutureBuilder(
      future: Hive.openBox("tasks"),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          _box = _snapshot.data;
          return _taskList();
        } else {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Color.fromARGB(255, 82, 113, 255),
            ),
          );
        }
      },
    );
  }

  Widget _taskList() {
    List tasks = _box!.values.toList();
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext _context, int _index) {
        var task = Task.fromMap(tasks[_index]);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
          child: Container(
            //margin: EdgeInsets.only(top: 10),
            child: ListTile(
              title: Text(
                task.content,
                style: TextStyle(
                    decoration: task.done ? TextDecoration.lineThrough : null,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                "added on : " + DateFormat.yMMMEd().format(task.timeStamp),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Quicksand',
                ),
              ),
              trailing: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    task.done ? Icons.check_box : Icons.check_box_outline_blank,
                    color: Color.fromARGB(255, 82, 113, 255),
                  ),
                ),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              ),
              onTap: () {
                task.done = !task.done;

                _box!.putAt(
                  _index,
                  task.toMap(),
                );
                setState(() {});
              },
              onLongPress: (() {
                _box!.deleteAt(_index);
                setState(() {});
              }),
            ),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 247, 251, 255),
                // color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                // border: Border.all( width: 2, color: Color.fromARGB(235, 35, 1, 88),)
                boxShadow: [
                  BoxShadow(blurRadius: 0.22, offset: Offset(0.1, 0.1)),
                  //BoxShadow(blurRadius: 2.22, offset: Offset(-0.1, -0.1)),
                ]),
          ),
        );
      },
    );
  }

  Widget _floatTask() {
    return FloatingActionButton(
      elevation: 100.0,
      onPressed: _showPopup,
      child: Icon(
        Icons.add,
        color: Colors.white,
        size: 31.3,
      ),
      backgroundColor: Color.fromARGB(255, 82, 113, 255),
    );
  }

  void _showPopup() {
    showDialog(
        context: context,
        builder: (BuildContext _context) {
          return AlertDialog(
            title: Text("Add a new task"),
            content: TextField(
              onSubmitted: (_) {
                if (_newTaskContent != null) {
                  var _task = Task(
                      content: _newTaskContent!,
                      timeStamp: DateTime.now(),
                      done: false);
                  _box!.add(_task.toMap());
                  setState(() {
                    _newTaskContent = null;
                    Navigator.pop(context);
                  });
                }
              },
              onChanged: (_value) {
                setState(() {
                  _newTaskContent = _value;
                });
              },
            ),
          );
        });
  }
}
