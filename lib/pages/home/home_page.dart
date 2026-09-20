import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../models/berita.dart';
import '../../models/galeri.dart';
import '../../models/produk.dart';
import '../../services/berita_service.dart';
import '../../services/galeri_service.dart';
import '../../services/pengaturan_service.dart';
import '../../services/produk_service.dart';
import 'package:tembarak/widgets/google_drive_video_web.dart';

import '../berita/berita_detail_page.dart';
class HomePage extends StatelessWidget {
  final String currentPage;
  final Function(String) onNavigate;

  static final PengaturanService _pengaturanService = PengaturanService();

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
          _welcomeSection(context),
          _statisticsSection(context),
          _productsSection(context),
          _newsSection(context),
          _activitySection(context),
          _contactSection(context),
        ],
      ),
    );
  }

  // ============================================================
  // HERO
  // TAMPILAN ASLI
  // ============================================================

  Widget _heroSection(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

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
          colors: [Color(0xFF0D3B13), AppTheme.primary, AppTheme.primaryLight],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: isMobile ? 1 : 6,
                child: Column(
                  crossAxisAlignment: isMobile
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
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
                    ),

                    const SizedBox(height: 22),

                    Text(
                      'Selamat Datang di\nDesa Tembarak',
                      textAlign: isMobile ? TextAlign.center : TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 38 : 52,
                        fontWeight: FontWeight.bold,
                        height: 1.15,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'Bersama membangun desa yang maju, mandiri, '
                      'sejahtera, dan berdaya saing.',
                      textAlign: isMobile ? TextAlign.center : TextAlign.left,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 17,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 32),

                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: isMobile
                          ? WrapAlignment.center
                          : WrapAlignment.start,
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
                            side: const BorderSide(color: Colors.white),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (!isMobile) const SizedBox(width: 60),

              if (isMobile) const SizedBox(height: 50),

              Expanded(
                flex: isMobile ? 1 : 4,
                child: _heroLogoPlaceholder(isMobile),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heroLogoPlaceholder(bool isMobile) {
    return Container(
      width: isMobile ? 190 : 300,
      height: isMobile ? 190 : 300,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.25), width: 2),
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
  // TAMPILAN ASLI
  // ============================================================

  Widget _quickMenu(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
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
          border: Border.all(color: AppTheme.primary.withOpacity(0.08)),
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
              child: Icon(icon, color: AppTheme.primary, size: 27),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
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
  //
  // BAGIAN SAMBUTAN ASLI DIGANTI DENGAN VIDEO.
  // UKURAN DAN LAYOUT TETAP MENGIKUTI BAGIAN ASLI.
  // ============================================================

  Widget _welcomeSection(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    return Container(
      color: AppTheme.background,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 70),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1050),
          child: FutureBuilder<Map<String, dynamic>?>(
            future: _pengaturanService.getPengaturan(),
            builder: (context, snapshot) {
              final data = snapshot.data ?? {};

              final videoJudul = data['videoJudul']?.toString() ?? '';

              final videoUrl = data['videoUrl']?.toString() ?? '';

              return Flex(
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                children: [
                  // ==================================================
                  // VIDEO GOOGLE DRIVE
                  // ==================================================
                  SizedBox(
                    width: isMobile ? 180 : 250,
                    height: isMobile ? 180 : 250,
                    child: videoUrl.trim().isEmpty
                        ? Container(
                            decoration: BoxDecoration(
                              color: AppTheme.lightGreen,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Icon(
                              Icons.video_library_outlined,
                              size: 90,
                              color: AppTheme.primary,
                            ),
                          )
                        : GoogleDriveVideo(
                            url: videoUrl,
                            height: isMobile ? 180 : 250,
                            borderRadius: BorderRadius.circular(30),
                          ),
                  ),

                  SizedBox(width: isMobile ? 0 : 55, height: isMobile ? 35 : 0),

                  Expanded(
                    flex: isMobile ? 1 : 1,
                    child: Column(
                      crossAxisAlignment: isMobile
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Video Profil Desa',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),

                        const SizedBox(height: 18),

                        Text(
                          videoJudul.trim().isEmpty
                              ? 'Mengenal Desa Tembarak'
                              : videoJudul,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: isMobile
                              ? TextAlign.center
                              : TextAlign.left,
                        ),

                        const SizedBox(height: 15),

                        const Text(
                          'Kenali lebih dekat Desa Tembarak '
                          'melalui video profil desa yang telah '
                          'disiapkan oleh pemerintah desa.',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                            height: 1.7,
                          ),
                          textAlign: TextAlign.left,
                        ),

                        const SizedBox(height: 22),

                        if (videoUrl.trim().isEmpty)
                          ElevatedButton(
                            onPressed: () {
                              onNavigate('profil');
                            },
                            child: const Text('Lihat Profil Desa'),
                          ),
                      ],
                    ),
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
  // STATISTIK
  // ============================================================

  Widget _statisticsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 55),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: FutureBuilder<Map<String, dynamic>?>(
            future: _pengaturanService.getPengaturan(),
            builder: (context, snapshot) {
              final data = snapshot.data ?? {};

              final jumlahPenduduk = data['jumlahPenduduk']?.toString() ?? '—';

              final jumlahKeluarga = data['jumlahKeluarga']?.toString() ?? '—';

              final jumlahDusun = data['jumlahDusun']?.toString() ?? '—';

              final jumlahRtRw = data['jumlahRtRw']?.toString() ?? '—';

              return Column(
                children: [
                  const Text(
                    'Desa Tembarak dalam Angka',
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Data singkat mengenai Desa Tembarak',
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                  ),

                  const SizedBox(height: 35),

                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      _statCard(Icons.people, 'Penduduk', jumlahPenduduk),
                      _statCard(
                        Icons.home_work,
                        'Kepala Keluarga',
                        jumlahKeluarga,
                      ),
                      _statCard(Icons.location_city, 'Dusun', jumlahDusun),
                      _statCard(Icons.groups, 'RT / RW', jumlahRtRw),
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

  Widget _statCard(IconData icon, String title, String value) {
    return Container(
      width: 210,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: AppTheme.primary),

          const SizedBox(height: 12),

          Text(
            value,
            style: const TextStyle(
              color: AppTheme.primary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            title,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRODUK
  // DATA DINAMIS DARI PRODUK SERVICE
  // ============================================================

  Widget _productsSection(BuildContext context) {
    final produkService = ProdukService();

    return Container(
      color: AppTheme.background,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 65),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              const Text(
                'Produk Unggulan Desa',
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
                style: TextStyle(color: Colors.black54, fontSize: 15),
              ),

              const SizedBox(height: 35),

              StreamBuilder<List<Produk>>(
                stream: produkService.getProduk(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Text('Produk gagal dimuat.');
                  }

                  final produk = snapshot.data ?? [];

                  if (produk.isEmpty) {
                    return const Text('Belum ada produk.');
                  }

                  final produkTerpilih = produk.take(3).toList();

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
                child: const Text('Lihat Semua Produk'),
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
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Image.network(
                      produk.fotoUrl,
                      width: double.infinity,
                      height: 170,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    style: const TextStyle(color: Colors.black54, fontSize: 13),
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
  // BAGIAN ASLI DIPERTAHANKAN
  // ============================================================

  Widget _newsSection(BuildContext context) {
    final beritaService = BeritaService();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 65),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              const Text(
                'Berita & Informasi',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Informasi terbaru seputar kegiatan Desa Tembarak',
                style: TextStyle(color: Colors.black54, fontSize: 15),
              ),

              const SizedBox(height: 35),

              StreamBuilder<List<Berita>>(
                stream: beritaService.getBeritaTerbaru(limit: 3),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(30),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Text('Berita gagal dimuat.');
                  }

                  final berita = snapshot.data ?? [];

                  if (berita.isEmpty) {
                    return const Text('Belum ada berita.');
                  }

                  return Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: berita.map((item) {
                      return _newsPreview(context, item);
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 30),

              OutlinedButton(
                onPressed: () {
                  onNavigate('berita');
                },
                child: const Text('Lihat Semua Berita'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _newsPreview(BuildContext context, Berita berita) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: berita.fotoUrl.isNotEmpty
                ? Image.network(
                    berita.fotoUrl,
                    width: double.infinity,
                    height: 130,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
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
                    builder: (_) => BeritaDetailPage(berita: berita),
                  ),
                );
              },
              child: const Text('Baca Selengkapnya'),
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
      child: const Icon(Icons.article, size: 55, color: AppTheme.primary),
    );
  }

  // ============================================================
  // KEGIATAN
  // DATA DINAMIS DARI GALERI SERVICE
  // ============================================================

  Widget _activitySection(BuildContext context) {
    final galeriService = GaleriService();

    return Container(
      color: AppTheme.background,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 65),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              const Text(
                'Kegiatan Desa',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Dokumentasi kegiatan masyarakat Desa Tembarak',
                style: TextStyle(color: Colors.black54, fontSize: 15),
              ),

              const SizedBox(height: 35),

              StreamBuilder<List<Galeri>>(
                stream: galeriService.getGaleri(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Text('Kegiatan gagal dimuat.');
                  }

                  final galeri = snapshot.data ?? [];

                  if (galeri.isEmpty) {
                    return const Text('Belum ada kegiatan.');
                  }

                  final galeriTerpilih = galeri.take(4).toList();

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
                child: const Text('Lihat Galeri'),
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
                    errorBuilder: (context, error, stackTrace) {
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(
              galeri.judul,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // KONTAK / FOOTER
  // DATA DARI PENGATURAN SERVICE
  // ============================================================

  Widget _contactSection(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _pengaturanService.getPengaturan(),
      builder: (context, snapshot) {
        final data = snapshot.data ?? {};

        final footerDeskripsi =
            data['footerDeskripsi']?.toString().trim() ?? '';

        final footerAlamat = data['footerAlamat']?.toString().trim() ?? '';

        final footerTelepon = data['footerTelepon']?.toString().trim() ?? '';

        final footerEmail = data['footerEmail']?.toString().trim() ?? '';

        final footerCopyright =
            data['footerCopyright']?.toString().trim() ?? '';

        final namaDesa = data['namaDesa']?.toString().trim() ?? '';

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
          color: const Color(0xFF0D3B13),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                children: [
                  Text(
                    namaDesa.isEmpty ? 'Desa Tembarak' : namaDesa,
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
                    style: const TextStyle(color: Colors.white70, fontSize: 15),
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
                        footerTelepon.isEmpty ? 'Telepon Desa' : footerTelepon,
                      ),

                      _contactItem(
                        Icons.email,
                        footerEmail.isEmpty ? 'Email Desa' : footerEmail,
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),

                  const Divider(color: Colors.white24),

                  const SizedBox(height: 20),

                  Text(
                    footerCopyright.isEmpty
                        ? '© 2026 Pemerintah Desa Tembarak'
                        : footerCopyright,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _contactItem(IconData icon, String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 20),

        const SizedBox(width: 8),

        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }

}

