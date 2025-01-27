import 'package:inkpals_app/models/line_model.dart';

class DrawingModel {
  final String name;
  final String id;
  final List<Line> lines;

  DrawingModel({required this.name, required this.id, required this.lines});

  factory DrawingModel.fromJson(Map<String, dynamic> json) {
    return DrawingModel(
      name: json['name'],
      id: json['id'],
      lines: (json['lines'] as List<dynamic>)
          .map((e) => Line.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lines': lines.map((e) => e.toJson()).toList(),
    };
  }
}
