import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../models/berita.dart';
import '../../models/galeri.dart';
import '../../models/produk.dart';

import '../../services/berita_service.dart';
import '../../services/galeri_service.dart';
import '../../services/pengaturan_service.dart';
import '../../services/produk_service.dart';

import '../../widgets/google_drive_video.dart';

import '../berita/berita_detail_page.dart';

class HomePage extends StatelessWidget {
  final String currentPage;
  final Function(String) onNavigate;

  static final PengaturanService _pengaturanService =
      PengaturanService();

  const HomePage({
    super.key,
    required this.currentPage,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _heroSection(context),
          _quickMenu(context),

          // Video Profil Desa
          _welcomeSection(context),

          // Statistik
          _statisticsSection(context),

          // Produk
          _productsSection(context),

          // Berita
          _newsSection(context),

          // Kegiatan / Galeri
          _activitySection(context),

          // Footer
          _contactSection(context),
        ],
      ),
    );
  }

  // ============================================================
  // HERO
  // ============================================================

  Widget _heroSection(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 700;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 25 : 70,
        vertical: isMobile ? 60 : 90,
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
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1200,
          ),
          child: isMobile
              ? _heroMobile()
              : _heroDesktop(),
        ),
      ),
    );
  }

  // ============================================================
  // HERO DESKTOP
  // ============================================================

  Widget _heroDesktop() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _heroBadge(),

              const SizedBox(height: 22),

              const Text(
                'Selamat Datang di\nDesa Tembarak',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  height: 1.15,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Bersama membangun desa yang maju, mandiri, '
                'sejahtera, dan berdaya saing.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 17,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 32),

              _heroButtons(false),
            ],
          ),
        ),

        const SizedBox(width: 60),

        Expanded(
          flex: 4,
          child: _heroLogoPlaceholder(false),
        ),
      ],
    );
  }

  // ============================================================
  // HERO MOBILE
  // Tidak menggunakan Expanded di Column
  // ============================================================

  Widget _heroMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _heroBadge(),

        const SizedBox(height: 22),

        const Text(
          'Selamat Datang di\nDesa Tembarak',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 38,
            fontWeight: FontWeight.bold,
            height: 1.15,
          ),
        ),

        const SizedBox(height: 20),

        Text(
          'Bersama membangun desa yang maju, mandiri, '
          'sejahtera, dan berdaya saing.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.85),
            fontSize: 16,
            height: 1.6,
          ),
        ),

        const SizedBox(height: 32),

        _heroButtons(true),

        const SizedBox(height: 50),

        _heroLogoPlaceholder(true),
      ],
    );
  }

  // ============================================================
  // BADGE HERO
  // ============================================================

  Widget _heroBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Text(
        'WEBSITE RESMI DESA',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }

  // ============================================================
  // BUTTON HERO
  // ============================================================

  Widget _heroButtons(bool isMobile) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment:
          isMobile ? WrapAlignment.center : WrapAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            onNavigate('profil');
          },
          icon: const Icon(Icons.explore),
          label: const Text('Jelajahi Desa'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppTheme.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
          ),
        ),

        OutlinedButton.icon(
          onPressed: () {
            onNavigate('produk');
          },
          icon: const Icon(Icons.storefront),
          label: const Text('Produk Desa'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // LOGO HERO
  // ============================================================

  Widget _heroLogoPlaceholder(bool isMobile) {
    return Container(
      width: isMobile ? 190 : 300,
      height: isMobile ? 190 : 300,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.25),
          width: 2,
        ),
      ),
      child: Center(
        child: Container(
          width: isMobile ? 135 : 210,
          height: isMobile ? 135 : 210,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.account_balance,
            size: isMobile ? 65 : 95,
            color: AppTheme.primary,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // QUICK MENU
  // ============================================================

  Widget _quickMenu(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 35,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1100,
          ),
          child: Wrap(
            spacing: 18,
            runSpacing: 18,
            alignment: WrapAlignment.center,
            children: [
              _quickCard(
                icon: Icons.info_outline,
                title: 'Profil Desa',
                description: 'Mengenal Desa Tembarak',
                page: 'profil',
              ),

              _quickCard(
                icon: Icons.people_outline,
                title: 'Pemerintahan',
                description: 'Struktur organisasi desa',
                page: 'struktur',
              ),

              _quickCard(
                icon: Icons.storefront_outlined,
                title: 'Produk Desa',
                description: 'Potensi UMKM desa',
                page: 'produk',
              ),

              _quickCard(
                icon: Icons.article_outlined,
                title: 'Berita',
                description: 'Informasi terbaru desa',
                page: 'berita',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickCard({
    required IconData icon,
    required String title,
    required String description,
    required String page,
  }) {
    return InkWell(
      onTap: () {
        onNavigate(page);
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 245,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppTheme.lightGreen,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppTheme.primary.withOpacity(0.08),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppTheme.primary,
                size: 27,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // VIDEO PROFIL DESA
  // RESPONSIVE
  // ============================================================

  Widget _welcomeSection(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 800;

    return Container(
      width: double.infinity,
      color: AppTheme.background,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 35,
        vertical: isMobile ? 50 : 70,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1150,
          ),
          child: FutureBuilder<Map<String, dynamic>?>(
            future: _pengaturanService.getPengaturan(),
            builder: (context, snapshot) {
              final data = snapshot.data ?? {};

              final String videoJudul =
                  data['videoJudul']?.toString().trim() ?? '';

              final String videoUrl =
                  data['videoUrl']?.toString().trim() ?? '';

              if (isMobile) {
                return _videoMobile(
                  videoJudul: videoJudul,
                  videoUrl: videoUrl,
                );
              }

              return _videoDesktop(
                videoJudul: videoJudul,
                videoUrl: videoUrl,
              );
            },
          ),
        ),
      ),
    );
  }

  // ============================================================
  // VIDEO DESKTOP
  // ============================================================

  Widget _videoDesktop({
    required String videoJudul,
    required String videoUrl,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 6,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: _videoWidget(videoUrl),
          ),
        ),

        const SizedBox(width: 55),

        Expanded(
          flex: 5,
          child: _videoText(
            videoJudul: videoJudul,
            isMobile: false,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // VIDEO MOBILE
  // Tidak menggunakan Expanded
  // ============================================================

  Widget _videoMobile({
    required String videoJudul,
    required String videoUrl,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: _videoWidget(videoUrl),
        ),

        const SizedBox(height: 30),

        _videoText(
          videoJudul: videoJudul,
          isMobile: true,
        ),
      ],
    );
  }

  // ============================================================
  // WIDGET VIDEO GOOGLE DRIVE
  // ============================================================

  Widget _videoWidget(String videoUrl) {
    if (videoUrl.isEmpty) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.lightGreen,
          borderRadius: BorderRadius.circular(28),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.video_library_outlined,
                size: 65,
                color: AppTheme.primary,
              ),

              SizedBox(height: 12),

              Text(
                'Video profil belum tersedia',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GoogleDriveVideo(
      url: videoUrl,
      height: double.infinity,
      borderRadius: BorderRadius.circular(28),
    );
  }

  // ============================================================
  // TEKS VIDEO
  // ============================================================

  Widget _videoText({
    required String videoJudul,
    required bool isMobile,
  }) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          'Video Profil Desa',
          textAlign:
              isMobile ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            color: AppTheme.primary,
            fontSize: isMobile ? 30 : 38,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 18),

        Text(
          videoJudul.isEmpty
              ? 'Mengenal Desa Tembarak'
              : videoJudul,
          textAlign:
              isMobile ? TextAlign.center : TextAlign.left,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 15),

        const Text(
          'Kenali lebih dekat Desa Tembarak melalui '
          'video profil desa yang telah disiapkan '
          'oleh pemerintah desa.',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 15,
            height: 1.7,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // STATISTIK
  // ============================================================

  Widget _statisticsSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 55,
      ),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1000,
          ),
          child: FutureBuilder<Map<String, dynamic>?>(
            future: _pengaturanService.getPengaturan(),
            builder: (context, snapshot) {
              final data = snapshot.data ?? {};

              final String jumlahPenduduk =
                  data['jumlahPenduduk']?.toString() ?? '—';

              final String jumlahKeluarga =
                  data['jumlahKeluarga']?.toString() ?? '—';

              final String jumlahDusun =
                  data['jumlahDusun']?.toString() ?? '—';

              final String jumlahRtRw =
                  data['jumlahRtRw']?.toString() ?? '—';

              return Column(
                children: [
                  const Text(
                    'Desa Tembarak dalam Angka',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Data singkat mengenai Desa Tembarak',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 35),

                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      _statCard(
                        Icons.people,
                        'Penduduk',
                        jumlahPenduduk,
                      ),

                      _statCard(
                        Icons.home_work,
                        'Kepala Keluarga',
                        jumlahKeluarga,
                      ),

                      _statCard(
                        Icons.location_city,
                        'Dusun',
                        jumlahDusun,
                      ),

                      _statCard(
                        Icons.groups,
                        'RT / RW',
                        jumlahRtRw,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ============================================================
  // STAT CARD
  // ============================================================

  Widget _statCard(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      width: 210,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 25,
      ),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 40,
            color: AppTheme.primary,
          ),

          const SizedBox(height: 12),

          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.primary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRODUK
  // ============================================================

  Widget _productsSection(BuildContext context) {
    final produkService = ProdukService();

    return Container(
      color: AppTheme.background,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 65,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1100,
          ),
          child: Column(
            children: [
              const Text(
                'Produk Unggulan Desa',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Potensi dan produk lokal masyarakat Desa Tembarak',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 35),

              StreamBuilder<List<Produk>>(
                stream: produkService.getProduk(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Text(
                      'Produk gagal dimuat.',
                    );
                  }

                  final produk = snapshot.data ?? [];

                  if (produk.isEmpty) {
                    return const Text(
                      'Belum ada produk.',
                    );
                  }

                  final produkTerpilih =
                      produk.take(3).toList();

                  return Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: produkTerpilih.map((item) {
                      return _productPreview(item);
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 30),

              OutlinedButton(
                onPressed: () {
                  onNavigate('produk');
                },
                child: const Text(
                  'Lihat Semua Produk',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _productPreview(Produk produk) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 170,
            decoration: BoxDecoration(
              color: AppTheme.lightGreen,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: produk.fotoUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Image.network(
                      produk.fotoUrl,
                      width: double.infinity,
                      height: 170,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.storefront,
                            size: 75,
                            color: AppTheme.primary,
                          ),
                        );
                      },
                    ),
                  )
                : const Center(
                    child: Icon(
                      Icons.storefront,
                      size: 75,
                      color: AppTheme.primary,
                    ),
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  produk.nama,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),

                if (produk.pemilik.isNotEmpty) ...[
                  const SizedBox(height: 7),

                  Text(
                    produk.pemilik,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BERITA
  // ============================================================

  Widget _newsSection(BuildContext context) {
    final beritaService = BeritaService();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 65,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1100,
          ),
          child: Column(
            children: [
              const Text(
                'Berita & Informasi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Informasi terbaru seputar kegiatan Desa Tembarak',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 35),

              StreamBuilder<List<Berita>>(
                stream:
                    beritaService.getBeritaTerbaru(limit: 3),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Text(
                      'Berita gagal dimuat.',
                    );
                  }

                  final berita = snapshot.data ?? [];

                  if (berita.isEmpty) {
                    return const Text(
                      'Belum ada berita.',
                    );
                  }

                  return Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: berita.map((item) {
                      return _newsPreview(
                        context,
                        item,
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 30),

              OutlinedButton(
                onPressed: () {
                  onNavigate('berita');
                },
                child: const Text(
                  'Lihat Semua Berita',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _newsPreview(
    BuildContext context,
    Berita berita,
  ) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: berita.fotoUrl.isNotEmpty
                ? Image.network(
                    berita.fotoUrl,
                    width: double.infinity,
                    height: 130,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) {
                      return _newsImagePlaceholder();
                    },
                  )
                : _newsImagePlaceholder(),
          ),

          const SizedBox(height: 18),

          Text(
            berita.kategori,
            style: const TextStyle(
              color: AppTheme.primary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            berita.judul,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            berita.ringkasan,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 13,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        BeritaDetailPage(
                      berita: berita,
                    ),
                  ),
                );
              },
              child: const Text(
                'Baca Selengkapnya',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _newsImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 130,
      color: AppTheme.lightGreen,
      child: const Icon(
        Icons.article,
        size: 55,
        color: AppTheme.primary,
      ),
    );
  }

  // ============================================================
  // KEGIATAN / GALERI
  // ============================================================

  Widget _activitySection(BuildContext context) {
    final galeriService = GaleriService();

    return Container(
      color: AppTheme.background,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 65,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1100,
          ),
          child: Column(
            children: [
              const Text(
                'Kegiatan Desa',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Dokumentasi kegiatan masyarakat Desa Tembarak',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 35),

              StreamBuilder<List<Galeri>>(
                stream: galeriService.getGaleri(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Text(
                      'Kegiatan gagal dimuat.',
                    );
                  }

                  final galeri = snapshot.data ?? [];

                  if (galeri.isEmpty) {
                    return const Text(
                      'Belum ada kegiatan.',
                    );
                  }

                  final galeriTerpilih =
                      galeri.take(4).toList();

                  return Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    alignment: WrapAlignment.center,
                    children: galeriTerpilih.map((item) {
                      return _activityBox(item);
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  onNavigate('galeri');
                },
                child: const Text(
                  'Lihat Galeri',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _activityBox(Galeri galeri) {
    return Container(
      width: 245,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: galeri.fotoUrl.isNotEmpty
                ? Image.network(
                    galeri.fotoUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.photo_library_outlined,
                          size: 50,
                          color: AppTheme.primary,
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Icon(
                      Icons.photo_library_outlined,
                      size: 50,
                      color: AppTheme.primary,
                    ),
                  ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            child: Text(
              galeri.judul,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FOOTER / KONTAK
  // ============================================================

  Widget _contactSection(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _pengaturanService.getPengaturan(),
      builder: (context, snapshot) {
        final data = snapshot.data ?? {};

        final String footerDeskripsi =
            data['footerDeskripsi']
                    ?.toString()
                    .trim() ??
                '';

        final String footerAlamat =
            data['footerAlamat']
                    ?.toString()
                    .trim() ??
                '';

        final String footerTelepon =
            data['footerTelepon']
                    ?.toString()
                    .trim() ??
                '';

        final String footerEmail =
            data['footerEmail']
                    ?.toString()
                    .trim() ??
                '';

        final String footerCopyright =
            data['footerCopyright']
                    ?.toString()
                    .trim() ??
                '';

        final String namaDesa =
            data['namaDesa']
                    ?.toString()
                    .trim() ??
                '';

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 50,
          ),
          color: const Color(0xFF0D3B13),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1000,
              ),
              child: Column(
                children: [
                  Text(
                    namaDesa.isEmpty
                        ? 'Desa Tembarak'
                        : namaDesa,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    footerDeskripsi.isEmpty
                        ? 'Melayani masyarakat dengan sepenuh hati.'
                        : footerDeskripsi,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Wrap(
                    spacing: 30,
                    runSpacing: 15,
                    alignment: WrapAlignment.center,
                    children: [
                      _contactItem(
                        Icons.location_on,
                        footerAlamat.isEmpty
                            ? 'Alamat Kantor Desa'
                            : footerAlamat,
                      ),

                      _contactItem(
                        Icons.phone,
                        footerTelepon.isEmpty
                            ? 'Telepon Desa'
                            : footerTelepon,
                      ),

                      _contactItem(
                        Icons.email,
                        footerEmail.isEmpty
                            ? 'Email Desa'
                            : footerEmail,
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),

                  const Divider(
                    color: Colors.white24,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    footerCopyright.isEmpty
                        ? '© 2026 Pemerintah Desa Tembarak'
                        : footerCopyright,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _contactItem(
    IconData icon,
    String title,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),

        const SizedBox(width: 8),

        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}