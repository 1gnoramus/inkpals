import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inkpals_app/models/drawing_model.dart';
import 'package:inkpals_app/models/line_model.dart';

class FirebaseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<DrawingModel>> getDrawingsFromFirestore() async {
    try {
      QuerySnapshot drawingSnapshot =
          await _firestore.collection('drawings').get();
      List<DrawingModel> drawings = drawingSnapshot.docs.map((doc) {
        return DrawingModel(
          name: doc['name'],
          id: doc['id'],
          lines: (doc['lines'] as List<dynamic>)
              .map((line) => Line.fromJson(line))
              .toList(),
        );
      }).toList();
      return drawings;
    } catch (e) {
      throw Exception('Error fetching drawing ${e}');
    }
  }

  Future<void> saveDrawingtoFirestore(DrawingModel drawing) async {
    // if (drawing == null) {
    //   throw ArgumentError('Drawing cannot t be null');
    // }
    try {
      await _firestore.collection('drawings').doc(drawing.id).set({
        'name': drawing.name,
        'id': drawing.id,
        'lines': drawing.lines.map((line) => line.toJson()).toList(),
      });
      print('Drawing ${drawing.name} sent to Firestore');
    } catch (e) {
      print('Error sending drawing to Firestore ${e}');
    }
  }

  Future<void> updateDrawingFirestore(DrawingModel drawing) async {
    try {
      QuerySnapshot drawingSnapshot = await _firestore
          .collection('drawings')
          .where('id', isEqualTo: drawing.id)
          .get();
      if (drawingSnapshot.docs.isNotEmpty) {
        await drawingSnapshot.docs.first.reference.update({
          'lines': drawing.lines.map((line) => line.toJson()).toList(),
        });
        print('Drawing ${drawing.name} updated in Firestore');
      } else {
        print('Drawing with id ${drawing.id} not found');
      }
    } catch (e) {
      print('Error updating drawing to Firestore ${e}');
    }
  }

  Future<void> deleteDrawingFirestore(DrawingModel drawing) async {
    // if (drawing.id == null || drawing.id.isEmpty) {
    //   print('Error: Drawing ID is null or empty');
    //   return;
    // }
    try {
      QuerySnapshot drawingSnapshot = await _firestore
          .collection('drawings')
          .where('id', isEqualTo: drawing.id)
          .get();
      if (drawingSnapshot.docs.isNotEmpty) {
        for (var doc in drawingSnapshot.docs) {
          await _firestore.collection('drawings').doc(doc.id).delete();
          print('Deleted drawing: ${drawing.id}');
        }
      } else {
        print('No drawings found with ID: ${drawing.id}');
      }
    } catch (e) {
      print('Error deleting records: $e');
    }
  }
}
