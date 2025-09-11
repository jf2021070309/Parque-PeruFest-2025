import 'package:flutter/material.dart';
import '../../dominio/casos_uso/gestionar_eventos.dart';
import '../../dominio/modelos/evento.dart';

class AdminEventosViewModel extends ChangeNotifier {
  final GestionarEventos _gestionarEventos;

  AdminEventosViewModel(this._gestionarEventos);

  // Estado de la lista de eventos
  List<Evento> _eventos = [];
  bool _cargandoEventos = false;
  String? _errorEventos;

  // Estado del formulario de evento
  bool _guardandoEvento = false;
  String? _errorFormulario;
  String? _mensajeExito;

  // Getters
  List<Evento> get eventos => _eventos;
  bool get cargandoEventos => _cargandoEventos;
  String? get errorEventos => _errorEventos;
  bool get guardandoEvento => _guardandoEvento;
  String? get errorFormulario => _errorFormulario;
  String? get mensajeExito => _mensajeExito;

  // Cargar eventos
  Future<void> cargarEventos() async {
    _cargandoEventos = true;
    _errorEventos = null;
    notifyListeners();

    try {
      _eventos = await _gestionarEventos.obtenerEventos();
      _errorEventos = null;
    } catch (e) {
      _errorEventos = e.toString();
      _eventos = [];
    } finally {
      _cargandoEventos = false;
      notifyListeners();
    }
  }

  // Crear evento
  Future<bool> crearEvento({
    required String nombre,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required String lugar,
    required String descripcion,
    String? imagenUrl,
    required String creadoPor, // Ahora este parámetro SÍ se usará
  }) async {
    _guardandoEvento = true;
    _errorFormulario = null;
    _mensajeExito = null;
    notifyListeners();

    try {
      // Validar que el usuario está autenticado
      if (creadoPor.isEmpty) {
        throw Exception('Usuario no autenticado');
      }

      // Validaciones básicas
      if (nombre.trim().isEmpty) {
        throw Exception('El nombre del evento es obligatorio');
      }
      if (lugar.trim().isEmpty) {
        throw Exception('El lugar del evento es obligatorio');
      }
      if (descripcion.trim().isEmpty) {
        throw Exception('La descripción del evento es obligatoria');
      }
      if (fechaFin.isBefore(fechaInicio)) {
        throw Exception('La fecha de fin debe ser posterior a la fecha de inicio');
      }
      if (fechaInicio.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
        throw Exception('La fecha de inicio no puede ser anterior a hoy');
      }

      final evento = Evento(
        nombre: nombre.trim(),
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
        lugar: lugar.trim(),
        descripcion: descripcion.trim(),
        imagenUrl: imagenUrl?.trim(),
        fechaCreacion: DateTime.now(),
        creadoPor: creadoPor, // Usar el ID del usuario que viene como parámetro
      );

      await _gestionarEventos.crearEvento(evento);
      _mensajeExito = 'Evento creado exitosamente';
      
      // Recargar la lista de eventos
      await cargarEventos();
      
      return true;
    } catch (e) {
      _errorFormulario = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _guardandoEvento = false;
      notifyListeners();
    }
  }

  // Actualizar evento
  Future<bool> actualizarEvento(Evento evento) async {
    _guardandoEvento = true;
    _errorFormulario = null;
    _mensajeExito = null;
    notifyListeners();

    try {
      await _gestionarEventos.actualizarEvento(evento);
      _mensajeExito = 'Evento actualizado exitosamente';
      
      // Recargar la lista de eventos
      await cargarEventos();
      
      return true;
    } catch (e) {
      _errorFormulario = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _guardandoEvento = false;
      notifyListeners();
    }
  }

  // Eliminar evento
  Future<bool> eliminarEvento(String id) async {
    try {
      await _gestionarEventos.eliminarEvento(id);
      _mensajeExito = 'Evento eliminado exitosamente';
      
      // Recargar la lista de eventos
      await cargarEventos();
      
      return true;
    } catch (e) {
      _errorFormulario = e.toString().replaceFirst('Exception: ', '');
      return false;
    }
  }

  // Buscar eventos
  Future<void> buscarEventos(String termino) async {
    _cargandoEventos = true;
    _errorEventos = null;
    notifyListeners();

    try {
      _eventos = await _gestionarEventos.buscarEventos(termino);
      _errorEventos = null;
    } catch (e) {
      _errorEventos = e.toString();
      _eventos = [];
    } finally {
      _cargandoEventos = false;
      notifyListeners();
    }
  }

  // Limpiar mensajes
  void limpiarMensajes() {
    _errorFormulario = null;
    _mensajeExito = null;
    notifyListeners();
  }

  // Limpiar errores de eventos
  void limpiarErrorEventos() {
    _errorEventos = null;
    notifyListeners();
  }
}
