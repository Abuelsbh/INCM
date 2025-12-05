import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/custom_app_bar_mob.dart';
import '../../generated/assets.dart';

class AllLogosScreen extends StatelessWidget {
  static const String routeName = '/all-logos';

  const AllLogosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    // All logos list
    final allLogos = [
      // Consultation logos (40)
      Assets.logosConsultation1,
      Assets.logosConsultation2,
      Assets.logosConsultation3,
      Assets.logosConsultation4,
      Assets.logosConsultation5,
      Assets.logosConsultation6,
      Assets.logosConsultation7,
      Assets.logosConsultation8,
      Assets.logosConsultation9,
      Assets.logosConsultation10,
      Assets.logosConsultation11,
      Assets.logosConsultation12,
      Assets.logosConsultation13,
      Assets.logosConsultation14,
      Assets.logosConsultation15,
      Assets.logosConsultation16,
      Assets.logosConsultation17,
      Assets.logosConsultation18,
      Assets.logosConsultation19,
      Assets.logosConsultation20,
      Assets.logosConsultation21,
      Assets.logosConsultation22,
      Assets.logosConsultation23,
      Assets.logosConsultation24,
      Assets.logosConsultation25,
      Assets.logosConsultation26,
      Assets.logosConsultation27,
      Assets.logosConsultation28,
      Assets.logosConsultation29,
      Assets.logosConsultation30,
      Assets.logosConsultation31,
      Assets.logosConsultation32,
      Assets.logosConsultation33,
      Assets.logosConsultation34,
      Assets.logosConsultation35,
      Assets.logosConsultation36,
      Assets.logosConsultation37,
      Assets.logosConsultation38,
      Assets.logosConsultation39,
      Assets.logosConsultation40,
      // Facility logos (29)
      Assets.logosFacilityAisle,
      Assets.logosFacilityAriana,
      Assets.logosFacilityAttracta,
      Assets.logosFacilityB,
      Assets.logosFacilityBreakYard,
      Assets.logosFacilityCapitaal,
      Assets.logosFacilityCapital,
      Assets.logosFacilityCloudnine,
      Assets.logosFacilityEleven,
      Assets.logosFacilityFive,
      Assets.logosFacilityGar,
      Assets.logosFacilityGlitz,
      Assets.logosFacilityItiz,
      Assets.logosFacilityJaya,
      Assets.logosFacilityKernel,
      Assets.logosFacilityMall,
      Assets.logosFacilityNeux,
      Assets.logosFacilityNova,
      Assets.logosFacilityRayan,
      Assets.logosFacilitySee90,
      Assets.logosFacilitySolaria,
      Assets.logosFacilityStar,
      Assets.logosFacilityTerrace,
      Assets.logosFacilityUmc,
      Assets.logosFacilityV,
      Assets.logosFacilityVitali,
      Assets.logosFacilityVocoMall,
      Assets.logosFacilityZoom,
      Assets.logosFacilityUntitled1,
      Assets.logosFacilityNabed,
      // Franchise logos (14)
      Assets.logosFranchise2,
      Assets.logosFranchise3,
      Assets.logosFranchise4,
      Assets.logosFranchise5,
      Assets.logosFranchise6,
      Assets.logosFranchise7,
      Assets.logosFranchise8,
      Assets.logosFranchise9,
      Assets.logosFranchise10,
      Assets.logosFranchise11,
      Assets.logosFranchise12,
      Assets.logosFranchise13,
      Assets.logosFranchise14,
      Assets.logosFranchiseUntitled1,
      // Primary logos (12)
      Assets.logosPrimary1,
      Assets.logosPrimary2,
      Assets.logosPrimary3,
      Assets.logosPrimary4,
      Assets.logosPrimary5,
      Assets.logosPrimary6,
      Assets.logosPrimary7,
      Assets.logosPrimary8,
      Assets.logosPrimary9,
      Assets.logosPrimary10,
      Assets.logosPrimary11,
      Assets.logosPrimary12,
      // Retail logos (9)
      Assets.logosRetail1,
      Assets.logosRetail2,
      Assets.logosRetail3,
      Assets.logosRetail4,
      Assets.logosRetail5,
      Assets.logosRetail6,
      Assets.logosRetail7,
      Assets.logosRetail8,
      Assets.logosRetail9,
      // Marketing logos (6)
      Assets.logosMarketing1,
      Assets.logosMarketing2,
      Assets.logosMarketing3,
      Assets.logosMarketing4,
      Assets.logosMarketing5,
      Assets.logosMarketing6,
    ];

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
                // Logos Grid
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 12.w : 40.w),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isMobile ? 2 : 4,
                      crossAxisSpacing: isMobile ? 12.w : 30.w,
                      mainAxisSpacing: isMobile ? 12.h : 30.h,
                      childAspectRatio: isMobile ? 1.2 : 1.5,
                    ),
                    itemCount: allLogos.length,
                    itemBuilder: (context, index) {
                      return _buildLogoItem(
                        context,
                        allLogos[index],
                        isMobile,
                      );
                    },
                  ),
                ),
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

