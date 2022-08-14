import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:secretqrcode/models/model_dataenrties.dart';
import 'package:secretqrcode/models/students.dart';
import 'package:secretqrcode/service/pdf_print_api.dart';
import 'package:secretqrcode/service/pdfapi.dart';
import 'package:secretqrcode/widgets/student_widget/add_students.dart';
import 'package:secretqrcode/widgets/student_widget/edite_students.dart';

class StudentData extends StatefulWidget {
  const StudentData({Key? key, required this.dataEntries, }) : super(key: key);
  final DataEntries dataEntries;
  @override
  _StudentDataState createState() => _StudentDataState();
}

class _StudentDataState extends State<StudentData> {

  bool edit = false;

  List<Students> selectIndex = [];

  delete() {
    setState(() {
      for (var x in selectIndex) {
        for (var y in Hive.box<Students>('students')
            .values
            .toList()
            .cast<Students>()) {

          if (x == y) {

            y.delete();

          }
        }
      }
      edit = false;
      selectIndex.clear();
    });

    print(Hive.box<Students>('students').values);
    print(selectIndex);
  }

  selectedBox() {
    if (selectIndex.length < Hive.box<Students>('students').length) {
        for (var y in Hive.box<Students>('students').values.toList()) {
          if (selectIndex.contains(y)) {
            continue;
          } else {
            setState(() {
              selectIndex.add(y);
            });
          }
        }
        print(selectIndex.length);

    } else {
      setState(() {
        edit = false;
        selectIndex.clear();
      });
    }
  }

  final doc = pw.Document();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: edit
            ? AppBar(
          title: Text(
            ' المحدد ${selectIndex.length} ',
          ),
          actions: [

            IconButton(
                onPressed:selectedBox,
                icon: selectIndex.length <
                    Hive.box<Students>('students').length
                    ? const Icon(Icons.check_box_outline_blank_outlined)
                    : const Icon(Icons.check_box)),
            IconButton(
              icon: const Icon(Icons.print),
              onPressed: () async{

                final pdfFile = await PdfPrintApi.generate(selectIndex);
                PdfApi.openFile(pdfFile);

                // await printingWedget().whenComplete(() =>  setState(() {
                //   doc.document.pdfPageList.pages.clear();
                //   selectIndex.clear();
                //   edit=false;
                // }));
              },

            ),

            selectIndex.length == 1?
                 IconButton(
                onPressed: () async {
                  await showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return EditeStudents(
                            selectIndex: selectIndex);
                      });
                  setState(() {
                    edit = false;
                    selectIndex.clear();
                  });
                  print(edit);
                  print(selectIndex);
                },
                icon: Icon(Icons.edit))

                : const Text(''),
            IconButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return Directionality(
                        textDirection: TextDirection.rtl,
                        child: AlertDialog(
                          title: Text('تنبية'),
                          content: Text('هل انت متأكد من حذف البيانات'),
                          actionsAlignment: MainAxisAlignment.start,
                          actions: <Widget>[
                            TextButton(
                              child: Text('نعم'),
                              onPressed: () {
                                delete();
                                Navigator.of(dialogContext)
                                    .pop(); // Dismiss alert dialog
                              },
                            ),
                            TextButton(
                              child: Text('إلغاء'),
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
                },
                icon: Icon(Icons.delete)),
            
          ],
        )
            : AppBar(
          title: const Text(
            'بيانات الطلاب',
          ),
          centerTitle: true,
        ),
        body: ValueListenableBuilder<Box<Students>>(
            valueListenable: Hive.box<Students>('students').listenable(),
            builder: (context, box, _) {
              final Students = box.values.toList().reversed.where((element) => element.dataEntryId.toString()==widget.dataEntries.data_entriesId.toString());
              final Students1 = Students.toList();
              return Students1.isEmpty?const Center(
                child: Text('لايوجد بيانات'),
              ):
              ListView.builder(
                  itemCount: Students1.length,
                  itemBuilder: (BuildContext context, index) {
                    return InkWell(
                      onLongPress: () {
                        setState(() {
                          edit = true;
                          if (edit) {
                            setState(() {
                              if (selectIndex.contains(Students1[index]) &&
                                  selectIndex.length == 1) {
                                selectIndex.clear();
                                edit = false;
                                print(index);
                                print('$selectIndex');
                                print('$edit');
                              } else if (selectIndex
                                  .contains(Students1[index]) &&
                                  selectIndex.length > 1) {
                                selectIndex.remove(Students1[index]);
                                print(index);
                                print('$selectIndex');
                                print('$edit');
                              } else {
                                selectIndex.add(Students1[index]);
                              }
                              print('$selectIndex');
                              print('$edit');
                            });
                          }
                        });
                        print('$selectIndex');
                        print('$edit');
                      },
                      onTap: () {
                        if (edit) {
                          setState(() {
                            if (selectIndex.contains(Students1[index]) &&
                                selectIndex.length == 1) {
                              selectIndex.clear();
                              edit = false;
                              print(index);
                              print('$selectIndex');
                              print('$edit');
                            }
                            else if (selectIndex
                                .contains(Students1[index]) &&
                                selectIndex.length > 1) {
                              selectIndex.remove(Students1[index]);
                              print(index);
                              print('$selectIndex');
                              print('$edit');
                            }
                            else {
                              selectIndex.add(Students1[index]);
                            }
                            print('$selectIndex');
                            print('$edit');
                          });
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(0),
                        height: 70,
                        decoration: BoxDecoration(
                            color: selectIndex.contains(Students1[index])
                                ? Colors.black12
                                : null,
                            border: Border.all(
                              color: Colors.blue,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            QrImage(
                              data: Students1[index].qrCode.toString(),
                              version: QrVersions.auto,
                              size: 80,
                              gapless: false,

                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              width: 3,
                              height: 40,
                              color: Colors.blue,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Students1[index].stdName.toString(),
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text(
                                  Students1[index].stdNumber.toString(),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    );
                  });
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return  AddStudents(dataEntries: widget.dataEntries,);
                });
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat
      ),
    );
  }

  // Future<void> printingWedget() async {
  //    doc.addPage(pw.MultiPage(
  //     build: (context)=>[
  //      printingPage(),// Center
  //     ]
  //   ));
  //   await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
  // }
  //
  // pw.Directionality printingPage() {
  //   return pw.Directionality(
  //     textDirection:pw.TextDirection.rtl,
  //     child: pw.ListView.builder(
  //       itemCount: selectIndex.length,
  //       itemBuilder: (context,index){
  //         return pw.Row(
  //             mainAxisAlignment: pw.MainAxisAlignment.end,
  //             children: [
  //               pw.Text(selectIndex[index].stdName.toString()),
  //               pw.SizedBox(width: 10),
  //               pw.Text(selectIndex[index].stdNumber.toString()),
  //               pw.BarcodeWidget(
  //                 data: selectIndex[index].qrCode.toString(),
  //                 barcode: pw.Barcode.qrCode(),
  //                 width: 50,
  //                 height: 50,
  //                 padding: const pw.EdgeInsets.all(8),
  //                 margin: const pw.EdgeInsets.all(8),
  //               ),
  //             ]
  //         );
  //       },
  //     ),
  //   );
  // }
}
