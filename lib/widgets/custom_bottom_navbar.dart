import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavbar extends StatelessWidget {

  final int currentIndex;

  const CustomBottomNavbar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {

    const backgroundColor = Color(0xFF0E0F14);

    const neonGreen = Color(0xFFB6FF00);

    return Container(

      margin: const EdgeInsets.fromLTRB(14, 0, 14, 18),

      decoration: BoxDecoration(

        color: backgroundColor,

        borderRadius: BorderRadius.circular(24),

        border: Border.all(
          color: neonGreen.withOpacity(0.18),
        ),
      ),

      child: ClipRRect(

        borderRadius: BorderRadius.circular(24),

        child: BottomNavigationBar(

          currentIndex: currentIndex,

          backgroundColor: backgroundColor,

          selectedItemColor: neonGreen,
          unselectedItemColor: Colors.grey,

          type: BottomNavigationBarType.fixed,

          elevation: 0,

          onTap: (index) {

            switch(index) {

              case 0:
                context.go('/');
                break;

              case 1:
                context.go('/routines');
                break;

              case 2:
                context.go('/progress');
                break;

              case 3:
                context.go('/history');
                break;
            }
          },

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
      ),
    );
  }
}