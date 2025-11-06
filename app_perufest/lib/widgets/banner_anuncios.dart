import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../viewmodels/anuncios_viewmodel.dart';
import '../models/anuncio.dart';

class BannerAnuncios extends StatefulWidget {
  final String posicion; // 'superior' o 'inferior'
  final EdgeInsetsGeometry? padding;
  
  const BannerAnuncios({
    super.key,
    required this.posicion,
    this.padding,
  });

  @override
  State<BannerAnuncios> createState() => _BannerAnunciosState();
}

class _BannerAnunciosState extends State<BannerAnuncios> {
  Timer? _rotationTimer;
  int _currentIndex = 0;
  List<Anuncio> _anunciosActivos = [];

  @override
  void initState() {
    super.initState();
    _iniciarRotacion();
  }

  @override
  void dispose() {
    _rotationTimer?.cancel();
    super.dispose();
  }

  void _iniciarRotacion() {
    _rotationTimer?.cancel();
    _rotationTimer = Timer.periodic(const Duration(seconds: 45), (timer) {
      if (_anunciosActivos.isNotEmpty && mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _anunciosActivos.length;
        });
      }
    });
  }

  void _actualizarAnuncios(List<Anuncio> nuevosAnuncios) {
    if (mounted) {
      setState(() {
        _anunciosActivos = nuevosAnuncios;
        if (_currentIndex >= _anunciosActivos.length) {
          _currentIndex = 0;
        }
      });
      
      // Reiniciar timer si hay cambios en los anuncios
      if (nuevosAnuncios.isNotEmpty) {
        _iniciarRotacion();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Anuncio>>(
      stream: context.watch<AnunciosViewModel>().obtenerAnunciosActivos(
        posicion: widget.posicion,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink(); // No mostrar nada si no hay anuncios
        }

        final anuncios = snapshot.data!;
        
        // Actualizar la lista local si es diferente
        if (_anunciosActivos != anuncios) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _actualizarAnuncios(anuncios);
          });
        }

        if (anuncios.isEmpty) {
          return const SizedBox.shrink();
        }

        final anuncioActual = anuncios[_currentIndex % anuncios.length];
        
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _buildBannerContent(anuncioActual),
        );
      },
    );
  }

  Widget _buildBannerContent(Anuncio anuncio) {
    return Container(
      key: ValueKey(anuncio.id),
      width: double.infinity,
      height: 55,
      margin: widget.padding ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            const Color(0xFF8B1B1B).withOpacity(0.9),
            const Color(0xFF8B1B1B).withOpacity(0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _mostrarDetalleAnuncio(anuncio),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                // Icono de campaña
                const Icon(
                  Icons.campaign,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                
                // Contenido del anuncio
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        anuncio.titulo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (anuncio.contenido.isNotEmpty)
                        Text(
                          anuncio.contenido,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 10,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                
                // Imagen si existe
                if (anuncio.imagenUrl != null)
                  Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      image: DecorationImage(
                        image: NetworkImage(anuncio.imagenUrl!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                
                // Indicador de múltiples anuncios
                if (_anunciosActivos.length > 1)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        _anunciosActivos.length,
                        (index) => Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == _currentIndex
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                
                // Botón cerrar (opcional)
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white.withOpacity(0.7),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _mostrarDetalleAnuncio(Anuncio anuncio) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.campaign, color: Color(0xFF8B1B1B)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                anuncio.titulo,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (anuncio.imagenUrl != null)
              Container(
                width: double.infinity,
                height: 150,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(anuncio.imagenUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Text(
              anuncio.contenido,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              'Válido hasta: ${_formatearFecha(anuncio.fechaFin)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }
}