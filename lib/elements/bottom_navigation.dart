import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:aqua_pet/layers/calendar_page.dart';
import 'package:aqua_pet/layers/home_page.dart';
import 'package:aqua_pet/layers/reminder_page.dart';
import 'package:aqua_pet/layers/profile_page.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigation();
}

class _BottomNavigation extends State<BottomNavigation> {
  int index = 0;

  final List<Widget> pages = const [
    HomePage(),
    ReminderPage(),
    CalendarPage(),
    ProfilePage(),
  ];

  final List<IconData> icons = const [
    Icons.home_rounded,
    Icons.notifications_rounded,
    Icons.calendar_month_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return BottomBar(
      layout: BottomBarLayout(
        width: MediaQuery.of(context).size.width,
        borderRadius: BorderRadius.circular(40),
        fit: StackFit.expand,
      ),
      motion: const BottomBarMotion.curved(
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
      ),
      scrollBehavior: const BottomBarScrollBehavior(
        hideOnScroll: true,
      ),
      theme: const BottomBarThemeData(
        barDecoration: BoxDecoration(
          color: Colors.transparent,
        ),
      ),
      body: IndexedStack(
        index: index,
        children: pages,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: SizedBox(
          height: 72,
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 4,
                  sigmaY: 4,
                ),
                child: Container(),
              ),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: Colors.white.withAlpha(33),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withAlpha(38),
                      Colors.white.withAlpha(13),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(icons.length, (i) {
                    final selected = i == index;

                    return GestureDetector(
                      onTap: () => setState(() => index = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: selected
                              ? Colors.white.withAlpha(38)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icons[i],
                          color: selected ? Colors.white : Colors.white70,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}