import '../modelos/evento.dart';
import '../repositorios/evento_repositorio.dart';

class GestionarEventos {
  final EventoRepositorio _eventoRepositorio;

  GestionarEventos(this._eventoRepositorio);

  Future<List<Evento>> obtenerEventos() async {
    return await _eventoRepositorio.obtenerEventos();
  }

  Future<Evento?> obtenerEventoPorId(String id) async {
    return await _eventoRepositorio.obtenerEventoPorId(id);
  }

  Future<String> crearEvento(Evento evento) async {
    // Validaciones de negocio
    _validarEvento(evento);
    return await _eventoRepositorio.crearEvento(evento);
  }

  Future<void> actualizarEvento(Evento evento) async {
    _validarEvento(evento);
    await _eventoRepositorio.actualizarEvento(evento);
  }

  Future<void> eliminarEvento(String id) async {
    await _eventoRepositorio.eliminarEvento(id);
  }

  Future<List<Evento>> obtenerEventosPorFecha(DateTime fecha) async {
    return await _eventoRepositorio.obtenerEventosPorFecha(fecha);
  }

  Future<List<Evento>> buscarEventos(String termino) async {
    if (termino.trim().isEmpty) {
      return await obtenerEventos();
    }
    return await _eventoRepositorio.buscarEventos(termino);
  }

  void _validarEvento(Evento evento) {
    if (evento.nombre.trim().isEmpty) {
      throw Exception('El nombre del evento es obligatorio');
    }
    
    if (evento.lugar.trim().isEmpty) {
      throw Exception('El lugar del evento es obligatorio');
    }
    
    if (evento.descripcion.trim().isEmpty) {
      throw Exception('La descripción del evento es obligatoria');
    }
    
    if (evento.fechaInicio.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      throw Exception('La fecha de inicio no puede ser anterior a hoy');
    }
    
    if (evento.fechaFin.isBefore(evento.fechaInicio)) {
      throw Exception('La fecha de fin no puede ser anterior a la fecha de inicio');
    }
    
    final diferencia = evento.fechaFin.difference(evento.fechaInicio);
    if (diferencia.inDays > 365) {
      throw Exception('El evento no puede durar más de un año');
    }
  }
}
