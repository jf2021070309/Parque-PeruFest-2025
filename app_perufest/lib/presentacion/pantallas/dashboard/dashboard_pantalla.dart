import 'package:flutter/material.dart';

class DashboardPantalla extends StatefulWidget {
  const DashboardPantalla({super.key});

  @override
  State<DashboardPantalla> createState() => _DashboardPantallaState();
}

class _DashboardPantallaState extends State<DashboardPantalla> {
  int _indiceActual = 0;

  Widget _obtenerPantalla() {
    switch (_indiceActual) {
      case 0:
        return const Center(
          child: Text('Hola, bienvenido', style: TextStyle(fontSize: 24)),
        );
      case 1:
        return const Center(
          child: Text('Pantalla de Búsqueda', style: TextStyle(fontSize: 24)),
        );
      case 2:
        return const Center(
          child: Text('Notificaciones', style: TextStyle(fontSize: 24)),
        );
      case 3:
        return const Center(
          child: Text('Perfil de Usuario', style: TextStyle(fontSize: 24)),
        );
      default:
        return const Center(
          child: Text('Pantalla no encontrada', style: TextStyle(fontSize: 24)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _obtenerPantalla(),
      bottomNavigationBar: BottomNavigationBar(
        type:
            BottomNavigationBarType.fixed, // Necesario para más de 3 elementos
        currentIndex: _indiceActual,
        onTap: (index) {
          setState(() {
            _indiceActual = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificaciones',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
