# Implementación de Descarga de PDF - Item 19

## Resumen
Se ha implementado la funcionalidad para asociar, almacenar y mostrar documentos PDF en los eventos usando codificación base64.

## Archivos Modificados

### 1. Modelo de Evento (`lib/models/evento.dart`)
**Campos agregados:**
- `String? pdfBase64` - Almacena el PDF codificado en base64
- `String? pdfNombre` - Nombre original del archivo PDF

**Métodos actualizados:**
- `fromJson()` - Incluye los campos de PDF
- `toJson()` - Serializa los campos de PDF
- `copyWith()` - Permite copiar con nuevos valores de PDF

### 2. Vista de Opciones del Evento (`lib/views/visitante/evento_opciones_view.dart`)
**Funcionalidades agregadas:**
- Botón "Abrir Documento PDF" en el header del evento
- Método `_tienePDF()` para validar existencia del documento
- Método `_abrirPDF()` para decodificar y abrir el PDF
- Manejo de errores con mensajes informativos
- Indicador de carga durante el procesamiento

### 3. Widget para Panel Admin (`lib/widgets/subir_pdf_widget.dart`)
**Características:**
- Selección de archivos PDF mediante `file_picker`
- Validación de tamaño (máximo 5MB)
- Codificación automática a base64
- Previsualización del archivo seleccionado
- Opción para eliminar PDF existente

### 4. Dependencias (`pubspec.yaml`)
**Nuevas dependencias agregadas:**
- `path_provider: ^2.1.1` - Para acceso a directorios temporales
- `open_file: ^3.3.2` - Para abrir archivos PDF
- `file_picker: ^6.1.1` - Para seleccionar archivos (panel admin)

## Uso en Panel de Administrador

```dart
import '../widgets/subir_pdf_widget.dart';

// En el formulario de creación/edición de evento
SubirPDFWidget(
  pdfActual: evento.pdfBase64,
  nombreActual: evento.pdfNombre,
  onPDFSelected: (String base64, String nombre) {
    // Actualizar el evento con los nuevos datos
    setState(() {
      _pdfBase64 = base64.isEmpty ? null : base64;
      _pdfNombre = nombre.isEmpty ? null : nombre;
    });
  },
)

// Al guardar el evento
final eventoActualizado = evento.copyWith(
  pdfBase64: _pdfBase64,
  pdfNombre: _pdfNombre,
);
```

## Flujo de Usuario Visitante

1. **Vista de Opciones del Evento**
   - Si el evento tiene PDF: Botón "Abrir Documento PDF" habilitado
   - Si no tiene PDF: Botón "Sin documento disponible" deshabilitado

2. **Al presionar el botón**
   - Muestra indicador de carga
   - Decodifica el base64 a bytes
   - Crea archivo temporal en el dispositivo
   - Abre el PDF con la aplicación predeterminada
   - Muestra mensaje de éxito o error

## Validaciones Implementadas

### Frontend (Vista de Usuario)
- ✅ Verificación de existencia de PDF antes de mostrar botón
- ✅ Manejo de errores durante decodificación
- ✅ Mensajes informativos para el usuario
- ✅ Indicador de carga durante procesamiento

### Frontend (Panel Admin)
- ✅ Validación de tipo de archivo (solo PDF)
- ✅ Validación de tamaño (máximo 5MB)
- ✅ Previsualización del archivo seleccionado
- ✅ Opción para eliminar PDF existente

### Backend (Base de Datos)
- ✅ Campos opcionales en el modelo
- ✅ Serialización/deserialización automática
- ✅ Compatibilidad con eventos existentes sin PDF

## Criterios de Aceptación - Cumplimiento

| Criterio | Estado | Implementación |
|----------|---------|----------------|
| Botón visible en vista detalle | ✅ | Botón en header con estado condicional |
| PDF asociado al evento | ✅ | Campos pdfBase64 y pdfNombre en modelo |
| Validación de accesibilidad | ✅ | Método `_tienePDF()` y validaciones |
| Mensajes de confirmación/error | ✅ | SnackBar para todos los estados |
| Botón desactivado sin documento | ✅ | Botón gris y deshabilitado |

## Consideraciones Técnicas

### Ventajas del Enfoque Base64
- ✅ No requiere almacenamiento externo (Firebase Storage)
- ✅ Funciona completamente offline una vez cargado
- ✅ Control total sobre los archivos
- ✅ Simplicidad en la implementación

### Limitaciones
- ⚠️ Aumenta el tamaño de los documentos en Firestore
- ⚠️ Límite de 1MB por documento en Firestore (considerar división)
- ⚠️ Tiempo de carga inicial mayor para eventos con PDF

### Recomendaciones
- Para PDFs grandes (>500KB), considerar migrar a Firebase Storage
- Implementar compresión de PDF si es necesario
- Considerar lazy loading para optimizar rendimiento

## Instalación y Configuración

1. **Instalar dependencias:**
   ```bash
   flutter pub get
   ```

2. **Para plataformas específicas:**
   - **Android**: Agregar permisos en `android/app/src/main/AndroidManifest.xml` si es necesario
   - **iOS**: Configurar `ios/Runner/Info.plist` para acceso a archivos

3. **Configuración de Base de Datos:**
   - Los campos PDF son opcionales, no se requiere migración
   - Eventos existentes funcionarán sin modificaciones

## Testing

### Casos de Prueba Recomendados
1. Evento sin PDF - botón deshabilitado
2. Evento con PDF válido - apertura exitosa
3. Evento con PDF corrupto - manejo de error
4. PDF grande (>5MB) - validación en panel admin
5. Selección de archivo no-PDF - rechazo en panel admin

### Comandos de Testing
```bash
# Ejecutar tests unitarios
flutter test

# Ejecutar tests de integración
flutter test integration_test/
```

## Próximos Pasos

1. **Optimizaciones:**
   - Implementar caché local para PDFs frecuentemente accedidos
   - Comprimir PDFs automáticamente en el panel admin

2. **Mejoras UX:**
   - Previsualización del PDF sin descargar completamente
   - Progreso de descarga para archivos grandes

3. **Escalabilidad:**
   - Migrar a Firebase Storage para mejor rendimiento
   - Implementar URLs firmadas para seguridad adicional