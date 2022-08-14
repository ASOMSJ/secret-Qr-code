import 'dart:convert';

class Admin {
 final String  adminId;
 final String userName;
 final String password;


  Admin({required this.adminId, required this.userName, required this.password});

  factory Admin.fromJson(Map<String, dynamic> map) {
    return Admin(adminId: map["adminId"], userName:map["userName"],password: map["password"],
     );
  }

  Map<String, dynamic> toJson() {
    return {"adminId": adminId, "userName": userName, "password": password};
  }

  @override
  String toString() {
    return 'Admin{adminId: $adminId, userName: $userName, password:$password}';
  }

}



List<Admin> AdminFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Admin>.from(data.map((item) => Admin.fromJson(item)));
}

String AdminToJson(Admin data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}