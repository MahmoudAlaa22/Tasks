import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:notes/screens/home.dart';

import 'controller/bloc/bloc_observer.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
