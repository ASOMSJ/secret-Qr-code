import 'package:hive/hive.dart';
part 'students.g.dart';
@HiveType(typeId: 0)
class Students extends HiveObject {
  @HiveField(0)
  String? stdName;
  @HiveField(1)
  String? stdNumber;
  @HiveField(2)
  int? dataEntryId;
  @HiveField(3)
  String? qrCode;
  Students({this.stdName,this.stdNumber,this.dataEntryId,this.qrCode});
}





