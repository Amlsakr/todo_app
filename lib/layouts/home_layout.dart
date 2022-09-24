import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/AchivedTasksScreen.dart';
import 'package:todo_app/modules/done_tasks/DoneTasksScreen.dart';
import 'package:todo_app/modules/new_tasks/NewTasksScreen.dart';
import 'package:todo_app/shared/components/Components.dart';

class HomeLayout extends StatefulWidget
{
  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),

  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks'
  ];
   Database? database;
   var scaffOldKey =  GlobalKey<ScaffoldState>();
   var formKey = GlobalKey<FormState>();
   bool isBottomSheetShown = false ;
   IconData fabIcon = Icons.edit ;

  @override
  void initState() {
    createDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: scaffOldKey,
      appBar: AppBar(
      title: Text(
        titles[currentIndex],
      ),

    ),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(isBottomSheetShown){
            if(formKey.currentState!.validate()) {
              insertToDB(
                title: titleController.text,
                time: timeController.text,
                date: dateController.text
              ).then((value) {
                Navigator.pop(context);
                isBottomSheetShown = false;
                setState(() {
                  fabIcon = Icons.edit;
                });
              });

            }
          }else {

            scaffOldKey.currentState?.showBottomSheet(
                    (context) =>
                    Container(
                      color: Colors.white,

                      padding: const EdgeInsets.all(16.0,),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            defaultFormField(controller: titleController,
                                label: 'Task Title',
                                iconData: Icons.title,
                                type: TextInputType.text,
                                validate: ( value){
                              if(value!.isEmpty){
                                return 'Title must not be empty';
                              }
                              return null ;
                                }),
                            SizedBox(height: 15.0,),
                            defaultFormField(controller: timeController,
                                label: 'Task Time',
                                iconData: Icons.watch_later_outlined,
                                type: TextInputType.datetime,
                                validate: ( value){
                                  if(value!.isEmpty){
                                    return 'Time must not be empty';
                                  }
                                  return null ;
                                },
                              onTab: (){
                              showTimePicker(context: context, initialTime: TimeOfDay.now())
                              .then((value) {
                                timeController.text = value!.format(context).toString();
                              });
                              },

                                ),
                            SizedBox(height: 15.0,),
                            defaultFormField(controller: dateController,
                                label: 'Task Date',
                                iconData: Icons.calendar_today,
                                type: TextInputType.datetime,
                                validate: ( value){
                                  if(value!.isEmpty){
                                    return 'Date must not be empty';
                                  }
                                  return null ;
                                },
                                onTab: (){
                                  showDatePicker(context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2022-09-20'))
                                  .then(
                                      (value){
                                        dateController.text = DateFormat.yMMMd().format(value!);
                                      }
                                  );
                                },

                            ),


                          ],
                        ),
                      ),
                    )
            ,
            elevation: 20.0);
            isBottomSheetShown = true;
            setState((){
              fabIcon = Icons.add ;
            });
          }
          //insertToDB();
          // try {
          //   var name = await getName();
          //   print(name);
          //   throw('some error !!!!!!!!');
          // } catch(error){
          //   print("error ${error.toString()}");
          // }

          // getName().then((value) =>
          // {
          //   print(value)
          // }).catchError((error) {
          //   print('error is ${error.toString()}');
          // });
        },
        child: Icon(fabIcon),

      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'New',),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Done',),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive_outlined),
            label: 'Archived',),

        ],

      ),
    );
  }

  Future <String> getName() async {
    return 'Aml Sakr ';
  }

  Future<Database?> createDB() async{
    database = await openDatabase(
        'todo.db',
        version: 1,
        onCreate: (database, version) async {
          print('database created');
          database.execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY , title TEXT , date TEXT , time TEXT, status TEXT)')
              .
          then((value) {
            print('Table Created');
          }).catchError((error) {
            print('Error When creating table ${error.toString()}');
          });
        },
        onOpen: (database) {
          print('database opened');
        }
    )  ;

    return database;
  }

  Future<int?> insertToDB({
  required String title,
  required String date,
  required String time,

}) async {
return await database?.transaction((txn) async{
      txn.rawInsert(
        'INSERT INTO tasks (title, date, time, status) VALUES ("$title", "$date", "$time", "New")',
      ).then((value) {
        print('$value Inserted Successfully');
      }).catchError(
              (error) {
            print('Error When inserting new record ${error.toString()}');
          });

    }
    );
  }
}