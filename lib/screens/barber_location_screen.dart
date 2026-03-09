import 'package:flutter/material.dart';
import 'barber_address_screen.dart'; // Importamos la nueva pantalla de dirección

class BarberLocationScreen extends StatefulWidget {
  final String userName;

  const BarberLocationScreen({super.key, required this.userName});

  @override
  State<BarberLocationScreen> createState() => _BarberLocationScreenState();
}

class _BarberLocationScreenState extends State<BarberLocationScreen> {
  bool _inShop = false;
  bool _atHome = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
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
                    Text(
                      '¿Dónde cortas, ${widget.userName}?',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '¿Dónde vas a ofrecer tus servicios? Puedes elegir ambas opciones.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 40),

                    _buildLocationOption(
                      title: 'En mi local',
                      subtitle: 'Los clientes vendrán a tu barbería',
                      icon: Icons.storefront_outlined,
                      isSelected: _inShop,
                      onTap: () { setState(() { _inShop = !_inShop; }); },
                    ),
                    const SizedBox(height: 16),

                    _buildLocationOption(
                      title: 'A domicilio',
                      subtitle: 'Tú te desplazas donde esté el cliente',
                      icon: Icons.home_repair_service_outlined,
                      isSelected: _atHome,
                      onTap: () { setState(() { _atHome = !_atHome; }); },
                    ),
                  ],
                ),
              ),
            ),
            
            // BOTÓN SIGUIENTE CON LA LÓGICA DE BIFURCACIÓN
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  // 1. Validar que al menos una opción esté marcada
                  if (!_inShop && !_atHome) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor, selecciona al menos una opción'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }
                  
                  // 2. Si ha marcado "En mi local" (aunque también haya marcado domicilio)
                  // -> Le pedimos la dirección
                  if (_inShop) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BarberAddressScreen(userName: widget.userName),
                      ),
                    );
                  } 
                  // 3. Si SOLO ha marcado "A domicilio"
                  // -> Nos saltamos la dirección y pasamos a lo siguiente
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Solo a domicilio: Saltando la dirección...'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    // TODO: Aquí pondremos el Navigator.push a la pantalla de fotos o servicios
                  }
                },
                child: const Text('Siguiente', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationOption({
    required String title, 
    required String subtitle, 
    required IconData icon, 
    required bool isSelected, 
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Colors.black),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                ],
              ),
            ),
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.black : Colors.transparent,
                border: isSelected ? null : Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }
}