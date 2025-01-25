import 'dart:ui';

class Line {
  Line({required this.color, required this.points, required this.strokeWidth});
  final Color color;
  final List<Offset?> points;
  final double strokeWidth;

  Map<String, dynamic> toJson() {
    return {
      'color': color.value.toRadixString(16).padLeft(8, '0'),
      'points':
          points.map((p) => p != null ? {'x': p.dx, 'y': p.dy} : null).toList(),
      'strokeWidth': strokeWidth,
    };
  }

  static Line fromJson(Map<String, dynamic> json) {
    return Line(
        color: Color(int.parse(json['color'], radix: 16)),
        points: (json['points'] as List<dynamic>)
            .map((p) => p != null ? Offset(p['x'], p['y']) : null)
            .toList(),
        strokeWidth: json['strokeWidth']);
  }
}
