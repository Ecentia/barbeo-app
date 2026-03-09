import 'package:flutter/material.dart';

class BarberDetailsScreen extends StatefulWidget {
  const BarberDetailsScreen({super.key});

  @override
  State<BarberDetailsScreen> createState() => _BarberDetailsScreenState();
}

class _BarberDetailsScreenState extends State<BarberDetailsScreen> {
  // Variables para guardar el estado de las casillas
  bool _termsAccepted = false;
  bool _promosAccepted = false;
  String _selectedCountryCode = '+34'; // Prefijo por defecto

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context), // Flecha para volver atrás
        ),
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
                    // Título
                    const Text(
                      'Sobre ti',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Subtítulo
                    const Text(
                      'Cuéntanos algo más sobre ti y tu barbería',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Campo: Nombre del negocio
                    _buildTextField(
                      hintText: 'Nombre del negocio',
                    ),
                    const SizedBox(height: 16),

                    // Campo: Tu nombre
                    _buildTextField(
                      hintText: 'Tu nombre',
                    ),
                    const SizedBox(height: 16),

                    // Campo: Teléfono con prefijo
                    _buildPhoneField(),
                    const SizedBox(height: 32),

                    // Checkbox: Términos y condiciones
                    _buildCustomCheckbox(
                      value: _termsAccepted,
                      text: 'Al registrarte, aceptas nuestros Términos y condiciones y confirmas haber leído nuestra Política de privacidad.',
                      onChanged: (val) {
                        setState(() => _termsAccepted = val ?? false);
                      },
                      onTapArrow: () {
                        // TODO: Abrir pantalla de Términos
                        print('Ver términos');
                      },
                    ),
                    const SizedBox(height: 16),

                    // Checkbox: Promociones
                    _buildCustomCheckbox(
                      value: _promosAccepted,
                      text: 'Me gustaría recibir ofertas exclusivas, promociones personalizadas y consejos para mejorar mi barbería.',
                      onChanged: (val) {
                        setState(() => _promosAccepted = val ?? false);
                      },
                      onTapArrow: () {
                        // TODO: Abrir más info de promociones
                        print('Ver info promos');
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            
            // Botón de Siguiente anclado abajo
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56), // Ancho completo, alto 56
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // TODO: Validar datos y pasar a la siguiente pantalla
                  print('Siguiente presionado');
                },
                child: const Text(
                  'Siguiente',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS REUTILIZABLES PARA ESTA PANTALLA ---

  // Método para crear los campos de texto normales
  Widget _buildTextField({required String hintText}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        filled: true,
        fillColor: Colors.grey.shade100, // Fondo gris clarito
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none, // Sin borde
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
    );
  }

  // Método para el campo de teléfono con selector de prefijo
  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Selector de país (Falso/Visual de momento)
          InkWell(
            onTap: () {
              // TODO: Mostrar lista de países
            },
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
              child: Row(
                children: [
                  Text(
                    _selectedCountryCode,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                ],
              ),
            ),
          ),
          // Línea separadora
          Container(
            height: 24,
            width: 1,
            color: Colors.grey.shade300,
          ),
          // Input del número
          Expanded(
            child: TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Teléfono',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Método para crear los Checkboxes con texto y flecha
 // Método para crear los Checkboxes con texto y flecha
  Widget _buildCustomCheckbox({
    required bool value,
    required String text,
    required Function(bool?) onChanged,
    required VoidCallback onTapArrow,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // AQUÍ ESTABA EL ERROR: Cambiamos BorderSide por Border.all
        border: Border.all(color: Colors.grey.shade200), 
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: onTapArrow,
            child: const Padding(
              padding: EdgeInsets.only(top: 2.0),
              child: Icon(Icons.chevron_right, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
  
}