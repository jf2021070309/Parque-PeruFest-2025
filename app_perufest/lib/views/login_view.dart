import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../services/validador_service.dart';
import 'seleccion_registro_view.dart';
import 'dashboard_user_view.dart';
import 'dashboard_admin_view.dart';
import 'dashboard_expositor_view.dart';
import 'recuperar_paso1.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

      await authViewModel.login(
        _correoController.text.trim(),
        _contrasenaController.text,
      );

      if (mounted && authViewModel.state == AuthState.success) {
        final rol = authViewModel.currentUser?.rol ?? 'usuario';
        Widget destino;
        if (rol == 'administrador') {
          destino = const DashboardAdminView();
        } else if (rol == 'expositor') {
          destino = const DashboardExpositorView();
        } else if (rol == 'usuario') {
          destino = const DashboardUserView();
        } else {
          destino = const DashboardUserView();
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => destino),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Fondo con forma curveada
          Column(
            children: [
              // Parte superior curveada con imagen de fondo
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6E6FA), // Color de fondo por si la imagen no carga
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                    child: Image.asset(
                      'assets/images/fondo.png',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFE6E6FA), // Lavanda claro
                                Color(0xFFD8BFD8), // Morado claro
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              // Parte inferior gris plomo
              Expanded(
                flex: 6,
                child: Container(
                  width: double.infinity,
                  color: const Color(0xFFF1F5F9),
                ),
              ),
            ],
          ),
          // Formas decorativas del fondo
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Contenido principal
          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Parte superior con logo y título
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),
                              // Logo de la aplicación - Extra grande
                              Image.asset(
                                'assets/images/logo.png',
                                width: 280,
                                height: 280,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.festival,
                                    size: 160,
                                    color: Colors.white,
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      // Card blanco con formulario
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                              spreadRadius: -5,
                            ),
                          ],
                        ),
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            // Título "Iniciar Sesión"
                            const Text(
                              'Iniciar Sesión',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2D3748),
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Texto de registro
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '¿No tienes cuenta? ',
                                  style: TextStyle(
                                    color: Color(0xFF718096),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const SeleccionRegistroView(),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Regístrate',
                                    style: TextStyle(
                                      color: Color(0xFFB45309), // Marrón dorado del logo
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Color(0xFFB45309),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            // Campo de usuario
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                  width: 1,
                                ),
                              ),
                              child: TextFormField(
                                controller: _correoController,
                                decoration: const InputDecoration(
                                  hintText: 'Correo electrónico',
                                  hintStyle: TextStyle(
                                    color: Color(0xFFA0AEC0),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: Color(0xFF9CA3AF), // Gris neutro
                                    size: 22,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 18,
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2D3748),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: ValidadorService.validarCorreo,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Campo de contraseña
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                  width: 1,
                                ),
                              ),
                              child: TextFormField(
                                controller: _contrasenaController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  hintText: 'Contraseña',
                                  hintStyle: const TextStyle(
                                    color: Color(0xFFA0AEC0),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    color: Color(0xFF9CA3AF), // Gris neutro
                                    size: 22,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                      color: const Color(0xFFA0AEC0),
                                      size: 22,
                                    ),
                                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 18,
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2D3748),
                                ),
                                validator: ValidadorService.validarContrasena,
                              ),
                            ),
                            const SizedBox(height: 30),
                            // Botón de login
                            Consumer<AuthViewModel>(
                              builder: (context, authViewModel, child) {
                                return Column(
                                  children: [
                                    // Mostrar error
                                    if (authViewModel.state == AuthState.error)
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(12),
                                        margin: const EdgeInsets.only(bottom: 16),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.red.shade300),
                                        ),
                                        child: Text(
                                          authViewModel.errorMessage,
                                          style: TextStyle(color: Colors.red.shade700),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    // Botón LOGIN
                                    Container(
                                      width: double.infinity,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF8B1B1B), // Burgundy principal
                                            Color(0xFFB91C1C), // Burgundy más claro
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF8B1B1B).withOpacity(0.3),
                                            blurRadius: 15,
                                            offset: const Offset(0, 8),
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed: authViewModel.isLoading ? null : _login,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25),
                                          ),
                                        ),
                                        child: authViewModel.isLoading
                                            ? const CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              )
                                            : const Text(
                                                'Iniciar Sesión',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            // Texto "No recuerdas tu clave?"
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RecuperarPaso1(),
                                  ),
                                );
                              },
                              child: const Text(
                                '¿Olvidaste tu contraseña?',
                                style: TextStyle(
                                  color: Color(0xFF8B1B1B), // Burgundy principal
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(0xFF8B1B1B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}