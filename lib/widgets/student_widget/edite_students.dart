import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:secretqrcode/models/students.dart';
import 'package:secretqrcode/widgets/student_widget/students_edite_dilog.dart';

import '../../service/crypt.dart';

class EditeStudents extends StatefulWidget {
  const EditeStudents({Key? key, required this.selectIndex})
      : super(key: key);
  final List<Students> selectIndex;

  @override
  _EditeStudentsState createState() => _EditeStudentsState();
}

class _EditeStudentsState extends State<EditeStudents> {
  String? empty1;
  String? empty2;
  bool? isContain(String val){
    bool? contain;
    if(val!=widget.selectIndex[0].stdNumber){
      for (var x in Hive.box<Students>('students')
          .values
          .toList()
          .cast<Students>()) {
        if (val==x.stdNumber) {
          contain= true;
          break;
        }

      }}
    return contain;
  }

  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
@override
  void initState() {

  controller1.text = widget.selectIndex[0].stdName!;
  controller2.text = widget.selectIndex[0].stdNumber!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text('تعديل معلومات الطالب'),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                onChanged: (val){
                  if(val.isNotEmpty){
                    setState(() {
                      empty1=null;
                    });
                  }

                },
                textInputAction: TextInputAction.next,
                controller: controller1,
                // textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.blue.shade100,
                  hintText: 'اسم الطالب',
                  errorText: empty1,

                  // hintTextDirection: TextDirection.rtl,
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
                textInputAction: TextInputAction.done,
                controller: controller2,

                // textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  errorText: empty2,
                  suffixIcon: Icon(Icons.note),
                  filled: true,
                  fillColor: Colors.blue.shade100,
                  hintText: 'رقم القيد',
                  //  hintTextDirection: TextDirection.rtl,
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
                    highlightColor: Colors.black,
                    splashColor: Colors.green,
                    focusColor: Colors.amber,
                    borderRadius: BorderRadius.circular(10),
                    onTap: () async {
                      if (controller1.text.isEmpty) {
                        setState(() {
                          controller1.text=widget.selectIndex[0].stdName!;
                        });
                      }
                      else  if (controller2.text.isEmpty) {
                        setState(() {
                          controller2.text=widget.selectIndex[0].stdNumber!;
                        });
                      }
                      else if(isContain(controller2.text)==true){

                        setState(() {
                          empty2='هذا الرقم موجود بالفعل';
                        });
                      }
                      else {
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StudentsEditeDilog(
                                stdNumber: controller2.text,
                                stdName: controller1.text,
                                selectIndex: widget.selectIndex[0],
                              );
                            });
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
                    borderRadius: BorderRadius.circular(10),
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
        ),
      ),
    );
  }
}
