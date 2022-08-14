import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secretqrcode/models/model_dataenrties.dart';
import 'package:secretqrcode/service/api_service.dart';



class AddDataEntry extends StatefulWidget {
  const AddDataEntry({Key? key, required this.adminId}) : super(key: key);
final  String adminId;

  @override
  _AddDataEntryState createState() => _AddDataEntryState();
}

class _AddDataEntryState extends State<AddDataEntry> {
  String? empty1;
  String? empty2;
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();



  bool isContain(List<DataEntries>l){
    late bool s;
    for(var i in l){
      if(controller1.text==i.userName){
        s=true;

      }
      else{
        s=false;
      }
    }
    return s;

  }

  @override
  Widget build(BuildContext context) {


    return Directionality(textDirection:TextDirection.rtl,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text('إضافة مدخل بيانات'),
            const SizedBox(
              height: 10,
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                onChanged: (val)async{
                  List<DataEntries> l = (await ApiService().getDataEntriess());
                  if(val.isNotEmpty||isContain(l)==false){
                    setState(() {
                      empty1=null;
                    });
                  }

                },
                textInputAction:TextInputAction.done,
                controller: controller1,
                // textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.blue.shade100,
                  hintText: 'اسم المستخدم',
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
                  if(val.isNotEmpty){
                    setState(() {
                      empty2=null;
                    });
                  }

                },
                // inputFormatters: [
                //   FilteringTextInputFormatter.digitsOnly
                // ],
               // keyboardType:TextInputType.number,
                textInputAction:TextInputAction.next,
                controller: controller2,
                // textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.vpn_key_rounded),
                  filled: true,
                  fillColor: Colors.blue.shade100,
                  hintText: 'كلمة المرور',
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
                    onTap: ()async{
                      List<DataEntries> l = (await ApiService().getDataEntriess());
                      if(controller1.text.isEmpty){
                        setState(() {
                          empty1='اكمل الحقل الفارغ';
                        });
                      }
                      else if(isContain(l)){

                        setState(() {
                          empty1='اسم المستخدم هذا موجود بالفعل';
                        });
                      }

                      else if(controller2.text.isEmpty){

                        setState(() {
                          empty2='اكمل الحقل الفارغ';
                        });
                      }
                      else{
                     await  ApiService().createDataEntries(DataEntries(data_entriesId: '1', userName: controller1.text, password: controller2.text, adminId: widget.adminId));


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
        ),
      ),
    );
  }
}
