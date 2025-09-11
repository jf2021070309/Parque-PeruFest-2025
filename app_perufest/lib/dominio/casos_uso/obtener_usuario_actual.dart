import '../modelos/usuario.dart';
import '../repositorios/usuario_repositorio.dart';

class ObtenerUsuarioActual {
  final UsuarioRepositorio repositorio;
  ObtenerUsuarioActual(this.repositorio);

  Future<Usuario?> call() {
    return repositorio.obtenerUsuarioActual();
  }
}
