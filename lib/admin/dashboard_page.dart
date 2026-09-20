import 'package:flutter/material.dart';

import '../config/app_theme.dart';
import '../services/auth_service.dart';

import 'profil/profil_admin_page.dart';
import 'struktur/struktur_admin_page.dart';
import 'produk/produk_admin_page.dart';
import 'berita/berita_admin_page.dart';
import 'galeri/galeri_admin_page.dart';
import 'pengaturan/pengaturan_admin_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'Dashboard Admin',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Keluar',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();

              if (!context.mounted) return;

              Navigator.of(context).pushNamedAndRemoveUntil(
                '/admin',
                (route) => false,
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1150,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selamat Datang, Admin 👋',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Kelola informasi website Desa Tembarak dari sini.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 35),

                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = 3;

                    if (constraints.maxWidth < 900) {
                      crossAxisCount = 2;
                    }

                    if (constraints.maxWidth < 600) {
                      crossAxisCount = 1;
                    }

                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.35,
                      children: [
                        // PROFIL
                        _MenuCard(
                          icon: Icons.account_balance_outlined,
                          title: 'Profil Desa',
                          subtitle:
                              'Kelola identitas dan informasi desa',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    const ProfilAdminPage(),
                              ),
                            );
                          },
                        ),

                        // STRUKTUR
                        _MenuCard(
                          icon: Icons.account_tree_outlined,
                          title: 'Struktur Desa',
                          subtitle:
                              'Kelola perangkat dan struktur desa',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    const StrukturAdminPage(),
                              ),
                            );
                          },
                        ),

                        // PRODUK
                        _MenuCard(
                          icon: Icons.storefront_outlined,
                          title: 'Produk Desa',
                          subtitle:
                              'Kelola produk unggulan desa',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    const ProdukAdminPage(),
                              ),
                            );
                          },
                        ),

                        // BERITA
                        _MenuCard(
                          icon: Icons.article_outlined,
                          title: 'Berita Desa',
                          subtitle: 'Kelola berita dan informasi desa',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    const BeritaAdminPage(),
                              ),
                            );
                          },
                        ),

                        // GALERI
                        // GALERI
                        _MenuCard(
                          icon: Icons.photo_library_outlined,
                          title: 'Galeri',
                          subtitle: 'Kelola foto kegiatan desa',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const GaleriAdminPage(),
                              ),
                            );
                          },
                        ),

                        // PENGATURAN
                        // PENGATURAN
                        _MenuCard(
                          icon: Icons.settings_outlined,
                          title: 'Pengaturan',
                          subtitle:
                              'Kelola isi beranda dan informasi website',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    const PengaturanAdminPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
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
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppTheme.lightGreen,
                  borderRadius:
                      BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primary,
                  size: 30,
                ),
              ),

              const Spacer(),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}