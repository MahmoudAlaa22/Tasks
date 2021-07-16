import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/controller/bloc/cubit.dart';
import 'package:notes/controller/bloc/states.dart';
import 'package:notes/widgets/scale_transition.dart';
import 'package:notes/widgets/show_dialog.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state){
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text('${cubit.titles[cubit.currentIndex]}'),
            ),
            body: cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                defaultShowDialog(context: context);
              },
              child: Icon(Icons.add),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changedScreen(index);
              },
              items: [
                BottomNavigationBarItem(label: 'Tasks', icon: Icon(Icons.menu)),
                BottomNavigationBarItem(
                    label: 'Done', icon: Icon(Icons.check_circle_outline)),
                BottomNavigationBarItem(
                    label: 'Archived', icon: Icon(Icons.archive_outlined)),
              ],
            ),
          );
        },
      ),
    );
  }
}
