import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/Shared/cubit/states/states.dart';
import 'package:todoapp/modules/archived/archived.dart';
import 'package:todoapp/modules/done/done.dart';
import 'package:todoapp/modules/tasks/tasks.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppCubitInitial());
  List<Map> task = [];
  List<Map> newtask = [];
  List<Map> donetask = [];
  List<Map> archivetask = [];

  static AppCubit push(context) => BlocProvider.of(context);
  bool toggle = true;
  int x = 0;
  List<Widget> lists = [Task(), Done(), Archived()];
  List<String> string = ["Tasks", "Done", "Archived"];
  void change(int index) {
    x = index;
    emit(AppCubitChange());
  }

  Database? db;
  void create() {
    openDatabase("todo.db", version: 1, onCreate: (database, version) {
      print("database created");
      database
          .execute(
              "CREATE TABLE tasks (id INTEGER PRIMARY KEY , title TEXT , date TEXT , time TEXT , status TEXT)")
          .then((value) {
        print("success");
      }).catchError((onError) {
        print(onError.toString());
      });
    }, onOpen: (database) {
      getData(database);
      print(database);
    }).then((value) {
      db = value;
      emit(AppCubitCreate());
    });
  }

  void insert({
    required String title,
    required String time,
    required String date,
  }) {
    db?.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO tasks (title,time,date,status)VALUES("$title","$time","$date","new")')
          .then((value) {
        print("$value");
      }).catchError((error) {
        print(error.toString());
      });
    }).then((value) {
      emit(AppCubitInsert());
      getData(db);
    });
  }

  void getData(database) {
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == "new") {
          newtask.add(element);
        } else if (element['status'] == "done") {
          donetask.add(element);
        } else {
          archivetask.add(element);
        }
      });
      emit(AppCubitGet());
    });
  }

  void updateData({
    required String status,
    required int id,
  }) {
    db!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      emit(AppCubitUpdate());
      // getData(db);
    });
  }

  void deleteData({required int id}) {
    db!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      // getData(db);
      emit(AppCubitDelete());
    });
  }

  void changeToggle(bool n) {
    toggle = n;
    emit(AppCubitToggle());
  }
}
