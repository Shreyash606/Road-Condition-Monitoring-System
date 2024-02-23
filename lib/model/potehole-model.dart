class PoteHoleModel {
  final int id;
  final String lat;
  final String long;

  const PoteHoleModel({
    required this.id,
    required this.lat,
    required this.long,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lat': lat,
      'long': long,
    };
  }

  @override
  String toString() {
    return 'PoteHoleModel{id: $id, name: $lat, age: $long}';
  }
}
