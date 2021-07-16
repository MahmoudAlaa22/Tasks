import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes/controller/bloc/cubit.dart';
import 'package:notes/widgets/scale_transition.dart';

import 'button_date_or_time.dart';
import 'default_text_form_field.dart';

final key = GlobalKey<FormState>();

Future defaultShowDialog({@required BuildContext context}) {
  String title = '';
  String time = '';
  String date = '';
  return showDialog(
      context: context,
      builder: (_) {
        return WidgetOfScaleTransition(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: key,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      defaultFormField(
                          label: 'Task Title',
                          validate: (String value) {
                            return validateFun(value: value);
                          },
                          prefix: Icons.title,
                          onChange: (value) {
                            title = value;
                          }),
                      Row(
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
                                log("time is $time");
                              });
                            },
                          ),
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
                                log("date is $date");
                                AppCubit.get(context).changeDate(date: date);
                              });
                            },
                          ),
                        ],
                      ),
                      defaultButton(onClick: () {
                        if (key.currentState.validate()) {
                          key.currentState.save();
                          log("in default button ADD");
                          log('title is $title time is $time date is $date');
                          AppCubit.get(context).insertToDatabase(
                              title: title, time: time, date: date);
                          Navigator.of(context).pop();
                        }
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
}

String validateFun({String value}) {
  if (value.isEmpty) return 'This field must not be empty';
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
