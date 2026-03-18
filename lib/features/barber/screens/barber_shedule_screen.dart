import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/shared_widgets.dart';
import '../models/barber_onboarding_data.dart';
import 'barber_services_screen.dart';

class BarberScheduleScreen extends StatefulWidget {
  final BarberOnboardingData data;

  const BarberScheduleScreen({super.key, required this.data});

  @override
  State<BarberScheduleScreen> createState() => _BarberScheduleScreenState();
}

class _BarberScheduleScreenState extends State<BarberScheduleScreen> {
  late List<DaySchedule> _schedule;

  @override
  void initState() {
    super.initState();
    _schedule = List.from(widget.data.schedule);
  }

  bool get _hasAtLeastOneOpenDay => _schedule.any((d) => d.isOpen);

  void _handleNext() {
    if (!_hasAtLeastOneOpenDay) {
      showAppSnackBar(context, 'Debes tener al menos un día abierto.');
      return;
    }

    // Validar que para días abiertos la hora de cierre sea después de la apertura
    for (final day in _schedule.where((d) => d.isOpen)) {
      final openMins = day.openTime.hour * 60 + day.openTime.minute;
      final closeMins = day.closeTime.hour * 60 + day.closeTime.minute;
      if (closeMins <= openMins) {
        showAppSnackBar(
          context,
          'En ${day.dayLabel}, la hora de cierre debe ser posterior a la de apertura.',
        );
        return;
      }
      if (closeMins - openMins < 60) {
        showAppSnackBar(
          context,
          'En ${day.dayLabel}, el horario debe ser de al menos 1 hora.',
        );
        return;
      }
    }

    widget.data.schedule = _schedule;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BarberServicesScreen(data: widget.data)),
    );
  }

  Future<void> _pickTime({
    required DaySchedule day,
    required bool isOpenTime,
  }) async {
    final initial = isOpenTime ? day.openTime : day.closeTime;

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.black,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.black,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppColors.white,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isOpenTime) {
          day.openTime = picked;
          // Si la apertura queda después del cierre, ajustar cierre
          final openMins = picked.hour * 60 + picked.minute;
          final closeMins = day.closeTime.hour * 60 + day.closeTime.minute;
          if (closeMins <= openMins) {
            day.closeTime = TimeOfDay(
              hour: (picked.hour + 1).clamp(0, 23),
              minute: picked.minute,
            );
          }
        } else {
          day.closeTime = picked;
        }
      });
    }
  }

  void _applyToAllOpen(DaySchedule source) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 4, width: 40,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.greyMid,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text('Aplicar horario', style: AppTextStyles.headline2),
            const SizedBox(height: 8),
            Text(
              'Aplicar ${source.formattedHours} a todos los días abiertos',
              style: AppTextStyles.bodyMuted,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Aplicar a todos los días abiertos',
              onPressed: () {
                setState(() {
                  for (final day in _schedule.where((d) => d.isOpen)) {
                    day.openTime = source.openTime;
                    day.closeTime = source.closeTime;
                  }
                });
                Navigator.pop(ctx);
                showAppSnackBar(context, 'Horario aplicado a todos los días abiertos.', isError: false);
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.black,
                  side: const BorderSide(color: AppColors.greyMid),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancelar', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: OnboardingAppBar(currentStep: 5, totalSteps: 7),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const Text('Horario de\napertura', style: AppTextStyles.headline1),
                  const SizedBox(height: 8),
                  const Text(
                    '¿Cuándo pueden los clientes reservar una cita contigo?',
                    style: AppTextStyles.bodyMuted,
                  ),
                  const SizedBox(height: 32),

                  // Lista de días
                  ..._schedule.map((day) => _DayRow(
                    day: day,
                    onToggle: () => setState(() => day.isOpen = !day.isOpen),
                    onTapOpenTime: () => _pickTime(day: day, isOpenTime: true),
                    onTapCloseTime: () => _pickTime(day: day, isOpenTime: false),
                    onLongPress: () => _applyToAllOpen(day),
                  )),

                  const SizedBox(height: 16),
                  // Hint
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.greyLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.info_outline, size: 16, color: AppColors.greyText),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Mantén pulsado un día abierto para aplicar ese horario a todos.',
                            style: TextStyle(fontSize: 12, color: AppColors.greyText, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: PrimaryButton(
              label: 'Siguiente',
              onPressed: _handleNext,
              isEnabled: _hasAtLeastOneOpenDay,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// FILA DE UN DÍA
// ─────────────────────────────────────────────
class _DayRow extends StatelessWidget {
  final DaySchedule day;
  final VoidCallback onToggle;
  final VoidCallback onTapOpenTime;
  final VoidCallback onTapCloseTime;
  final VoidCallback onLongPress;

  const _DayRow({
    required this.day,
    required this.onToggle,
    required this.onTapOpenTime,
    required this.onTapCloseTime,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: day.isOpen ? onLongPress : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            // Toggle switch
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 26,
                decoration: BoxDecoration(
                  color: day.isOpen ? AppColors.black : AppColors.greyMid,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 200),
                  alignment:
                      day.isOpen ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Nombre del día
            SizedBox(
              width: 80,
              child: Text(
                day.dayLabel,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: day.isOpen ? AppColors.black : AppColors.greySubtext,
                ),
              ),
            ),

            if (day.isOpen) ...[
              const Spacer(),
              // Hora apertura
              _TimeButton(
                time: day.openTime,
                onTap: onTapOpenTime,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  '–',
                  style: TextStyle(
                    color: AppColors.greyText,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              // Hora cierre
              _TimeButton(
                time: day.closeTime,
                onTap: onTapCloseTime,
              ),
            ] else ...[
              const Spacer(),
              Text(
                'Cerrado',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.greySubtext,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TimeButton extends StatelessWidget {
  final TimeOfDay time;
  final VoidCallback onTap;

  const _TimeButton({required this.time, required this.onTap});

  String _format(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.greyLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          _format(time),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}