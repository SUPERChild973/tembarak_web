import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../models/galeri.dart';
import '../../services/galeri_service.dart';

class GaleriPage extends StatelessWidget {
  const GaleriPage({super.key});

  // ============================================================
  // FORMAT TANGGAL
  // ============================================================
  String _formatTanggal(DateTime? date) {
    if (date == null) {
      return '-';
    }

    const bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${date.day} '
        '${bulan[date.month - 1]} '
        '${date.year}';
  }

  // ============================================================
  // PLACEHOLDER FOTO
  // ============================================================
  Widget _galleryPlaceholder() {
    return Container(
      width: double.infinity,
      height: 220,
      color: AppTheme.lightGreen,
      child: const Center(
        child: Icon(
          Icons.photo,
          color: AppTheme.primary,
          size: 75,
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================
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
  // GALLERY SECTION
  // ============================================================
  Widget _gallerySection() {
    final galeriService = GaleriService();

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

              // ==================================================
              // DATA GALERI DARI FIRESTORE
              // ==================================================
              StreamBuilder<List<Galeri>>(
                stream: galeriService.getGaleri(),
                builder: (
                  context,
                  snapshot,
                ) {
                  // ==================================================
                  // LOADING
                  // ==================================================
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(),
                    );
                  }

                  // ==================================================
                  // ERROR
                  // ==================================================
                  if (snapshot.hasError) {
                    return Text(
                      'Gagal memuat galeri:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    );
                  }

                  // ==================================================
                  // DATA
                  // ==================================================
                  final galeri = snapshot.data ?? [];

                  // ==================================================
                  // DATA KOSONG
                  // ==================================================
                  if (galeri.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(40),
                      child: Text(
                        'Belum ada dokumentasi kegiatan.',
                      ),
                    );
                  }

                  // ==================================================
                  // TAMPILKAN GALERI
                  // ==================================================
                  return Wrap(
                    spacing: 22,
                    runSpacing: 22,
                    alignment: WrapAlignment.center,
                    children: galeri.map((item) {
                      return _galleryCard(
                        galeri: item,
                      );
                    }).toList(),
                  );
                },
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
    required Galeri galeri,
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
          // ======================================================
          // FOTO
          // ======================================================
          Container(
            width: double.infinity,
            height: 220,
            decoration: const BoxDecoration(
              color: AppTheme.lightGreen,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(22),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              child: galeri.fotoUrl.isNotEmpty
                  ? Image.network(
                      galeri.fotoUrl,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,

                      // ==================================================
                      // JIKA GAMBAR GAGAL DIMUAT
                      // ==================================================
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return _galleryPlaceholder();
                      },
                    )
                  : _galleryPlaceholder(),
            ),
          ),

          // ======================================================
          // CONTENT
          // ======================================================
          Padding(
            padding: const EdgeInsets.all(23),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // TANGGAL
                // ==================================================
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: AppTheme.primary,
                      size: 18,
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        _formatTanggal(
                          galeri.createdAt,
                        ),
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

                // ==================================================
                // JUDUL
                // ==================================================
                Text(
                  galeri.judul,
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

                // ==================================================
                // DESKRIPSI
                // ==================================================
                Text(
                  galeri.deskripsi,
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