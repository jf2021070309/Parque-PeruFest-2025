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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Información del evento debajo de la imagen
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: const Color(0xFF8B1B1B),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${_formatearFecha(evento.fechaInicio)} - ${_formatearFecha(evento.fechaFin)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8B1B1B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 20,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          evento.lugar,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.picture_as_pdf, size: 18),
                      label: Text(
                        _tienePDF()
                            ? 'Ver información detallada'
                            : 'Sin información adicional',
                        style: const TextStyle(fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _tienePDF() ? const Color(0xFF8B1B1B) : Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 14,
                        ),
                      ),
                      onPressed: _tienePDF() ? () => _abrirPDF(context) : null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _tienePDF()
                          ? 'Documento con información más detallada del evento.'
                          : 'No hay documento adicional disponible para este evento.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      evento.descripcion,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF8B1B1B),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '¿Qué deseas explorar?',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5D4037), // Color marrón similar al mostrado
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5), // Fondo claro similar al mostrado
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 32,
                                    color: const Color(0xFF795548), // Color marrón para el ícono
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Actividades',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF5D4037),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Consulta el programa',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF8D6E63),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5), // Fondo claro similar al mostrado
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.store,
                                    size: 32,
                                    color: const Color(0xFF795548), // Color marrón para el ícono
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Stands',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF5D4037),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Encuentra a los expositores',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF8D6E63),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
