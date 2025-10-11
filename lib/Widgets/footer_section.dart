import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../generated/assets.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450.h,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage(Assets.imagesFollowUsBackground), // your background image asset
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Main content
          Padding(
            padding: EdgeInsets.all(60.w),
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
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          _buildSocialIcon(Icons.facebook),
                          SizedBox(width: 16.w),
                          _buildSocialIcon(Icons.camera_alt),
                          SizedBox(width: 16.w),
                          _buildSocialIcon(Icons.business),
                          SizedBox(width: 16.w),
                          _buildSocialIcon(Icons.music_note),
                        ],
                      ),


                      SizedBox(height: 40.h),

                      // Contact information
                      _buildContactInfo(
                        Icons.email,
                        'Incomercial@gmail.com',
                      ),

                      SizedBox(height: 16.h),

                      _buildContactInfo(
                        Icons.location_on,
                        '14 A/2 Admin building, New Cairo, Egypt',
                      ),

                      SizedBox(height: 16.h),

                      _buildContactInfo(
                        Icons.phone,
                        '0111-032-7777',
                      ),
                    ],
                  ),
                ),

                // Right side - App download
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'DOWNLOAD OUR \nAPP NOW!',
                        style: TextStyle(
                          color: const Color(0xFF000000),
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // QR Code placeholder
                      Container(
                        width: 120.w,
                        height: 120.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.qr_code,
                            size: 100.sp,
                            color: Colors.black,
                          ),
                        ),
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
                  fontSize: 16.sp,
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
      width: 40.w,
      height: 40.h,
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
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: const Color(0xFF000000),
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
