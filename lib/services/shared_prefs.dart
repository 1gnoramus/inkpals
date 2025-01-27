import 'dart:convert';

import 'package:inkpals_app/models/drawing_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository {
  Future<void> saveDrawingOffline(DrawingModel drawing) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<DrawingModel> drawings = [];

    String? savedData = prefs.getString('saved_drawings');
    if (savedData != null) {
      List<dynamic> decodedData = json.decode(savedData);
      drawings = decodedData.map((e) => DrawingModel.fromJson(e)).toList();
    }
    drawings.add(drawing);

    await prefs.setString(
      'saved_drawings',
      json.encode(drawings.map((e) => e.toJson()).toList()),
    );
  }

  Future<List<DrawingModel>> getDrawingsOffline() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedDrawings = prefs.getString('saved_drawings');
    List<DrawingModel> drawings = [];
    if (savedDrawings != null) {
      List<dynamic> decodedData = json.decode(savedDrawings);

      drawings = decodedData.map((e) => DrawingModel.fromJson(e)).toList();
    }
    return drawings;
  }

  Future<void> updateDrawingOffline(DrawingModel updatedDrawing) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<DrawingModel> savedDrawings = await getDrawingsOffline();
    for (int i = 0; i < savedDrawings.length; i++) {
      if (savedDrawings[i].id == updatedDrawing.id) {
        savedDrawings[i] = updatedDrawing;
        break;
      }
    }
    await prefs.setString(
      'saved_drawings',
      json.encode(
        savedDrawings.map((e) => e.toJson()).toList(),
      ),
    );
  }

  void clearAllPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Полное удаление всех данных
  }
}
