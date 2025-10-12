import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3), // Lighter overlay for better contrast
            BlendMode.darken,
          ),
        ),
        // Additional gradient overlay for warm tones like in the image
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.brown.withOpacity(0.1),
            Colors.orange.withOpacity(0.05),
            Colors.brown.withOpacity(0.1),
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 50.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Search Bar - Like the image
          Container(
            width: double.infinity,
            constraints: BoxConstraints(maxWidth: 900.w),
            height: 60.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r), // Very rounded corners like capsule
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Row(
                children: [
                  // Search icon (yellow magnifying glass)
                  Icon(
                    Icons.search,
                    color: const Color(0xFFFFC700),
                    size: 28.sp,
                  ),
                  SizedBox(width: 20.w),
                  // Text input area
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for properties, locations, or services...',
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
    );
  }
}
