import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../generated/assets.dart';

class FooterSectionMob extends StatelessWidget {
  const FooterSectionMob({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.h,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage(Assets.imagesFollowUsBackgroundMob), // your background image asset
        ),
      ),
      child: Stack(
        children: [
          // Main content
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Row(
              children: [
                // Left side - Contact info and social media
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Follow Us
                      // Social media icons
                      Row(
                        children: [
                          Text(
                            'FOLLOW US',
                            style: TextStyle(
                              color: const Color(0xFF8B0000),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          _buildSocialIcon(Icons.facebook),
                          SizedBox(width: 10.w),
                          _buildSocialIcon(Icons.camera_alt),
                          SizedBox(width: 10.w),
                          _buildSocialIcon(Icons.business),
                          SizedBox(width: 10.w),
                          _buildSocialIcon(Icons.music_note),
                        ],
                      ),


                      SizedBox(height: 6.h),

                      // Contact information
                      _buildContactInfo(
                        Icons.email,
                        'Incomercial@gmail.com',
                      ),

                      SizedBox(height: 4.h),

                      _buildContactInfo(
                        Icons.location_on,
                        '14 A/2 Admin building, New Cairo, Egypt',
                      ),

                      SizedBox(height: 4.h),

                      _buildContactInfo(
                        Icons.phone,
                        '0111-032-7777',
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),

          // Copyright
          Positioned(
            bottom: 20.h,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Powered by E-code Wave',
                style: TextStyle(
                  color: const Color(0xFF8B0000),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      width: 24.w,
      height: 24.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 20.sp,
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF000000),
          size: 20.sp,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: const Color(0xFF000000),
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
