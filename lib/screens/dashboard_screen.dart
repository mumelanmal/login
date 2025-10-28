import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:login/core/constants.dart';
import 'package:provider/provider.dart';
import 'package:login/providers/auth_provider.dart';
// removed direct import of LoginScreen in favor of named route navigation

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentBottomNavIndex = 0;

  // Preload SVG chart sekali saja
  late final Widget _chartSvgWidget;

  @override
  void initState() {
    super.initState();
    _chartSvgWidget = SvgPicture.string(
      _chartSvgData,
      width: double.infinity,
      height: 150,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackgroundColor,
      // HAPUS extendBody untuk mengurangi kompleksitas rendering
      body: Stack(
        children: [
          // Background pattern dengan opacity rendah
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: SvgPicture.asset(
                'assets/bg_pattern.svg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main content
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(context),
              _buildMainContent(),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: kDarkBackgroundColor.withAlpha((0.95 * 255).round()), // Lebih opaque, kurangi blur
      elevation: 0,
      toolbarHeight: 80,
      // HAPUS BackdropFilter - sangat berat untuk GPU
      title: Row(
        children: [
          // Avatar dengan decoration sederhana
          const CircleAvatar(
            radius: 24,
            backgroundColor: kPrimaryColor,
            child: Icon(Icons.person, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          const Text(
            "Welcome back, Alex!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.27,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, size: 24),
          onPressed: () {
            Provider.of<AuthProvider>(context, listen: false).logout();
            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildMainContent() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headline
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
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
            
            const SizedBox(height: 24),
            
            // Quick Actions
            _buildQuickActions(),
            
            const SizedBox(height: 24),
            
            // Recent Activity
            const Text(
              "Recent Activity",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.27,
              ),
            ),
            const SizedBox(height: 12),
            _buildRecentActivityList(),
            
            const SizedBox(height: 100), // Spacing untuk bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard() {
    // Hilangkan ClipRRect dan BackdropFilter yang berat
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
    color: kDarkBackgroundColor.withAlpha((0.8 * 255).round()),
    border: Border.all(color: kPrimaryColor.withAlpha((0.3 * 255).round()), width: 1.5),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Task Completion",
            style: TextStyle(
              color: kDarkTextColor.withAlpha((0.8 * 255).round()),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "82%",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: const [
              Text(
                "Last 7 Days",
                style: TextStyle(color: kSubtleTextColor, fontSize: 14),
              ),
              SizedBox(width: 4),
              Text(
                "+5%",
                style: TextStyle(
                  color: kPositiveGreen,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Chart dengan RepaintBoundary
          RepaintBoundary(child: _chartSvgWidget),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    // Gunakan Row + Expanded untuk 2 item saja (lebih ringan dari GridView)
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.add_task,
            label: "Start New Task",
            onTap: () {},
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.bar_chart,
            label: "View Report",
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivityList() {
    // Gunakan Column langsung tanpa shrinkWrap GridView
    return Column(
      children: const [
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
    // HAPUS BackdropFilter dan blur - sangat berat
    return Container(
      decoration: BoxDecoration(
        color: kDarkBackgroundColor.withAlpha((0.98 * 255).round()),
          border: Border(
            top: BorderSide(color: kPrimaryColor.withAlpha((0.2 * 255).round()), width: 1.0),
          ),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
        },
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: kSubtleTextColor,
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Icon(Icons.home, size: 24),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Icon(Icons.bar_chart, size: 24),
            ),
            label: "Stats",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Icon(Icons.person, size: 24),
            ),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Icon(Icons.settings, size: 24),
            ),
            label: "Settings",
          ),
        ],
      ),
    );
  }

  // Chart SVG data
  static const String _chartSvgData = '''
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
}

// --- Widget Kustom ---

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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: kIconBgColor,
            border: Border.all(color: kPrimaryColor.withAlpha((0.3 * 255).round())),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: kPrimaryColor, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: kDarkTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
    color: kDarkBackgroundColor.withAlpha((0.6 * 255).round()),
    borderRadius: BorderRadius.circular(12.0),
    border: Border.all(color: kPrimaryColor.withAlpha((0.1 * 255).round())),
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: kIconBgColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Icon(icon, color: kPrimaryColor, size: 22),
          ),
          const SizedBox(width: 12),
          
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: kDarkTextColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: kSubtleTextColor,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          
          // Time
          Text(
            time,
            style: const TextStyle(
              color: kSubtleTextColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}