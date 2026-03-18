import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/shared_widgets.dart';
import '../models/barber_onboarding_data.dart';
import 'barber_schedule_screen.dart';

class BarberTeamSizeScreen extends StatefulWidget {
  final BarberOnboardingData data;

  const BarberTeamSizeScreen({super.key, required this.data});

  @override
  State<BarberTeamSizeScreen> createState() => _BarberTeamSizeScreenState();
}

class _BarberTeamSizeScreenState extends State<BarberTeamSizeScreen> {
  int? _selectedSize; // 1, 4 (2-4), 9 (5-9), 10 (10+)

  final List<_TeamOption> _options = const [
    _TeamOption(
      value: 1,
      label: 'Trabajo solo/a',
      subtitle: 'Eres el único barbero',
      icon: Icons.person_outline,
    ),
    _TeamOption(
      value: 4,
      label: '2-4 empleados',
      subtitle: 'Equipo pequeño',
      icon: Icons.people_outline,
    ),
    _TeamOption(
      value: 9,
      label: '5-9 empleados',
      subtitle: 'Equipo mediano',
      icon: Icons.groups_outlined,
    ),
    _TeamOption(
      value: 10,
      label: 'Más de 10 empleados',
      subtitle: 'Gran equipo',
      icon: Icons.corporate_fare_outlined,
    ),
  ];

  void _handleNext() {
    if (_selectedSize == null) {
      showAppSnackBar(context, 'Selecciona el tamaño de tu equipo para continuar.');
      return;
    }

    widget.data.teamSize = _selectedSize;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BarberScheduleScreen(data: widget.data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: OnboardingAppBar(currentStep: 4, totalSteps: 7),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    '¿Cuál es el tamaño\nde tu equipo?',
                    style: AppTextStyles.headline1,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Esto nos ayuda a configurar tu agenda de la mejor forma.',
                    style: AppTextStyles.bodyMuted,
                  ),
                  const SizedBox(height: 36),
                  ...List.generate(_options.length, (i) {
                    final opt = _options[i];
                    final isSelected = _selectedSize == opt.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _TeamOptionTile(
                        option: opt,
                        isSelected: isSelected,
                        onTap: () => setState(() => _selectedSize = opt.value),
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: PrimaryButton(
              label: 'Siguiente',
              onPressed: _handleNext,
              isEnabled: _selectedSize != null,
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamOption {
  final int value;
  final String label;
  final String subtitle;
  final IconData icon;

  const _TeamOption({
    required this.value,
    required this.label,
    required this.subtitle,
    required this.icon,
  });
}

class _TeamOptionTile extends StatelessWidget {
  final _TeamOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _TeamOptionTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.black : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.black : AppColors.greyMid,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            // Radio
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.white : Colors.transparent,
                border: isSelected
                    ? null
                    : Border.all(color: AppColors.greyMid, width: 2),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.black,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? AppColors.white : AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    option.subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected
                          ? Colors.white.withOpacity(0.65)
                          : AppColors.greyText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              option.icon,
              size: 22,
              color: isSelected ? Colors.white.withOpacity(0.7) : AppColors.greyText,
            ),
          ],
        ),
      ),
    );
  }
}