import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/admin_eventos_viewmodel.dart';
import '../../viewmodels/autenticacion_viewmodel.dart';
import '../../widgets/campo_texto_personalizado.dart';
import '../../widgets/selector_fecha_personalizado.dart';

class CrearEventoPantalla extends StatefulWidget {
  const CrearEventoPantalla({super.key});

  @override
  State<CrearEventoPantalla> createState() => _CrearEventoPantallaState();
}

class _CrearEventoPantallaState extends State<CrearEventoPantalla> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _lugarController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _imagenUrlController = TextEditingController();
  
  DateTime? _fechaInicioSeleccionada;
  TimeOfDay? _horaInicioSeleccionada;
  DateTime? _fechaFinSeleccionada;
  TimeOfDay? _horaFinSeleccionada;

  @override
  void dispose() {
    _nombreController.dispose();
    _lugarController.dispose();
    _descripcionController.dispose();
    _imagenUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Nuevo Evento'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AdminEventosViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Mensajes de estado
                  if (viewModel.errorFormulario != null)
                    _buildMensajeError(viewModel.errorFormulario!),
                  
                  if (viewModel.mensajeExito != null)
                    _buildMensajeExito(viewModel.mensajeExito!),

                  const SizedBox(height: 16),

                  // Formulario
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Información del Evento',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),

                          // Nombre del evento
                          CampoTextoPersonalizado(
                            controller: _nombreController,
                            labelText: 'Nombre del evento *',
                            hintText: 'Ej: Festival de Música PeruFest 2025',
                            prefixIcon: Icons.event,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El nombre del evento es obligatorio';
                              }
                              if (value.trim().length < 3) {
                                return 'El nombre debe tener al menos 3 caracteres';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Lugar del evento
                          CampoTextoPersonalizado(
                            controller: _lugarController,
                            labelText: 'Lugar del evento *',
                            hintText: 'Ej: Parque Central de Lima',
                            prefixIcon: Icons.location_on,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El lugar del evento es obligatorio';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Fechas de inicio y fin
                          Row(
                            children: [
                              Expanded(
                                child: SelectorFechaPersonalizado(
                                  labelText: 'Fecha de inicio *',
                                  fechaSeleccionada: _fechaInicioSeleccionada,
                                  onFechaSeleccionada: (fecha) {
                                    setState(() {
                                      _fechaInicioSeleccionada = fecha;
                                      // Si la fecha de fin es anterior a la de inicio, limpiarla
                                      if (_fechaFinSeleccionada != null && 
                                          fecha != null && 
                                          _fechaFinSeleccionada!.isBefore(fecha)) {
                                        _fechaFinSeleccionada = null;
                                      }
                                    });
                                  },
                                  validator: (fecha) {
                                    if (fecha == null) {
                                      return 'La fecha de inicio es obligatoria';
                                    }
                                    if (fecha.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
                                      return 'La fecha no puede ser anterior a hoy';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildSelectorHoraInicio(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: SelectorFechaPersonalizado(
                                  labelText: 'Fecha de fin *',
                                  fechaSeleccionada: _fechaFinSeleccionada,
                                  fechaMinima: _fechaInicioSeleccionada,
                                  onFechaSeleccionada: (fecha) {
                                    setState(() {
                                      _fechaFinSeleccionada = fecha;
                                    });
                                  },
                                  validator: (fecha) {
                                    if (fecha == null) {
                                      return 'La fecha de fin es obligatoria';
                                    }
                                    if (_fechaInicioSeleccionada != null && 
                                        fecha.isBefore(_fechaInicioSeleccionada!)) {
                                      return 'Debe ser posterior a la fecha de inicio';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildSelectorHoraFin(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Descripción
                          CampoTextoPersonalizado(
                            controller: _descripcionController,
                            labelText: 'Descripción del evento *',
                            hintText: 'Describe los detalles del evento...',
                            prefixIcon: Icons.description,
                            maxLines: 4,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'La descripción del evento es obligatoria';
                              }
                              if (value.trim().length < 10) {
                                return 'La descripción debe tener al menos 10 caracteres';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // URL de imagen (opcional)
                          CampoTextoPersonalizado(
                            controller: _imagenUrlController,
                            labelText: 'URL de la imagen (opcional)',
                            hintText: 'https://ejemplo.com/imagen.jpg',
                            prefixIcon: Icons.image,
                            validator: (value) {
                              if (value != null && value.trim().isNotEmpty) {
                                final uri = Uri.tryParse(value.trim());
                                if (uri == null || !uri.hasScheme) {
                                  return 'Ingresa una URL válida';
                                }
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Botones de acción
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: viewModel.guardandoEvento ? null : () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: viewModel.guardandoEvento ? null : _guardarEvento,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: viewModel.guardandoEvento
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Crear Evento',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectorHoraInicio() {
    return InkWell(
      onTap: () => _seleccionarHoraInicio(),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Hora de inicio *',
          prefixIcon: const Icon(Icons.access_time),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.orange, width: 2),
          ),
        ),
        child: Text(
          _horaInicioSeleccionada != null
              ? _horaInicioSeleccionada!.format(context)
              : 'Seleccionar hora',
          style: TextStyle(
            color: _horaInicioSeleccionada != null ? Colors.black : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectorHoraFin() {
    return InkWell(
      onTap: () => _seleccionarHoraFin(),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Hora de fin *',
          prefixIcon: const Icon(Icons.access_time_filled),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.orange, width: 2),
          ),
        ),
        child: Text(
          _horaFinSeleccionada != null
              ? _horaFinSeleccionada!.format(context)
              : 'Seleccionar hora',
          style: TextStyle(
            color: _horaFinSeleccionada != null ? Colors.black : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Future<void> _seleccionarHoraInicio() async {
    final hora = await showTimePicker(
      context: context,
      initialTime: _horaInicioSeleccionada ?? TimeOfDay.now(),
    );
    
    if (hora != null) {
      setState(() {
        _horaInicioSeleccionada = hora;
        // Si hay hora de fin y es anterior a la de inicio, limpiarla
        if (_horaFinSeleccionada != null && 
            _fechaInicioSeleccionada != null &&
            _fechaFinSeleccionada != null &&
            _fechaInicioSeleccionada!.day == _fechaFinSeleccionada!.day) {
          final inicioMinutos = hora.hour * 60 + hora.minute;
          final finMinutos = _horaFinSeleccionada!.hour * 60 + _horaFinSeleccionada!.minute;
          if (finMinutos <= inicioMinutos) {
            _horaFinSeleccionada = null;
          }
        }
      });
    }
  }

  Future<void> _seleccionarHoraFin() async {
    final hora = await showTimePicker(
      context: context,
      initialTime: _horaFinSeleccionada ?? 
          (_horaInicioSeleccionada?.replacing(hour: _horaInicioSeleccionada!.hour + 1) ?? TimeOfDay.now()),
    );
    
    if (hora != null) {
      setState(() {
        _horaFinSeleccionada = hora;
      });
    }
  }

  Widget _buildMensajeError(String mensaje) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        border: Border.all(color: Colors.red[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              mensaje,
              style: TextStyle(color: Colors.red[700]),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.red[700], size: 20),
            onPressed: () {
              context.read<AdminEventosViewModel>().limpiarMensajes();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMensajeExito(String mensaje) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        border: Border.all(color: Colors.green[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: Colors.green[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              mensaje,
              style: TextStyle(color: Colors.green[700]),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.green[700], size: 20),
            onPressed: () {
              context.read<AdminEventosViewModel>().limpiarMensajes();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _guardarEvento() async {
    // Limpiar mensajes previos
    context.read<AdminEventosViewModel>().limpiarMensajes();

    // Validar formulario
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validar fechas
    if (_fechaInicioSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona la fecha de inicio del evento'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_fechaFinSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona la fecha de fin del evento'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_horaInicioSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona la hora de inicio del evento'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_horaFinSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona la hora de fin del evento'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Combinar fechas y horas
    final fechaInicioCompleta = DateTime(
      _fechaInicioSeleccionada!.year,
      _fechaInicioSeleccionada!.month,
      _fechaInicioSeleccionada!.day,
      _horaInicioSeleccionada!.hour,
      _horaInicioSeleccionada!.minute,
    );

    final fechaFinCompleta = DateTime(
      _fechaFinSeleccionada!.year,
      _fechaFinSeleccionada!.month,
      _fechaFinSeleccionada!.day,
      _horaFinSeleccionada!.hour,
      _horaFinSeleccionada!.minute,
    );

    // Validar que la fecha de fin sea posterior a la de inicio
    if (!fechaFinCompleta.isAfter(fechaInicioCompleta)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La fecha y hora de fin debe ser posterior a la de inicio'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Crear evento
    final exito = await context.read<AdminEventosViewModel>().crearEvento(
      nombre: _nombreController.text.trim(),
      fechaInicio: fechaInicioCompleta,
      fechaFin: fechaFinCompleta,
      lugar: _lugarController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      imagenUrl: _imagenUrlController.text.trim().isEmpty 
          ? null 
          : _imagenUrlController.text.trim(),
      creadoPor: context.read<AutenticacionViewModel>().usuario?.id ?? '',
    );

    if (exito) {
      // Limpiar formulario
      _nombreController.clear();
      _lugarController.clear();
      _descripcionController.clear();
      _imagenUrlController.clear();
      setState(() {
        _fechaInicioSeleccionada = null;
        _fechaFinSeleccionada = null;
        _horaInicioSeleccionada = null;
        _horaFinSeleccionada = null;
      });

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Evento creado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );

      // Regresar a la pantalla anterior después de un breve delay
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }
}
