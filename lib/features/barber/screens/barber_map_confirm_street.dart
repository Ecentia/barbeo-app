import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/shared_widgets.dart';
import '../models/barber_onboarding_data.dart';
import 'barber_team_size_screen.dart';

/// Pantalla de confirmación de ubicación en mapa.
/// Muestra el mapa estático de OpenStreetMap con un pin ajustable.
/// Para mapa interactivo real se integraría flutter_map o google_maps_flutter.
class BarberMapConfirmScreen extends StatefulWidget {
  final BarberOnboardingData data;

  const BarberMapConfirmScreen({super.key, required this.data});

  @override
  State<BarberMapConfirmScreen> createState() => _BarberMapConfirmScreenState();
}

class _BarberMapConfirmScreenState extends State<BarberMapConfirmScreen> {
  bool _showTip = true;
  final _apartmentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _apartmentController.text = widget.data.apartment;
    // Auto-ocultar el tip después de 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showTip = false);
    });
  }

  @override
  void dispose() {
    _apartmentController.dispose();
    super.dispose();
  }

  String get _fullAddress {
    return [
      widget.data.street,
      widget.data.streetNumber,
    ].where((s) => s.isNotEmpty).join(', ');
  }

  String get _cityPostal {
    // Extraemos ciudad/código de la dirección guardada si la tenemos
    return 'Sevilla, España';
  }

  void _handleContinue() {
    widget.data.apartment = _apartmentController.text.trim();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BarberTeamSizeScreen(data: widget.data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // ── HEADER ──────────────────────────────────
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: AppColors.black, size: 22),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                OnboardingProgressBar(currentStep: 3, totalSteps: 7),
              ],
            ),
          ),

          // ── DIRECCIÓN + EDITAR ──────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Confirmar ubicación', style: AppTextStyles.headline2),
                      const SizedBox(height: 4),
                      Text(
                        _fullAddress,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.greyText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: AppColors.black, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // ── MAPA SIMULADO ────────────────────────────
          Expanded(
            child: Stack(
              children: [
                // Mapa estático de OpenStreetMap
                _StaticMap(
                  lat: widget.data.latitude ?? 37.3841,
                  lon: widget.data.longitude ?? -5.9913,
                ),

                // PIN central
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(Icons.storefront, color: AppColors.white, size: 22),
                      ),
                      // Sombra del pin
                      Container(
                        width: 12, height: 6,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          color: AppColors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ),

                // TIP "Mueve el mapa"
                if (_showTip)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: AnimatedOpacity(
                      opacity: _showTip ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.black.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.touch_app, color: AppColors.white, size: 16),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Mueve el mapa para ajustar el marcador',
                                style: TextStyle(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => _showTip = false),
                              child: const Icon(Icons.close, color: AppColors.white, size: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── PANEL INFERIOR ────────────────────────────
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Añadir más detalles',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.black),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _apartmentController,
                  decoration: const InputDecoration(
                    hintText: 'Apartamento, suite o local (opcional)',
                  ),
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                PrimaryButton(label: 'Continuar', onPressed: _handleContinue),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget que muestra un mapa estático via OpenStreetMap/Staticmap.
/// Para producción se usa flutter_map o google_maps_flutter.
class _StaticMap extends StatelessWidget {
  final double lat;
  final double lon;
  const _StaticMap({required this.lat, required this.lon});

  @override
  Widget build(BuildContext context) {
    // Usamos la API gratuita de staticmap de OpenStreetMap (sin key)
    final url =
        'https://staticmap.openstreetmap.de/staticmap.php'
        '?center=$lat,$lon&zoom=17&size=600x400&maptype=mapnik';

    return Container(
      color: const Color(0xFFE8E0D8), // fallback color similar al mapa
      child: Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => _MapPlaceholder(lat: lat, lon: lon),
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.black,
            ),
          );
        },
      ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  final double lat;
  final double lon;
  const _MapPlaceholder({required this.lat, required this.lon});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE8E0D8),
      child: CustomPaint(
        painter: _GridPainter(),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.map_outlined, size: 40, color: Colors.grey.shade400),
              const SizedBox(height: 8),
              Text(
                '${lat.toStringAsFixed(4)}, ${lon.toStringAsFixed(4)}',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4C8BC)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // "Calles" simuladas
    final streetPaint = Paint()..color = Colors.white..strokeWidth = 8;
    canvas.drawLine(
        Offset(0, size.height * 0.4), Offset(size.width, size.height * 0.4), streetPaint);
    canvas.drawLine(
        Offset(size.width * 0.45, 0), Offset(size.width * 0.45, size.height), streetPaint);
    canvas.drawLine(
        Offset(0, size.height * 0.7), Offset(size.width, size.height * 0.7), streetPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}