// Ejemplo de integración del BannerAnuncios en una vista de usuario
// Este es un archivo de ejemplo que muestra cómo integrar los banners de anuncios

import 'package:flutter/material.dart';
import '../widgets/banner_anuncios.dart';

class EjemploPantallaConBanners extends StatelessWidget {
  const EjemploPantallaConBanners({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejemplo con Banners'),
        backgroundColor: const Color(0xFF8B1B1B),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Banner superior - se muestra arriba del contenido
          const BannerAnuncios(
            posicion: 'superior',
            padding: EdgeInsets.only(bottom: 8.0),
          ),
          
          // Contenido principal
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const Text(
                  'Contenido Principal',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                
                // Aquí iría el contenido normal de la pantalla
                ...List.generate(10, (index) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Elemento ${index + 1}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Este es contenido de ejemplo que se puede hacer scroll.',
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
          
          // Banner inferior - se muestra abajo del contenido
          const BannerAnuncios(
            posicion: 'inferior',
            padding: EdgeInsets.only(top: 8.0),
          ),
        ],
      ),
    );
  }
}

/*
INSTRUCCIONES DE USO:

1. Para pantallas con AppBar y contenido scrolleable:
   - Banner superior: Después del AppBar
   - Banner inferior: Antes de la navegación inferior o al final

2. Para pantallas de navegación (BottomNavigationBar):
   - Banner superior: En la parte superior del body
   - Banner inferior: Arriba del BottomNavigationBar

3. Ejemplo de integración en DashboardUserView:

body: Column(
  children: [
    // Banner superior
    const BannerAnuncios(posicion: 'superior'),
    
    // Contenido principal
    Expanded(
      child: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    ),
    
    // Banner inferior (opcional, solo si no hay BottomNavigationBar)
    const BannerAnuncios(posicion: 'inferior'),
  ],
),

4. Para pantallas con Drawer:
   - Los banners se integran igual, dentro del body del Scaffold

5. Personalización:
   - padding: Para agregar espacio alrededor del banner
   - Los banners se ocultan automáticamente si no hay anuncios activos
   - Rotación automática cada 45 segundos si hay múltiples anuncios
   - Tap para ver detalles del anuncio

6. Características automáticas:
   - Verificación de fechas de vigencia
   - Solo muestra anuncios activos
   - Respeta la configuración de posición
   - Animaciones suaves entre anuncios
   - Indicadores visuales para múltiples anuncios
*/