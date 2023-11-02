class DataModel {
  final String msg;
  DataModel.fromJson(Map<String, dynamic> json) : msg = json['msg'];
}
