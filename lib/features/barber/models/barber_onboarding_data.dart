class ServiceItem {
  String name;
  double price;
  int durationMinutes;

  ServiceItem({
    required this.name,
    required this.price,
    required this.durationMinutes,
  });

  String get formattedPrice => '${price.toStringAsFixed(2)} €';
  String get formattedDuration =>
      durationMinutes >= 60
          ? '${durationMinutes ~/ 60}h ${durationMinutes % 60 > 0 ? '${durationMinutes % 60}min' : ''}'.trim()
          : '${durationMinutes}min';

  ServiceItem copyWith({String? name, double? price, int? durationMinutes}) {
    return ServiceItem(
      name: name ?? this.name,
      price: price ?? this.price,
      durationMinutes: durationMinutes ?? this.durationMinutes,
    );
  }
}

class DaySchedule {
  final String dayKey;
  final String dayLabel;
  bool isOpen;
  TimeOfDay openTime;
  TimeOfDay closeTime;

  DaySchedule({
    required this.dayKey,
    required this.dayLabel,
    required this.isOpen,
    required this.openTime,
    required this.closeTime,
  });

  String get formattedHours {
    if (!isOpen) return 'Cerrado';
    return '${_formatTime(openTime)} - ${_formatTime(closeTime)}';
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class BarberOnboardingData {
  // Step 1: Info personal
  String businessName;
  String ownerName;
  String phone;
  String countryCode;
  bool termsAccepted;
  bool promosAccepted;

  // Step 2: Ubicación
  bool worksInShop;
  bool worksAtHome;

  // Step 3: Dirección
  String street;
  String streetNumber;
  String apartment;

  // Step 4: Coordenadas
  double? latitude;
  double? longitude;

  // Step 5: Equipo
  int? teamSize; // 1, 4, 9, 10+

  // Step 6: Horario
  List<DaySchedule> schedule;

  // Step 7: Servicios
  List<ServiceItem> services;

  BarberOnboardingData({
    this.businessName = '',
    this.ownerName = '',
    this.phone = '',
    this.countryCode = '+34',
    this.termsAccepted = false,
    this.promosAccepted = false,
    this.worksInShop = false,
    this.worksAtHome = false,
    this.street = '',
    this.streetNumber = '',
    this.apartment = '',
    this.latitude,
    this.longitude,
    this.teamSize,
    List<DaySchedule>? schedule,
    List<ServiceItem>? services,
  })  : schedule = schedule ?? _defaultSchedule(),
        services = services ?? [];

  static List<DaySchedule> _defaultSchedule() {
    final days = [
      ('monday', 'Lunes'),
      ('tuesday', 'Martes'),
      ('wednesday', 'Miércoles'),
      ('thursday', 'Jueves'),
      ('friday', 'Viernes'),
      ('saturday', 'Sábado'),
      ('sunday', 'Domingo'),
    ];
    return days.map((d) => DaySchedule(
      dayKey: d.$1,
      dayLabel: d.$2,
      isOpen: d.$1 != 'saturday' && d.$1 != 'sunday',
      openTime: const TimeOfDay(hour: 10, minute: 0),
      closeTime: const TimeOfDay(hour: 19, minute: 0),
    )).toList();
  }
}