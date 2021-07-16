import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notes/controller/bloc/cubit.dart';

class BuildTaskItem extends StatelessWidget {
  final List tasks;

  BuildTaskItem({@required this.tasks});

  @override
  Widget build(BuildContext context) {
    log('tasks is $tasks');
    return tasks.length > 0
        ? ListView.separated(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(tasks[index]['id'].toString()),
                onDismissed: (value){
                  AppCubit.get(context).deleteData(id: tasks[index]['id']);
                },
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Text('${tasks[index]['time']}',style: TextStyle(fontSize: 10),),
                  ),
                  title: Text("${tasks[index]['title']}"),
                  subtitle: Text("${tasks[index]['date']}"),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            AppCubit.get(context).updateData(
                              status: 'done',
                              id: tasks[index]['id'],
                            );
                          },
                          icon: Icon(
                            Icons.check_box,
                            color: Colors.green,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            AppCubit.get(context).updateData(
                              status: 'archive',
                              id: tasks[index]['id'],
                            );
                          },
                          icon: Icon(
                            Icons.archive,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          )
        : Center(
            child: Text('No Tasks here'),
          );
  }
}
