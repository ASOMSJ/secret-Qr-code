import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:secretqrcode/models/students.dart';

import '../../service/crypt.dart';

class StudentsEditeDilog extends StatefulWidget {
  const StudentsEditeDilog({Key? key, required this.stdName, required this.stdNumber, required this.selectIndex}) : super(key: key);
final String stdName;final String stdNumber;
  final Students selectIndex;
  @override
  _StudentsEditeDilogState createState() => _StudentsEditeDilogState();
}



class _StudentsEditeDilogState extends State<StudentsEditeDilog> {
  AESEncryption encryption = AESEncryption();
  editItem(String stdName,String stdNumber) {


    for (var y in Hive.box<Students>('Students')
        .values
        .toList()
        .cast<Students>()) {
      if (widget.selectIndex == y) {

        y.stdName = stdName;
        y.stdNumber = stdNumber;
        y.qrCode=encryption.encryptMsg(stdName+'\n'+stdNumber).base16 ;
        y.save();
        break;
      }
    }




  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Text('تنبية'),
        content: const Text('هل تريد الاستمرار بتعديل المعلومات ؟'),
        actionsAlignment: MainAxisAlignment.start,
        actions: <Widget>[
          TextButton(
            child: Text('نعم'),
            onPressed: () async{
              await  editItem(widget.stdName,widget.stdNumber);
              Navigator.pop(context);// Dismiss alert dialog
            },
          ),
          TextButton(
            child: Text('إلغاء'),
            onPressed: () {
              Navigator.of(context)
                  .pop(); // Dismiss alert dialog
            },
          ),
        ],
      ),
    );
  }
}
