import 'package:flutter/foundation.dart';
import '../models/evento.dart';
import '../services/eventos_service.dart';

enum EventosState { idle, loading, success, error }

class EventosViewModel extends ChangeNotifier {
  EventosState _state = EventosState.idle;
  String _errorMessage = '';
  List<Evento> _eventos = [];
  List<Evento> _eventosFiltrados = [];

  // Getters
  EventosState get state => _state;
  String get errorMessage => _errorMessage;
  List<Evento> get eventos => _eventosFiltrados;
  bool get isLoading => _state == EventosState.loading;
  bool get hasEventos => _eventosFiltrados.isNotEmpty;

  // Cargar todos los eventos
  Future<void> cargarEventos() async {
    _setState(EventosState.loading);
    
    try {
      // Primero intentamos crear eventos de prueba si no existen
      await EventosService.crearEventosPrueba();
      
      _eventos = await EventosService.obtenerEventos();
      _eventosFiltrados = List.from(_eventos);
      _setState(EventosState.success);
      
      if (kDebugMode) {
        debugPrint('Eventos cargados: ${_eventos.length}');
      }
    } catch (e) {
      _setError('Error al cargar los eventos');
      if (kDebugMode) {
        debugPrint('Error al cargar eventos: $e');
      }
    }
  }

  // Crear nuevo evento
  Future<bool> crearEvento(Evento evento) async {
    try {
      _setState(EventosState.loading);
      
      final id = await EventosService.crearEvento(evento);
      final nuevoEvento = evento.copyWith(id: id);
      
      _eventos.add(nuevoEvento);
      _aplicarFiltros();
      _setState(EventosState.success);
      
      if (kDebugMode) {
        debugPrint('Evento creado exitosamente: ${nuevoEvento.nombre}');
      }
      return true;
    } catch (e) {
      _setError('Error al crear el evento');
      if (kDebugMode) {
        debugPrint('Error al crear evento: $e');
      }
      return false;
    }
  }

  // Actualizar evento
  Future<bool> actualizarEvento(String id, Evento evento) async {
    try {
      _setState(EventosState.loading);
      
      await EventosService.actualizarEvento(id, evento);
      
      final index = _eventos.indexWhere((e) => e.id == id);
      if (index != -1) {
        _eventos[index] = evento.copyWith(id: id);
        _aplicarFiltros();
      }
      
      _setState(EventosState.success);
      
      if (kDebugMode) {
        debugPrint('Evento actualizado exitosamente: ${evento.nombre}');
      }
      return true;
    } catch (e) {
      _setError('Error al actualizar el evento');
      if (kDebugMode) {
        debugPrint('Error al actualizar evento: $e');
      }
      return false;
    }
  }

  // Eliminar evento
  Future<bool> eliminarEvento(String id) async {
    try {
      _setState(EventosState.loading);
      
      await EventosService.eliminarEvento(id);
      
      _eventos.removeWhere((e) => e.id == id);
      _aplicarFiltros();
      _setState(EventosState.success);
      
      if (kDebugMode) {
        debugPrint('Evento eliminado exitosamente: $id');
      }
      return true;
    } catch (e) {
      _setError('Error al eliminar el evento');
      if (kDebugMode) {
        debugPrint('Error al eliminar evento: $e');
      }
      return false;
    }
  }

  // Actualizar estado del evento
  Future<bool> actualizarEstado(String id, String nuevoEstado) async {
    try {
      await EventosService.actualizarEstadoEvento(id, nuevoEstado);
      
      final index = _eventos.indexWhere((e) => e.id == id);
      if (index != -1) {
        _eventos[index] = _eventos[index].copyWith(estado: nuevoEstado);
        _aplicarFiltros();
      }
      
      notifyListeners();
      
      if (kDebugMode) {
        debugPrint('Estado actualizado: $id -> $nuevoEstado');
      }
      return true;
    } catch (e) {
      _setError('Error al actualizar el estado');
      if (kDebugMode) {
        debugPrint('Error al actualizar estado: $e');
      }
      return false;
    }
  }

  // Buscar eventos
  void buscarEventos(String termino) {
    if (termino.isEmpty) {
      _eventosFiltrados = List.from(_eventos);
    } else {
      _eventosFiltrados = _eventos.where((evento) {
        final terminoLower = termino.toLowerCase();
        return evento.nombre.toLowerCase().contains(terminoLower) ||
            evento.lugar.toLowerCase().contains(terminoLower) ||
            evento.organizador.toLowerCase().contains(terminoLower);
      }).toList();
    }
    notifyListeners();
  }

  // Filtrar por categoría
  void filtrarPorCategoria(String? categoria) {
    if (categoria == null || categoria.isEmpty) {
      _eventosFiltrados = List.from(_eventos);
    } else {
      _eventosFiltrados = _eventos.where((evento) => evento.categoria == categoria).toList();
    }
    notifyListeners();
  }

  // Obtener evento por ID
  Future<Evento?> obtenerEvento(String id) async {
    try {
      return await EventosService.obtenerEventoPorId(id);
    } catch (e) {
      _setError('Error al cargar el evento');
      if (kDebugMode) {
        debugPrint('Error al obtener evento: $e');
      }
      return null;
    }
  }

  // Reset state
  void resetState() {
    _setState(EventosState.idle);
  }

  // Métodos privados
  void _setState(EventosState newState) {
    _state = newState;
    if (newState != EventosState.error) {
      _errorMessage = '';
    }
    notifyListeners();
  }

  void _setError(String message) {
    _state = EventosState.error;
    _errorMessage = message;
    notifyListeners();
  }

  void _aplicarFiltros() {
    _eventosFiltrados = List.from(_eventos);
  }
}