import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import '../generated/assets.dart';
import 'custom_button.dart';

class AnimatedLogosFooterV2 extends StatefulWidget {
  const AnimatedLogosFooterV2({super.key});

  @override
  State<AnimatedLogosFooterV2> createState() => _AnimatedLogosFooterV2State();
}

class _AnimatedLogosFooterV2State extends State<AnimatedLogosFooterV2>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  final List<String> companyLogos = [
    Assets.logosLogo2,
    Assets.logosLogo3,
    Assets.logosLogo4,
    Assets.logosLogo4,
    Assets.logosLogo2,
    Assets.logosLogo6,
  ];

  double scrollPosition = 0;
  double scrollSpeed = 1.5; // pixels per frame (تقدر تعدلها لتسريع أو تبطئة الحركة)

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 16)); // ~60fps
      if (_scrollController.hasClients) {
        scrollPosition += scrollSpeed;
        if (scrollPosition >= _scrollController.position.maxScrollExtent) {
          scrollPosition = 0;
          _scrollController.jumpTo(0);
        } else {
          _scrollController.jumpTo(scrollPosition);
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allLogos = [...companyLogos, ...companyLogos]; // مضاعفة للّوب السلس

    return Container(
      height: MediaQuery.of(context).size.width >= 600 ? 320.h : 260,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.imagesLogosBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Text(
              'OUR SUCCESS PARTNERS',
              style: TextStyle(
                color: const Color(0xFF8B0000),
                fontSize:  MediaQuery.of(context).size.width >= 600 ? 24.sp : 18.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ),

          // ✅ الشريط المتحرك للوجوهات
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: allLogos.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal:  MediaQuery.of(context).size.width >= 600 ? 40.w : 10.w),
                  child: _buildLogoItem(allLogos[index]),
                );
              },
            ),
          ),

          MediaQuery.of(context).size.width >= 600 ? ButtonStyles.learnMoreButton(
            onPressed: () {},
          ) : ButtonStyles.learnMoreButtonMob(
              onPressed: () {},
          ),
          Gap(30.h),
        ],
      ),
    );
  }

  Widget _buildLogoItem(String logoPath) {
    return Container(
      width:  MediaQuery.of(context).size.width >= 600 ? 120.w : 60.w,
      height: 60.h,
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child:  Builder(
          builder: (_) {
            try {
              return SvgPicture.asset(logoPath, width: 200.w,
                  height: 200.h, fit: BoxFit.contain);
            } catch (e) {
              debugPrint('Error loading $logoPath: $e');
              return const Icon(Icons.error, color: Colors.red);
            }
          },
        ),
      ),
    );
  }
}
