import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

import '../data/workout_history.dart';
import '../widgets/custom_bottom_navbar.dart';

class ProgressScreen extends StatelessWidget {

  const ProgressScreen({super.key});

  // =========================================================
  // COLORS
  // =========================================================

  static const Color backgroundColor = Color(0xFF050505);

  static const Color cardColor = Color(0xFF111217);

  static const Color neonGreen = Color(0xFFB6FF00);

  @override
  Widget build(BuildContext context) {

    final totalWorkouts = workoutHistory.length;

    final totalMinutes = workoutHistory.fold(
      0,
      (sum, workout) => sum + workout.duration,
    );

    final estimatedCalories = totalMinutes * 8;

    return Scaffold(

      backgroundColor: backgroundColor,

      bottomNavigationBar: const CustomBottomNavbar(
        currentIndex: 2,
      ),

      body: SafeArea(

        child: SingleChildScrollView(

          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              // =====================================
              // HEADER
              // =====================================

              Text(
                'Progress',

                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Track your fitness evolution',

                style: GoogleFonts.inter(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 34),

              // =====================================
              // STATS ROW
              // =====================================

              Row(

                children: [

                  Expanded(
                    child: buildStatCard(
                      title: 'Workouts',
                      value: '$totalWorkouts',
                      subtitle: 'completed',
                      icon: Icons.fitness_center,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: buildStatCard(
                      title: 'Minutes',
                      value: '$totalMinutes',
                      subtitle: 'trained',
                      icon: Icons.timer_outlined,
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 16),

              buildLargeStatCard(
                title: 'Calories Burned',
                value: '$estimatedCalories',
                subtitle: 'estimated kcal',
                icon: Icons.local_fire_department_outlined,
              ),

              const SizedBox(height: 30),

              // =====================================
              // CHART TITLE
              // =====================================

              Text(
                'Weekly Activity',

                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 24),

              // =====================================
              // CHART CARD
              // =====================================

              Container(

                height: 280,

                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  color: cardColor,

                  borderRadius: BorderRadius.circular(30),

                  border: Border.all(
                    color: neonGreen.withOpacity(0.20),
                  ),
                ),

                child: BarChart(

                  BarChartData(

                    alignment: BarChartAlignment.spaceAround,

                    maxY: 10,

                    gridData: FlGridData(
                      show: false,
                    ),

                    borderData: FlBorderData(
                      show: false,
                    ),

                    titlesData: FlTitlesData(

                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),

                      topTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),

                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),

                      bottomTitles: AxisTitles(

                        sideTitles: SideTitles(

                          showTitles: true,

                          getTitlesWidget:
                              (value, meta) {

                            final style =
                                GoogleFonts.inter(
                              color: Colors.grey,
                              fontSize: 12,
                            );

                            switch (value.toInt()) {

                              case 0:
                                return Text(
                                  'Mon',
                                  style: style,
                                );

                              case 1:
                                return Text(
                                  'Tue',
                                  style: style,
                                );

                              case 2:
                                return Text(
                                  'Wed',
                                  style: style,
                                );

                              case 3:
                                return Text(
                                  'Thu',
                                  style: style,
                                );

                              case 4:
                                return Text(
                                  'Fri',
                                  style: style,
                                );

                              case 5:
                                return Text(
                                  'Sat',
                                  style: style,
                                );

                              case 6:
                                return Text(
                                  'Sun',
                                  style: style,
                                );

                              default:
                                return const SizedBox();
                            }
                          },
                        ),
                      ),
                    ),

                    barGroups: [

                      buildBar(0, 3),
                      buildBar(1, 6),
                      buildBar(2, 4),
                      buildBar(3, 8),
                      buildBar(4, 5),
                      buildBar(5, 7),
                      buildBar(6, 2),

                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // =====================================
              // MOTIVATION CARD
              // =====================================

              Container(

                width: double.infinity,

                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  color: cardColor,

                  borderRadius: BorderRadius.circular(28),

                  border: Border.all(
                    color: neonGreen.withOpacity(0.20),
                  ),
                ),

                child: Row(

                  children: [

                    Container(

                      padding: const EdgeInsets.all(14),

                      decoration: BoxDecoration(
                        color: neonGreen,
                        borderRadius:
                            BorderRadius.circular(18),
                      ),

                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.black,
                      ),
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
              ),

            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // SMALL STAT CARD
  // =========================================================

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

        border: Border.all(
          color: neonGreen.withOpacity(0.20),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Icon(
            icon,
            color: neonGreen,
            size: 24,
          ),

          const SizedBox(height: 20),

          Text(
            value,

            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 34,
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

            style: GoogleFonts.inter(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),

        ],
      ),
    );
  }

  // =========================================================
  // LARGE STAT CARD
  // =========================================================

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

        border: Border.all(
          color: neonGreen.withOpacity(0.20),
        ),
      ),

      child: Row(

        children: [

          Container(

            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              color: neonGreen.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),

            child: Icon(
              icon,
              color: neonGreen,
              size: 30,
            ),
          ),

          const SizedBox(width: 20),

          Expanded(

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  value,

                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 34,
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
    );
  }

  // =========================================================
  // BAR CHART
  // =========================================================

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
}