import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/agenda.dart';
class AgendaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String coleccion = 'agenda_usuarios';
  // Agregar actividad a agenda
  Future<bool> agregarActividadAAgenda(String userId, String actividadId) async {
    try {
      // Verificar si ya existe
      final existe = await _firestore
          .collection(coleccion)
          .where('userId', isEqualTo: userId)
          .where('actividadId', isEqualTo: actividadId)
          .get();
      if (existe.docs.isNotEmpty) {
        return false; // Ya existe
      }
      // Crear nuevo registro
      await _firestore.collection(coleccion).add({
        'userId': userId,
        'actividadId': actividadId,
        'fechaAgregado': FieldValue.serverTimestamp(),
        'estado': 'confirmado',
        'recordatorioMinutos': 30,
      });
      return true;
    } catch (e) {
      print('Error al agregar a agenda: $e');
      return false;
    }
  }
  // Quitar actividad de agenda
  Future<bool> quitarActividadDeAgenda(String userId, String actividadId) async {
    try {
      final query = await _firestore
          .collection(coleccion)
          .where('userId', isEqualTo: userId)
          .where('actividadId', isEqualTo: actividadId)
          .get();
      if (query.docs.isNotEmpty) {
        await _firestore.collection(coleccion).doc(query.docs.first.id).delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error al quitar de agenda: $e');
      return false;
    }
  }
  // Verificar si una actividad está en la agenda del usuario
  Future<bool> estaEnAgenda(String userId, String actividadId) async {
    try {
      final doc = await _firestore.collection(coleccion).doc(userId).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final actividades = List<String>.from(data['actividades'] ?? []);
        return actividades.contains(actividadId);
      }
      return false;
    } catch (e) {
      print('Error al verificar agenda: $e');
      return false;
    }
  }
  // Obtener todas las actividades de la agenda del usuario
  Future<List<String>> obtenerActividadesAgendadas(String userId) async {
    try {
      final doc = await _firestore.collection(coleccion).doc(userId).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        return List<String>.from(data['actividades'] ?? []);
      }
      return [];
    } catch (e) {
      print('Error al obtener agenda: $e');
      return [];
    }
  }
  Future<Map<String, dynamic>> obtenerDetallesAgenda(String userId) async {
    try {
      final doc = await _firestore.collection(coleccion).doc(userId).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        return {
          'actividades': List<String>.from(data['actividades'] ?? []),
          'detalles': Map<String, dynamic>.from(data['detalles'] ?? {}),
        };
      }
      return {'actividades': [], 'detalles': {}};
    } catch (e) {
      print('Error al obtener detalles agenda: $e');
      return {'actividades': [], 'detalles': {}};
    }
  }

  Future<List<AgendaUsuario>> obtenerAgendaPorUsuario(String userId) async {
    try {
      final doc = await _firestore.collection(coleccion).doc(userId).get();
      if (!doc.exists || doc.data() == null) return [];

      final data = doc.data()!;
      final actividades = List<String>.from(data['actividades'] ?? []);
      final detalles = Map<String, dynamic>.from(data['detalles'] ?? {});

      return actividades.map((actividadId) {
        final detalle = detalles[actividadId] ?? {};
        return AgendaUsuario(
          id: actividadId,
          userId: userId,
          actividadId: actividadId,
          fechaAgregado: (detalle['fechaAgregado'] as Timestamp?)?.toDate() ?? DateTime.now(),
          estado: 'confirmado',
          recordatorioMinutos: detalle['recordatorioMinutos'] ?? 30,
        );
      }).toList();
    } catch (e) {
      print('Error al obtener agenda por usuario: $e');
      return [];
    }
  }

  Future<bool> alternarActividadEnAgenda(String userId, String actividadId, bool estaEnAgenda, {int recordatorioMinutos = 30}) async {
    try {
      final docRef = _firestore.collection(coleccion).doc(userId);

      if (estaEnAgenda) {
        // Remover
        await docRef.update({
          'actividades': FieldValue.arrayRemove([actividadId]),
          'detalles.$actividadId': FieldValue.delete(),
        });
      } else {
        // Agregar con recordatorio calculado
        final agendaItem = {
          'actividadId': actividadId,
          'fechaAgregado': FieldValue.serverTimestamp(),
          'recordatorioMinutos': recordatorioMinutos,
        };

        await docRef.set({
          'actividades': FieldValue.arrayUnion([actividadId]),
          'detalles': {actividadId: agendaItem}
        }, SetOptions(merge: true));
      }

      return true;
    } catch (e) {
      print('Error al alterar agenda: $e');
      return false;
    }
  }

}