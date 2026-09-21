import 'dart:async';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../models/berita.dart';
import '../../models/galeri.dart';
import '../../models/produk.dart';
import '../../services/berita_service.dart';
import '../../services/galeri_service.dart';
import '../../services/produk_service.dart';

import '../berita/berita_detail_page.dart';

class HomePage extends StatefulWidget {
  final String currentPage;
  final Function(String) onNavigate;

  const HomePage({
    super.key,
    required this.currentPage,
    required this.onNavigate,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final ProdukService _produkService = ProdukService();
  final GaleriService _galeriService = GaleriService();
  final BeritaService _beritaService = BeritaService();

  // ============================================================
  // GOOGLE DRIVE VIDEO
  // ============================================================

  String _googleDrivePreviewUrl(String url) {
    final value = url.trim();

    if (value.isEmpty) {
      return '';
    }

    // Format:
    // https://drive.google.com/file/d/FILE_ID/view?usp=sharing
    final fileMatch = RegExp(
      r'drive\.google\.com/file/d/([^/]+)',
      caseSensitive: false,
    ).firstMatch(value);

    if (fileMatch != null) {
      final fileId = fileMatch.group(1)!;

      return 'https://drive.google.com/file/d/$fileId/preview';
    }

    // Format:
    // https://drive.google.com/open?id=FILE_ID
    try {
      final uri = Uri.parse(value);
      final id = uri.queryParameters['id'];

      if (id != null && id.isNotEmpty) {
        return 'https://drive.google.com/file/d/$id/preview';
      }
    } catch (_) {}

    // Jika sudah berupa /preview
    return value;
  }

  // ============================================================
  // PENGATURAN HOME
  // ============================================================

  Stream<DocumentSnapshot<Map<String, dynamic>>>
      _getHomeSettings() {
    // PENTING:
    // PengaturanService menyimpan data pada:
    // pengaturan/website

    return _firestore
        .collection('pengaturan')
        .doc('website')
        .snapshots();
  }

  Map<String, dynamic> _settingsData(
    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
  ) {
    if (!snapshot.hasData) {
      return {};
    }

    if (!snapshot.data!.exists) {
      return {};
    }

    return snapshot.data!.data() ?? {};
  }

  String _stringSetting(
    Map<String, dynamic> data,
    String key,
    String fallback,
  ) {
    final value = data[key];

    if (value == null) {
      return fallback;
    }

    final text = value.toString().trim();

    if (text.isEmpty) {
      return fallback;
    }

    return text;
  }

  List<String> _slidesSetting(
    Map<String, dynamic> data,
  ) {
    final value = data['heroSlides'];

    if (value is List) {
      return value
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return [];
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<
        DocumentSnapshot<Map<String, dynamic>>>(
      stream: _getHomeSettings(),
      builder: (context, snapshot) {
        final data = _settingsData(snapshot);

        return SingleChildScrollView(
          child: Column(
            children: [
              // HERO / SLIDE
              _heroSection(context, data),

              // MENU CEPAT
              _quickMenu(context),

              // VIDEO PROFIL
              _welcomeSection(context, data),

              // DATA SINGKAT
              _statisticsSection(context, data),

              // PRODUK
              _productsSection(context),

              // BERITA
              _newsSection(context),

              // GALERI
              _activitySection(context),

              // KONTAK
              _contactSection(context, data),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // HERO SECTION
  // ============================================================

  Widget _heroSection(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    final slides = _slidesSetting(data);

    final title = _stringSetting(
      data,
      'homeTitle',
      'Selamat Datang di\nDesa Tembarak',
    );

    final description = _stringSetting(
      data,
      'homeDescription',
      'Bersama membangun desa yang maju, mandiri, '
          'sejahtera, dan berdaya saing.',
    );

    // Logo utama sekarang diatur dari Admin > Pengaturan.
    // homeLogoUrl tetap dipakai sebagai fallback agar data lama
    // yang sudah tersimpan tidak hilang.
    final logoUrl = _stringSetting(
      data,
      'logoUrl',
      _stringSetting(data, 'homeLogoUrl', ''),
    );

    if (slides.isEmpty) {
      return _heroDefault(
        context,
        title,
        description,
        logoUrl,
      );
    }

    return _HeroSlider(
      slides: slides,
      title: title,
      description: description,
      logoUrl: logoUrl,
      isMobile: isMobile,
      onNavigate: widget.onNavigate,
    );
  }

  Widget _heroDefault(
    BuildContext context,
    String title,
    String description,
    String logoUrl,
  ) {
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
          child: Flex(
            direction:
                isMobile ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: isMobile ? 0 : 6,
                child: Column(
                  crossAxisAlignment: isMobile
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    _websiteBadge(),

                    const SizedBox(height: 22),

                    Text(
                      title,
                      textAlign: isMobile
                          ? TextAlign.center
                          : TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 36 : 50,
                        fontWeight: FontWeight.bold,
                        height: 1.15,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      description,
                      textAlign: isMobile
                          ? TextAlign.center
                          : TextAlign.left,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 17,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 32),

                    _heroButtons(isMobile),
                  ],
                ),
              ),

              if (!isMobile)
                const SizedBox(width: 60),

              if (isMobile)
                const SizedBox(height: 50),

              Expanded(
                flex: isMobile ? 0 : 4,
                child: _heroLogo(
                  logoUrl,
                  isMobile,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _websiteBadge() {
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

  Widget _heroButtons(bool isMobile) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: isMobile
          ? WrapAlignment.center
          : WrapAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            widget.onNavigate('profil');
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
            widget.onNavigate('produk');
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

  Widget _heroLogo(
    String logoUrl,
    bool isMobile,
  ) {
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
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: logoUrl.isEmpty
              ? Icon(
                  Icons.account_balance,
                  size: isMobile ? 65 : 95,
                  color: AppTheme.primary,
                )
              : ClipOval(
                  child: Image.network(
                    logoUrl,
                    fit: BoxFit.contain,
                    errorBuilder:
                        (context, error, stackTrace) {
                      return Icon(
                        Icons.account_balance,
                        size: isMobile ? 65 : 95,
                        color: AppTheme.primary,
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }

  // ============================================================
  // QUICK MENU
  // ============================================================

  Widget _quickMenu(
    BuildContext context,
  ) {
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
        widget.onNavigate(page);
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
  // VIDEO PROFIL GOOGLE DRIVE
  // ============================================================

  Widget _welcomeSection(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    final videoUrl = _stringSetting(
      data,
      'videoUrl',
      '',
    );

    final videoJudul = _stringSetting(
      data,
      'videoJudul',
      'Mengenal lebih dekat Desa Tembarak',
    );

    return Container(
      width: double.infinity,
      color: AppTheme.background,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 25,
        vertical: isMobile ? 38 : 65,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1100,
          ),
          child: Column(
            children: [
              _videoContainer(
                videoUrl,
                isMobile: isMobile,
              ),

              SizedBox(
                height: isMobile ? 28 : 35,
              ),

              Text(
                'Video Profil Desa',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: isMobile ? 28 : 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(
                height: isMobile ? 10 : 12,
              ),

              Text(
                videoJudul,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: isMobile ? 16 : 17,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(
                height: isMobile ? 12 : 15,
              ),

              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isMobile ? 400 : 700,
                ),
                child: const Text(
                  'Kenali lebih dekat Desa Tembarak melalui '
                  'video profil desa yang telah disiapkan '
                  'oleh pemerintah desa.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    height: 1.7,
                  ),
                ),
              ),

              SizedBox(
                height: isMobile ? 22 : 25,
              ),

              ElevatedButton.icon(
                onPressed: () {
                  widget.onNavigate('profil');
                },
                icon: const Icon(
                  Icons.arrow_forward,
                  size: 19,
                ),
                label: const Text(
                  'Lihat Profil Desa',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _videoContainer(
    String videoUrl, {
    required bool isMobile,
  }) {
    if (videoUrl.trim().isEmpty) {
      return Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: isMobile ? 500 : 1000,
        ),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.lightGreen,
              borderRadius:
                  BorderRadius.circular(
                isMobile ? 18 : 20,
              ),
            ),
            child: const Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.video_library_outlined,
                  size: 55,
                  color: AppTheme.primary,
                ),

                SizedBox(height: 12),

                Text(
                  'Video profil belum tersedia',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 6),

                Padding(
                  padding:
                      EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Text(
                    'Video dapat diatur melalui Pengaturan Admin',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final previewUrl =
        _googleDrivePreviewUrl(videoUrl);

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: isMobile ? 500 : 1000,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius:
            BorderRadius.circular(
          isMobile ? 18 : 20,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: _GoogleDriveVideo(
          url: previewUrl,
        ),
      ),
    );
  }

  // ============================================================
  // DATA SINGKAT
  // ============================================================

  Widget _statisticsSection(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    // ==========================================================
    // PENTING
    //
    // Nama field HARUS sama dengan PengaturanService:
    //
    // jumlahPenduduk
    // jumlahKeluarga
    // jumlahDusun
    // jumlahRtRw
    //
    // ==========================================================

    final penduduk = _stringSetting(
      data,
      'jumlahPenduduk',
      '—',
    );

    final kepalaKeluarga = _stringSetting(
      data,
      'jumlahKeluarga',
      '—',
    );

    final dusun = _stringSetting(
      data,
      'jumlahDusun',
      '—',
    );

    final rtRw = _stringSetting(
      data,
      'jumlahRtRw',
      '—',
    );

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
          child: Column(
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
                    penduduk,
                  ),

                  _statCard(
                    Icons.home_work,
                    'Kepala Keluarga',
                    kepalaKeluarga,
                  ),

                  _statCard(
                    Icons.location_city,
                    'Dusun',
                    dusun,
                  ),

                  _statCard(
                    Icons.groups,
                    'RT / RW',
                    rtRw,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

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
  // PRODUK UNGGULAN
  // ============================================================

  Widget _productsSection(
    BuildContext context,
  ) {
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
                stream: _produkService.getProduk(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(30),
                      child: Center(
                        child:
                            CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Text(
                      'Produk gagal dimuat.',
                    );
                  }

                  final produk =
                      snapshot.data ?? [];

                  if (produk.isEmpty) {
                    return _emptyHomeState(
                      Icons.storefront,
                      'Belum ada produk desa',
                    );
                  }

                  final data =
                      produk.take(6).toList();

                  return Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment:
                        WrapAlignment.center,
                    children: data
                        .map(
                          (item) =>
                              _productCard(item),
                        )
                        .toList(),
                  );
                },
              ),

              const SizedBox(height: 30),

              OutlinedButton(
                onPressed: () {
                  widget.onNavigate('produk');
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

  Widget _productCard(
    Produk produk,
  ) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 180,
              child: produk.fotoUrl.isEmpty
                  ? _productPlaceholder()
                  : Image.network(
                      produk.fotoUrl,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) {
                        return _productPlaceholder();
                      },
                    ),
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  produk.nama,
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 17,
                  ),
                ),

                if (produk.pemilik
                    .isNotEmpty) ...[
                  const SizedBox(height: 7),

                  Text(
                    produk.pemilik,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style:
                        const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                ],

                if (produk.deskripsi
                    .isNotEmpty) ...[
                  const SizedBox(height: 8),

                  Text(
                    produk.deskripsi,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style:
                        const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      height: 1.4,
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

  Widget _productPlaceholder() {
    return Container(
      color: AppTheme.lightGreen,
      child: const Center(
        child: Icon(
          Icons.storefront,
          size: 70,
          color: AppTheme.primary,
        ),
      ),
    );
  }

  // ============================================================
  // BERITA
  // ============================================================

  Widget _newsSection(
    BuildContext context,
  ) {
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
                stream: _beritaService.getBerita(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(30),
                      child: Center(
                        child:
                            CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Text(
                      'Berita gagal dimuat.',
                    );
                  }

                  final berita =
                      snapshot.data ?? [];

                  if (berita.isEmpty) {
                    return _emptyHomeState(
                      Icons.article,
                      'Belum ada berita',
                    );
                  }

                  final data =
                      berita.take(3).toList();

                  return Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment:
                        WrapAlignment.center,
                    children: data
                        .map(
                          (item) =>
                              _newsCard(
                            context,
                            item,
                          ),
                        )
                        .toList(),
                  );
                },
              ),

              const SizedBox(height: 30),

              OutlinedButton(
                onPressed: () {
                  widget.onNavigate('berita');
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

  Widget _newsCard(
    BuildContext context,
    Berita berita,
  ) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // ======================================================
          // GAMBAR BERITA
          // ======================================================

          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: AppTheme.lightGreen,
              borderRadius:
                  BorderRadius.circular(15),
            ),
            clipBehavior: Clip.antiAlias,
            child: _beritaImage(berita),
          ),

          const SizedBox(height: 18),

          Text(
            _formatDate(berita.createdAt),
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

  // ============================================================
  // GAMBAR BERITA
  // ============================================================

  Widget _beritaImage(
    Berita berita,
  ) {
    /*
      Kode ini mencoba mengambil fotoUrl dari model Berita.

      Jika fotoUrl tersedia:
      -> tampilkan gambar berita.

      Jika kosong:
      -> tampilkan placeholder.
    */

    final fotoUrl = berita.fotoUrl.trim();

    if (fotoUrl.isEmpty) {
      return _newsPlaceholder();
    }

    return Image.network(
      fotoUrl,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder:
          (context, error, stackTrace) {
        return _newsPlaceholder();
      },
      loadingBuilder:
          (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _newsPlaceholder() {
    return Container(
      color: AppTheme.lightGreen,
      child: const Center(
        child: Icon(
          Icons.article,
          size: 55,
          color: AppTheme.primary,
        ),
      ),
    );
  }

  String _formatDate(
    DateTime? date,
  ) {
    if (date == null) {
      return '';
    }

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // ============================================================
  // KEGIATAN / GALERI
  // ============================================================

  Widget _activitySection(
    BuildContext context,
  ) {
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
                stream: _galeriService.getGaleri(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(30),
                      child: Center(
                        child:
                            CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Text(
                      'Galeri gagal dimuat.',
                    );
                  }

                  final galeri =
                      snapshot.data ?? [];

                  if (galeri.isEmpty) {
                    return _emptyHomeState(
                      Icons.photo_library,
                      'Belum ada kegiatan desa',
                    );
                  }

                  final data =
                      galeri.take(6).toList();

                  return Wrap(
                    spacing: 18,
                    runSpacing: 18,
                    alignment:
                        WrapAlignment.center,
                    children: data
                        .map(
                          (item) =>
                              _activityCard(item),
                        )
                        .toList(),
                  );
                },
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  widget.onNavigate('galeri');
                },
                child: const Text(
                  'Lihat Semua Galeri',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _activityCard(
    Galeri galeri,
  ) {
    return Container(
      width: 320,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            galeri.fotoUrl.isEmpty
                ? _galleryPlaceholder()
                : Image.network(
                    galeri.fotoUrl,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) {
                      return _galleryPlaceholder();
                    },
                  ),

            Container(
              decoration:
                  BoxDecoration(
                gradient:
                    LinearGradient(
                  begin:
                      Alignment.topCenter,
                  end:
                      Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.80),
                  ],
                ),
              ),
            ),

            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    galeri.judul,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style:
                        const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  if (galeri
                      .deskripsi
                      .isNotEmpty) ...[
                    const SizedBox(height: 5),

                    Text(
                      galeri.deskripsi,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _galleryPlaceholder() {
    return Container(
      color: AppTheme.lightGreen,
      child: const Center(
        child: Icon(
          Icons.photo_library,
          size: 70,
          color: AppTheme.primary,
        ),
      ),
    );
  }

  Widget _emptyHomeState(
    IconData icon,
    String text,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 60,
            color: Colors.grey,
          ),

          const SizedBox(height: 15),

          Text(
            text,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // KONTAK / INFORMASI BAWAH
  // ============================================================

  Widget _contactSection(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    final title = _stringSetting(
      data,
      'footerCopyright',
      'Desa Tembarak',
    );

    final description = _stringSetting(
      data,
      'footerDeskripsi',
      'Melayani masyarakat dengan sepenuh hati.',
    );

    final address = _stringSetting(
      data,
      'footerAlamat',
      'Alamat Kantor Desa',
    );

    final phone = _stringSetting(
      data,
      'footerTelepon',
      'Telepon Desa',
    );

    final email = _stringSetting(
      data,
      'footerEmail',
      'Email Desa',
    );

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
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                description,
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
                alignment:
                    WrapAlignment.center,
                children: [
                  _contactItem(
                    Icons.location_on,
                    address,
                  ),

                  _contactItem(
                    Icons.phone,
                    phone,
                  ),

                  _contactItem(
                    Icons.email,
                    email,
                  ),
                ],
              ),

              const SizedBox(height: 35),

              const Divider(
                color: Colors.white24,
              ),

              const SizedBox(height: 20),

              Text(
                '© ${DateTime.now().year} Pemerintah Desa Tembarak',
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

// ============================================================
// GOOGLE DRIVE VIDEO VIEWER
// ============================================================

class _GoogleDriveVideo extends StatefulWidget {
  final String url;

  const _GoogleDriveVideo({
    required this.url,
  });

  @override
  State<_GoogleDriveVideo> createState() =>
      _GoogleDriveVideoState();
}

class _GoogleDriveVideoState
    extends State<_GoogleDriveVideo> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();

    _viewType =
        'google-drive-video-'
        '${DateTime.now().microsecondsSinceEpoch}-'
        '${widget.url.hashCode}';

    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..src = widget.url
          ..style.border = '0'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.display = 'block'
          ..setAttribute(
            'allowfullscreen',
            'true',
          )
          ..setAttribute(
            'allow',
            'autoplay; fullscreen; encrypted-media; picture-in-picture',
          );

        return iframe;
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    if (widget.url.isEmpty) {
      return const Center(
        child: Text(
          'URL video tidak tersedia',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }

    return HtmlElementView(
      viewType: _viewType,
    );
  }
}

// ============================================================
// HERO SLIDER
// ============================================================

class _HeroSlider extends StatefulWidget {
  final List<String> slides;
  final String title;
  final String description;
  final String logoUrl;
  final bool isMobile;
  final Function(String) onNavigate;

  const _HeroSlider({
    required this.slides,
    required this.title,
    required this.description,
    required this.logoUrl,
    required this.isMobile,
    required this.onNavigate,
  });

  @override
  State<_HeroSlider> createState() =>
      _HeroSliderState();
}

class _HeroSliderState
    extends State<_HeroSlider> {
  final PageController _controller =
      PageController();

  Timer? _timer;

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) {
        if (!_controller.hasClients ||
            widget.slides.isEmpty) {
          return;
        }

        _currentPage++;

        if (_currentPage >=
            widget.slides.length) {
          _currentPage = 0;
        }

        _controller.animateToPage(
          _currentPage,
          duration:
              const Duration(
            milliseconds: 600,
          ),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final height =
        widget.isMobile ? 560.0 : 650.0;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.slides.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder:
                (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.slides[index],
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) {
                      return Container(
                        color: AppTheme.primary,
                      );
                    },
                  ),

                  Container(
                    color: Colors.black.withOpacity(
                      0.42,
                    ),
                  ),

                  Center(
                    child: Padding(
                      padding:
                          const EdgeInsets.all(25),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          const Text(
                            'WEBSITE RESMI DESA',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),

                          const SizedBox(height: 20),

                          Text(
                            widget.title,
                            textAlign:
                                TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  widget.isMobile
                                      ? 34
                                      : 50,
                              fontWeight:
                                  FontWeight.bold,
                              height: 1.15,
                              shadows: const [
                                Shadow(
                                  color:
                                      Colors.black54,
                                  blurRadius: 8,
                                  offset:
                                      Offset(2, 2),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          Text(
                            widget.description,
                            textAlign:
                                TextAlign.center,
                            maxLines: 3,
                            overflow:
                                TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white
                                  .withOpacity(0.9),
                              fontSize:
                                  widget.isMobile
                                      ? 16
                                      : 20,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 30),

                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            alignment:
                                WrapAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  widget.onNavigate(
                                    'profil',
                                  );
                                },
                                icon: const Icon(
                                  Icons.explore,
                                ),
                                label: const Text(
                                  'Jelajahi Desa',
                                ),
                                style:
                                    ElevatedButton
                                        .styleFrom(
                                  backgroundColor:
                                      Colors.white,
                                  foregroundColor:
                                      AppTheme.primary,
                                ),
                              ),

                              OutlinedButton.icon(
                                onPressed: () {
                                  widget.onNavigate(
                                    'produk',
                                  );
                                },
                                icon: const Icon(
                                  Icons.storefront,
                                ),
                                label: const Text(
                                  'Produk Desa',
                                ),
                                style:
                                    OutlinedButton
                                        .styleFrom(
                                  foregroundColor:
                                      Colors.white,
                                  side:
                                      const BorderSide(
                                    color:
                                        Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // ======================================================
          // TOMBOL KIRI
          // ======================================================

          if (widget.slides.length > 1)
            Positioned(
              left: 20,
              top: 0,
              bottom: 0,
              child: Center(
                child: _sliderButton(
                  Icons.chevron_left,
                  () {
                    _controller.previousPage(
                      duration:
                          const Duration(
                        milliseconds: 400,
                      ),
                      curve:
                          Curves.easeInOut,
                    );
                  },
                ),
              ),
            ),

          // ======================================================
          // TOMBOL KANAN
          // ======================================================

          if (widget.slides.length > 1)
            Positioned(
              right: 20,
              top: 0,
              bottom: 0,
              child: Center(
                child: _sliderButton(
                  Icons.chevron_right,
                  () {
                    _controller.nextPage(
                      duration:
                          const Duration(
                        milliseconds: 400,
                      ),
                      curve:
                          Curves.easeInOut,
                    );
                  },
                ),
              ),
            ),

          // ======================================================
          // INDICATOR
          // ======================================================

          Positioned(
            bottom: 25,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: List.generate(
                widget.slides.length,
                (index) {
                  final active =
                      index == _currentPage;

                  return AnimatedContainer(
                    duration:
                        const Duration(
                      milliseconds: 250,
                    ),
                    width:
                        active ? 24 : 8,
                    height: 8,
                    margin:
                        const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    decoration:
                        BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sliderButton(
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Material(
      color: Colors.black.withOpacity(0.35),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            color: Colors.white,
            size: 35,
          ),
        ),
      ),
    );
  }
}