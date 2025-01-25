class DrawingModel {
  final String name;
  final String id;

  DrawingModel({required this.name, required this.id});

  factory DrawingModel.fromJson(Map<String, dynamic> json) {
    return DrawingModel(name: json['name'], id: json['id']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
