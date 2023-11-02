class DataModel {
  final String message;
  final String lat, lon;
  DataModel.fromJson(Map<String, dynamic> json)
      : message = json['msg'],
        lat = json['lat'],
        lon = json['lon'];
}
