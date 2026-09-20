import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../services/pengaturan_service.dart';

class KontakPage extends StatefulWidget {
  const KontakPage({super.key});

  @override
  State<KontakPage> createState() => _KontakPageState();
}

class _KontakPageState extends State<KontakPage> {
  final PengaturanService _pengaturanService =
      PengaturanService();

  bool _isLoading = true;

  String _namaDesa = 'Desa Tembarak';
  String _alamat = '';
  String _telepon = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadKontak();
  }

  Future<void> _loadKontak() async {
    try {
      final data =
          await _pengaturanService.getPengaturan();

      if (!mounted) return;

      if (data != null) {
        setState(() {
          _namaDesa =
              data['namaDesa']?.toString().trim().isNotEmpty == true
                  ? data['namaDesa'].toString()
                  : 'Desa Tembarak';

          _alamat =
              data['footerAlamat']?.toString() ?? '';

          _telepon =
              data['footerTelepon']?.toString() ?? '';

          _email =
              data['footerEmail']?.toString() ?? '';

          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal memuat informasi kontak: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          _headerSection(),
          _contactSection(),
          _serviceSection(),
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
      child: Column(
        children: [
          const Icon(
            Icons.contact_phone,
            color: Colors.white,
            size: 60,
          ),
          const SizedBox(height: 20),
          const Text(
            'Kontak Desa',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Hubungi Pemerintah $_namaDesa',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // KONTAK
  // ============================================================

  Widget _contactSection() {
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
            maxWidth: 1050,
          ),
          child: Wrap(
            spacing: 25,
            runSpacing: 25,
            alignment: WrapAlignment.center,
            children: [
              _contactCard(
                icon: Icons.location_on,
                title: 'Alamat Kantor Desa',
                content: _alamat.isNotEmpty
                    ? _alamat
                    : 'Alamat belum diatur',
              ),
              _contactCard(
                icon: Icons.phone,
                title: 'Telepon',
                content: _telepon.isNotEmpty
                    ? _telepon
                    : 'Nomor telepon belum diatur',
              ),
              _contactCard(
                icon: Icons.email,
                title: 'Email',
                content: _email.isNotEmpty
                    ? _email
                    : 'Email belum diatur',
              ),
              _contactCard(
                icon: Icons.access_time,
                title: 'Jam Pelayanan',
                content: 'Senin - Jumat\n08.00 - 15.00 WIB',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CONTACT CARD
  // ============================================================

  Widget _contactCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      width: 480,
      constraints: const BoxConstraints(
        minHeight: 150,
      ),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: const BoxDecoration(
              color: AppTheme.lightGreen,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppTheme.primary,
              size: 27,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  content,
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

  // ============================================================
  // PELAYANAN
  // ============================================================

  Widget _serviceSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 55,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 900,
          ),
          child: Container(
            padding: const EdgeInsets.all(35),
            decoration: BoxDecoration(
              color: AppTheme.lightGreen,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.support_agent,
                  color: AppTheme.primary,
                  size: 50,
                ),
                const SizedBox(height: 18),
                const Text(
                  'Pelayanan Masyarakat',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Pemerintah $_namaDesa berkomitmen memberikan '
                  'pelayanan terbaik kepada seluruh masyarakat desa.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Informasi alamat, nomor telepon, dan email '
                  'dapat diperbarui melalui halaman admin.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}