

import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:secretqrcode/models/model_dataenrties.dart';
import 'package:secretqrcode/models/students.dart';

import '../../service/crypt.dart';



class AddStudents extends StatefulWidget {
  const AddStudents({Key? key, required this.dataEntries, }) : super(key: key);
  final DataEntries dataEntries;

  @override
  _AddStudentsState createState() => _AddStudentsState();
}

class _AddStudentsState extends State<AddStudents> {
  String? empty1;
  String? empty2;
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  AESEncryption encryption = AESEncryption();
  bool? isContain(String val){
    bool? contain;
    for (var x in Hive.box<Students>('Students')
        .values
        .toList()
        .cast<Students>()) {
      if (val==x.stdNumber) {
       contain= true;
       break;
      }

    }
    return contain;
  }
  bool isFromWrite=false;
  @override
  void dispose() {
   controller1.dispose();
   controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Directionality(textDirection:TextDirection.rtl,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child:isFromWrite?
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text('إضافة طالب جديد'),
            const SizedBox(
              height: 10,
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                onChanged: (val){
                  if(val.isNotEmpty ){
                    setState(() {
                      empty1=null;
                    });
                  }

                },
                textInputAction:TextInputAction.done,
                controller: controller1,
                // textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.blue.shade100,
                  hintText: 'اسم الطالب',
                  errorText: empty1,
                  //  hintTextDirection: TextDirection.rtl,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                onChanged: (val){
                  if(val.isNotEmpty|| (isContain(val)==null) ){
                    setState(() {
                      empty2=null;
                    });
                  }

                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                keyboardType:TextInputType.number,
                textInputAction:TextInputAction.next,
                controller: controller2,
                // textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.note),
                  filled: true,
                  fillColor: Colors.blue.shade100,
                  hintText: 'رقم القيد',
                  errorText: empty2,

                  // hintTextDirection: TextDirection.rtl,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    hoverColor: Colors.red,
                    highlightColor:Colors.black ,
                    splashColor: Colors.green,
                    focusColor: Colors.amber,

                    borderRadius:BorderRadius.circular(10),
                    onTap: () {

                      if(controller1.text.isEmpty){
                        setState(() {
                          empty1='اكمل الحقل الفارغ';
                        });
                      }
                      else if(controller2.text.isEmpty){

                        setState(() {
                          empty2='اكمل الحقل الفارغ';
                        });
                      }
                      else if(isContain(controller2.text)==true){

                        setState(() {
                          empty2='هذا الرقم موجود بالفعل';
                        });
                      }
                      else{
                        final students = Students()
                          ..stdNumber = controller2.text
                        ..stdName=controller1.text
                        ..dataEntryId=int.parse(widget.dataEntries.data_entriesId)
                        ..qrCode=encryption.encryptMsg(controller1.text+'\n'+controller2.text).base16

                        ;


                        Hive.box<Students>('students').add(students);

                        controller1.clear();
                        controller2.clear();

                        Navigator.of(context).pop();
                      }



                    },
                    child: Container(
                      // margin: EdgeInsets.all(1),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: 55,

                      child: const Text('حفظ'),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius:BorderRadius.circular(10),
                    onTap: () {
                      controller1.clear();
                      controller2.clear();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      //  margin: EdgeInsets.all(1),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: 55,

                      child: const Text('الغاء'),
                      decoration: BoxDecoration(

                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ):

         Padding(
           padding: const EdgeInsets.all(25),
           child: Row(
            // mainAxisSize: MainAxisSize.min,
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
               ElevatedButton(onPressed: (){
                 setState(() {
                   isFromWrite=true;
                 });
               }, child: const Text('ادخال يدوي')),
               ElevatedButton(
                   onPressed: ()async{
                     FilePickerResult? result = await FilePicker.platform.pickFiles(
                       type: FileType.custom,
                       allowedExtensions: ['xlsx']
                     );

                     if (result != null) {
                  try{
                    File file = File(result.files.single.path.toString());
                    var bytes = file.readAsBytesSync();
                    var excel = Excel.decodeBytes(bytes);

                    for (var table in excel.tables.keys) {
                      // print(table); //sheet Name
                      //  print(excel.tables[table]!.row(0)[0]!.value+excel.tables[table]!.row(0)[1]!.value);
                      for (var r =0;r < excel.tables[table]!.maxRows;r++){
                        if(excel.tables[table]!.row(r)[0]!=null){
                          // print(excel.tables[table]!.row(r)[0]!.value.toString() + excel.tables[table]!.row(r)[1]!.value.toString());
                          final students = Students()
                            ..stdNumber = excel.tables[table]!.row(r)[0]!.value.toString()
                            ..stdName=excel.tables[table]!.row(r)[1]!.value.toString()
                            ..dataEntryId=int.parse(widget.dataEntries.data_entriesId)
                            ..qrCode=encryption.encryptMsg(excel.tables[table]!.row(r)[1]!.value.toString()+'\n'+excel.tables[table]!.row(r)[0]!.value.toString()).base16

                          ;


                          Hive.box<Students>('students').add(students);


                        }
                      }
                    }
                  }catch(e){
               await     showDialog<void>(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return Directionality(
                          textDirection: TextDirection.rtl,
                          child: AlertDialog(
                            title: const Text('هناك مشكلة'),
                            content: const Text('يجب ان يحتوي ملف الاكسل على عمودين من اسماء الطلاب وارقام القيد فقط '),
                            actionsAlignment: MainAxisAlignment.start,
                            actions: <Widget>[
                              TextButton(
                                child: const Text('فهمت'),
                                onPressed: () {
                                  Navigator.of(dialogContext)
                                      .pop(); // Dismiss alert dialog
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                     }

                 Navigator.of(context).pop();
               }, child: const Text('ادخال من ملف اكسل')),

             ],
           ),
         ),
      ),
    );
  }
}
