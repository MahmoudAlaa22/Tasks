
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes/controller/bloc/cubit.dart';
import 'package:notes/controller/bloc/states.dart';
import 'package:notes/widgets/scale_transition.dart';

import 'button_date_or_time.dart';
import 'default_text_form_field.dart';

final key = GlobalKey<FormState>();
String time = '';
String date = '';
Future defaultShowDialog({@required BuildContext context}) {
  String title = '';
  time = '';
  date = '';
  return showDialog(
      context: context,
      builder: (_) {
        return BlocProvider(
          create: (_) => AppCubit(),
          child: WidgetOfScaleTransition(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: key,
                    child:
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        defaultFormField(
                            label: 'Task Title',
                            validate: (String value) {
                              return validateFun(value: value,message: '');
                            },
                            prefix: Icons.title,
                            onChange: (value) {
                              title = value;
                            }),
                    BlocBuilder<AppCubit,AppStates>(
                      builder: (context,state){
                        return RowHasTaskTimeAndTaskDate();
                      },
                    ),
                        defaultButton(onClick: () async{
                          onClickADD(title: title,context: context);
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      });
}
String validateFun({String value,String message}) {
  if (value.isEmpty) return '${ message.isEmpty?'This field':message} must not be empty';
  return null;
}
defaultButton({Function onClick}) {
  return MaterialButton(
      child: Text(
        'ADD',
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
      onPressed: onClick);
}
void onClickADD({@required BuildContext context,@required String title}){
  {
    if (key.currentState.validate() &&
        time != '' &&
        date != ''
    ) {
      key.currentState.save();
      AppCubit.get(context).insertToDatabase(
          title: title,
          time: time,
          date: date);
      Navigator.of(context).pop();
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(validateFun(value: '',message: 'Task Time and Task Date')))
      );
    }
  }
}
class RowHasTaskTimeAndTaskDate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ButtonDateOrTime(
              title: 'Task Time',
              iconData: Icons.watch_later_outlined,
              onTap: () {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ).then((value) {
                  time = value.format(context).toString();
                  AppCubit.get(context)
                      .changeTime(time: value.format(context).toString());
                });
              },
            ),
            Text(AppCubit
                .get(context)
                .time)
          ],
        ),
        Column(
          children: [
            ButtonDateOrTime(
              title: 'Task Date',
              iconData: Icons.calendar_today,
              onTap: () {
                showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.parse('2050-10-22'))
                    .then((value) {
                  date =
                      DateFormat.yMMMd().format(value).toString();
                  AppCubit.get(context).changeDate(
                      date: DateFormat.yMMMd().format(value).toString());
                });
              },
            ),
            Text(AppCubit
                .get(context)
                .date)
          ],
        ),
      ],
    );
  }
}
