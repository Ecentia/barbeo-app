import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/validators/app_validators.dart';
import '../../../shared/widgets/shared_widgets.dart';
import '../models/barber_onboarding_data.dart';
import 'barber_map_confirm_screen.dart';

class BarberStreetNumberScreen extends StatefulWidget {
  final BarberOnboardingData data;

  const BarberStreetNumberScreen({super.key, required this.data});

  @override
  State<BarberStreetNumberScreen> createState() => _BarberStreetNumberScreenState();
}

class _BarberStreetNumberScreenState extends State<BarberStreetNumberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _numberFocus = FocusNode();
  final _apartmentFocus = FocusNode();

  @override
  void dispose() {
    _numberController.dispose();
    _apartmentController.dispose();
    _numberFocus.dispose();
    _apartmentFocus.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      showAppSnackBar(context, 'Por favor, corrige los errores marcados.');
      return;
    }

    widget.data.streetNumber = _numberController.text.trim();
    widget.data.apartment = _apartmentController.text.trim();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BarberMapConfirmScreen(data: widget.data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: OnboardingAppBar(currentStep: 3, totalSteps: 7),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Dirección base seleccionada (solo lectura)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.greyLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              color: AppColors.greyText, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.data.street,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.greyText,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    const Text('¿Cuál es el número?', style: AppTextStyles.headline1),
                    const SizedBox(height: 8),
                    const Text(
                      'Añade el número y, si quieres, el piso o local.',
                      style: AppTextStyles.bodyMuted,
                    ),
                    const SizedBox(height: 32),

                    // Número de calle
                    _buildLabel('Número *'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _numberController,
                      focusNode: _numberFocus,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z/\-]')),
                        LengthLimitingTextInputFormatter(10),
                        _UpperCaseTextFormatter(),
                      ],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.black,
                        letterSpacing: 2,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Ej: 100, 12A, S/N',
                        hintStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.greySubtext,
                          letterSpacing: 2,
                        ),
                        counterText: '',
                        errorMaxLines: 2,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: AppValidators.validateStreetNumber,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_apartmentFocus),
                    ),
                    const SizedBox(height: 24),

                    // Apartamento / piso (opcional)
                    _buildLabel('Piso, puerta, local (opcional)'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _apartmentController,
                      focusNode: _apartmentFocus,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [LengthLimitingTextInputFormatter(30)],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Ej: 2ºB, Local 3, Bajo izquierda',
                        counterText: '',
                        errorMaxLines: 2,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: AppValidators.validateApartment,
                    ),

                    const SizedBox(height: 32),

                    // Dirección completa (preview)
                    _buildAddressPreview(),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: PrimaryButton(label: 'Siguiente', onPressed: _handleNext),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.greyText,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildAddressPreview() {
    return AnimatedBuilder(
      animation: Listenable.merge([_numberController, _apartmentController]),
      builder: (_, __) {
        final number = _numberController.text.trim();
        final apt = _apartmentController.text.trim();
        if (number.isEmpty) return const SizedBox.shrink();

        final fullAddress = [
          widget.data.street,
          if (number.isNotEmpty) number,
          if (apt.isNotEmpty) apt,
        ].join(', ');

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.white, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  fullAddress,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue old, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}