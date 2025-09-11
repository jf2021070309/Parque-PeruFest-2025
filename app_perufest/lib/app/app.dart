import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos/fuentes_datos/usuario_firestore_fuente.dart'
    show UsuarioSupabaseFuente;
import '../datos/repositorios/usuario_repositorio_impl.dart';
import '../dominio/casos_uso/login_usuario.dart';
import '../dominio/casos_uso/registrar_usuario.dart';
import '../presentacion/viewmodels/autenticacion_viewmodel.dart';
import '../presentacion/viewmodels/recuperacion_viewmodel.dart';
import '../presentacion/pantallas/autenticacion/login_pantalla.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Crear instancias una sola vez como variables estáticas
  static final _fuente = UsuarioSupabaseFuente();
  static final _repo = UsuarioRepositorioImpl(_fuente);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => AutenticacionViewModel(
                loginUsuario: LoginUsuario(_repo),
                registrarUsuario: RegistrarUsuario(_repo),
              ),
        ),
        ChangeNotifierProvider(create: (_) => RecuperacionViewModel()),
      ],
      child: MaterialApp(
        title: 'PeruFest',
        debugShowCheckedModeBanner: false, // Mejora rendimiento
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const LoginPantalla(),
      ),
    );
  }
}
