import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../generated/assets.dart';

class HomeSearchSectionMob extends StatelessWidget {
  const HomeSearchSectionMob({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 786.h,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.imagesSearchBackgroundMob),
          fit: BoxFit.cover,
        ),

      ),
      child: Stack(
        children: [
          // Background INCM text/logo
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  Assets.imagesINCM,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Main content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 50.h),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'EXPLORE INCM WORLD',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'AloeveraDisplayBold',
                      color: const Color(0xFFF4ED47),
                      fontSize: 26.sp,
                      height: 0.2,
                    ),
                  ),
                  Text(
                    'STEP INTO A WORLD WHERE REAL ESTATE MEETS INNOVATION AND EXCELLENCE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'AloeveraDisplayRegular',
                      color: Colors.white,

                    ),
                  ),
                  Gap(50.h),
                  // Search Bar
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(maxWidth: 900.w),
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: const Color(0xFFF4ED47),
                            size: 24.sp,
                          ),
                          SizedBox(width: 5.w),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
