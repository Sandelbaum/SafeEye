class DataModel {
  final String code, message;
  DataModel.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        message = json['string'];
}
