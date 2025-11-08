# Sistema de Preguntas Frecuentes (FAQ) y Soporte - PeruFest 2025

## 📋 Descripción

Este módulo implementa un sistema completo de preguntas frecuentes y soporte para la aplicación PeruFest 2025. Permite a los administradores gestionar las FAQs y a los visitantes encontrar respuestas rápidamente, además de contactar soporte cuando sea necesario.

## ✨ Funcionalidades Implementadas

### Para Administradores:
- ✅ **Gestión completa de FAQs**: Crear, editar, activar/desactivar y eliminar preguntas frecuentes
- ✅ **Panel de estadísticas**: Ver cantidad total, activas e inactivas
- ✅ **Ordenamiento**: Organizar las FAQs por prioridad
- ✅ **Inicialización automática**: Crear FAQs predeterminadas al primera uso
- ✅ **Validación de formularios**: Campos obligatorios y longitud mínima
- ✅ **Estados de FAQ**: Activar/desactivar preguntas según relevancia

### Para Visitantes:
- ✅ **Visualización de FAQs activas**: Solo mostrar preguntas relevantes
- ✅ **Búsqueda en tiempo real**: Buscar por texto en preguntas y respuestas
- ✅ **Interfaz intuitiva**: Diseño accordion para mejor experiencia
- ✅ **Contacto de soporte**: Enlaces directos a WhatsApp y email
- ✅ **Diseño responsive**: Adaptado para diferentes tamaños de pantalla

## 🏗️ Arquitectura

### Modelo de Datos (`FAQ`)
```dart
class FAQ {
  final String id;
  final String pregunta;
  final String respuesta;
  final bool estado; // true = activa, false = inactiva
  final DateTime fechaCreacion;
  final DateTime fechaModificacion;
  final int orden; // Para ordenar las preguntas
}
```

### Servicios
- **`FAQService`**: Maneja operaciones CRUD con Firestore
- **`InicializadorFAQ`**: Crea preguntas predeterminadas automáticamente

### ViewModels
- **`FAQViewModel`**: Gestiona el estado de la aplicación y lógica de negocio

### Vistas
- **`FAQAdminPage`**: Panel de administración
- **`CrearFAQPage`**: Formulario para crear nuevas FAQs
- **`EditarFAQPage`**: Formulario para editar FAQs existentes
- **`FAQVisitanteView`**: Vista pública para visitantes

## 📱 Navegación

### Dashboard Administrador:
- **Ruta**: Dashboard → FAQs
- **Icono**: `Icons.help_center`
- **Posición**: Menú lateral (index 5)

### Dashboard Visitante:
- **Ruta**: Dashboard → FAQ (Bottom Navigation)
- **Icono**: `Icons.help_center_outlined` / `Icons.help_center`
- **Posición**: Bottom Navigation (index 3)

## 🎯 FAQs Predeterminadas

El sistema incluye 5 preguntas frecuentes básicas que se crean automáticamente:

1. **¿Cuál es el horario del festival?**
2. **¿Dónde se ubica el ParquePerú Fest?**
3. **¿Las entradas tienen costo?**
4. **¿Puedo llevar comida y bebidas?**
5. **¿Hay estacionamiento disponible?**

## 🔧 Configuración de Soporte

### Contactos (Actualizar según necesidades):
- **WhatsApp**: `+51987654321`
- **Email**: `soporte@perufest.com`

Para cambiar estos valores, edita:
- `lib/views/visitante/faq_visitante_view.dart` (líneas 331 y 347)

## 🚀 Instalación y Uso

### 1. Dependencias
Asegúrate de que estas dependencias estén en `pubspec.yaml`:
```yaml
dependencies:
  cloud_firestore: ^5.4.4
  provider: ^6.0.0
  url_launcher: ^6.2.2
```

### 2. Configuración Firebase
- Configura Firestore en tu proyecto Firebase
- La colección `faqs` se creará automáticamente

### 3. Integración en la App
El sistema está completamente integrado en:
- `lib/app.dart`: Provider agregado
- `dashboard_admin_view.dart`: Navegación agregada
- `dashboard_user_view.dart`: Navegación agregada

## 📊 Base de Datos (Firestore)

### Colección: `faqs`
```json
{
  "pregunta": "¿Cuál es el horario del festival?",
  "respuesta": "El PeruFest 2025 se realizará de 9:00 AM a 10:00 PM...",
  "estado": true,
  "fechaCreacion": "2025-11-08T10:30:00Z",
  "fechaModificacion": "2025-11-08T10:30:00Z",
  "orden": 1
}
```

## 🎨 Diseño y UX

### Colores del Tema:
- **Principal**: `Color(0xFF8B1B1B)` (Guinda PeruFest)
- **Activo**: Verde para FAQs activas
- **Inactivo**: Naranja/Rojo para FAQs inactivas
- **Fondo**: Gris claro (`Colors.grey.shade50`)

### Características de UX:
- **Expansión suave**: AnimatedContainer para transiciones
- **Estados visuales**: Indicadores de color para estado de FAQ
- **Feedback inmediato**: SnackBars para confirmaciones
- **Carga progresiva**: Loading indicators durante operaciones

## 🔍 Funciones de Búsqueda

### Algoritmo de Búsqueda:
- Búsqueda en tiempo real (onChange)
- Insensible a mayúsculas/minúsculas
- Busca tanto en preguntas como en respuestas
- Filtra solo FAQs activas para visitantes

### Mejoras Futuras Sugeridas:
- Implementar Algolia para búsqueda avanzada
- Agregar filtros por categorías
- Implementar búsqueda con sinónimos
- Analytics de búsquedas más frecuentes

## 🛠️ Mantenimiento

### Operaciones Regulares:
1. **Revisar FAQs**: Verificar vigencia de información
2. **Actualizar respuestas**: Mantener información actualizada
3. **Monitorear búsquedas**: Identificar preguntas frecuentes no cubiertas
4. **Optimizar orden**: Organizar por relevancia/frecuencia

### Backup y Seguridad:
- Firestore maneja backups automáticamente
- Implementar roles de usuario apropiados
- Considerar versionado de respuestas para auditoría

## 📈 Métricas y Analytics

### Estadísticas Disponibles:
- Total de FAQs
- FAQs activas vs inactivas
- Fechas de creación y modificación

### Métricas Sugeridas para Implementar:
- Preguntas más vistas
- Efectividad de respuestas
- Patrones de búsqueda de usuarios
- Conversiones a contacto de soporte

## 🐛 Troubleshooting

### Problemas Comunes:

1. **FAQs no se cargan**:
   - Verificar conectividad a Firestore
   - Revisar reglas de seguridad de Firebase

2. **Error al crear FAQs**:
   - Verificar permisos de escritura
   - Validar campos obligatorios

3. **Búsqueda no funciona**:
   - Verificar índices de Firestore
   - Comprobar filtros de estado

## 📝 Changelog

### v1.0.0 (2025-11-08)
- ✅ Sistema completo de FAQs implementado
- ✅ Panel de administración funcional
- ✅ Vista pública para visitantes
- ✅ Integración con sistema de navegación
- ✅ FAQs predeterminadas incluidas
- ✅ Contacto de soporte integrado

---

## 👥 Equipo de Desarrollo

**Implementado por**: GitHub Copilot  
**Fecha**: 8 de Noviembre, 2025  
**Proyecto**: PeruFest 2025 - Sistema de FAQs y Soporte