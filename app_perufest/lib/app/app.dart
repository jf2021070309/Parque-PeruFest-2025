import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import '../datos/fuentes_datos/usuario_firestore_fuente.dart'
    show UsuarioSupabaseFuente;
import '../datos/repositorios/usuario_repositorio_impl.dart';
import '../datos/repositorios/evento_repositorio_impl.dart';
import '../dominio/casos_uso/login_usuario.dart';
import '../dominio/casos_uso/registrar_usuario.dart';
import '../dominio/casos_uso/gestionar_eventos.dart';
import '../dominio/repositorios/evento_repositorio.dart';
import '../presentacion/viewmodels/autenticacion_viewmodel.dart';
import '../presentacion/viewmodels/recuperacion_viewmodel.dart';
import '../presentacion/viewmodels/admin_eventos_viewmodel.dart';
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
        // Providers existentes
        ChangeNotifierProvider(
          create: (_) => AutenticacionViewModel(
            loginUsuario: LoginUsuario(_repo),
            registrarUsuario: RegistrarUsuario(_repo),
          ),
        ),
        ChangeNotifierProvider(create: (_) => RecuperacionViewModel()),
        
        // Nuevos providers para eventos
        Provider<EventoRepositorio>(
          create: (_) => EventoRepositorioImpl(),
        ),
        Provider<GestionarEventos>(
          create: (context) => GestionarEventos(
            context.read<EventoRepositorio>(),
          ),
        ),
        ChangeNotifierProvider<AdminEventosViewModel>(
          create: (context) => AdminEventosViewModel(
            context.read<GestionarEventos>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'PeruFest',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es', 'ES'),
          Locale('en', 'US'),
        ],
        locale: const Locale('es', 'ES'),
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const LoginPantalla(),
      ),
    );
  }
}
