import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    const backgroundColor = Color(0xFF050505);
    const cardColor = Color(0xFF111217);
    const neonGreen = Color(0xFFB6FF00);

    return Scaffold(

      backgroundColor: backgroundColor,

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: backgroundColor,
        selectedItemColor: neonGreen,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Routines',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Progress',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),

        ],
      ),

      body: SafeArea(

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: SingleChildScrollView(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                /// HEADER

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Text(
                          'FIT-NESS',
                          style: GoogleFonts.inter(
                            color: neonGreen,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          'Track your progress',
                          style: GoogleFonts.inter(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),

                      ],
                    ),

                    CircleAvatar(
                      radius: 26,
                      backgroundColor: neonGreen,
                      child: Text(
                        'D',
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )

                  ],
                ),

                const SizedBox(height: 30),

                /// TITLE

                Text(
                  'Today',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                /// STATS CARDS

                Row(
                  children: [

                    Expanded(
                      child: buildStatCard(
                        title: 'Calories',
                        value: '1240',
                        subtitle: 'kcal',
                        icon: Icons.local_fire_department_outlined,
                        neonGreen: neonGreen,
                        cardColor: cardColor,
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: buildStatCard(
                        title: 'Workout',
                        value: '2',
                        subtitle: 'sessions',
                        icon: Icons.fitness_center,
                        neonGreen: neonGreen,
                        cardColor: cardColor,
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 16),

                buildMotivationCard(
                  neonGreen,
                  cardColor,
                ),

                const SizedBox(height: 16),

                buildPlanCard(
                  neonGreen,
                  cardColor,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color neonGreen,
    required Color cardColor,
  }) {

    return Container(

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius: BorderRadius.circular(28),

        boxShadow: [

          BoxShadow(
            color: neonGreen.withOpacity(0.08),
            blurRadius: 20,
          ),

        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Icon(
            icon,
            color: neonGreen,
          ),

          const SizedBox(height: 20),

          Text(
            value,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            subtitle,
            style: GoogleFonts.inter(
              color: Colors.grey,
            ),
          ),

        ],
      ),
    );
  }

  Widget buildMotivationCard(
    Color neonGreen,
    Color cardColor,
  ) {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(

        color: cardColor,

        borderRadius: BorderRadius.circular(28),

        border: Border.all(
          color: neonGreen.withOpacity(0.3),
        ),

      ),

      child: Row(

        children: [

          Container(

            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: neonGreen,
              borderRadius: BorderRadius.circular(16),
            ),

            child: const Icon(
              Icons.auto_awesome,
              color: Colors.black,
            ),

          ),

          const SizedBox(width: 18),

          Expanded(

            child: Text(
              'Consistency beats motivation.',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

          ),

        ],
      ),
    );
  }

  Widget buildPlanCard(
    Color neonGreen,
    Color cardColor,
  ) {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [

              Text(
                'Today Plan',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Icon(
                Icons.arrow_forward,
                color: neonGreen,
              ),

            ],
          ),

          const SizedBox(height: 20),

          Text(
            'Push workout • 45 min',
            style: GoogleFonts.inter(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 20),

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

              onPressed: () {},

              child: Text(
                'Start Workout',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

            ),
          )

        ],
      ),
    );
  }
}