
import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:secretqrcode/models/model_admin.dart';
import 'package:secretqrcode/models/model_dataenrties.dart';



class ApiService {
  final String baseUrl = "http://192.168.43.130";
  Client client = Client();
late List<Admin> list1;
late List<DataEntries> list2;
  //List<DataEntries> data = [];

  Future<List<Admin>> getAdmins() async {
    final response = await client.get(Uri.parse( "$baseUrl/qrcode/admin/getdata.php"));
    if (response.statusCode == 200) {
      // print (response.body);
      var data=json.decode(response.body);
      var res=data as List;
      list1=res.map<Admin>((json) => Admin.fromJson(json)).toList();

    }
    return list1;
  }


  Future<List<DataEntries>> getDataEntriess() async {
    final response = await client.get(Uri.parse( "$baseUrl/qrcode/dataentries/getdata.php"));
     if (response.statusCode == 200) {
     // print (response.body);

var data=json.decode(response.body);
var res=data as List;
list2=res.map<DataEntries>((json) => DataEntries.fromJson(json)).toList();

     }
     return list2;
  }

  Future<bool> createDataEntries(DataEntries data) async {
    final response = await client.post(
        Uri.parse( "$baseUrl/qrcode/dataentries/postdata.php"),
      body:  data.toJson(),
    );
    if (response.statusCode == 200) {
      print(response.body);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateDataEntries(DataEntries data) async {
    final response = await client.post(
      Uri.parse( "$baseUrl/qrcode/dataentries/updatedata.php"),
      body:  data.toJson(),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
  Future<bool> deleteDataEntries(DataEntries data) async {
    final response = await client.post(
      Uri.parse( "$baseUrl/qrcode/dataentries/deletedata.php"),
      body:  data.toJson(),
    );
    if (response.statusCode == 200) {
      print('done');
      return true;
    } else {
      print('error');
      return false;
    }
  }
}