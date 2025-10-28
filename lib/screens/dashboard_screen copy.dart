
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:login/core/constants.dart';
import 'package:provider/provider.dart';
import 'package:login/providers/auth_provider.dart';
import 'package:login/screens/login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentBottomNavIndex = 0; // 'Home' aktif secara default

  // Data SVG untuk chart
  final String _chartSvgData = '''
  <svg fill="none" height="150" preserveaspectratio="none" viewBox="-3 0 478 150" width="100%" xmlns="http://www.w3.org/2000/svg">
    <path d="M0 109C18.1538 109 18.1538 21 36.3077 21C54.4615 21 54.4615 41 72.6154 41C90.7692 41 90.7692 93 108.923 93C127.077 93 127.077 33 145.231 33C163.385 33 163.385 101 181.538 101C199.692 101 199.692 61 217.846 61C236 61 236 45 254.154 45C272.308 45 272.308 121 290.462 121C308.615 121 308.615 149 326.769 149C344.923 149 344.923 1 363.077 1C381.231 1 381.231 81 399.385 81C417.538 81 417.538 129 435.692 129C453.846 129 453.846 25 472 25V149H326.769H0V109Z" fill="url(#paint0_linear_1131_5935)"></path>
    <path d="M0 109C18.1538 109 18.1538 21 36.3077 21C54.4615 21 54.4615 41 72.6154 41C90.7692 41 90.7692 93 108.923 93C127.077 93 127.077 33 145.231 33C163.385 33 163.385 101 181.538 101C199.692 101 199.692 61 217.846 61C236 61 236 45 254.154 45C272.308 45 272.308 121 290.462 121C308.615 121 308.615 149 326.769 149C344.923 149 344.923 1 363.077 1C381.231 1 381.231 81 399.385 81C417.538 81 417.538 129 435.692 129C453.846 129 453.846 25 472 25" stroke="#f04299" stroke-linecap="round" stroke-width="3"></path>
    <defs>
    <lineargradient gradientunits="userSpaceOnUse" id="paint0_linear_1131_5935" x1="236" x2="236" y1="1" y2="149">
    <stop stop-color="#f04299" stop-opacity="0.4"></stop>
    <stop offset="1" stop-color="#f04299" stop-opacity="0"></stop>
    </lineargradient>
    </defs>
  </svg>
  ''';

  // Cache widget chart agar parsing SVG tidak dilakukan berulang kali pada setiap build
  late final Widget _chartSvgWidget;

  @override
  void initState() {
    super.initState();
    // Buat widget SVG sekali dan gunakan ulang untuk menghindari parsing ulang
    _chartSvgWidget = SvgPicture.string(
      _chartSvgData,
      width: double.infinity,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Latar Belakang (Warna + Pola SVG)
        _buildBackgroundPattern(),
        
        // 2. Scaffold Utama (transparan agar pola terlihat)
        Scaffold(
          backgroundColor: Colors.transparent,
          // extendBody: true membuat body bisa tembus di belakang BottomNav
          extendBody: true, 
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(context),
              _buildMainContent(),
            ],
          ),
          bottomNavigationBar: _buildBottomNav(),
        ),
      ],
    );
  }

  // --- Widget Pembangun (Helpers) ---

  Widget _buildBackgroundPattern() {
    return Container(
      color: kDarkBackgroundColor,
      child: SvgPicture.asset(
        'assets/bg_pattern.svg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true, // 'sticky'
  backgroundColor: kDarkBackgroundColor.withOpacitySafe(0.8), // bg-background-dark/80
      elevation: 0,
      toolbarHeight: 80, // p-4 + size-12 = 16 + 48 + 16
      flexibleSpace: BackdropFilter(
        // make the blur lighter to reduce GPU work
        filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5), // lighter blur for performance
        child: Container(color: Colors.transparent),
      ),
      title: Row(
        children: [
          // Avatar
          Container(
            height: 48, // size-12
            width: 48, // size-12
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              // Placeholder gradient
              gradient: LinearGradient(
                colors: [kPrimaryColor, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          const SizedBox(width: 16), // gap-4
          const Text(
            "Welcome back, Alex!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.015 * 18,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, size: 30),
          iconSize: 48, // size-12
          onPressed: () {
            // Panggil provider untuk logout
            Provider.of<AuthProvider>(context, listen: false).logout();
            
            // Navigasi kembali ke login dan hapus semua rute sebelumnya
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false, // Hapus semua rute dari tumpukan
            );
          },
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    // SliverToBoxAdapter digunakan untuk menempatkan widget non-sliver
    // di dalam CustomScrollView
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 112), // px-4, pb-28
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headline
            const Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 12.0), // pt-5, pb-3
              child: Text(
                "Today's Stats",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            
            // Chart Card
            _buildChartCard(),
            
            // Quick Actions
            _buildQuickActions(),
            
            // Recent Activity
            const Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 8.0), // pt-4, pb-2
              child: Text(
                "Recent Activity",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.015 * 18,
                ),
              ),
            ),
            _buildRecentActivityList(),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard() {
    // Card kustom dengan border, bg, dan blur
    // Wrap the card in a RepaintBoundary so it can be rasterized separately
    // and avoid repainting the whole screen when small changes occur.
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0), // rounded-xl
        child: BackdropFilter(
          // reduced blur to make rendering cheaper
          filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0), // lighter backdrop blur
          child: Container(
            padding: const EdgeInsets.all(24.0), // p-6
            decoration: BoxDecoration(
              color: kDarkBackgroundColor.withOpacitySafe(0.5), // bg-background-dark/50
              border: Border.all(color: kPrimaryColor.withOpacitySafe(0.2)), // border-primary/20
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Task Completion", style: TextStyle(color: kDarkTextColor.withOpacitySafe(0.8), fontSize: 16)),
                const Text("82%", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                Row(
                  children: const [
                    Text("Last 7 Days", style: TextStyle(color: kSubtleTextColor, fontSize: 16)),
                    SizedBox(width: 4),
                    Text("+5%", style: TextStyle(color: kPositiveGreen, fontSize: 16, fontWeight: FontWeight.w500)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0), // py-4
                  child: RepaintBoundary(
                    child: _chartSvgWidget,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0), // py-6
      child: RepaintBoundary(
        // RepaintBoundary prevents unnecessary repaints of the grid contents
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0, // gap-4
          mainAxisSpacing: 16.0,
          shrinkWrap: true, // Penting di dalam CustomScrollView
          physics: const NeverScrollableScrollPhysics(), // Penting
          children: [
            _QuickActionButton(
              icon: Icons.add_task,
              label: "Start New Task",
              onTap: () {},
            ),
            _QuickActionButton(
              icon: Icons.bar_chart,
              label: "View Report",
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityList() {
    return Column(
      children: [
        _ActivityListItem(
          icon: Icons.check_circle,
          title: "Project Cygnus Updated",
          subtitle: "You completed 3 new tasks",
          time: "15m ago",
        ),
        _ActivityListItem(
          icon: Icons.group,
          title: "New Team Member",
          subtitle: "Casey joined the marketing team",
          time: "1h ago",
        ),
        _ActivityListItem(
          icon: Icons.calendar_month,
          title: "Upcoming Event",
          subtitle: "Quarterly review meeting tomorrow",
          time: "4h ago",
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    // Bungkus dengan ClipRRect dan BackdropFilter untuk efek blur
    // Wrap bottom nav in RepaintBoundary to avoid repainting the entire
    // screen when the nav renders translucent backgrounds.
    return RepaintBoundary(
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0), // lighter blur
          child: BottomNavigationBar(
            currentIndex: _currentBottomNavIndex,
            onTap: (index) {
              setState(() {
                _currentBottomNavIndex = index;
              });
            },
            backgroundColor: kDarkBackgroundColor.withOpacitySafe(0.8), // bg-background-dark/80
            type: BottomNavigationBarType.fixed, // Selalu tampilkan label
            selectedItemColor: kPrimaryColor,
            unselectedItemColor: kSubtleTextColor,
            selectedFontSize: 12.0,
            unselectedFontSize: 12.0,
            elevation: 0, // Dikelola oleh border container
            // decoration: BoxDecoration(
            //   border: Border(top: BorderSide(color: kPrimaryColor.withOpacitySafe(0.2), width: 1.0)),
            // ),
            items: const [
              BottomNavigationBarItem(
                icon: Padding(padding: EdgeInsets.only(bottom: 4.0), child: Icon(Icons.home, size: 30)),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Padding(padding: EdgeInsets.only(bottom: 4.0), child: Icon(Icons.bar_chart, size: 30)),
                label: "Stats",
              ),
              BottomNavigationBarItem(
                icon: Padding(padding: EdgeInsets.only(bottom: 4.0), child: Icon(Icons.person, size: 30)),
                label: "Profile",
              ),
              BottomNavigationBarItem(
                icon: Padding(padding: EdgeInsets.only(bottom: 4.0), child: Icon(Icons.settings, size: 30)),
                label: "Settings",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Widget Kustom untuk Tombol Aksi Cepat ---

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        height: 112, // h-28
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: kIconBgColor, // bg-primary/20
    border: Border.all(color: kPrimaryColor.withOpacitySafe(0.3)), // border-primary/30
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: kPrimaryColor, size: 30), // text-3xl
            const SizedBox(height: 8), // gap-2
            Text(label, style: const TextStyle(color: kDarkTextColor, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

// --- Widget Kustom untuk Item List ---

class _ActivityListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

  const _ActivityListItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0), // p-3
      margin: const EdgeInsets.only(bottom: 8.0), // gap-2
      decoration: BoxDecoration(
  color: kDarkBackgroundColor.withOpacitySafe(0.5), // bg-background-dark/50
        borderRadius: BorderRadius.circular(8.0), // rounded-lg
      ),
      child: Row(
        children: [
          // Ikon
          Container(
            height: 48, // size-12
            width: 48,
            decoration: BoxDecoration(
              color: kIconBgColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(icon, color: kPrimaryColor),
          ),
          const SizedBox(width: 16), // gap-4
          
          // Teks (meluas)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: kDarkTextColor, fontSize: 16, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: kSubtleTextColor, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          
          // Waktu
          Text(time, style: const TextStyle(color: kSubtleTextColor, fontSize: 14)),
        ],
      ),
    );
  }
}
