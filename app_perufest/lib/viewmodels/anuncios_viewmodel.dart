import 'package:flutter/material.dart';
import 'dart:io';
import '../models/anuncio.dart';
import '../services/anuncios_service.dart';
import '../services/imgbb_service.dart';

class AnunciosViewModel extends ChangeNotifier {
  final AnunciosService _anunciosService = AnunciosService();

  List<Anuncio> _anuncios = [];
  bool _isLoading = false;
  String? _error;

  List<Anuncio> get anuncios => _anuncios;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Inicializar y escuchar cambios
  void initialize() {
    try {
      _anunciosService.obtenerTodosLosAnuncios().listen(
        (anuncios) {
          if (mounted) {
            _anuncios = anuncios;
            notifyListeners();
          }
        },
        onError: (error) {
          if (mounted) {
            _error = error.toString();
            notifyListeners();
          }
        },
      );
    } catch (e) {
      _error = 'Error al inicializar: $e';
      notifyListeners();
    }
  }

  // Verificar si el widget sigue montado
  bool get mounted => hasListeners;

  // Crear nuevo anuncio
  Future<bool> crearAnuncio({
    required String titulo,
    required String contenido,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required String posicion,
    required String creadoPor,
    String? imagenPath,
  }) async {
    _setLoading(true);
    try {
      String? imagenUrl;
      
      // Subir imagen si se proporcionó
      if (imagenPath != null && imagenPath.isNotEmpty) {
        final imagenFile = File(imagenPath);
        imagenUrl = await ImgBBService.subirImagenPerfil(imagenFile, 'anuncio_${DateTime.now().millisecondsSinceEpoch}');
      }

      final orden = await _anunciosService.obtenerSiguienteOrden();
      
      final anuncio = Anuncio(
        id: '', // Se asigna automáticamente por Firestore
        titulo: titulo,
        contenido: contenido,
        imagenUrl: imagenUrl,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
        posicion: posicion,
        activo: true,
        orden: orden,
        fechaCreacion: DateTime.now(),
        creadoPor: creadoPor,
      );

      await _anunciosService.crearAnuncio(anuncio);
      _clearError();
      return true;
    } catch (e) {
      _setError('Error al crear anuncio: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Actualizar anuncio existente
  Future<bool> actualizarAnuncio({
    required String anuncioId,
    required String titulo,
    required String contenido,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required String posicion,
    String? nuevaImagenPath,
    String? imagenUrlActual,
  }) async {
    _setLoading(true);
    try {
      String? imagenUrl = imagenUrlActual;
      
      // Subir nueva imagen si se proporcionó
      if (nuevaImagenPath != null && nuevaImagenPath.isNotEmpty) {
        final imagenFile = File(nuevaImagenPath);
        imagenUrl = await ImgBBService.subirImagenPerfil(imagenFile, 'anuncio_${DateTime.now().millisecondsSinceEpoch}');
      }

      final anuncioOriginal = _anuncios.firstWhere((a) => a.id == anuncioId);
      final anuncioActualizado = anuncioOriginal.copyWith(
        titulo: titulo,
        contenido: contenido,
        imagenUrl: imagenUrl,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
        posicion: posicion,
      );

      await _anunciosService.actualizarAnuncio(anuncioActualizado);
      _clearError();
      return true;
    } catch (e) {
      _setError('Error al actualizar anuncio: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Eliminar anuncio
  Future<bool> eliminarAnuncio(String anuncioId) async {
    _setLoading(true);
    try {
      await _anunciosService.eliminarAnuncio(anuncioId);
      _clearError();
      return true;
    } catch (e) {
      _setError('Error al eliminar anuncio: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Cambiar estado activo/inactivo
  Future<bool> cambiarEstadoAnuncio(String anuncioId, bool nuevoEstado) async {
    try {
      await _anunciosService.cambiarEstadoAnuncio(anuncioId, nuevoEstado);
      _clearError();
      return true;
    } catch (e) {
      _setError('Error al cambiar estado: ${e.toString()}');
      return false;
    }
  }

  // Obtener anuncios activos por posición
  Stream<List<Anuncio>> obtenerAnunciosActivos({String? posicion}) {
    return _anunciosService.obtenerAnunciosActivos(posicion: posicion);
  }

  // Métodos auxiliares
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}