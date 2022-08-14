import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:secretqrcode/models/model_admin.dart';
import 'package:secretqrcode/models/model_dataenrties.dart';
import 'package:secretqrcode/service/api_service.dart';
import 'package:secretqrcode/widgets/data_entries_widget/add_data_entry.dart';
import 'package:secretqrcode/widgets/data_entries_widget/edite_data_entry.dart';


class AdminPage extends StatefulWidget {
  const AdminPage({Key? key, required this.admin}) : super(key: key);
  final Admin admin;

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  bool edit = false;

  List<DataEntries> selectIndex = [];

  Future delete() async {
    for (var x in selectIndex) {
      for (var y in data) {
        if (x.data_entriesId == y.data_entriesId) {
          await ApiService().deleteDataEntries(y);
        }
      }
    }
    setState(() {
      edit = false;
      selectIndex.clear();
      getDataEntry();
    });

    print(selectIndex);
  }

  selectedBox() {
    if (selectIndex.length < data.length) {
        for (var y in data) {
          if (selectIndex.contains(y)) {
            continue;
          } else {
            setState(() {
              selectIndex.add(y);
            });
          }
        }

    } else {
      setState(() {
        edit = false;
        selectIndex.clear();
      });
    }
  }

  List<DataEntries> data = [];

  Future getDataEntry() async {
    final response = await ApiService().client.get(
        Uri.parse("${ApiService().baseUrl}/qrcode/dataentries/getdata.php"));
    if (response.statusCode == 200) {
      var data1 = jsonDecode(response.body) as List;
      var res =
          data1.map<DataEntries>((json) => DataEntries.fromJson(json)).toList();
      setState(() {
        data = res.reversed
            .where((element) => element.adminId == widget.admin.adminId)
            .toList();
        print('feach done');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDataEntry();
  }

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
                      onPressed: selectedBox,
                      icon: selectIndex.length < data.length
                          ? Icon(Icons.check_box_outline_blank_outlined)
                          : Icon(Icons.check_box)),
                  selectIndex.length == 1
                      ? IconButton(
                          onPressed: () async {
                            await showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return EditeDataEntry(
                                    dataEntries: selectIndex[0],
                                  );
                                });
                            setState(() {
                              edit = false;
                              selectIndex.clear();
                              getDataEntry();
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
                                    onPressed: () async {
                                      await delete();
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
                  'مدخلي البيانات',
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: (){
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: AlertDialog(
                              title: const Text('معلومات المدير'),
                              content:
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,

                                children: [
                                   Row(

                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                     children: [
                                       Text('اسم المستخدم'), Text(widget.admin.userName),
                                     ],
                                   ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('كلمة المرور'), Text(widget.admin.password),
                                    ],
                                  ),
                                ],
                              ),
                              actionsAlignment: MainAxisAlignment.start,
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('رجوع'),
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
                    icon: Icon(Icons.person),
                )],
              ),
        body: data.isNotEmpty
            ? ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, index) {
                  return InkWell(
                    onLongPress: () {
                      setState(() {
                        edit = true;
                      });

                      if (edit) {
                        if (selectIndex.contains(data[index]) &&
                            selectIndex.length == 1) {
                          setState(() {
                            selectIndex.clear();
                            edit = false;
                          });
                          print(index);
                          print('$selectIndex');
                          print('$edit');
                        } else if (selectIndex.contains(data[index]) &&
                            selectIndex.length > 1) {
                          setState(() {
                            selectIndex.remove(data[index]);
                          });
                          print(index);
                          print('$selectIndex');
                          print('$edit');
                        } else {
                          setState(() {
                            selectIndex.add(data[index]);
                          });
                        }
                        print('$selectIndex');
                        print('$edit');
                      }

                      print('$selectIndex');
                      print('$edit');
                    },
                    onTap: () {
                      if (edit) {
                        if (selectIndex.contains(data[index]) &&
                            selectIndex.length == 1) {
                          setState(() {
                            selectIndex.clear();
                            edit = false;
                          });
                          print(index);
                          print('$selectIndex');
                          print('$edit');
                        } else if (selectIndex.contains(data[index]) &&
                            selectIndex.length > 1) {
                          setState(() {
                            selectIndex.remove(data[index]);
                          });
                          print(index);
                          print('$selectIndex');
                          print('$edit');
                        } else {
                          setState(() {
                            selectIndex.add(data[index]);
                          });
                        }
                        print('$selectIndex');
                        print('$edit');
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(8),
                      height: 60,
                      decoration: BoxDecoration(
                          color: selectIndex.contains(data[index])
                              ? Colors.black12
                              : null,
                          border: Border.all(
                            color: Colors.blue,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                       // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                             Icon(Icons.person,size: 18,),
                                Icon(Icons.vpn_key_rounded,size: 18,)
                              ],
                            ),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data[index].userName.toString(),
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                data[index].password.toString(),
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                })
            : const Center(child: Text('لايوجد مدخلي بيانات')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return AddDataEntry(
                    adminId: widget.admin.adminId,
                  );
                }).whenComplete(() => setState(() {
                  getDataEntry();
                }));
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }
}
