import 'package:flutter/material.dart';

import '../config/app_theme.dart';
import '../services/auth_service.dart';

import 'profil/profil_admin_page.dart';
import 'struktur/struktur_admin_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;

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
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              tooltip: 'Logout',
              onPressed: () async {
                await AuthService().logout();

                if (!context.mounted) return;

                Navigator.of(context).pushReplacementNamed('/admin');
              },
              icon: const Icon(Icons.logout),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1100,
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

                Text(
                  user?.email ?? 'Admin Desa',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'Kelola Website Desa',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 18),

                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount;

                    if (constraints.maxWidth >= 900) {
                      crossAxisCount = 3;
                    } else if (constraints.maxWidth >= 600) {
                      crossAxisCount = 2;
                    } else {
                      crossAxisCount = 1;
                    }

                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 18,
                      mainAxisSpacing: 18,
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      childAspectRatio:
                          crossAxisCount == 1 ? 2.3 : 1.35,
                      children: [

                        // =========================
                        // PROFIL DESA
                        // =========================
                        _MenuCard(
                          icon: Icons.home_work_outlined,
                          title: 'Profil Desa',
                          subtitle:
                              'Kelola informasi desa',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    const ProfilAdminPage(),
                              ),
                            );
                          },
                        ),

                        // =========================
                        // STRUKTUR DESA
                        // =========================
                        _MenuCard(
                          icon: Icons.groups_outlined,
                          title: 'Struktur Desa',
                          subtitle:
                              'Kelola perangkat desa',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    const StrukturAdminPage(),
                              ),
                            );
                          },
                        ),

                        // =========================
                        // PRODUK DESA
                        // =========================
                        _MenuCard(
                          icon:
                              Icons.storefront_outlined,
                          title: 'Produk Desa',
                          subtitle:
                              'Kelola produk unggulan',
                          onTap: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Menu Produk Desa akan kita buat berikutnya.',
                                ),
                              ),
                            );
                          },
                        ),

                        // =========================
                        // BERITA
                        // =========================
                        _MenuCard(
                          icon: Icons.article_outlined,
                          title: 'Berita',
                          subtitle:
                              'Kelola berita desa',
                          onTap: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Menu Berita akan kita buat berikutnya.',
                                ),
                              ),
                            );
                          },
                        ),

                        // =========================
                        // GALERI
                        // =========================
                        _MenuCard(
                          icon:
                              Icons.photo_library_outlined,
                          title: 'Galeri',
                          subtitle:
                              'Kelola foto kegiatan',
                          onTap: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Menu Galeri akan kita buat berikutnya.',
                                ),
                              ),
                            );
                          },
                        ),

                        // =========================
                        // PENGATURAN
                        // =========================
                        _MenuCard(
                          icon: Icons.settings_outlined,
                          title: 'Pengaturan',
                          subtitle:
                              'Pengaturan website',
                          onTap: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Menu Pengaturan akan kita buat berikutnya.',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 30),

                // =========================
                // INFO
                // =========================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppTheme.lightGreen,
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                  child: const Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppTheme.primary,
                        size: 30,
                      ),

                      SizedBox(width: 15),

                      Expanded(
                        child: Text(
                          'Dashboard ini menjadi pusat '
                          'pengelolaan seluruh informasi '
                          'website desa. Admin dapat '
                          'mengubah data yang ditampilkan '
                          'pada halaman website publik.',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// ======================================================
// MENU CARD
// ======================================================

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
      borderRadius: BorderRadius.circular(18),

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),

        child: Container(
          padding: const EdgeInsets.all(22),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),

            border: Border.all(
              color: Colors.grey.shade200,
            ),

            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Row(
            children: [

              Container(
                width: 52,
                height: 52,

                decoration:
                    const BoxDecoration(
                  color: AppTheme.lightGreen,
                  shape: BoxShape.circle,
                ),

                child: Icon(
                  icon,
                  color: AppTheme.primary,
                  size: 27,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.black38,
              ),
            ],
          ),
        ),
      ),
    );
  }
}