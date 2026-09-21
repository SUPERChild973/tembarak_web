import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PetaPage extends StatefulWidget {
  final String currentPage;
  final Function(String) onNavigate;

  const PetaPage({
    super.key,
    required this.currentPage,
    required this.onNavigate,
  });

  @override
  State<PetaPage> createState() => _PetaPageState();
}

class _PetaPageState extends State<PetaPage> {
  final MapController _mapController = MapController();

  // ============================================================
  // GANTI KOORDINAT INI DENGAN KOORDINAT ASLI DESA TEMBARAK
  // ============================================================
  static const LatLng _lokasiDesa = LatLng(
    -7.6072,
    112.1033,
  );

  static const double _zoomAwal = 14.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8FAF8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double lebar = constraints.maxWidth;

          // Tinggi peta dibuat responsif.
          double tinggiPeta;

          if (lebar < 600) {
            // HP
            tinggiPeta = 420;
          } else if (lebar < 1000) {
            // Tablet
            tinggiPeta = 500;
          } else {
            // Desktop
            tinggiPeta = 620;
          }

          return Padding(
            padding: EdgeInsets.all(
              lebar < 600 ? 12 : 24,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                lebar < 600 ? 12 : 16,
              ),
              child: SizedBox(
                width: double.infinity,
                height: tinggiPeta,
                child: Stack(
                  children: [
                    // ==================================================
                    // PETA SATELIT
                    // ==================================================
                    FlutterMap(
                      mapController: _mapController,
                      options: const MapOptions(
                        initialCenter: _lokasiDesa,
                        initialZoom: _zoomAwal,
                        minZoom: 5,
                        maxZoom: 19,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://server.arcgisonline.com/ArcGIS/rest/services/'
                              'World_Imagery/MapServer/tile/{z}/{y}/{x}',
                          userAgentPackageName: 'com.tembarak.web',
                          maxZoom: 19,
                        ),

                        // ==================================================
                        // MARKER DESA TEMBARAK
                        // ==================================================
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _lokasiDesa,
                              width: 60,
                              height: 70,
                              child: GestureDetector(
                                onTap: () {
                                  _showLokasiDesa(context);
                                },
                                child: const Icon(
                                  Icons.location_on,
                                  size: 58,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // ==================================================
                    // LABEL SATELLITE
                    // ==================================================
                    Positioned(
                      left: 16,
                      bottom: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.satellite_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Satellite',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ==================================================
                    // KONTROL ZOOM
                    // ==================================================
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: Column(
                        children: [
                          _MapButton(
                            icon: Icons.add,
                            onPressed: () {
                              _mapController.move(
                                _mapController.camera.center,
                                _mapController.camera.zoom + 1,
                              );
                            },
                          ),
                          const SizedBox(height: 6),
                          _MapButton(
                            icon: Icons.remove,
                            onPressed: () {
                              _mapController.move(
                                _mapController.camera.center,
                                _mapController.camera.zoom - 1,
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // ==================================================
                    // TOMBOL KEMBALI KE LOKASI DESA
                    // ==================================================
                    Positioned(
                      right: 16,
                      top: 16,
                      child: _MapButton(
                        icon: Icons.my_location,
                        onPressed: () {
                          _mapController.move(
                            _lokasiDesa,
                            _zoomAwal,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showLokasiDesa(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Desa Tembarak',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Lokasi Desa Tembarak pada peta.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}

// ================================================================
// BUTTON PETA
// ================================================================
class _MapButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _MapButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 3,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(
            icon,
            color: const Color(0xFF333333),
            size: 22,
          ),
        ),
      ),
    );
  }
}