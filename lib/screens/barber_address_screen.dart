import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class BarberAddressScreen extends StatefulWidget {
  final String userName;

  const BarberAddressScreen({super.key, required this.userName});

  @override
  State<BarberAddressScreen> createState() => _BarberAddressScreenState();
}

class _BarberAddressScreenState extends State<BarberAddressScreen> {
  final TextEditingController _addressController = TextEditingController();
  
  // Lista para guardar los resultados de la API
  List<String> _suggestions = [];
  bool _isLoading = false;
  
  // El temporizador para no saturar la API al escribir rápido
  Timer? _debounce;

  @override
  void dispose() {
    _addressController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // Función que llama a la API gratuita de OpenStreetMap
  Future<void> _searchAddress(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _suggestions = [];
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);

    // Endpoint de Nominatim (OpenStreetMap)
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=5');

    try {
      final response = await http.get(url, headers: {
        // A Nominatim le gusta saber quién hace la petición
        'User-Agent': 'BarbeoApp/1.0', 
      });

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          // Extraemos el nombre de las direcciones encontradas
          _suggestions = data.map((e) => e['display_name'].toString()).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error buscando dirección: $e');
      setState(() => _isLoading = false);
    }
  }

  // Se ejecuta cada vez que el usuario escribe una letra
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      _searchAddress(query);
    });
  }

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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      '¿Dónde está tu barbería?',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Busca la calle o el código postal para que los clientes puedan encontrarte.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // CAMPO DE BÚSQUEDA
                    TextField(
                      controller: _addressController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Ej: Calle Mayor 12, Madrid',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        prefixIcon: const Icon(Icons.location_on_outlined, color: Colors.black54),
                        // Mostramos un circulito de carga si está buscando
                        suffixIcon: _isLoading 
                            ? const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // LISTA DE RESULTADOS
                    Expanded(
                      child: ListView.builder(
                        itemCount: _suggestions.length,
                        itemBuilder: (context, index) {
                          final suggestion = _suggestions[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.location_on, color: Colors.black87, size: 20),
                            ),
                            title: Text(
                              suggestion,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              // Al tocar una dirección, rellenamos el input y limpiamos la lista
                              setState(() {
                                _addressController.text = suggestion;
                                _suggestions = [];
                                // Ponemos el cursor al final del texto
                                _addressController.selection = TextSelection.fromPosition(
                                  TextPosition(offset: _addressController.text.length),
                                );
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // BOTÓN SIGUIENTE
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
                  if (_addressController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor, selecciona una dirección'), backgroundColor: Colors.redAccent),
                    );
                    return;
                  }
                  print('Dirección seleccionada: ${_addressController.text}');
                  // TODO: Siguiente pantalla
                },
                child: const Text('Siguiente', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}