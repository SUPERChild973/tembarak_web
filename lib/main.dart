import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'config/app_theme.dart';

// Public pages
import 'pages/splash/splash_page.dart';
import 'pages/home/home_page.dart';
import 'pages/profil/profil_page.dart';
import 'pages/struktur/struktur_page.dart';
import 'pages/peta/peta_page.dart';
import 'pages/produk/produk_page.dart';
import 'pages/berita/berita_page.dart';
import 'pages/galeri/galeri_page.dart';
import 'pages/kontak/kontak_page.dart';

// Widgets
import 'widgets/navbar.dart';

// Admin
import 'admin/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const DesaApp());
}

class DesaApp extends StatelessWidget {
  const DesaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Website Desa Tembarak',
      theme: AppTheme.theme,
      home: const SplashPage(),
      routes: {
        '/admin': (context) => const LoginPage(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String currentPage = 'home';

  void navigateTo(String page) {
    setState(() {
      currentPage = page;
    });
  }

  Widget _getPage() {
    switch (currentPage) {
      case 'profil':
        return const ProfilPage();

      case 'struktur':
        return const StrukturPage();

      case 'peta':
        return const PetaPage();

      case 'produk':
        return const ProdukPage();

      case 'berita':
        return const BeritaPage();

      case 'galeri':
        return const GaleriPage();

      case 'kontak':
        return const KontakPage();

      case 'home':
      default:
        return HomePage(
          currentPage: currentPage,
          onNavigate: navigateTo,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Navbar(
            currentPage: currentPage,
            onNavigate: navigateTo,
          ),
          Expanded(
            child: _getPage(),
          ),
        ],
      ),
    );
  }
}