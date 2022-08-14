import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:secretqrcode/models/model_admin.dart';
import 'package:secretqrcode/models/model_dataenrties.dart';
import 'package:secretqrcode/service/api_service.dart';
import 'admin_page.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoad = false;
  String? empty1;
  String? empty2;

  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  @override
  void dispose() {
   controller1.dispose();
   controller2.dispose();
   Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: isLoad
            ? Center(child: CircularProgressIndicator())
            : Container(
                padding: EdgeInsets.all(30),
                child: SingleChildScrollView(

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Lottie.asset('assets/7803-qr-code-scanner.json',
                          width: 200, height: 200),
                      const SizedBox(
                        height: 30,
                      ),
                      TextField(
                        onChanged: (val) {
                          if (val.isNotEmpty) {
                            setState(() {
                              empty1 = null;
                            });
                          }
                        },
                        textInputAction: TextInputAction.done,
                        controller: controller1,
                        decoration: InputDecoration(
                          errorText: empty1,
                          suffixIcon: const Icon(Icons.person_outline),
                          filled: true,
                          fillColor: Colors.blue.shade100,
                          hintText: 'أسم المستخدم',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextField(
                        onChanged: (val) {
                          if (val.isNotEmpty) {
                            setState(() {
                              empty2 = null;
                            });
                          }
                        },
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        controller: controller2,
                        decoration: InputDecoration(
                          errorText: empty2,
                          suffixIcon: const Icon(Icons.vpn_key_outlined),
                          filled: true,
                          fillColor: Colors.blue.shade100,
                          hintText: 'كلمة المرور',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        hoverColor: Colors.red,
                        highlightColor: Colors.black,
                        splashColor: Colors.green,
                        focusColor: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                        onTap: () async {
                          if (controller1.text.isEmpty) {
                            setState(() {
                              empty1 = 'اكمل الحقل الفارغ';
                            });
                          } else if (controller2.text.isEmpty) {
                            setState(() {
                              empty2 = 'اكمل الحقل الفارغ';
                            });
                          } else {
                            setState(() {
                              isLoad = true;
                            });

                            List<Admin> l1 = (await ApiService().getAdmins());
                            List<DataEntries> l2 =
                                (await ApiService().getDataEntriess());
                            print('l1=$l1');
                            print('l2=$l2');
                            if (l1.isNotEmpty && isContainAdmin(l1)) {
                              setState(() {
                                isLoad = false;

                              });
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => AdminPage(
                                    admin: spsAdmin(l1),
                                  ),
                                ),
                              );
                            }
                            else if (l2.isNotEmpty &&  isContainDataEntry(l2)) {
                              setState(() {
                                 isLoad = false;
                              });
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => Home(
                                    dataEntries: spsEntry(l2),
                                  ),
                                ),
                              );
                            }
                            else {
                              setState(() => isLoad = false);
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: AlertDialog(
                                      title: const Text('عذراً'),
                                      content:
                                          const Text('هذه المستخدم غير موجود'),
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
                            }
                          }
                        },
                        child: Container(
                          // margin: EdgeInsets.all(1),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: 40,

                          child: const Text('تسجيل الدخول'),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  bool isContainAdmin(List<Admin> l) {
     bool s=false;
    for (var i in l) {
      if (controller1.text == i.userName && controller2.text == i.password) {
        s = true;
        break;
      }
    }
    return s;
  }
  bool isContainDataEntry(List<DataEntries> l) {
     bool s=false;
    for (var i in l) {
      if (controller1.text == i.userName && controller2.text == i.password) {
        s = true;
        break;
      }
    }
    return s;
  }

  Admin spsAdmin(List<Admin> l) {
    late Admin a;
    for (var i in l) {
      if (i.userName == controller1.text) {
        a = i;
        break;
      }
    }
    return a;
  }

  DataEntries spsEntry(List<DataEntries> l) {
    late DataEntries a;
    for (var i in l) {
      if (i.userName == controller1.text) {
        a = i;
        break;
      }
    }
    return a;
  }
}
