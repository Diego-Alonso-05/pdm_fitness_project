import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/dummy_routines.dart';
import '../widgets/routine_card.dart';
import '../widgets/custom_bottom_navbar.dart';

class RoutinesScreen extends StatelessWidget {

  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    const backgroundColor = Color(0xFF050505);

    const neonGreen = Color(0xFFB6FF00);

    return Scaffold(

      backgroundColor: backgroundColor,

      bottomNavigationBar: const CustomBottomNavbar(
        currentIndex: 1,
      ),

      floatingActionButton: FloatingActionButton(

        backgroundColor: neonGreen,

        onPressed: () {

          ScaffoldMessenger.of(context).showSnackBar(

            SnackBar(

              backgroundColor: neonGreen,

              content: Text(
                'Create Routine coming soon 🔥',

                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },

        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),

      body: SafeArea(

        child: Padding(

          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              // =========================================
              // HEADER
              // =========================================

              Text(
                'My Routines',

                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Choose your workout plan',

                style: GoogleFonts.inter(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 30),

              // =========================================
              // ROUTINES LIST
              // =========================================

              Expanded(

                child: ListView.builder(

                  physics: const BouncingScrollPhysics(),

                  itemCount: dummyRoutines.length,

                  itemBuilder: (context, index) {

                    final routine = dummyRoutines[index];

                    return RoutineCard(
                      routine: routine,
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}