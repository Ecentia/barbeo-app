import 'package:flutter/material.dart';
import 'barber_location_screen.dart';

class BarberWelcomeScreen extends StatefulWidget {
  const BarberWelcomeScreen({super.key});

  @override
  State<BarberWelcomeScreen> createState() => _BarberWelcomeScreenState();
}

class _BarberWelcomeScreenState extends State<BarberWelcomeScreen> {
  bool _termsAccepted = false;
  bool _promosAccepted = false;
  String _selectedCountryCode = '+34'; 

  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final List<Map<String, String>> _countries = [
    {'name': 'España', 'code': '+34', 'iso': 'ES'},
    {'name': 'México', 'code': '+52', 'iso': 'MX'},
    {'name': 'Colombia', 'code': '+57', 'iso': 'CO'},
    {'name': 'Argentina', 'code': '+54', 'iso': 'AR'},
    {'name': 'Chile', 'code': '+56', 'iso': 'CL'},
    {'name': 'Perú', 'code': '+51', 'iso': 'PE'},
    {'name': 'Estados Unidos', 'code': '+1', 'iso': 'US'},
  ];

  @override
  void dispose() {
    _businessNameController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true, 
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6, maxChildSize: 0.9, minChildSize: 0.4, expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 12),
                Container(height: 5, width: 50, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10))),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
                  child: Align(alignment: Alignment.centerLeft, child: Text('País o región', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black))),
                ),
                Divider(color: Colors.grey.shade100, height: 1),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: _countries.length,
                    separatorBuilder: (context, index) => Divider(color: Colors.grey.shade100, height: 1),
                    itemBuilder: (context, index) {
                      final country = _countries[index];
                      final isSelected = country['code'] == _selectedCountryCode;
                      return InkWell(
                        onTap: () {
                          setState(() { _selectedCountryCode = country['code']!; });
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                          child: Row(
                            children: [
                              Container(
                                width: 36, height: 24, alignment: Alignment.center,
                                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.grey.shade200)),
                                child: Text(country['iso']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(child: Text(country['name']!, style: TextStyle(fontSize: 16, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.black : Colors.black87))),
                              Row(
                                children: [
                                  Text(country['code']!, style: TextStyle(fontSize: 16, fontWeight: isSelected ? FontWeight.bold : FontWeight.w600, color: isSelected ? Colors.black : Colors.black54)),
                                  if (isSelected) ...[const SizedBox(width: 12), const Icon(Icons.check_circle, color: Colors.black, size: 20)],
                                ],
                              ),
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
      },
    );
  }

  // --- FUNCIÓN PARA MOSTRAR AVISOS DE ERROR ---
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text('Sobre ti', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.black)),
                    const SizedBox(height: 8),
                    const Text('Cuéntanos algo más sobre ti y tu barbería', style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 32),

                    _buildTextField(hintText: 'Nombre del negocio', controller: _businessNameController),
                    const SizedBox(height: 16),
                    _buildTextField(hintText: 'Tu nombre', controller: _nameController),
                    const SizedBox(height: 16),
                    _buildPhoneField(),
                    const SizedBox(height: 32),

                    _buildCustomCheckbox(
                      value: _termsAccepted,
                      text: 'Al registrarte, aceptas nuestros Términos y condiciones y confirmas haber leído nuestra Política de privacidad.',
                      onChanged: (val) { setState(() => _termsAccepted = val ?? false); },
                      onTapArrow: () => print('Ver términos'),
                    ),
                    const SizedBox(height: 16),
                    _buildCustomCheckbox(
                      value: _promosAccepted,
                      text: 'Me gustaría recibir ofertas exclusivas, promociones personalizadas y consejos para mejorar mi barbería.',
                      onChanged: (val) { setState(() => _promosAccepted = val ?? false); },
                      onTapArrow: () => print('Ver info promos'),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            
            // BOTÓN DE SIGUIENTE CON TODAS LAS VALIDACIONES
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 56), elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  String businessName = _businessNameController.text.trim();
                  String userName = _nameController.text.trim();
                  String phone = _phoneController.text.trim();

                  // 1. Nombres no vacíos
                  if (businessName.isEmpty || userName.isEmpty) {
                    _showError('Por favor, introduce tu nombre y el del negocio.');
                    return;
                  }

                  // 2. Validar que el teléfono solo tenga números y longitud correcta (8 a 15)
                  final phoneRegex = RegExp(r'^[0-9]{8,15}$');
                  if (!phoneRegex.hasMatch(phone)) {
                    _showError('Introduce un número de teléfono válido.');
                    return;
                  }

                  // 3. Aceptar términos es OBLIGATORIO
                  if (!_termsAccepted) {
                    _showError('Debes aceptar los Términos y Condiciones para continuar.');
                    return;
                  }

                  // Si todo está perfecto, pasamos a la siguiente pantalla
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BarberLocationScreen(userName: userName)),
                  );
                },
                child: const Text('Siguiente', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String hintText, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText, hintStyle: TextStyle(color: Colors.grey.shade500),
        filled: true, fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _showCountryPicker, borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
                child: Row(
                  children: [
                    Text(_selectedCountryCode, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                  ],
                ),
              ),
            ),
          ),
          Container(height: 24, width: 1, color: Colors.grey.shade300),
          Expanded(
            child: TextField(
              controller: _phoneController, 
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Teléfono', hintStyle: TextStyle(color: Colors.grey.shade500),
                border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomCheckbox({
    required bool value, required String text, required Function(bool?) onChanged, required VoidCallback onTapArrow,
  }) {
    return Container(
      padding: const EdgeInsets.all(12), decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24, width: 24, child: Checkbox(value: value, onChanged: onChanged, activeColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)))),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4))),
          const SizedBox(width: 8),
          InkWell(onTap: onTapArrow, child: const Padding(padding: EdgeInsets.only(top: 2.0), child: Icon(Icons.chevron_right, color: Colors.black54))),
        ],
      ),
    );
  }
}