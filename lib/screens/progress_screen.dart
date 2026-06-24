import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

import '../controllers/progress_controller.dart';
import '../models/completed_workout.dart';
import '../widgets/custom_bottom_navbar.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  static const Color backgroundColor = Color(0xFF050505);
  static const Color cardColor = Color(0xFF111217);
  static const Color neonGreen = Color(0xFFB6FF00);

  final ProgressController progressController = ProgressController();

  late Future<ProgressSummary> progressFuture;

  @override
  void initState() {
    super.initState();
    progressFuture = progressController.loadProgressData();
  }

  Future<void> refreshProgress() async {
    setState(() {
      progressFuture = progressController.loadProgressData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 2),
      body: SafeArea(
        child: FutureBuilder<ProgressSummary>(
          future: progressFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: neonGreen),
              );
            }

            if (snapshot.hasError) {
              return buildErrorState();
            }

            final summary = snapshot.data!;

            return RefreshIndicator(
              color: neonGreen,
              backgroundColor: cardColor,
              onRefresh: refreshProgress,
              child: Scrollbar(
                radius: const Radius.circular(20),
                thickness: 4,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 20, 24, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildHeader(),

                      const SizedBox(height: 34),

                      Row(
                        children: [
                          Expanded(
                            child: buildStatCard(
                                  title: 'Workouts',
                                  value: '${summary.totalWorkouts}',
                                  subtitle: 'completed',
                                  icon: Icons.fitness_center,
                                )
                                .animate()
                                .fadeIn(duration: 260.ms)
                                .slideY(begin: 0.08, end: 0),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: buildStatCard(
                                  title: 'Minutes',
                                  value: '${summary.totalMinutes}',
                                  subtitle: 'trained',
                                  icon: Icons.timer_outlined,
                                )
                                .animate(delay: 80.ms)
                                .fadeIn(duration: 260.ms)
                                .slideY(begin: 0.08, end: 0),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      buildLargeStatCard(
                            title: 'Calories Burned',
                            value: '${summary.estimatedCalories}',
                            subtitle: 'estimated kcal',
                            icon: Icons.local_fire_department_outlined,
                          )
                          .animate(delay: 140.ms)
                          .fadeIn(duration: 280.ms)
                          .scale(
                            begin: const Offset(0.97, 0.97),
                            end: const Offset(1, 1),
                          ),

                      const SizedBox(height: 30),

                      buildSectionTitle(
                        'Weekly Activity',
                        'Workouts completed by day',
                      ),

                      const SizedBox(height: 24),

                      buildChartCard(summary.weeklyData)
                          .animate(delay: 180.ms)
                          .fadeIn(duration: 320.ms)
                          .slideY(begin: 0.06, end: 0),

                      const SizedBox(height: 30),

                      buildSectionTitle(
                        'Recent Workouts',
                        'Last sessions saved locally',
                      ),

                      const SizedBox(height: 18),

                      if (summary.workouts.isEmpty)
                        buildEmptyState()
                      else
                        buildRecentWorkouts(summary.workouts),

                      const SizedBox(height: 30),

                      buildMotivationCard(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Track your fitness evolution',
          style: GoogleFonts.inter(color: Colors.grey, fontSize: 15),
        ),
      ],
    );
  }

  Widget buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
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
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: neonGreen.withValues(alpha: 0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: neonGreen, size: 24),
          const SizedBox(height: 20),
          Text(
            value,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget buildLargeStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: neonGreen.withValues(alpha: 0.20)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: neonGreen.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: neonGreen, size: 30)
                .animate()
                .scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.14, 1.14),
                  duration: 420.ms,
                )
                .then()
                .shake(duration: 620.ms, hz: 2),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChartCard(List<WeeklyWorkoutData> weeklyData) {
    final maxValue = weeklyData
        .map((data) => data.workouts)
        .fold<int>(
          0,
          (previous, current) => current > previous ? current : previous,
        );

    final maxY = maxValue < 3 ? 3.0 : maxValue + 1.0;

    return Container(
      height: 280,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: neonGreen.withValues(alpha: 0.20)),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();

                  if (index < 0 || index >= weeklyData.length) {
                    return const SizedBox();
                  }

                  return Text(
                    weeklyData[index].day,
                    style: GoogleFonts.inter(color: Colors.grey, fontSize: 12),
                  );
                },
              ),
            ),
          ),
          barGroups: List.generate(
            weeklyData.length,
            (index) => buildBar(index, weeklyData[index].workouts.toDouble()),
          ),
        ),
      ),
    );
  }

  BarChartGroupData buildBar(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 18,
          borderRadius: BorderRadius.circular(10),
          color: neonGreen,
        ),
      ],
    );
  }

  Widget buildRecentWorkouts(List<CompletedWorkout> workouts) {
    final recentWorkouts = workouts.reversed.take(5).toList();

    return Column(
      children:
          recentWorkouts.asMap().entries.map((entry) {
            final index = entry.key;
            final workout = entry.value;

            return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: neonGreen.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: neonGreen.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.fitness_center,
                          color: neonGreen,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              workout.routineName,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${workout.date} - ${workout.duration} min',
                              style: GoogleFonts.inter(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                .animate(delay: (55 * index).ms)
                .fadeIn(duration: 240.ms)
                .slideX(begin: 0.04, end: 0);
          }).toList(),
    );
  }

  Widget buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: neonGreen.withValues(alpha: 0.20)),
      ),
      child: Column(
        children: [
          Icon(Icons.insights, color: neonGreen, size: 42),
          const SizedBox(height: 16),
          Text(
            'No workouts yet',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete a workout session to see your progress here.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget buildMotivationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: neonGreen.withValues(alpha: 0.20)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: neonGreen,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.black),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              'Small progress every day adds up to big results.',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.red.withValues(alpha: 0.35)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 42),
              const SizedBox(height: 16),
              Text(
                'Error loading progress',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please try again later.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
