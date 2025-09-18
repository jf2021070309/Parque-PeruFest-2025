import 'package:flutter/material.dart';
import 'admin/noticias_page.dart';
import 'admin/eventos_page.dart';
import 'admin/actividades_page.dart';
import 'admin/estadisticas_page.dart';

class DashboardAdminView extends StatefulWidget {
  const DashboardAdminView({super.key});

  @override
  State<DashboardAdminView> createState() => _DashboardAdminViewState();
}

class _DashboardAdminViewState extends State<DashboardAdminView> {
  int _currentIndex = 0;

  // Lista de páginas para cada tab
  final List<Widget> _pages = [
    const NoticiasPage(),
    const EventosPage(),
    const ActividadesPage(),
    const EstadisticasPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Administrador'),
      ),
      body: SafeArea(
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Noticias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Eventos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_activity),
            label: 'Actividades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Estadísticas',
          ),
        ],
      ),
    );
  }

  // Método estático para acceder al estado desde otras páginas
  //static _DashboardAdminViewState? of(BuildContext context) {
    //return context.findAncestorStateOfType<_DashboardAdminViewState>();
  //}
}