import 'dart:convert';

class DataEntries {
  final String  data_entriesId;
  final String userName;
  final String password;
  final String adminId;


  DataEntries( {required this.data_entriesId, required this.userName, required this.password,required this.adminId,});

  factory DataEntries.fromJson(Map<String, dynamic> map) {
    return DataEntries(data_entriesId: map["data_entriesId"], userName:map["username"],password: map["password"], adminId: map["adminId"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"data_entriesId": data_entriesId, "username": userName, "password": password, "adminId": adminId};
  }

  @override
  String toString() {
    return 'DataEntries{data_entriesId: $data_entriesId, userName: $userName, password:$password, adminId:$adminId}';
  }

}



List<DataEntries> DataEntriesFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<DataEntries>.from(data.map((item) => DataEntries.fromJson(item)));
}

String DataEntriesToJson(DataEntries data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}