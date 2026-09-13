import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class BeritaPage extends StatelessWidget {
  const BeritaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _headerSection(),
          _newsSection(),
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
            Icons.newspaper,
            color: Colors.white,
            size: 60,
          ),
          SizedBox(height: 20),
          Text(
            'Berita & Informasi',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Informasi terbaru seputar Desa Tembarak',
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
  // NEWS SECTION
  // ============================================================

  Widget _newsSection() {
    final news = [
      {
        'title': 'Gotong Royong Membersihkan Lingkungan Desa',
        'date': '10 September 2026',
        'category': 'Kegiatan Desa',
        'description':
            'Masyarakat Desa Tembarak melaksanakan kegiatan gotong royong '
            'untuk membersihkan lingkungan dan fasilitas umum desa.',
        'icon': Icons.cleaning_services,
      },
      {
        'title': 'Pelatihan UMKM Desa',
        'date': '7 September 2026',
        'category': 'UMKM',
        'description':
            'Kegiatan pelatihan UMKM dilaksanakan untuk meningkatkan '
            'kemampuan masyarakat dalam mengembangkan usaha dan pemasaran produk.',
        'icon': Icons.storefront,
      },
      {
        'title': 'Musyawarah Desa Tahun 2026',
        'date': '5 September 2026',
        'category': 'Pemerintahan',
        'description':
            'Pemerintah Desa bersama masyarakat melaksanakan musyawarah '
            'untuk membahas rencana pembangunan dan kegiatan desa.',
        'icon': Icons.groups,
      },
      {
        'title': 'Kegiatan Posyandu Desa',
        'date': '2 September 2026',
        'category': 'Kesehatan',
        'description':
            'Kegiatan Posyandu dilaksanakan sebagai bagian dari pelayanan '
            'kesehatan masyarakat Desa Tembarak.',
        'icon': Icons.health_and_safety,
      },
      {
        'title': 'Persiapan Kegiatan Desa',
        'date': '30 Agustus 2026',
        'category': 'Kegiatan Desa',
        'description':
            'Masyarakat bersama pemerintah desa melakukan persiapan '
            'untuk berbagai kegiatan yang akan dilaksanakan di desa.',
        'icon': Icons.event,
      },
      {
        'title': 'Penanaman Pohon Bersama Masyarakat',
        'date': '25 Agustus 2026',
        'category': 'Lingkungan',
        'description':
            'Kegiatan penanaman pohon dilakukan sebagai upaya menjaga '
            'kelestarian lingkungan dan penghijauan wilayah desa.',
        'icon': Icons.park,
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
                'Berita Terbaru',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Berbagai informasi dan kegiatan terbaru Desa Tembarak',
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
                children: news.map((item) {
                  return _newsCard(
                    title: item['title'] as String,
                    date: item['date'] as String,
                    category: item['category'] as String,
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
  // NEWS CARD
  // ============================================================

  Widget _newsCard({
    required String title,
    required String date,
    required String category,
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
          // FOTO / THUMBNAIL
          Container(
            width: double.infinity,
            height: 200,
            decoration: const BoxDecoration(
              color: AppTheme.lightGreen,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(22),
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 75,
                color: AppTheme.primary,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // KATEGORI + TANGGAL
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.lightGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const Spacer(),

                    Text(
                      date,
                      style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // JUDUL
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

                const SizedBox(height: 12),

                // DESKRIPSI
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

                const SizedBox(height: 20),

                // BUTTON
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Detail berita akan kita aktifkan nanti.
                    },
                    icon: const Icon(
                      Icons.arrow_forward,
                      size: 17,
                    ),
                    label: const Text(
                      'Baca Selengkapnya',
                    ),
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