import 'package:flutter/material.dart';
import '../../../core/utilidades/validador.dart';
import '../../viewmodels/autenticacion_viewmodel.dart';
import '../dashboard/dashboard_pantalla.dart';
import 'registro_pantalla.dart';
import '../recuperacion/recuperar_paso1.dart';
import 'package:provider/provider.dart';

class LoginPantalla extends StatefulWidget {
  const LoginPantalla({super.key});

  @override
  State<LoginPantalla> createState() => _LoginPantallaState();
}

class _LoginPantallaState extends State<LoginPantalla> {
  final _formKey = GlobalKey<FormState>();
  String correo = '';
  String contrasena = '';
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 80), // Más espacio arriba
                Container(
                  height: 180, // Aumentamos el tamaño del logo
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                  ), // Más padding horizontal
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported,
                        size: 120, // Aumentamos el ícono de error también
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Ingrese su correo';
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(v)) {
                      return 'Ingrese un correo válido';
                    }
                    return null;
                  },
                  onSaved: (v) => correo = v ?? '',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  obscureText: _obscure,
                  validator: Validador.validarContrasena,
                  onSaved: (v) => contrasena = v ?? '',
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RecuperarPaso1(),
                        ),
                      );
                    },
                    child: const Text(
                      'Olvidaste tu contraseña?',
                      style: TextStyle(color: Color(0xFF1976D2)),
                    ),
                  ),
                ),
                Consumer<AutenticacionViewModel>(
                  builder: (context, viewModel, child) {
                    return Column(
                      children: [
                        if (viewModel.estado == EstadoAutenticacion.cargando)
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        if (viewModel.estado == EstadoAutenticacion.error)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              viewModel.mensajeError ?? '',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 8),
                Consumer<AutenticacionViewModel>(
                  builder: (context, viewModel, child) {
                    return SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B1B1B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed:
                            viewModel.estado == EstadoAutenticacion.cargando
                                ? null
                                : () async {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    _formKey.currentState?.save();

                                    // Mostrar feedback inmediato
                                    FocusScope.of(context).unfocus();

                                    await viewModel.loginSeguro(correo, contrasena);

                                    if (!mounted) return;

                                    print('🔍 Estado después del login: ${viewModel.estado}');
                                    print('🔍 Usuario: ${viewModel.usuario?.correo}');
                                    print('🔍 Error: ${viewModel.mensajeError}');

                                    if (viewModel.estado ==
                                        EstadoAutenticacion.autenticado) {
                                      print('✅ Navegando al dashboard...');
                                      if (mounted) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) =>
                                                    const DashboardPantalla(),
                                          ),
                                        );
                                      }
                                    } else if (viewModel.estado == EstadoAutenticacion.error) {
                                      print('❌ Error en login: ${viewModel.mensajeError}');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(viewModel.mensajeError ?? 'Error de autenticación'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                        child:
                            viewModel.estado == EstadoAutenticacion.cargando
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text(
                                  'Iniciar sesión',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No tienes cuenta?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegistroPantalla(),
                          ),
                        );
                      },
                      child: const Text(
                        'Registrate',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('o'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    child: const Text(
                      'Iniciar sesión con Google',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
