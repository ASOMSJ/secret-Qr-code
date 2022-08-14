import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:secretqrcode/models/model_dataenrties.dart';
import 'package:secretqrcode/screens/home.dart';
import 'package:secretqrcode/screens/login.dart';
import 'package:secretqrcode/screens/student_data.dart';


import 'models/students.dart';
void main()async{

  await Hive.initFlutter();
  Hive.registerAdapter(StudentsAdapter());
  await Hive.openBox<Students>('students');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Login(),
      //Home(dataEntries: DataEntries(data_entriesId: '125',userName: 'uhufue',password: 'jhgyf',adminId: 'jygjfth'),),
    );
  }
}

