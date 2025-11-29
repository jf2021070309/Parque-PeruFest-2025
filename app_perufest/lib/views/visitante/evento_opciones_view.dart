import 'package:flutter/material.dart';
import '../../models/evento.dart';
import 'actividades_evento_view.dart';
import 'stands_evento_view.dart';
import 'pdf_viewer_page.dart';

class EventoOpcionesView extends StatelessWidget {
  final Evento evento;
  final String userId;

  const EventoOpcionesView({
    super.key,
    required this.evento,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                child: evento.imagenUrl.isNotEmpty
                    ? Image.network(
                        evento.imagenUrl,
                        height: 260,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 260,
                          color: Colors.grey[300],
                          child: const Center(child: Icon(Icons.broken_image, size: 48)),
                        ),
                      )
                    : Container(
                        height: 260,
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.broken_image, size: 48)),
                      ),
              ),
              Positioned(
                top: 32,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.85),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Información del evento debajo de la imagen
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 32,
                            color: const Color(0xFF8B1B1B),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_formatearFecha(evento.fechaInicio)} - ${_formatearFecha(evento.fechaFin)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF8B1B1B),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 14,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  evento.lugar,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: 220,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.picture_as_pdf, size: 18),
                              label: Text(
                                _tienePDF()
                                    ? 'Ver información detallada'
                                    : 'Sin información adicional',
                                style: const TextStyle(fontSize: 13),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    _tienePDF()
                                        ? const Color(0xFF8B1B1B)
                                        : Colors.grey,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 14,
                                ),
                              ),
                              onPressed:
                                  _tienePDF() ? () => _abrirPDF(context) : null,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _tienePDF()
                                ? 'Documento con información más detallada del evento.'
                                : 'No hay documento adicional disponible para este evento.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    // Descripción del evento
                    if (evento.descripcion.isNotEmpty) ...[
                      Text(
                        evento.descripcion,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF8B1B1B),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 24),

                    // Título de opciones
                    Text(
                      '¿Qué deseas explorar?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF8B1B1B),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    // Opciones
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: _buildOpcionCard(
                              context: context,
                              icon: Icons.event,
                              title: 'Actividades',
                              subtitle: 'Ver todas las actividades del evento',
                              color: const Color(0xFF8B1B1B),
                              onTap: () => _navegarAActividades(context),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: _buildOpcionCard(
                              context: context,
                              icon: Icons.store,
                              title: 'Stands',
                              subtitle: 'Explora los stands y empresas participantes',
                              color: const Color(0xFFA52A2A),
                              onTap: () => _navegarAStands(context),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpcionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, color.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Icono decorativo de fondo
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                icon,
                size: 120,
                color: Colors.white.withOpacity(0.1),
              ),
            ),

            // Contenido
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(icon, size: 32, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Explorar',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white.withOpacity(0.9),
                        size: 14,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navegarAActividades(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ActividadesEventoView(evento: evento, userId: userId),
      ),
    );
  }

  void _navegarAStands(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StandsEventoView(evento: evento)),
    );
  }

  // Método para verificar si el evento tiene PDF
  bool _tienePDF() {
    // Verificar primero si tiene URL de Supabase (nuevo sistema)
    if (evento.pdfUrl != null && evento.pdfUrl!.isNotEmpty) {
      return true;
    }
    // Compatibilidad con sistema antiguo Base64
    return evento.pdfBase64 != null && evento.pdfBase64!.isNotEmpty;
  }

  // Método para abrir el PDF
  Future<void> _abrirPDF(BuildContext context) async {
    // Si tiene URL de Supabase (nuevo sistema)
    if (evento.pdfUrl != null && evento.pdfUrl!.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerPage(
            pdfUrl: evento.pdfUrl!,
            fileName: evento.pdfNombre ?? 'documento_${evento.nombre}.pdf',
          ),
        ),
      );
    }
    // Compatibilidad con sistema antiguo Base64
    else if (evento.pdfBase64 != null && evento.pdfBase64!.isNotEmpty) {
      _abrirPDFDesdeBase64(context);
    }
  }

  // Método legacy para PDFs en Base64 (por compatibilidad)
  Future<void> _abrirPDFDesdeBase64(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Este documento usa el formato antiguo. Por favor, pide al administrador que lo actualice.'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 3),
      ),
    );
    // Aquí podrías implementar la lógica del Base64 si quieres mantener compatibilidad completa
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }
}
