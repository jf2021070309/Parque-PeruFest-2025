import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/evento.dart';
import '../viewmodels/eventos_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'visitante/evento_opciones_view.dart';
import 'perfil_usuario_view.dart';
import 'visitante/mapa_view.dart';
import 'visitante/faq_visitante_simple.dart';
import 'visitante/agenda_view.dart';
import 'visitante/noticias_visitante_view.dart';
import '../widgets/banner_anuncios.dart';

class DashboardUserView extends StatefulWidget {
  const DashboardUserView({super.key});

  @override
  State<DashboardUserView> createState() => _DashboardUserViewState();
}

class _DashboardUserViewState extends State<DashboardUserView> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Color> _eventoColors = [
    const Color(0xFF8B1B1B), // Guinda principal
    const Color(0xFFA52A2A), // Rojo-marrón
    const Color(0xFF8B0000), // Rojo oscuro
    const Color(0xFF800020), // Burgundy
    const Color(0xFF722F37), // Marrón-rojo
    const Color(0xFF9B1B1B), // Guinda claro
    const Color(0xFF7B1B1B), // Guinda oscuro
    const Color(0xFF8B2635), // Guinda-rosado
    const Color(0xFF8B3A3A), // Rojo tierra
    const Color(0xFF8B4B4B), // Rojo suave
    const Color(0xFFB22222), // Firebrick
    const Color(0xFF8B4513), // Saddle brown
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarEventos();
    });
  }

  Future<void> _cargarEventos() async {
    final eventosViewModel = context.read<EventosViewModel>();
    await eventosViewModel.cargarEventos();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2E8F0),
      body: Column(
        children: [
          // Banner único global - aparece en todas las pestañas
          const BannerAnuncios(
            padding: EdgeInsets.zero,
          ),
          
          // Contenido principal con PageView
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: [
                _buildEventosPage(), 
                const NoticiasVisitanteView(), 
                _buildMapaPage(), 
                const AgendaView(), 
                const FAQVisitanteSimple(), 
                _buildPerfilPage()
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildEventosPage() {
    return Consumer<EventosViewModel>(
      builder: (context, eventosViewModel, child) {
        return CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            if (eventosViewModel.isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (eventosViewModel.eventos.isEmpty)
              SliverFillRemaining(child: _buildEmptyState())
            else
              _buildEventosList(eventosViewModel.eventos),
          ],
        );
      },
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 180.0,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF8B1B1B),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black.withOpacity(0.1),
      forceElevated: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF8B1B1B),
              Color(0xFFA52A2A),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: FlexibleSpaceBar(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.celebration,
                  color: Colors.white.withOpacity(0.9),
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'PerúFest 2025',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  letterSpacing: 0.3,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          centerTitle: false,
          titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
          background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFB91C1C),
                Color(0xFF8B1B1B),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Elementos decorativos simples
              Positioned(
                right: -30,
                top: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              Positioned(
                left: -20,
                bottom: 20,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
              ),
              
              // Contenido principal simplificado
              Positioned(
                bottom: 60,
                left: 24,
                right: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.waving_hand,
                            color: Colors.white.withOpacity(0.9),
                            size: 14,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Bienvenido al',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Descubre eventos únicos',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventosList(List<Evento> eventos) {
    // Filtrar solo eventos activos
    final eventosActivos = eventos.where((e) => e.estado == 'activo').toList();

    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final evento = eventosActivos[index];
            final color = _eventoColors[index % _eventoColors.length];
            return Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: _buildEventoCard(evento, color),
            );
          },
          childCount: eventosActivos.length,
        ),
      ),
    );
  }

  Widget _buildEventoCard(Evento evento, Color color) {
    final now = DateTime.now();
    final hoy = DateTime(now.year, now.month, now.day);
    final inicioEvento = DateTime(
      evento.fechaInicio.year,
      evento.fechaInicio.month,
      evento.fechaInicio.day,
    );
    final finEvento = DateTime(
      evento.fechaFin.year,
      evento.fechaFin.month,
      evento.fechaFin.day,
    );

    String estadoTexto = '';
    Color estadoColor = const Color(0xFF6B7280);

    if (hoy.isAtSameMomentAs(inicioEvento) ||
        (hoy.isAfter(inicioEvento) && hoy.isBefore(finEvento)) ||
        hoy.isAtSameMomentAs(finEvento)) {
      estadoTexto = 'ACTUAL';
      estadoColor = const Color(0xFF059669);
    } else if (inicioEvento.isAfter(hoy)) {
      final diasRestantes = inicioEvento.difference(hoy).inDays;
      if (diasRestantes <= 7) {
        estadoTexto = 'PRÓXIMO';
        estadoColor = const Color(0xFFB91C1C);
      }
    }

    return GestureDetector(
      onTap: () => _verActividadesEvento(evento),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFF1F5F9),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con categoría y estado mejorado
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B1B1B).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF8B1B1B),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              evento.categoria,
                              style: const TextStyle(
                                color: Color(0xFF8B1B1B),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (estadoTexto.isNotEmpty)
                    const SizedBox(width: 12),
                  if (estadoTexto.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: estadoColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        estadoTexto,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              
              // Título del evento mejorado
              Text(
                evento.nombre,
                style: const TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 18),
              
              // Información simplificada y elegante
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.calendar_today_outlined,
                          color: Color(0xFF8B1B1B),
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Fechas',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_formatearFecha(evento.fechaInicio)} - ${_formatearFecha(evento.fechaFin)}',
                            style: const TextStyle(
                              color: Color(0xFF1E293B),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.location_on_outlined,
                          color: Color(0xFF8B1B1B),
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ubicación',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              evento.lugar,
                              style: const TextStyle(
                                color: Color(0xFF1E293B),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Footer elegante y minimalista
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: evento.tipoEvento == 'gratis' 
                        ? const Color(0xFF10B981)
                        : const Color(0xFF6B7280),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      evento.tipoEvento == 'gratis' ? 'GRATIS' : 'DE PAGO',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No hay eventos disponibles',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Los eventos aparecerán aquí cuando estén disponibles',
            style: TextStyle(color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _cargarEventos,
            icon: const Icon(Icons.refresh),
            label: const Text('Actualizar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B1B1B),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }





  Widget _buildPerfilPage() {
    final authViewModel = context.watch<AuthViewModel>();
    final currentUser = authViewModel.currentUser;

    if (currentUser == null) {
      return const Center(child: Text('Error: Usuario no encontrado'));
    }

    return PerfilUsuarioView(
      userId: currentUser.id,
      userData: {
        'username': currentUser.username,
        'email': currentUser.correo,
        'telefono': currentUser.telefono,
        'rol': currentUser.rol,
        'imagenPerfil': currentUser.imagenPerfil,
      },
    );
  }

  Widget _buildMapaPage() {
    return const MapaView();
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFBFBFB),
            Color(0xFFFFFFFF),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 25,
            offset: const Offset(0, -8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: const Color(0xFFE2E8F0).withOpacity(0.7),
            width: 0.5,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 6) {
            _mostrarMenuCerrarSesion();
            return;
          }

          setState(() {
            _selectedIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        selectedItemColor: const Color(0xFF8B1B1B),
        unselectedItemColor: const Color(0xFF64748B),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 11,
          letterSpacing: 0.3,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 10,
          letterSpacing: 0.2,
        ),
        elevation: 0,
        iconSize: 22,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.celebration_outlined),
            activeIcon: Icon(Icons.celebration),
            label: 'Eventos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            activeIcon: Icon(Icons.article),
            label: 'Noticias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_outlined),
            activeIcon: Icon(Icons.event_note),
            label: 'Agenda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_center_outlined),
            activeIcon: Icon(Icons.help_center),
            label: 'FAQ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Salir',
          ),
        ],
      ),
    );
  }

  void _mostrarMenuCerrarSesion() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Icon(Icons.logout, size: 48, color: Colors.red.shade400),
                const SizedBox(height: 16),
                const Text(
                  '¿Cerrar Sesión?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Se cerrará tu sesión y regresarás a la pantalla de inicio',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _cerrarSesion();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade400,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Cerrar Sesión'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  void _cerrarSesion() async {
    final authViewModel = context.read<AuthViewModel>();
    authViewModel.logout();

    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  void _verActividadesEvento(Evento evento) {
    final authViewModel = context.read<AuthViewModel>();
    final currentUserId = authViewModel.currentUser?.id ?? '';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                EventoOpcionesView(evento: evento, userId: currentUserId),
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }
}
