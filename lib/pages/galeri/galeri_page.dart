import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class GaleriPage extends StatelessWidget {
  const GaleriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _headerSection(),
          _gallerySection(),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _headerSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 60,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D3B13),
            AppTheme.primary,
            AppTheme.primaryLight,
          ],
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.photo_library,
            color: Colors.white,
            size: 60,
          ),
          SizedBox(height: 20),
          Text(
            'Galeri Kegiatan Desa',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Dokumentasi kegiatan masyarakat Desa Tembarak',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // GALLERY
  // ============================================================

  Widget _gallerySection() {
    final activities = [
      {
        'title': 'Gotong Royong Desa',
        'date': '10 September 2026',
        'description':
            'Kegiatan gotong royong membersihkan lingkungan desa.',
        'icon': Icons.cleaning_services,
      },
      {
        'title': 'Kegiatan Posyandu',
        'date': '7 September 2026',
        'description':
            'Kegiatan pelayanan kesehatan masyarakat melalui Posyandu.',
        'icon': Icons.health_and_safety,
      },
      {
        'title': 'Musyawarah Desa',
        'date': '5 September 2026',
        'description':
            'Musyawarah bersama masyarakat membahas pembangunan desa.',
        'icon': Icons.groups,
      },
      {
        'title': 'Pelatihan UMKM',
        'date': '2 September 2026',
        'description':
            'Pelatihan untuk meningkatkan kemampuan pelaku UMKM desa.',
        'icon': Icons.storefront,
      },
      {
        'title': 'Kegiatan Karang Taruna',
        'date': '30 Agustus 2026',
        'description':
            'Kegiatan kepemudaan dan pemberdayaan generasi muda desa.',
        'icon': Icons.diversity_3,
      },
      {
        'title': 'Kegiatan Desa',
        'date': '25 Agustus 2026',
        'description':
            'Dokumentasi kegiatan masyarakat Desa Tembarak.',
        'icon': Icons.celebration,
      },
      {
        'title': 'Penanaman Pohon',
        'date': '20 Agustus 2026',
        'description':
            'Kegiatan penghijauan dan menjaga kelestarian lingkungan desa.',
        'icon': Icons.park,
      },
      {
        'title': 'Kegiatan PKK',
        'date': '18 Agustus 2026',
        'description':
            'Kegiatan pemberdayaan dan pembinaan keluarga masyarakat desa.',
        'icon': Icons.family_restroom,
      },
    ];

    return Container(
      width: double.infinity,
      color: AppTheme.background,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 60,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1150,
          ),
          child: Column(
            children: [
              const Text(
                'Dokumentasi Kegiatan',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Berbagai kegiatan masyarakat Desa Tembarak',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 40),

              Wrap(
                spacing: 22,
                runSpacing: 22,
                alignment: WrapAlignment.center,
                children: activities.map((item) {
                  return _galleryCard(
                    title: item['title'] as String,
                    date: item['date'] as String,
                    description: item['description'] as String,
                    icon: item['icon'] as IconData,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // GALLERY CARD
  // ============================================================

  Widget _galleryCard({
    required String title,
    required String date,
    required String description,
    required IconData icon,
  }) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====================================================
          // TEMPAT FOTO
          // ====================================================

          Container(
            width: double.infinity,
            height: 220,
            decoration: const BoxDecoration(
              color: AppTheme.lightGreen,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(22),
              ),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.photo,
                    color: AppTheme.primary,
                    size: 75,
                  ),
                ),

                Positioned(
                  top: 15,
                  right: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Foto',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ====================================================
          // CONTENT
          // ====================================================

          Padding(
            padding: const EdgeInsets.all(23),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: AppTheme.primary,
                      size: 20,
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        date,
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}