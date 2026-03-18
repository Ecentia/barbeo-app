import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/validators/app_validators.dart';
import '../../../shared/widgets/shared_widgets.dart';
import '../models/barber_onboarding_data.dart';
import 'barber_location_screen.dart';

class BarberWelcomeScreen extends StatefulWidget {
  const BarberWelcomeScreen({super.key});

  @override
  State<BarberWelcomeScreen> createState() => _BarberWelcomeScreenState();
}

class _BarberWelcomeScreenState extends State<BarberWelcomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _businessFocus = FocusNode();
  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();

  bool _termsAccepted = false;
  bool _promosAccepted = false;
  bool _termsError = false;
  String _selectedCountryCode = '+34';

  final List<Map<String, String>> _countries = [
    {'name': 'España', 'code': '+34', 'iso': 'ES', 'flag': '🇪🇸'},
    {'name': 'México', 'code': '+52', 'iso': 'MX', 'flag': '🇲🇽'},
    {'name': 'Colombia', 'code': '+57', 'iso': 'CO', 'flag': '🇨🇴'},
    {'name': 'Argentina', 'code': '+54', 'iso': 'AR', 'flag': '🇦🇷'},
    {'name': 'Chile', 'code': '+56', 'iso': 'CL', 'flag': '🇨🇱'},
    {'name': 'Perú', 'code': '+51', 'iso': 'PE', 'flag': '🇵🇪'},
    {'name': 'Estados Unidos', 'code': '+1', 'iso': 'US', 'flag': '🇺🇸'},
  ];

  @override
  void dispose() {
    _businessNameController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _businessFocus.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => _CountryPickerSheet(
        countries: _countries,
        selectedCode: _selectedCountryCode,
        onSelect: (code) {
          setState(() => _selectedCountryCode = code);
          // Revalidar teléfono al cambiar de país
          _phoneController.notifyListeners();
        },
      ),
    );
  }

  void _handleNext() {
    // Forzar validación del form
    final formValid = _formKey.currentState?.validate() ?? false;

    // Validar términos por separado
    setState(() => _termsError = !_termsAccepted);

    if (!formValid || !_termsAccepted) {
      if (!formValid) {
        showAppSnackBar(context, 'Por favor, corrige los errores antes de continuar.');
      } else if (!_termsAccepted) {
        showAppSnackBar(context, 'Debes aceptar los Términos y Condiciones para continuar.');
      }
      return;
    }

    final data = BarberOnboardingData(
      businessName: _businessNameController.text.trim(),
      ownerName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      countryCode: _selectedCountryCode,
      termsAccepted: _termsAccepted,
      promosAccepted: _promosAccepted,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BarberLocationScreen(data: data)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: OnboardingAppBar(currentStep: 1, totalSteps: 7),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    const Text('Sobre ti', style: AppTextStyles.headline1),
                    const SizedBox(height: 8),
                    const Text(
                      'Cuéntanos algo más sobre ti y tu barbería.',
                      style: AppTextStyles.bodyMuted,
                    ),
                    const SizedBox(height: 32),

                    // Nombre del negocio
                    _buildFormField(
                      hintText: 'Nombre del negocio',
                      controller: _businessNameController,
                      focusNode: _businessFocus,
                      nextFocus: _nameFocus,
                      validator: AppValidators.validateBusinessName,
                      textCapitalization: TextCapitalization.words,
                      maxLength: 80,
                      prefixIcon: const Icon(Icons.storefront_outlined,
                          color: AppColors.greyText, size: 20),
                    ),
                    const SizedBox(height: 14),

                    // Tu nombre
                    _buildFormField(
                      hintText: 'Tu nombre completo',
                      controller: _nameController,
                      focusNode: _nameFocus,
                      nextFocus: _phoneFocus,
                      validator: (v) =>
                          AppValidators.validateName(v, fieldName: 'Tu nombre'),
                      textCapitalization: TextCapitalization.words,
                      maxLength: 60,
                      prefixIcon: const Icon(Icons.person_outline,
                          color: AppColors.greyText, size: 20),
                    ),
                    const SizedBox(height: 14),

                    // Teléfono
                    _buildPhoneField(),
                    const SizedBox(height: 28),

                    // Checkbox términos
                    _buildCheckbox(
                      value: _termsAccepted,
                      hasError: _termsError,
                      text:
                          'Al registrarte, aceptas nuestros Términos y condiciones y confirmas haber leído nuestra Política de privacidad.',
                      onChanged: (val) {
                        setState(() {
                          _termsAccepted = val ?? false;
                          _termsError = !_termsAccepted;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // Checkbox promos
                    _buildCheckbox(
                      value: _promosAccepted,
                      hasError: false,
                      text:
                          'Me gustaría recibir ofertas exclusivas y consejos para mejorar mi barbería. (Opcional)',
                      onChanged: (val) =>
                          setState(() => _promosAccepted = val ?? false),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: PrimaryButton(label: 'Siguiente', onPressed: _handleNext),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String hintText,
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocus,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    int? maxLength,
    Widget? prefixIcon,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      textInputAction:
          nextFocus != null ? TextInputAction.next : TextInputAction.done,
      style: const TextStyle(
        fontSize: 15,
        color: AppColors.black,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        counterText: '',
        errorMaxLines: 2,
      ),
      onFieldSubmitted: (_) {
        if (nextFocus != null) FocusScope.of(context).requestFocus(nextFocus);
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.transparent),
          ),
          child: Row(
            children: [
              // Selector de país
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _showCountryPicker,
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 17),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _countries.firstWhere(
                              (c) => c['code'] == _selectedCountryCode,
                              orElse: () => _countries.first)['flag']!,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _selectedCountryCode,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 2),
                        const Icon(Icons.keyboard_arrow_down,
                            color: AppColors.greyText, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
              // Divisor
              Container(height: 26, width: 1, color: AppColors.greyMid),
              // Input número
              Expanded(
                child: TextFormField(
                  controller: _phoneController,
                  focusNode: _phoneFocus,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                  decoration: const InputDecoration(
                    hintText: 'Número de teléfono',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    fillColor: Colors.transparent,
                    filled: false,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 14, vertical: 17),
                    counterText: '',
                    errorStyle: TextStyle(height: 0, fontSize: 0),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (v) =>
                      AppValidators.validatePhone(v, _selectedCountryCode),
                ),
              ),
            ],
          ),
        ),
        // Error de teléfono por fuera del container
        Builder(builder: (context) {
          final error = AppValidators.validatePhone(
              _phoneController.text, _selectedCountryCode);
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildCheckbox({
    required bool value,
    required bool hasError,
    required String text,
    required Function(bool?) onChanged,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasError ? AppColors.error : AppColors.greyMid,
          width: hasError ? 1.5 : 1,
        ),
        color: hasError
            ? AppColors.error.withOpacity(0.03)
            : AppColors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.black,
              side: BorderSide(
                color: hasError ? AppColors.error : AppColors.greyMid,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.black,
                  height: 1.5,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BOTTOM SHEET SELECTOR DE PAÍS
// ─────────────────────────────────────────────
class _CountryPickerSheet extends StatelessWidget {
  final List<Map<String, String>> countries;
  final String selectedCode;
  final void Function(String) onSelect;

  const _CountryPickerSheet({
    required this.countries,
    required this.selectedCode,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            const SizedBox(height: 12),
            Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.greyMid,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('País o región', style: AppTextStyles.headline2),
              ),
            ),
            const Divider(height: 1, color: AppColors.greyLight),
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                itemCount: countries.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: AppColors.greyLight),
                itemBuilder: (ctx, i) {
                  final c = countries[i];
                  final isSel = c['code'] == selectedCode;
                  return InkWell(
                    onTap: () {
                      onSelect(c['code']!);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      child: Row(
                        children: [
                          Text(c['flag']!,
                              style: const TextStyle(fontSize: 22)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              c['name']!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSel
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          Text(
                            c['code']!,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isSel
                                  ? AppColors.black
                                  : AppColors.greyText,
                            ),
                          ),
                          if (isSel) ...[
                            const SizedBox(width: 10),
                            const Icon(Icons.check_circle,
                                color: AppColors.black, size: 18),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}