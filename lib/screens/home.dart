
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:secretqrcode/models/model_dataenrties.dart';
import 'package:secretqrcode/screens/student_data.dart';

import 'scan_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.dataEntries, }) : super(key: key);
  final DataEntries dataEntries;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {
    return   DefaultTabController(
      length: 2,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(

          bottomNavigationBar: const TabBar(

            indicatorColor:  Color(0xffffffff),
            labelColor: Colors.blue,
              unselectedLabelColor:Colors.grey,

            tabs: [
              Tab(
                icon: Icon(Icons.person),
                iconMargin: EdgeInsets.only(bottom: 0.0),
                height: 50,

              ),
              Tab(
                icon: Icon(Icons.qr_code_scanner),
                iconMargin: EdgeInsets.only(bottom: 0.0),
                height: 50,
              ),


            ],
          ),
          body: TabBarView(
            children: [
              StudentData(dataEntries: widget.dataEntries,),
              ScanQR(),
            ],
          ),
        ),
      ),
    );
  }
}