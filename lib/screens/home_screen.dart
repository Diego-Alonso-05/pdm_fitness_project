import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/sync_manager.dart';
import '../widgets/custom_bottom_navbar.dart';

// =========================================================
// LOCAL GOOGLE FONTS REPLACEMENT
// =========================================================

class GoogleFonts {
  static TextStyle inter({
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    double? height,
  }) {
    return TextStyle(
      fontFamily: 'Arial',
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // =========================================================
  // COLORS
  // =========================================================

  static const Color backgroundColor = Color(0xFF050505);

  static const Color cardColor = Color(0xFF111217);

  static const Color neonGreen = Color(0xFFB6FF00);

  static const Color primaryText = Colors.white;

  static const Color secondaryText = Color(0xFFD0D0D0);

  static const Color mutedText = Color(0xFF8A8A8A);

  // =========================================================
  // STATE
  // =========================================================

  int waterGlasses = 5;

  int workoutSessions = 2;

  final int maxWater = 8;

  int waterAnimationSeed = 0;

  // =========================================================
  // GREETING
  // =========================================================

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    }

    if (hour < 18) {
      return 'Good Afternoon';
    }

    return 'Good Evening';
  }

  // =========================================================
  // ACTIONS
  // =========================================================

  void addWater() {
    if (waterGlasses < maxWater) {
      setState(() {
        waterGlasses++;
        waterAnimationSeed++;
      });

      showCustomSnackBar('Water updated 💧');
    }
  }

  void startWorkout() {
    setState(() {
      workoutSessions++;
    });

    showCustomSnackBar('Workout started 🔥');
  }

  void showCustomSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: neonGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          text,
          style: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // =========================================================
  // PROFILE MENU
  // =========================================================

  void openProfileMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 24),

                CircleAvatar(
                  radius: 34,
                  backgroundColor: neonGreen,
                  child: Text(
                    'D',
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'David',
                  style: GoogleFonts.inter(
                    color: primaryText,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Fitness Enthusiast',
                  style: GoogleFonts.inter(color: secondaryText, fontSize: 15),
                ),

                const SizedBox(height: 28),

                buildProfileOption(
                  icon: Icons.person_outline,
                  title: 'Profile',
                ),

                buildProfileOption(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                ),

                buildProfileOption(
                  icon: Icons.sync,
                  title: 'Sync Data',
                  onTap: syncData,
                ),

                buildProfileOption(
                  icon: Icons.logout,
                  title: 'Logout',
                  isLogout: true,
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildProfileOption({
    required IconData icon,
    required String title,
    bool isLogout = false,
    Future<void> Function()? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () async {
          Navigator.pop(context);

          if (onTap != null) {
            await onTap();
          } else {
            showCustomSnackBar('$title selected');
          }
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF171920),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color:
                  isLogout
                      ? Colors.red.withValues(alpha: 0.35)
                      : neonGreen.withValues(alpha: 0.20),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: isLogout ? Colors.red : neonGreen),

              const SizedBox(width: 14),

              Text(
                title,
                style: GoogleFonts.inter(
                  color: primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> syncData() async {
    final result = await SyncManager.instance.syncExercises();

    if (!mounted) return;

    showCustomSnackBar('${result.message}: ${result.exerciseCount} exercises');
  }

  Future<void> openNearbyGymsMap() async {
    final mapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=gyms%20near%20me',
    );

    final opened = await launchUrl(
      mapsUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!mounted) return;

    if (!opened) {
      showCustomSnackBar('Could not open Google Maps');
    }
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(),

              const SizedBox(height: 34),

              buildTodaySection(),

              const SizedBox(height: 24),

              buildStatsSection(),

              const SizedBox(height: 16),

              buildMotivationCard(),

              const SizedBox(height: 16),

              buildWorkoutPlanCard(),

              const SizedBox(height: 16),

              buildWaterTrackerCard(),

              const SizedBox(height: 16),

              buildNearbyGymsCard(),

              const SizedBox(height: 16),

              // =====================================
              // API BUTTON
              // =====================================
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: neonGreen,
                    side: BorderSide(color: neonGreen.withValues(alpha: 0.30)),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {
                    context.go('/exercises');
                  },
                  child: Text(
                    'OPEN EXERCISE LIBRARY',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FIT-NESS',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: neonGreen,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                '${getGreeting()}, David',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: secondaryText,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 14),

        GestureDetector(
          onTap: openProfileMenu,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: neonGreen.withValues(alpha: 0.14),
                  blurRadius: 20,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: neonGreen,
              child: Text(
                'D',
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // TODAY
  // =========================================================

  Widget buildTodaySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today',
          style: GoogleFonts.inter(
            color: primaryText,
            fontSize: 40,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          'Your daily fitness overview',
          style: GoogleFonts.inter(color: secondaryText, fontSize: 15),
        ),
      ],
    );
  }

  // =========================================================
  // STATS
  // =========================================================

  Widget buildStatsSection() {
    return Row(
      children: [
        Expanded(
          child: buildStatCard(
            title: 'Calories',
            value: '1240',
            subtitle: 'kcal burned',
            icon: Icons.local_fire_department_outlined,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: buildStatCard(
            title: 'Workout',
            value: '$workoutSessions',
            subtitle: 'sessions',
            icon: Icons.fitness_center,
          ),
        ),
      ],
    );
  }

  Widget buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: neonGreen.withValues(alpha: 0.22),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: secondaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Icon(icon, color: neonGreen, size: 22),
            ],
          ),

          const SizedBox(height: 18),

          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: GoogleFonts.inter(
                color: primaryText,
                fontSize: 42,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            subtitle,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: mutedText,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // MOTIVATION
  // =========================================================

  Widget buildMotivationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: neonGreen.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: neonGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.black),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Motivation',
                  style: GoogleFonts.inter(
                    color: secondaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Consistency beats motivation.',
                  style: GoogleFonts.inter(
                    color: primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // WORKOUT PLAN
  // =========================================================

  Widget buildWorkoutPlanCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: neonGreen.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today Plan',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: primaryText,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Push workout • 45 min',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: secondaryText,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: neonGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.arrow_forward, color: neonGreen),
              ),
            ],
          ),

          const SizedBox(height: 24),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: 0.7,
              minHeight: 8,
              backgroundColor: Colors.white10,
              valueColor: const AlwaysStoppedAnimation(neonGreen),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            '70% completed',
            style: GoogleFonts.inter(color: secondaryText, fontSize: 14),
          ),

          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: neonGreen,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: startWorkout,
              child: Text(
                'Start Workout',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // WATER
  // =========================================================

  Widget buildWaterTrackerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: neonGreen.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Water Intake',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: primaryText,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '$waterGlasses / $maxWater glasses',
                  style: GoogleFonts.inter(color: secondaryText, fontSize: 15),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          GestureDetector(
            onTap: addWater,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                if (waterAnimationSeed > 0)
                  Positioned(
                    top: -34,
                    child: Row(
                          children: const [
                            Icon(
                              Icons.water_drop,
                              color: Colors.lightBlueAccent,
                              size: 18,
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.water_drop,
                              color: Colors.lightBlueAccent,
                              size: 24,
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.water_drop,
                              color: Colors.lightBlueAccent,
                              size: 18,
                            ),
                          ],
                        )
                        .animate(key: ValueKey(waterAnimationSeed))
                        .fadeIn(duration: 120.ms)
                        .moveY(begin: 20, end: -18, duration: 650.ms)
                        .fadeOut(delay: 420.ms, duration: 260.ms),
                  ),
                Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: neonGreen,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 26,
                      ),
                    )
                    .animate(key: ValueKey('water-$waterAnimationSeed'))
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.08, 1.08),
                      duration: 140.ms,
                    )
                    .then()
                    .scale(
                      begin: const Offset(1.08, 1.08),
                      end: const Offset(1, 1),
                      duration: 140.ms,
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNearbyGymsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: neonGreen.withValues(alpha: 0.22)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: neonGreen.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.map_outlined, color: neonGreen, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gyms Near You',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: primaryText,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Open an interactive Google Maps search',
                  style: GoogleFonts.inter(color: secondaryText, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: neonGreen,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: openNearbyGymsMap,
            child: Text(
              'MAP',
              style: GoogleFonts.inter(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}
