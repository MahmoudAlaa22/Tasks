import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/controller/bloc/cubit.dart';
import 'package:notes/controller/bloc/states.dart';
import 'package:notes/widgets/build_task_item.dart';
class Done extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        var tasks = AppCubit.get(context).doneTasks;
        return BuildTaskItem(tasks: tasks,);
      },);
  }
}
