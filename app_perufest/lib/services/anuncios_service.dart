import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/anuncio.dart';

class AnunciosService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'anuncios';

  // Obtener todos los anuncios (para admin)
  Stream<List<Anuncio>> obtenerTodosLosAnuncios() {
    try {
      return _firestore
          .collection(_collection)
          .orderBy('fechaCreacion', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) {
                try {
                  return Anuncio.fromFirestore(doc);
                } catch (e) {
                  debugPrint('Error al procesar anuncio ${doc.id}: $e');
                  return null;
                }
              })
              .where((anuncio) => anuncio != null)
              .cast<Anuncio>()
              .toList())
          .handleError((error) {
            debugPrint('Error en stream de anuncios: $error');
          });
    } catch (e) {
      debugPrint('Error al obtener anuncios: $e');
      return Stream.value(<Anuncio>[]);
    }
  }

  // Obtener anuncios activos y vigentes (para usuarios)
  Stream<List<Anuncio>> obtenerAnunciosActivos({String? posicion}) {
    Query query = _firestore
        .collection(_collection)
        .where('activo', isEqualTo: true)
        .orderBy('orden');

    if (posicion != null) {
      query = query.where('posicion', isEqualTo: posicion);
    }

    return query.snapshots().map((snapshot) {
      final ahora = DateTime.now();
      return snapshot.docs
          .map((doc) => Anuncio.fromFirestore(doc))
          .where((anuncio) => 
              ahora.isAfter(anuncio.fechaInicio) && 
              ahora.isBefore(anuncio.fechaFin))
          .toList();
    });
  }

  // Crear anuncio
  Future<void> crearAnuncio(Anuncio anuncio) async {
    try {
      await _firestore.collection(_collection).add(anuncio.toFirestore());
    } catch (e) {
      throw Exception('Error al crear anuncio: $e');
    }
  }

  // Actualizar anuncio
  Future<void> actualizarAnuncio(Anuncio anuncio) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(anuncio.id)
          .update(anuncio.toFirestore());
    } catch (e) {
      throw Exception('Error al actualizar anuncio: $e');
    }
  }

  // Eliminar anuncio
  Future<void> eliminarAnuncio(String anuncioId) async {
    try {
      await _firestore.collection(_collection).doc(anuncioId).delete();
    } catch (e) {
      throw Exception('Error al eliminar anuncio: $e');
    }
  }

  // Cambiar estado activo/inactivo
  Future<void> cambiarEstadoAnuncio(String anuncioId, bool nuevoEstado) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(anuncioId)
          .update({'activo': nuevoEstado});
    } catch (e) {
      throw Exception('Error al cambiar estado del anuncio: $e');
    }
  }

  // Obtener siguiente número de orden
  Future<int> obtenerSiguienteOrden() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('orden', descending: true)
          .limit(1)
          .get();
      
      if (snapshot.docs.isEmpty) {
        return 1;
      }
      
      final ultimoOrden = snapshot.docs.first.data()['orden'] as int? ?? 0;
      return ultimoOrden + 1;
    } catch (e) {
      return 1;
    }
  }

  // Actualizar orden de anuncios
  Future<void> actualizarOrden(String anuncioId, int nuevoOrden) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(anuncioId)
          .update({'orden': nuevoOrden});
    } catch (e) {
      throw Exception('Error al actualizar orden: $e');
    }
  }
}