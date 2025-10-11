import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../generated/assets.dart';

class HomeWelcomeSection extends StatelessWidget {
  const HomeWelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black,
            Colors.grey[900]!,
            Colors.black,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Large INCM overlay
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Text(
                'INCM',
                style: TextStyle(
                  fontSize: 200.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF8B0000).withOpacity(0.3),
                  letterSpacing: -10,
                  height: 0.8,
                ),
              ),
            ),
          ),
          
          // Dramatic lighting effect
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1.5,
                  colors: [
                    const Color(0xFFFFC700).withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          // Main content
          Positioned(
            top: 150.h,
            left: 50.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome text
                Text(
                  'WELCOME TO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2,
                  ),
                ),
                
                SizedBox(height: 8.h),
                
                // Company name
                Text(
                  'INCOMERCIAL™️',
                  style: TextStyle(
                    color: const Color(0xFFFFC700),
                    fontSize: 48.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                
                SizedBox(height: 16.h),
                
                // Tagline
                Text(
                  'WHERE OPPORTUNITIES BEGIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          
          // Sub-text at bottom


          Image.asset(Assets.imagesSlogany)
          // Positioned(
          //   bottom: 80.h,
          //   left: 0,
          //   right: 0,
          //   child: Center(
          //     child: Text(
          //       'Consult. Manage. Lease.',
          //       style: TextStyle(
          //         color: const Color(0xFFFFC700),
          //         fontSize: 18.sp,
          //         fontWeight: FontWeight.w500,
          //         letterSpacing: 1.5,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
