import 'package:flutter/material.dart';
import 'package:secretqrcode/models/model_dataenrties.dart';
import 'package:secretqrcode/service/api_service.dart';

class DataEntryEditeDilog extends StatefulWidget {
  const DataEntryEditeDilog({Key? key, required this.userName, required this.password, required this.dataEntries,}) : super(key: key);
final String userName;
final String password;
final DataEntries dataEntries;
  @override
  _DataEntryEditeDilogState createState() => _DataEntryEditeDilogState();
}



class _DataEntryEditeDilogState extends State<DataEntryEditeDilog> {

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
              await  ApiService().updateDataEntries(DataEntries(data_entriesId: widget.dataEntries.data_entriesId, userName: widget.userName, password: widget.password, adminId: widget.dataEntries.adminId));
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
