import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/berita.dart';
import '../../services/berita_service.dart';
import '../berita/berita_detail_page.dart';

class HomePage extends StatelessWidget {
  final String currentPage;
  final Function(String) onNavigate;

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
          colors: [
            Color(0xFF0D3B13),
            AppTheme.primary,
            AppTheme.primaryLight,
          ],
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
                flex: isMobile ? 0 : 6,
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
                      textAlign: isMobile
                          ? TextAlign.center
                          : TextAlign.left,
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
                    ),
                  ],
                ),
              ),

              if (!isMobile)
                const SizedBox(width: 60),

              if (isMobile)
                const SizedBox(height: 50),

              Expanded(
                flex: isMobile ? 0 : 4,
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
  // SAMBUTAN
  // ============================================================

  Widget _welcomeSection(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    return Container(
      color: AppTheme.background,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 70,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1050),
          child: Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            children: [
              Container(
                width: isMobile ? 180 : 250,
                height: isMobile ? 180 : 250,
                decoration: BoxDecoration(
                  color: AppTheme.lightGreen,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.people,
                  size: 100,
                  color: AppTheme.primary,
                ),
              ),

              SizedBox(
                width: isMobile ? 0 : 55,
                height: isMobile ? 35 : 0,
              ),

              Expanded(
                flex: isMobile ? 0 : 1,
                child: Column(
                  crossAxisAlignment: isMobile
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sambutan Pemerintah Desa',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Selamat datang di Website Resmi Desa Tembarak.',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.left,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'Website ini menjadi media informasi dan pelayanan '
                      'digital bagi masyarakat Desa Tembarak. Melalui '
                      'website ini, masyarakat dapat memperoleh informasi '
                      'mengenai profil desa, kegiatan, berita, potensi '
                      'produk lokal, serta berbagai informasi lainnya.',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                        height: 1.7,
                      ),
                    ),

                    const SizedBox(height: 22),

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
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 55,
      ),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
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
                    '—',
                  ),
                  _statCard(
                    Icons.home_work,
                    'Kepala Keluarga',
                    '—',
                  ),
                  _statCard(
                    Icons.location_city,
                    'Dusun',
                    '—',
                  ),
                  _statCard(
                    Icons.groups,
                    'RT / RW',
                    '—',
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
            style: const TextStyle(
              color: AppTheme.primary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
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
    return Container(
      color: AppTheme.background,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 65,
      ),
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
                  _productPreview(
                    Icons.local_dining,
                    'Keripik Singkong',
                  ),
                  _productPreview(
                    Icons.coffee,
                    'Kopi Desa',
                  ),
                  _productPreview(
                    Icons.hive,
                    'Madu Desa',
                  ),
                ],
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

  Widget _productPreview(
    IconData icon,
    String title,
  ) {
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
            child: Center(
              child: Icon(
                icon,
                size: 75,
                color: AppTheme.primary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }

// ============================================================
// BERITA
// ============================================================

Widget _newsSection(
  BuildContext context,
) {
  final beritaService =
      BeritaService();

  return Container(
    color: Colors.white,
    padding:
        const EdgeInsets.symmetric(
      horizontal: 25,
      vertical: 65,
    ),
    child: Center(
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(
          maxWidth: 1100,
        ),
        child: Column(
          children: [
            const Text(
              'Berita & Informasi',
              style: TextStyle(
                color:
                    AppTheme.primary,
                fontSize: 30,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            const Text(
              'Informasi terbaru seputar kegiatan Desa Tembarak',
              style: TextStyle(
                color:
                    Colors.black54,
                fontSize: 15,
              ),
            ),

            const SizedBox(
              height: 35,
            ),

            StreamBuilder<List<Berita>>(
              stream: beritaService
                  .getBeritaTerbaru(
                limit: 3,
              ),
              builder: (
                context,
                snapshot,
              ) {
                if (snapshot
                        .connectionState ==
                    ConnectionState.waiting) {
                  return const Padding(
                    padding:
                        EdgeInsets.all(30),
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
                  return const Text(
                    'Belum ada berita.',
                  );
                }

                return Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment:
                      WrapAlignment
                          .center,
                  children:
                      berita.map(
                    (item) {
                      return _newsPreview(
                        context,
                        item,
                      );
                    },
                  ).toList(),
                );
              },
            ),

            const SizedBox(
              height: 30,
            ),

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
    padding:
        const EdgeInsets.all(22),
    decoration:
        BoxDecoration(
      color:
          AppTheme.background,
      borderRadius:
          BorderRadius.circular(
        20,
      ),
      border: Border.all(
        color: Colors.black
            .withOpacity(0.05),
      ),
    ),
    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        // FOTO
        ClipRRect(
          borderRadius:
              BorderRadius.circular(
            15,
          ),
          child: berita.fotoUrl
                  .isNotEmpty
              ? Image.network(
                  berita.fotoUrl,
                  width:
                      double.infinity,
                  height: 130,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (
                    context,
                    error,
                    stackTrace,
                  ) {
                    return _newsImagePlaceholder();
                  },
                )
              : _newsImagePlaceholder(),
        ),

        const SizedBox(
          height: 18,
        ),

        Text(
          berita.kategori,
          style:
              const TextStyle(
            color:
                AppTheme.primary,
            fontSize: 12,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(
          height: 8,
        ),

        Text(
          berita.judul,
          maxLines: 2,
          overflow:
              TextOverflow.ellipsis,
          style:
              const TextStyle(
            fontSize: 16,
            fontWeight:
                FontWeight.bold,
            height: 1.4,
          ),
        ),

        const SizedBox(
          height: 10,
        ),

        Text(
          berita.ringkasan,
          maxLines: 2,
          overflow:
              TextOverflow.ellipsis,
          style:
              const TextStyle(
            color:
                Colors.black54,
            fontSize: 13,
            height: 1.5,
          ),
        ),

        const SizedBox(
          height: 15,
        ),

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
    color:
        AppTheme.lightGreen,
    child: const Icon(
      Icons.article,
      size: 55,
      color:
          AppTheme.primary,
    ),
  );
}

  // ============================================================
  // KEGIATAN
  // ============================================================

  Widget _activitySection(BuildContext context) {
    return Container(
      color: AppTheme.background,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 65,
      ),
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
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 35),

              Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: [
                  _activityBox(
                    Icons.cleaning_services,
                    'Gotong Royong',
                  ),
                  _activityBox(
                    Icons.health_and_safety,
                    'Posyandu',
                  ),
                  _activityBox(
                    Icons.groups,
                    'Musyawarah Desa',
                  ),
                  _activityBox(
                    Icons.school,
                    'Pelatihan UMKM',
                  ),
                ],
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

  Widget _activityBox(
    IconData icon,
    String title,
  ) {
    return Container(
      width: 245,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 50,
            color: AppTheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // KONTAK
  // ============================================================

  Widget _contactSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 50,
      ),
      color: const Color(0xFF0D3B13),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              const Text(
                'Desa Tembarak',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Melayani masyarakat dengan sepenuh hati.',
                textAlign: TextAlign.center,
                style: TextStyle(
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
                    'Alamat Kantor Desa',
                  ),
                  _contactItem(
                    Icons.phone,
                    'Telepon Desa',
                  ),
                  _contactItem(
                    Icons.email,
                    'Email Desa',
                  ),
                ],
              ),

              const SizedBox(height: 35),

              const Divider(
                color: Colors.white24,
              ),

              const SizedBox(height: 20),

              const Text(
                '© 2026 Pemerintah Desa Tembarak',
                style: TextStyle(
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