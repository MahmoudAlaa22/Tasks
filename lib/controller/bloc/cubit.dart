import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/controller/bloc/states.dart';
import 'package:notes/screens/archived.dart';
import 'package:notes/screens/done.dart';
import 'package:notes/screens/tasks.dart';
import 'package:sqflite/sqflite.dart';

import '../const.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  Database database;
  int currentIndex = 0;
  String time='',date='';
  List<Widget> screens = [
    Tasks(),
    Done(),
    Archived(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  void createDataBase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      log('database created');
      database
          .execute(
              'CREATE TABLE $tableNameOfDatabase (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) => log('table created'))
          .catchError((onError) => log('error in create table is $onError'));
    }, onOpen: (database) {
      getDataFromDatabase(database);
      print('database opened');
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  void changedScreen(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void getDataFromDatabase(Database database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppGetDatabaseLoadingState());
    database
        .rawQuery('SELECT * FROM $tableNameOfDatabase')
        .then((value) {
      log('value of database is $value');
      value.forEach((element)
      {
        if(element['status'] == 'new')
          newTasks.add(element);
        else if(element['status'] == 'done')
          doneTasks.add(element);
        else archivedTasks.add(element);
        log('newTasks is $newTasks');
        log('doneTasks is $doneTasks');
        log('archivedTasks is $archivedTasks');
      });
      emit(AppGetDatabaseState());
    });
  }

  void insertToDatabase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
        'INSERT INTO $tableNameOfDatabase (title, date, time, status) VALUES("$title", "$date", "$time", "new")',
      )
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);
      }).catchError((error) {
        print('Error When Inserting New Record ${error.toString()}');
      });

      return null;
    });
  }
  void updateData({
    @required String status,
    @required int id,
})async{
    database.rawUpdate(
      'UPDATE $tableNameOfDatabase SET status=? WHERE id=?',
      ['$status',id]
    ).then((value)
    {
      log("update database");
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }
  void deleteData({
    @required int id,
  }) async
  {
    database.rawDelete('DELETE FROM $tableNameOfDatabase WHERE id = ?', [id])
        .then((value)
    {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }
void changeTime({@required String time}){
    this.time=time;
    emit(AppChangeTimeState());
}
  void changeDate({@required String date}){
    this.date=date;
    emit(AppChangeDateState());
  }
}
