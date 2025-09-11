import '../modelos/evento.dart';

abstract class EventoRepositorio {
  Future<List<Evento>> obtenerEventos();
  Future<Evento?> obtenerEventoPorId(String id);
  Future<String> crearEvento(Evento evento);
  Future<void> actualizarEvento(Evento evento);
  Future<void> eliminarEvento(String id);
  Future<List<Evento>> obtenerEventosPorFecha(DateTime fecha);
  Future<List<Evento>> buscarEventos(String termino);
}
