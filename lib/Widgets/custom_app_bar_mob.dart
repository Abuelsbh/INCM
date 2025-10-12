import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Modules/Home/home_screen.dart';
import '../generated/assets.dart';
import 'custom_button.dart';

class CustomAppBarMob extends StatefulWidget {
  const CustomAppBarMob({super.key});

  @override
  State<CustomAppBarMob> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBarMob> {
  bool isMenuOpen = false;

  void _scrollToSection(String sectionId) {
    HomeScreen.scrollToSection(sectionId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 60.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            border: Border(
              bottom: BorderSide(
                color: const Color(0xFFFFC700).withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
            // Logo Section (Left) - INCOMERCIAL with tagline
            GestureDetector(
              onTap: () => _scrollToSection('home'),
              child: Image.asset(Assets.imagesINCMLogoMob, height: double.infinity,fit: BoxFit.cover,)
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     Text(
              //       'INCOMERCIAL',
              //       style: TextStyle(
              //         color: const Color(0xFFFFC700),
              //         fontSize: 20.sp,
              //         fontWeight: FontWeight.w600,
              //         letterSpacing: 0.5,
              //       ),
              //     ),
              //     Text(
              //       'Consult. Manage. Lease.',
              //       style: TextStyle(
              //         color: const Color(0xFFFFC700).withOpacity(0.8),
              //         fontSize: 12.sp,
              //         fontWeight: FontWeight.w400,
              //         letterSpacing: 0.3,
              //       ),
              //     ),
              //   ],
              // ),
            ),


            const Spacer(),

            // Explore Us Button (Right side)
            if (MediaQuery.of(context).size.width > 768)
              ButtonStyles.exploreUsButton(
                onPressed: () => _scrollToSection('about'),
              ),

            SizedBox(width: 16.w),

            // Mobile Menu Button (Right)
            IconButton(
              onPressed: () {
                setState(() {
                  isMenuOpen = !isMenuOpen;
                });
              },
              icon: Icon(
                isMenuOpen ? Icons.close : Icons.menu,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
              ],
            ),
          ),
        ),


      ],
    );
  }

}