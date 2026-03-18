class AppValidators {
  // Nombre: solo letras, espacios y caracteres especiales (acentos, ñ)
  // Mínimo 2 caracteres, máximo 60
  static String? validateName(String? value, {String fieldName = 'Este campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es obligatorio';
    }
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return '$fieldName debe tener al menos 2 caracteres';
    }
    if (trimmed.length > 60) {
      return '$fieldName no puede superar los 60 caracteres';
    }
    // Solo letras, espacios, apóstrofes y guiones
    final nameRegex = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚàèìòùÀÈÌÒÙäëïöüÄËÏÖÜñÑçÇ\s'\-\.]+$");
    if (!nameRegex.hasMatch(trimmed)) {
      return '$fieldName solo puede contener letras';
    }
    return null;
  }

  // Nombre de negocio: letras, números, espacios y caracteres básicos
  static String? validateBusinessName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre del negocio es obligatorio';
    }
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    if (trimmed.length > 80) {
      return 'El nombre no puede superar los 80 caracteres';
    }
    // Permite letras, números, espacios, &, -, ., '
    final businessRegex = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ0-9\s&\-\.\']+$");
    if (!businessRegex.hasMatch(trimmed)) {
      return 'Nombre inválido. Solo letras, números y & - .';
    }
    return null;
  }

  // Teléfono: valida por país (longitud y prefijo)
  static String? validatePhone(String? value, String countryCode) {
    if (value == null || value.trim().isEmpty) {
      return 'El teléfono es obligatorio';
    }
    final digits = value.trim().replaceAll(RegExp(r'\s'), '');

    // Solo dígitos
    if (!RegExp(r'^\d+$').hasMatch(digits)) {
      return 'Solo se permiten números';
    }

    // Validación por país
    switch (countryCode) {
      case '+34': // España: 9 dígitos, empieza por 6, 7, 8 o 9
        if (digits.length != 9) return 'El teléfono español debe tener 9 dígitos';
        if (!RegExp(r'^[6789]\d{8}$').hasMatch(digits)) {
          return 'Teléfono español inválido (debe empezar por 6, 7, 8 o 9)';
        }
        break;
      case '+52': // México: 10 dígitos
        if (digits.length != 10) return 'El teléfono mexicano debe tener 10 dígitos';
        break;
      case '+57': // Colombia: 10 dígitos, empieza por 3
        if (digits.length != 10) return 'El teléfono colombiano debe tener 10 dígitos';
        if (!digits.startsWith('3')) return 'Móvil colombiano debe empezar por 3';
        break;
      case '+54': // Argentina: 10 dígitos
        if (digits.length < 10 || digits.length > 11) {
          return 'El teléfono argentino debe tener 10-11 dígitos';
        }
        break;
      case '+56': // Chile: 9 dígitos
        if (digits.length != 9) return 'El teléfono chileno debe tener 9 dígitos';
        break;
      case '+51': // Perú: 9 dígitos
        if (digits.length != 9) return 'El teléfono peruano debe tener 9 dígitos';
        break;
      case '+1': // EEUU/Canadá: 10 dígitos
        if (digits.length != 10) return 'El teléfono debe tener 10 dígitos';
        break;
      default:
        if (digits.length < 7 || digits.length > 15) {
          return 'Número de teléfono inválido';
        }
    }
    return null;
  }

  // Precio: número positivo con máximo 2 decimales
  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El precio es obligatorio';
    }
    final cleaned = value.trim().replaceAll(',', '.');
    final price = double.tryParse(cleaned);
    if (price == null) return 'Introduce un precio válido (ej: 15.00)';
    if (price < 0) return 'El precio no puede ser negativo';
    if (price > 9999) return 'El precio máximo es 9.999 €';

    // Máximo 2 decimales
    final parts = cleaned.split('.');
    if (parts.length > 1 && parts[1].length > 2) {
      return 'Máximo 2 decimales';
    }
    return null;
  }

  // Duración en minutos: entero positivo
  static String? validateDuration(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La duración es obligatoria';
    }
    final mins = int.tryParse(value.trim());
    if (mins == null) return 'Introduce un número entero de minutos';
    if (mins < 5) return 'La duración mínima es 5 minutos';
    if (mins > 480) return 'La duración máxima es 480 minutos (8h)';
    if (mins % 5 != 0) return 'La duración debe ser múltiplo de 5 minutos';
    return null;
  }

  // Nombre de servicio
  static String? validateServiceName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre del servicio es obligatorio';
    }
    if (value.trim().length < 2) return 'Mínimo 2 caracteres';
    if (value.trim().length > 50) return 'Máximo 50 caracteres';
    return null;
  }

  // Número de calle/portal
  static String? validateStreetNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El número es obligatorio';
    }
    final trimmed = value.trim();
    if (trimmed.length > 10) return 'Número demasiado largo';
    // Acepta: 12, 12A, 12-B, S/N
    final regex = RegExp(r'^[0-9]+[a-zA-Z\-]?$|^[Ss]\/[Nn]$');
    if (!regex.hasMatch(trimmed)) {
      return 'Formato inválido (ej: 12, 12A, S/N)';
    }
    return null;
  }

  // Piso/puerta/apartamento (opcional pero validado si se rellena)
  static String? validateApartment(String? value) {
    if (value == null || value.trim().isEmpty) return null; // opcional
    if (value.trim().length > 30) return 'Máximo 30 caracteres';
    return null;
  }
}