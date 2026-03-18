import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────────
// BARRA DE PROGRESO SUPERIOR
// ─────────────────────────────────────────────
class OnboardingProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const OnboardingProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: List.generate(totalSteps, (index) {
          final isCompleted = index < currentStep;
          final isCurrent = index == currentStep - 1;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 3,
              margin: EdgeInsets.only(right: index < totalSteps - 1 ? 4 : 0),
              decoration: BoxDecoration(
                color: isCompleted || isCurrent ? AppColors.black : AppColors.greyMid,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BOTÓN PRIMARIO
// ─────────────────────────────────────────────
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final canPress = isEnabled && !isLoading && onPressed != null;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: canPress ? 1.0 : 0.5,
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.black,
            foregroundColor: AppColors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: canPress ? onPressed : null,
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
              : Text(label, style: AppTextStyles.buttonText),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CAMPO DE TEXTO CON VALIDACIÓN
// ─────────────────────────────────────────────
class AppTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final String? labelText;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction textInputAction;

  const AppTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.labelText,
    this.focusNode,
    this.onChanged,
    this.onFieldSubmitted,
    this.textInputAction = TextInputAction.next,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  String? _errorText;
  bool _hasInteracted = false;

  void _validate(String value) {
    if (_hasInteracted && widget.validator != null) {
      setState(() => _errorText = widget.validator!(value));
    }
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(widget.labelText!, style: AppTextStyles.label),
          const SizedBox(height: 6),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          obscureText: widget.obscureText,
          maxLength: widget.maxLength,
          textCapitalization: widget.textCapitalization,
          textInputAction: widget.textInputAction,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.black,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: _errorText != null
                ? const Icon(Icons.error_outline, color: AppColors.error, size: 18)
                : widget.suffixIcon,
            counterText: '',
            errorText: _errorText,
            errorMaxLines: 2,
          ),
          onChanged: _validate,
          onTap: () => setState(() => _hasInteracted = true),
          onFieldSubmitted: widget.onFieldSubmitted,
          validator: widget.validator,
        ),
      ],
    );
  }

  String? validate() {
    setState(() {
      _hasInteracted = true;
      _errorText = widget.validator?.call(widget.controller.text);
    });
    return _errorText;
  }
}

// ─────────────────────────────────────────────
// DIVIDER CON ETIQUETA
// ─────────────────────────────────────────────
class LabeledDivider extends StatelessWidget {
  final String label;
  const LabeledDivider({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.greyMid, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(label, style: AppTextStyles.caption),
        ),
        Expanded(child: Divider(color: AppColors.greyMid, thickness: 1)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// CHIP DE SELECCIÓN
// ─────────────────────────────────────────────
class SelectionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectionChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.black : AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.black : AppColors.greyMid,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SNACKBAR DE ERROR / ÉXITO
// ─────────────────────────────────────────────
void showAppSnackBar(
  BuildContext context,
  String message, {
  bool isError = true,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: isError ? AppColors.error : AppColors.success,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: isError ? AppColors.error : AppColors.success,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: isError ? AppColors.errorLight : AppColors.successLight,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      duration: const Duration(seconds: 3),
    ),
  );
}

// ─────────────────────────────────────────────
// APPBAR ESTÁNDAR DE ONBOARDING
// ─────────────────────────────────────────────
class OnboardingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBack;
  final int currentStep;
  final int totalSteps;

  const OnboardingAppBar({
    super.key,
    this.onBack,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.black, size: 22),
            onPressed: onBack ?? () => Navigator.pop(context),
          ),
        ),
        OnboardingProgressBar(currentStep: currentStep, totalSteps: totalSteps),
      ],
    );
  }
}