import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/custom_app_bar_mob.dart';
import '../../generated/assets.dart';
import '../../core/Language/locales.dart';

class AllLogosScreen extends StatelessWidget {
  static const String routeName = '/all-logos';

  const AllLogosScreen({Key? key}) : super(key: key);

  // Group logos by service
  Map<String, List<String>> _getLogosByService() {
    return {
      'CONSULTATION': [
        'assets/logos/consultation/consultation1.png',
        'assets/logos/consultation/2.png',
        'assets/logos/consultation/3.png',
        'assets/logos/consultation/4.png',
        'assets/logos/consultation/5.png',
        'assets/logos/consultation/6.png',
        'assets/logos/consultation/7.png',
        'assets/logos/consultation/8.png',
        'assets/logos/consultation/9.png',
        'assets/logos/consultation/10.png',
        'assets/logos/consultation/11.png',
        'assets/logos/consultation/12.png',
        'assets/logos/consultation/13.png',
        'assets/logos/consultation/14.png',
        'assets/logos/consultation/15.png',
        'assets/logos/consultation/16.png',
        'assets/logos/consultation/17.png',
        'assets/logos/consultation/18.png',
        'assets/logos/consultation/19.png',
        'assets/logos/consultation/20.png',
        'assets/logos/consultation/21.png',
        'assets/logos/consultation/22.png',
        'assets/logos/consultation/23.png',
        'assets/logos/consultation/24.png',
        'assets/logos/consultation/25.png',
        'assets/logos/consultation/26.png',
        'assets/logos/consultation/27.png',
        'assets/logos/consultation/28.png',
        'assets/logos/consultation/29.png',
        'assets/logos/consultation/30.png',
        'assets/logos/consultation/31.png',
        'assets/logos/consultation/32.png',
        'assets/logos/consultation/33.png',
        'assets/logos/consultation/34.png',
        'assets/logos/consultation/35.png',
        'assets/logos/consultation/36.png',
        'assets/logos/consultation/37.png',
        'assets/logos/consultation/38.png',
        'assets/logos/consultation/39.png',
        'assets/logos/consultation/40.png',
      ],
      'FACILITY_MANAGEMENT': [
        'assets/logos/facility/aisle.png',
        'assets/logos/facility/ariana.png',
        'assets/logos/facility/attracta.png',
        'assets/logos/facility/b.png',
        'assets/logos/facility/break-yard.png',
        'assets/logos/facility/capitaal.png',
        'assets/logos/facility/capital.png',
        'assets/logos/facility/cloudnine.png',
        'assets/logos/facility/eleven.png',
        'assets/logos/facility/five.png',
        'assets/logos/facility/gar..png',
        'assets/logos/facility/glitz.png',
        'assets/logos/facility/itiz.png',
        'assets/logos/facility/jaya.png',
        'assets/logos/facility/kernel.png',
        'assets/logos/facility/mall.png',
        'assets/logos/facility/neux.png',
        'assets/logos/facility/nova.png',
        'assets/logos/facility/rayan.png',
        'assets/logos/facility/see90.png',
        'assets/logos/facility/solaria.png',
        'assets/logos/facility/star.png',
        'assets/logos/facility/terrace.png',
        'assets/logos/facility/umc.png',
        'assets/logos/facility/v.png',
        'assets/logos/facility/vitali.png',
        'assets/logos/facility/voco-mall.png',
        'assets/logos/facility/zoom.png',
        'assets/logos/facility/Untitled-1.png',
        'assets/logos/facility/نبض.png',
      ],
      'FRANCHISE_INVESTMENT': [
        'assets/logos/franchise/2.png',
        'assets/logos/franchise/3.png',
        'assets/logos/franchise/4.png',
        'assets/logos/franchise/5.png',
        'assets/logos/franchise/6.png',
        'assets/logos/franchise/7.png',
        'assets/logos/franchise/8.png',
        'assets/logos/franchise/9.png',
        'assets/logos/franchise/10.png',
        'assets/logos/franchise/11.png',
        'assets/logos/franchise/12.png',
        'assets/logos/franchise/13.png',
        'assets/logos/franchise/14.png',
        'assets/logos/franchise/Untitled-1.png',
      ],
      'PRIMARY_INVESTMENT': [
        'assets/logos/primary/1.png',
        'assets/logos/primary/2.png',
        'assets/logos/primary/3.png',
        'assets/logos/primary/4.png',
        'assets/logos/primary/5.png',
        'assets/logos/primary/6.png',
        'assets/logos/primary/7.png',
        'assets/logos/primary/8.png',
        'assets/logos/primary/9.png',
        'assets/logos/primary/10.png',
        'assets/logos/primary/11.png',
        'assets/logos/primary/12.png',
      ],
      'RETAIL_LEASING': [
        'assets/logos/retail/1.png',
        'assets/logos/retail/2.png',
        'assets/logos/retail/3.png',
        'assets/logos/retail/4.png',
        'assets/logos/retail/5.png',
        'assets/logos/retail/6.png',
        'assets/logos/retail/7.png',
        'assets/logos/retail/8.png',
        'assets/logos/retail/9.png',
      ],
      'MARKETING': [
        'assets/logos/marketing/1.png',
        'assets/logos/marketing/2.png',
        'assets/logos/marketing/3.png',
        'assets/logos/marketing/4.png',
        'assets/logos/marketing/5.png',
        'assets/logos/marketing/6.png',
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final logosByService = _getLogosByService();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: isMobile ? 80.h : 120.h),
                // Title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: Text(
                    'OUR CLIENTS',
                    style: TextStyle(
                      fontFamily: 'OptimalBold',
                      color: const Color(0xFFF4ED47),
                      fontSize: isMobile ? 28.sp : 60.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                // Logos grouped by service
                ...logosByService.entries.map((entry) {
                  final serviceName = entry.key;
                  final logos = entry.value;
                  
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: isMobile ? 30.h : 50.h,
                      left: isMobile ? 12.w : 40.w,
                      right: isMobile ? 12.w : 40.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Service Title
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: isMobile ? 15.h : 25.h,
                            left: isMobile ? 8.w : 0,
                          ),
                          child: Text(
                            serviceName.tr(context),
                            style: TextStyle(
                              fontFamily: 'OptimalBold',
                              color: const Color(0xFFF4ED47),
                              fontSize: isMobile ? 22.sp : 40.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        // Logos Grid for this service
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isMobile ? 2 : 4,
                            crossAxisSpacing: isMobile ? 12.w : 30.w,
                            mainAxisSpacing: isMobile ? 12.h : 30.h,
                            childAspectRatio: isMobile ? 1.2 : 1.5,
                          ),
                          itemCount: logos.length,
                          itemBuilder: (context, index) {
                            return _buildLogoItem(
                              context,
                              logos[index],
                              isMobile,
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
                SizedBox(height: isMobile ? 40.h : 80.h),
              ],
            ),
          ),
          // App Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: isMobile
                ? const CustomAppBarMob()
                : const CustomAppBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoItem(BuildContext context, String logoPath, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 8.w : 16.w),
      decoration: BoxDecoration(
        color: Colors.grey[900]!.withOpacity(0.4),
        borderRadius: BorderRadius.circular(isMobile ? 12.r : 20.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Builder(
        builder: (_) {
          try {
            // Try SVG first
            if (logoPath.toLowerCase().endsWith('.svg')) {
              return SvgPicture.asset(
                logoPath,
                fit: BoxFit.contain,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              );
            } else {
              // Try Image
              return Image.asset(
                logoPath,
                fit: BoxFit.contain,
              );
            }
          } catch (e) {
            debugPrint('Error loading logo $logoPath: $e');
            return Icon(
              Icons.business,
              color: Colors.white.withOpacity(0.5),
              size: isMobile ? 30.sp : 50.sp,
            );
          }
        },
      ),
    );
  }
}

