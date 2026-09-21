import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../main.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  String _logoUrl = '';
  String _namaDesa = 'DESA TEMBARAK';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();

    _loadPengaturan();

    Future.delayed(
      const Duration(seconds: 3),
      _goToHome,
    );
  }

  // ============================================================
  // AMBIL LOGO DAN NAMA DESA DARI FIRESTORE
  // ============================================================

  Future<void> _loadPengaturan() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('pengaturan')
          .doc('website')
          .get();

      if (!snapshot.exists) {
        return;
      }

      final data = snapshot.data();

      if (data == null || !mounted) {
        return;
      }

      setState(() {
        _logoUrl = data['logoUrl']?.toString() ?? '';

        final namaDesa =
            data['namaDesa']?.toString().trim() ?? '';

        if (namaDesa.isNotEmpty) {
          _namaDesa = namaDesa.toUpperCase();
        }
      });
    } catch (e) {
      debugPrint(
        'Gagal mengambil pengaturan Splash: $e',
      );
    }
  }

  // ============================================================
  // PINDAH KE HOME
  // ============================================================

  Future<void> _goToHome() async {
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const MainPage(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ============================================================
  // LOGO
  // ============================================================

  Widget _buildLogo() {
    return Container(
      width: 150,
      height: 150,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: _logoUrl.isNotEmpty
          ? ClipOval(
              child: Image.network(
                _logoUrl,

                fit: BoxFit.contain,

                // Supaya browser tidak terus menggunakan
                // gambar lama setelah logo diganti.
                key: ValueKey(_logoUrl),

                loadingBuilder: (
                  context,
                  child,
                  loadingProgress,
                ) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return const Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },

                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return const Icon(
                    Icons.account_balance,
                    size: 70,
                    color: AppTheme.primary,
                  );
                },
              ),
            )
          : const Icon(
              Icons.account_balance,
              size: 70,
              color: AppTheme.primary,
            ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  // =================================================
                  // LOGO DARI FIRESTORE
                  // =================================================

                  _buildLogo(),

                  const SizedBox(height: 28),

                  // =================================================
                  // NAMA DESA
                  // =================================================

                  Text(
                    _namaDesa,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Bersama Membangun Desa',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 35),

                  // =================================================
                  // LOADING
                  // =================================================

                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}