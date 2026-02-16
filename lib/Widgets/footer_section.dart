import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Utilities/font_helper.dart';
import '../core/Language/app_languages.dart';
import '../generated/assets.dart';
import '../core/Language/locales.dart';
import '../core/Contact/contact_info_provider.dart';
import 'animated_contact_info.dart';
import 'package:provider/provider.dart';

class FooterSection extends StatefulWidget {
  const FooterSection({super.key});

  @override
  State<FooterSection> createState() => _FooterSectionState();
}

class _FooterSectionState extends State<FooterSection> with SingleTickerProviderStateMixin {
  late AnimationController _colorController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _colorAnimation = ColorTween(
      begin: const Color(0xFFFFFFFF), // أسود
      end: const Color(0xFFC63424), // أحمر
    ).animate(CurvedAnimation(
      parent: _colorController,
      curve: Curves.easeInOut,
    ));

    // تشغيل animation بشكل متكرر
    _colorController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _openLink(String link) async {
    final Uri googleMapsUri = Uri.parse(link);

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        height: 520.h,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesFooterDesktop),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 50.h,),
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
                        Builder(
                          builder: (context) {
                            final isArabic =
                                Provider.of<AppLanguage>(context, listen: false).appLang ==
                                    Languages.ar;
                            return isArabic ? Row(
                              children: [


                                AnimatedContactInfo(icon: Assets.iconsFace, text: '',isClickable: true,iconColor: const Color(0xFFF4ED47),
                                  onTap: () => _openLink('https://www.facebook.com/Incomercial.egypt'),iconSize: 40.r,),
                                SizedBox(width: 8.w),
                                AnimatedContactInfo(icon: Assets.iconsInsta, text: '',isClickable: true,iconColor: const Color(0xFFF4ED47),
                                  onTap: () => _openLink('https://www.instagram.com/incomercial.egypt/'),iconSize: 40.r,),
                                SizedBox(width: 8.w),
                                AnimatedContactInfo(icon: Assets.iconsLinked, text: '',isClickable: true,iconColor: const Color(0xFFF4ED47),
                                  onTap: () => _openLink('https://www.linkedin.com/company/incomercial-egypt/'),iconSize: 40.r,),
                                SizedBox(width: 8.w),
                                AnimatedContactInfo(icon: Assets.iconsTik, text: '',isClickable: true,iconColor: const Color(0xFFF4ED47),
                                  onTap: () => _openLink('https://www.tiktok.com/@incomercial.egypt'),iconSize: 40.r,),
                                SizedBox(width: 28.w),
                                Text(
                                  'FOLLOW_US'.tr(context),
                                  style: TextStyle(
                                    fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 42.sp,
                                  ),
                                ),
                              ],
                            ) : Row(
                              children: [
                                Text(
                                  'FOLLOW_US'.tr(context),
                                  style: TextStyle(
                                    fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 42.sp,
                                  ),
                                ),
                                SizedBox(width: 28.w),
                                AnimatedContactInfo(icon: Assets.iconsFace, text: '',isClickable: true,iconColor: const Color(0xFFF4ED47),
                                  onTap: () => _openLink('https://www.facebook.com/Incomercial.egypt'),iconSize: 40.r,),
                                SizedBox(width: 8.w),
                                AnimatedContactInfo(icon: Assets.iconsInsta, text: '',isClickable: true,iconColor: const Color(0xFFF4ED47),
                                  onTap: () => _openLink('https://www.instagram.com/incomercial.egypt/'),iconSize: 40.r,),
                                SizedBox(width: 8.w),
                                AnimatedContactInfo(icon: Assets.iconsLinked, text: '',isClickable: true,iconColor: const Color(0xFFF4ED47),
                                  onTap: () => _openLink('https://www.linkedin.com/company/incomercial-egypt/'),iconSize: 40.r,),
                                SizedBox(width: 8.w),
                                AnimatedContactInfo(icon: Assets.iconsTik, text: '',isClickable: true,iconColor: const Color(0xFFF4ED47),
                                  onTap: () => _openLink('https://www.tiktok.com/@incomercial.egypt'),iconSize: 40.r,),
                              ],
                            );
                          }
                        ),


                        SizedBox(height: 50.h),
      
                        // Contact information
                        Consumer<ContactInfoProvider>(
                          builder: (context, contactProvider, _) {
                            final info = contactProvider.contactInfo;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnimatedContactInfo(
                                  icon: Assets.iconsMail,
                                  text: info.email,
                                  textColor: const Color(0xFFFFFFFF),
                                  iconColor: const Color(0xFFF4ED47),
                                  isClickable: true,
                                  textSize: 28.sp,
                                  iconSize: 28.sp,
                                  onTap: () => _sendEmail(info.email),
                                ),
                                SizedBox(height: 16.h),
                                AnimatedContactInfo(
                                  icon: Assets.iconsLocation,
                                  text: info.address,
                                  textDirection: TextDirection.ltr,
                                  isClickable: true,
                                  textColor: const Color(0xFFFFFFFF),
                                  iconColor: const Color(0xFFF4ED47),
                                  textSize: 28.sp,
                                  iconSize: 28.sp,
                                  onTap: () => _openLink(info.mapLink),
                                ),
                                SizedBox(height: 16.h),
                                AnimatedContactInfo(
                                  icon: Assets.iconsCall,
                                  text: info.phone,
                                  isClickable: true,
                                  textSize: 28.sp,
                                  iconSize: 28.sp,
                                  textColor: const Color(0xFFFFFFFF),
                                  iconColor: const Color(0xFFF4ED47),
                                  onTap: () => _makePhoneCall(info.phone),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
      
                  // Right side - App download
                  Expanded(
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AnimatedBuilder(
                          animation: _colorController,
                          builder: (context, child) {
                            return Text(
                              'DOWNLOAD_OUR_APP'.tr(context),
                              style: TextStyle(
                                fontFamily: 'AloeveraDisplayBold',
                                color: _colorAnimation.value ?? const Color(0xFFFFFFFF),
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            );
                          },
                        ),
      
                        SizedBox(height: 10.h),
      
                        // QR Code placeholder
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
      
                            Container(
                              width: 60.w,
                              height: 60.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
      
                              ),
                              child: Center(
                                child: Image.asset(
                                  Assets.iconsGooglePlay,
                                  width: 60.w,
                                  height: 60.h,
                                ),
                              ),
                            ),
                            Gap(30.w),
                            Container(
                              width: 60.w,
                              height: 60.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
      
                              ),
                              child: Center(
                                child: Image.asset(
                                  Assets.iconsAppStore,
                                  width: 60.w,
                                  height: 60.h,
                                ),
                              ),
                            ),
                          ],
                        ),
      
                        // Image.asset(Assets.imagesDownloadAppStore,height: 80.h, width: 300.w,),
                        // Image.asset(Assets.imagesDownloadGooglePlay,height: 120.h, width: 450.w,)
      
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
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'INCOMERCIAL REAL ESTATE 2026',
                      style: TextStyle(
                        color: const Color(0xFFFFFFFF),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Gap(10.h),
                  Center(
                    child: _buildPoweredByText(),
                  ),
                ],
              ),
              ),
            ],
          ),
      ),
    );
  }

  // دالة لفتح البريد الإلكتروني
  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  // دالة لفتح رابط الاتصال
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  // Widget لبناء نص "Powered by E-CODE WAVE" مع تأثير hover
  Widget _buildPoweredByText() {
    return _ClickableTextSpan(
      onTap: () => _openLink('https://e-codewave.com/?utm_source=ig&utm_medium=social&utm_content=link_in_bio'),
      baseStyle: TextStyle(
        color: const Color(0xFFFFFFFF),
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),
      clickableText: 'E-CODE WAVE',
      prefixText: 'Powered by ',
    );
  }
}

// Widget مخصص لجعل جزء من النص فقط قابل للنقر مع hover effect
class _ClickableTextSpan extends StatefulWidget {
  final VoidCallback onTap;
  final TextStyle baseStyle;
  final String clickableText;
  final String prefixText;

  const _ClickableTextSpan({
    required this.onTap,
    required this.baseStyle,
    required this.clickableText,
    required this.prefixText,
  });

  @override
  State<_ClickableTextSpan> createState() => _ClickableTextSpanState();
}

class _ClickableTextSpanState extends State<_ClickableTextSpan> {
  bool _isHovered = false;
  final TapGestureRecognizer _tapRecognizer = TapGestureRecognizer();

  @override
  void initState() {
    super.initState();
    _tapRecognizer.onTap = widget.onTap;
  }

  @override
  void dispose() {
    _tapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      hitTestBehavior: HitTestBehavior.translucent,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: widget.baseStyle,
          children: [
            TextSpan(text: widget.prefixText),
            TextSpan(
              text: widget.clickableText,
              recognizer: _tapRecognizer,
              style: widget.baseStyle.copyWith(
                color: _isHovered ? const Color(0xFFC63424) : widget.baseStyle.color,
                decoration: _isHovered ? TextDecoration.underline : TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
