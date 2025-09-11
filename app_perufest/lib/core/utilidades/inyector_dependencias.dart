import 'package:provider/provider.dart';
import '../../datos/repositorios/evento_repositorio_impl.dart';
import '../../dominio/casos_uso/gestionar_eventos.dart';
import '../../dominio/repositorios/evento_repositorio.dart';
import '../../presentacion/viewmodels/admin_eventos_viewmodel.dart';

class InyectorDependencias {
  static List<Provider> obtenerProviders() {
    return [
      // Repositorios
      Provider<EventoRepositorio>(
        create: (_) => EventoRepositorioImpl(),
      ),
      
      // Casos de uso
      Provider<GestionarEventos>(
        create: (context) => GestionarEventos(
          context.read<EventoRepositorio>(),
        ),
      ),
    ];
  }

  static List<ChangeNotifierProvider> obtenerViewModels() {
    return [
      ChangeNotifierProvider<AdminEventosViewModel>(
        create: (context) => AdminEventosViewModel(
          context.read<GestionarEventos>(),
        ),
      ),
    ];
  }
}
