import 'package:supabase_flutter/supabase_flutter.dart';
import '../../dominio/modelos/evento.dart';
import '../../dominio/repositorios/evento_repositorio.dart';

class EventoRepositorioImpl implements EventoRepositorio {
  final SupabaseClient _client = Supabase.instance.client;
  final String _tabla = 'eventos';

  @override
  Future<List<Evento>> obtenerEventos() async {
    try {
      final response = await _client
          .from(_tabla)
          .select()
          .order('fecha_inicio', ascending: true);

      return response
          .map<Evento>((data) => Evento.fromMap(data, data['id'].toString()))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener eventos: $e');
    }
  }

  @override
  Future<Evento?> obtenerEventoPorId(String id) async {
    try {
      final response = await _client
          .from(_tabla)
          .select()
          .eq('id', id)
          .single();

      return Evento.fromMap(response, response['id'].toString());
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String> crearEvento(Evento evento) async {
    try {
      // El evento ya viene con el UUID del usuario desde el ViewModel
      // que lo obtiene del usuario autenticado localmente
      final response = await _client
          .from(_tabla)
          .insert(evento.toMap())
          .select('id')
          .single();

      return response['id'].toString();
    } catch (e) {
      throw Exception('Error al crear evento: $e');
    }
  }

  @override
  Future<void> actualizarEvento(Evento evento) async {
    try {
      await _client
          .from(_tabla)
          .update(evento.toMap())
          .eq('id', evento.id!);
    } catch (e) {
      throw Exception('Error al actualizar evento: $e');
    }
  }

  @override
  Future<void> eliminarEvento(String id) async {
    try {
      await _client
          .from(_tabla)
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar evento: $e');
    }
  }

  @override
  Future<List<Evento>> obtenerEventosPorFecha(DateTime fecha) async {
    try {
      final fechaInicio = DateTime(fecha.year, fecha.month, fecha.day);
      final fechaFin = fechaInicio.add(const Duration(days: 1));

      final response = await _client
          .from(_tabla)
          .select()
          .gte('fecha_inicio', fechaInicio.toIso8601String())
          .lt('fecha_inicio', fechaFin.toIso8601String())
          .order('fecha_inicio', ascending: true);

      return response
          .map<Evento>((data) => Evento.fromMap(data, data['id'].toString()))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener eventos por fecha: $e');
    }
  }

  @override
  Future<List<Evento>> buscarEventos(String termino) async {
    try {
      final response = await _client
          .from(_tabla)
          .select()
          .or('nombre.ilike.%$termino%,descripcion.ilike.%$termino%,lugar.ilike.%$termino%')
          .order('fecha_inicio', ascending: true);

      return response
          .map<Evento>((data) => Evento.fromMap(data, data['id'].toString()))
          .toList();
    } catch (e) {
      throw Exception('Error al buscar eventos: $e');
    }
  }
}
