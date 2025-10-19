import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/stand.dart';
import '../models/evento.dart';
import '../models/zona.dart';

class StandsViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Stand> _stands = [];
  List<Evento> _eventos = [];
  bool _isLoading = false;
  String _error = '';

  // Getters
  List<Stand> get stands => _stands;
  List<Evento> get eventos => _eventos;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Estado del formulario
  Evento? _eventoSeleccionado;
  Zona? _zonaSeleccionada;

  Evento? get eventoSeleccionado => _eventoSeleccionado;
  Zona? get zonaSeleccionada => _zonaSeleccionada;

  // Controladores para el formulario
  final TextEditingController nombreEmpresaController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController contactoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController imagenUrlController = TextEditingController();
  final TextEditingController productosController = TextEditingController();

  StandsViewModel() {
    _cargarEventosDeMuestra();
    _cargarStandsDeMuestra();
  }

  void setEventoSeleccionado(Evento? evento) {
    _eventoSeleccionado = evento;
    _zonaSeleccionada = null; // Reset zona cuando cambia evento
    notifyListeners();
  }

  void setZonaSeleccionada(Zona? zona) {
    _zonaSeleccionada = zona;
    notifyListeners();
  }

  // Obtener stands por evento
  List<Stand> getStandsPorEvento(String eventoId) {
    return _stands.where((stand) => stand.eventoId == eventoId).toList();
  }

  // Obtener stands por zona
  List<Stand> getStandsPorZona(String eventoId, int zonaNumero) {
    return _stands
        .where(
          (stand) =>
              stand.eventoId == eventoId && stand.zonaNumero == zonaNumero,
        )
        .toList();
  }

  // Agregar nuevo stand
  Future<void> agregarStand() async {
    if (_eventoSeleccionado == null || _zonaSeleccionada == null) {
      _error = 'Debe seleccionar un evento y una zona';
      notifyListeners();
      return;
    }

    if (nombreEmpresaController.text.trim().isEmpty) {
      _error = 'El nombre de la empresa es requerido';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // Procesar productos
      List<String> productos =
          productosController.text
              .split(',')
              .map((p) => p.trim())
              .where((p) => p.isNotEmpty)
              .toList();

      final nuevoStand = Stand(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nombreEmpresa: nombreEmpresaController.text.trim(),
        descripcion: descripcionController.text.trim(),
        imagenUrl: imagenUrlController.text.trim(),
        eventoId: _eventoSeleccionado!.id,
        zonaNumero: _zonaSeleccionada!.numero,
        zonaNombre: _zonaSeleccionada!.nombre,
        productos: productos,
        contacto: contactoController.text.trim(),
        telefono: telefonoController.text.trim(),
        fechaCreacion: DateTime.now(),
        fechaActualizacion: DateTime.now(),
      );

      // Guardar en Firestore en la colección 'stands'
      final docRef = _firestore.collection('stands').doc(nuevoStand.id);
      final data = Map<String, dynamic>.from(nuevoStand.toJson());
      // Convertir fechas a Timestamp para Firestore
      data['fecha_creacion'] = Timestamp.fromDate(nuevoStand.fechaCreacion);
      data['fecha_actualizacion'] = Timestamp.fromDate(
        nuevoStand.fechaActualizacion,
      );

      await docRef.set(data);

      // Añadir localmente
      _stands.add(nuevoStand);
      _limpiarFormulario();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Error al guardar el stand: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Eliminar stand
  Future<void> eliminarStand(String standId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Intentar eliminar en Firestore (si existe)
      try {
        await _firestore.collection('stands').doc(standId).delete();
      } catch (_) {
        // Ignorar si no existe o falla; igual removeremos localmente
      }

      _stands.removeWhere((stand) => stand.id == standId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Error al eliminar el stand: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Limpiar formulario
  void _limpiarFormulario() {
    nombreEmpresaController.clear();
    descripcionController.clear();
    contactoController.clear();
    telefonoController.clear();
    imagenUrlController.clear();
    productosController.clear();
    _eventoSeleccionado = null;
    _zonaSeleccionada = null;
  }

  void limpiarFormulario() {
    _limpiarFormulario();
    notifyListeners();
  }

  void limpiarError() {
    _error = '';
    notifyListeners();
  }

  // Datos de muestra para desarrollo
  void _cargarEventosDeMuestra() {
    _eventos = [
      Evento(
        id: '1',
        nombre: 'FERITAC PERU',
        descripcion: 'Feria Internacional de Tacna',
        organizador: 'Parque Peru',
        categoria: 'Cultural',
        fechaInicio: DateTime.now(),
        fechaFin: DateTime.now().add(const Duration(days: 10)),
        lugar: 'Parque Peru',
        imagenUrl: '',
        creadoPor: 'admin',
        estado: 'activo',
        fechaCreacion: DateTime.now(),
        fechaActualizacion: DateTime.now(),
      ),
      Evento(
        id: '2',
        nombre: 'SORPRESAA',
        descripcion: 'Evento sorpresa',
        organizador: 'Parque Peru',
        categoria: 'Entretenimiento',
        fechaInicio: DateTime.now(),
        fechaFin: DateTime.now().add(const Duration(days: 6)),
        lugar: 'Parque Peru',
        imagenUrl: '',
        creadoPor: 'admin',
        estado: 'activo',
        fechaCreacion: DateTime.now(),
        fechaActualizacion: DateTime.now(),
      ),
    ];
  }

  void _cargarStandsDeMuestra() {
    _stands = [
      Stand(
        id: '1',
        nombreEmpresa: 'Restaurante El Sabor',
        descripcion: 'Comida criolla tradicional',
        imagenUrl: '',
        eventoId: '1',
        zonaNumero: 10,
        zonaNombre: 'Patio de comidas',
        productos: ['Ceviche', 'Ají de gallina', 'Lomo saltado'],
        contacto: 'Juan Pérez',
        telefono: '987654321',
        fechaCreacion: DateTime.now(),
        fechaActualizacion: DateTime.now(),
      ),
      Stand(
        id: '2',
        nombreEmpresa: 'Artesanías Tacneñas',
        descripcion: 'Productos artesanales de la región',
        imagenUrl: '',
        eventoId: '1',
        zonaNumero: 14,
        zonaNombre: 'Zona artesanal',
        productos: ['Textiles', 'Cerámica', 'Joyería'],
        contacto: 'María García',
        telefono: '987654322',
        fechaCreacion: DateTime.now(),
        fechaActualizacion: DateTime.now(),
      ),
    ];
  }
}
