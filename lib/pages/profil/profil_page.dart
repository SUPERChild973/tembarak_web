import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../services/profil_service.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final ProfilService _profilService =
      ProfilService();

  Map<String, dynamic>? _profil;

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfil();
  }

  // =====================================================
  // LOAD PROFIL
  // =====================================================

  Future<void> _loadProfil() async {
    try {
      final data =
          await _profilService.getProfil();

      if (!mounted) return;

      setState(() {
        _profil = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // =====================================================
  // GET DATA
  // =====================================================

  String _getValue(
    String key,
    String defaultValue,
  ) {
    final value = _profil?[key];

    if (value == null) {
      return defaultValue;
    }

    if (value.toString().trim().isEmpty) {
      return defaultValue;
    }

    return value.toString();
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    // =====================================================
    // LOADING
    // =====================================================

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppTheme.primary,
        ),
      );
    }

    // =====================================================
    // ERROR
    // =====================================================

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding:
              const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [

              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 55,
              ),

              const SizedBox(height: 15),

              const Text(
                'Gagal Memuat Profil Desa',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                _errorMessage!,
                textAlign:
                    TextAlign.center,
                style: const TextStyle(
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });

                  _loadProfil();
                },
                icon:
                    const Icon(Icons.refresh),
                label:
                    const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    // =====================================================
    // DATA FIRESTORE
    // =====================================================

    final namaDesa = _getValue(
      'namaDesa',
      'Desa Tembarak',
    );

    final kecamatan = _getValue(
      'kecamatan',
      'Kecamatan',
    );

    final kabupaten = _getValue(
      'kabupaten',
      'Kabupaten',
    );

    final provinsi = _getValue(
      'provinsi',
      'Jawa Timur',
    );

    final sejarah = _getValue(
      'sejarah',
      'Sejarah desa belum tersedia.',
    );

    final visi = _getValue(
      'visi',
      'Visi desa belum tersedia.',
    );

    final misi = _getValue(
      'misi',
      'Misi desa belum tersedia.',
    );

    // =====================================================
    // LOGO DESA
    // =====================================================

    final logoUrl = _getValue(
      'logoUrl',
      '',
    );

    // =====================================================
    // FILOSOFI LOGO
    // =====================================================

    final filosofiLogo = _getValue(
      'filosofiLogo',
      'Filosofi logo desa belum tersedia.',
    );

    // =====================================================
    // HALAMAN
    // =====================================================

    return RefreshIndicator(
      color: AppTheme.primary,
      onRefresh: _loadProfil,
      child: SingleChildScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [

            // =================================================
            // HEADER
            // =================================================

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 65,
              ),
              decoration:
                  const BoxDecoration(
                color:
                    AppTheme.lightGreen,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(
                    maxWidth: 1100,
                  ),
                  child: Column(
                    children: [

                      // ===============================
                      // LOGO DESA
                      // ===============================

                      Container(
                        width: 110,
                        height: 110,
                        padding:
                            const EdgeInsets.all(
                                10),
                        decoration:
                            const BoxDecoration(
                          color: Colors.white,
                          shape:
                              BoxShape.circle,
                        ),
                        child: logoUrl
                                .isNotEmpty
                            ? ClipOval(
                                child:
                                    Image.network(
                                  logoUrl,
                                  fit: BoxFit
                                      .contain,
                                  errorBuilder:
                                      (
                                    context,
                                    error,
                                    stackTrace,
                                  ) {
                                    return const Icon(
                                      Icons
                                          .shield_outlined,
                                      color: AppTheme
                                          .primary,
                                      size: 55,
                                    );
                                  },
                                ),
                              )
                            : const Icon(
                                Icons
                                    .shield_outlined,
                                color: AppTheme
                                    .primary,
                                size: 55,
                              ),
                      ),

                      const SizedBox(
                        height: 22,
                      ),

                      Text(
                        'Profil $namaDesa',
                        textAlign:
                            TextAlign.center,
                        style:
                            const TextStyle(
                          fontSize: 38,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              AppTheme.primary,
                        ),
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      Text(
                        '$kecamatan • '
                        '$kabupaten • '
                        '$provinsi',
                        textAlign:
                            TextAlign.center,
                        style:
                            const TextStyle(
                          fontSize: 16,
                          color:
                              Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // =================================================
            // CONTENT
            // =================================================

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 45,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(
                    maxWidth: 1100,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [

                      // =================================================
                      // SEJARAH
                      // =================================================

                      const _SectionTitle(
                        icon: Icons
                            .history_edu_outlined,
                        title:
                            'Sejarah Desa',
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      _ContentCard(
                        child: Text(
                          sejarah,
                          style:
                              const TextStyle(
                            fontSize: 15,
                            height: 1.8,
                            color:
                                Colors.black87,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 40,
                      ),

                      // =================================================
                      // VISI
                      // =================================================

                      const _SectionTitle(
                        icon: Icons
                            .visibility_outlined,
                        title: 'Visi',
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      _ContentCard(
                        child: Text(
                          visi,
                          style:
                              const TextStyle(
                            fontSize: 16,
                            height: 1.8,
                            fontWeight:
                                FontWeight.w500,
                            color:
                                AppTheme.primary,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 40,
                      ),

                      // =================================================
                      // MISI
                      // =================================================

                      const _SectionTitle(
                        icon:
                            Icons.flag_outlined,
                        title: 'Misi',
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      _ContentCard(
                        child: Text(
                          misi,
                          style:
                              const TextStyle(
                            fontSize: 15,
                            height: 1.8,
                            color:
                                Colors.black87,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 40,
                      ),

                      // =================================================
                      // LOGO DESA
                      // =================================================

                      const _SectionTitle(
                        icon: Icons
                            .shield_outlined,
                        title:
                            'Logo Desa',
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      _ContentCard(
                        child: Center(
                          child: logoUrl
                                  .isNotEmpty
                              ? Image.network(
                                  logoUrl,
                                  height: 300,
                                  fit: BoxFit
                                      .contain,
                                  errorBuilder:
                                      (
                                    context,
                                    error,
                                    stackTrace,
                                  ) {
                                    return const Column(
                                      mainAxisSize:
                                          MainAxisSize
                                              .min,
                                      children: [
                                        Icon(
                                          Icons
                                              .broken_image_outlined,
                                          size: 80,
                                          color: Colors
                                              .black38,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Logo desa tidak dapat dimuat.',
                                          style:
                                              TextStyle(
                                            color: Colors
                                                .black54,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                )
                              : const Column(
                                  mainAxisSize:
                                      MainAxisSize
                                          .min,
                                  children: [
                                    Icon(
                                      Icons
                                          .shield_outlined,
                                      size: 80,
                                      color: AppTheme
                                          .primary,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Logo desa belum tersedia.',
                                      style:
                                          TextStyle(
                                        color: Colors
                                            .black54,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      const SizedBox(
                        height: 40,
                      ),

                      // =================================================
                      // FILOSOFI LOGO
                      // =================================================

                      const _SectionTitle(
                        icon: Icons
                            .menu_book_outlined,
                        title:
                            'Filosofi Logo Desa',
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      _ContentCard(
                        child: Text(
                          filosofiLogo,
                          style:
                              const TextStyle(
                            fontSize: 15,
                            height: 1.8,
                            color:
                                Colors.black87,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 50,
                      ),

                      // =================================================
                      // QUOTE
                      // =================================================

                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.all(
                                30),
                        decoration:
                            BoxDecoration(
                          color:
                              AppTheme.primary,
                          borderRadius:
                              BorderRadius
                                  .circular(22),
                        ),
                        child: Column(
                          children: [

                            const Icon(
                              Icons.format_quote,
                              color:
                                  Colors.white,
                              size: 42,
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            Text(
                              '“Bersama masyarakat, membangun '
                              '$namaDesa yang maju, mandiri, '
                              'dan sejahtera.”',
                              textAlign:
                                  TextAlign.center,
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                                fontSize: 18,
                                height: 1.6,
                                fontStyle:
                                    FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// SECTION TITLE
// =====================================================

class _SectionTitle
    extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      children: [

        Container(
          width: 42,
          height: 42,
          decoration:
              const BoxDecoration(
            color:
                AppTheme.lightGreen,
            shape:
                BoxShape.circle,
          ),
          child: Icon(
            icon,
            color:
                AppTheme.primary,
            size: 22,
          ),
        ),

        const SizedBox(width: 12),

        Text(
          title,
          style:
              const TextStyle(
            fontSize: 23,
            fontWeight:
                FontWeight.bold,
            color:
                AppTheme.primary,
          ),
        ),
      ],
    );
  }
}

// =====================================================
// CONTENT CARD
// =====================================================

class _ContentCard
    extends StatelessWidget {
  final Widget child;

  const _ContentCard({
    required this.child,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(25),
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color:
              Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.04),
            blurRadius: 15,
            offset:
                const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}