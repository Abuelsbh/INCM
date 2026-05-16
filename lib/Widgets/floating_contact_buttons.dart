import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../generated/assets.dart';
import '../core/Contact/contact_info_provider.dart';
import '../core/Contact/contact_launch.dart';
import 'main_contact_button.dart';

class FloatingContactButtons extends StatefulWidget {
  const FloatingContactButtons({Key? key}) : super(key: key);

  @override
  State<FloatingContactButtons> createState() => _FloatingContactButtonsState();
}

class _FloatingContactButtonsState extends State<FloatingContactButtons>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.125).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  // دالة لفتح رابط الاتصال
  Future<void> _makePhoneCall(String phoneNumber) async {
    await launchContactPhone(context, phoneNumber);
  }

  // دالة لفتح الواتساب
  Future<void> _openWhatsApp(String phoneNumber) async {
    final Uri launchUri = Uri.parse('https://wa.me/$phoneNumber');
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    }
  }

  // دالة لفتح البريد الإلكتروني
  Future<void> _sendEmail(String email) async {
    await launchContactEmail(email);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactInfoProvider>(
      builder: (context, contactProvider, _) {
        final info = contactProvider.contactInfo;
        return Positioned(
          left: 20.w,
          bottom: 30.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // الأيقونات المتوسعة
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // زر البريد الإلكتروني
                      if (_isExpanded)
                        Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Opacity(
                            opacity: _fadeAnimation.value,
                            child: _ContactButton(
                              icon: Assets.iconsMail,
                              onTap: () => _sendEmail(info.email),
                              backgroundColor: const Color(0xFFC63424),
                              useAsset: true,
                            ),
                          ),
                        ),

                      if (_isExpanded) SizedBox(height: 12.h),

                      // زر الاتصال الهاتفي (tel:)
                      if (_isExpanded)
                        Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Opacity(
                            opacity: _fadeAnimation.value,
                            child: _ContactButton(
                              icon: Assets.iconsCall,
                              onTap: () => _makePhoneCall(info.phone),
                              backgroundColor: const Color(0xFFF4ED47),
                              useAsset: true,
                              iconData: Icons.call,
                            ),
                          ),
                        ),

                      if (_isExpanded) SizedBox(height: 12.h),

                      // واتساب (https://wa.me/<رقم بدون +>)
                      if (_isExpanded)
                        Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Opacity(
                            opacity: _fadeAnimation.value,
                            child: _ContactButton(
                              onTap: () => _openWhatsApp(info.whatsapp),
                              backgroundColor: const Color(0xFF25D366),
                              useAsset: false,
                            ),
                          ),
                        ),

                      if (_isExpanded) SizedBox(height: 12.h),
                    ],
                  );
                },
              ),

              // الزر الرئيسي
              MainContactButton(
                onTap: _toggleExpansion,
                isExpanded: _isExpanded,
                rotationAnimation: _rotationAnimation,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ContactButton extends StatefulWidget {
  final String? icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final bool useAsset;
  final IconData? iconData;
  final String? icon2;

  const _ContactButton({
    Key? key,
    this.icon,
    required this.onTap,
    required this.backgroundColor,
    this.useAsset = true,
    this.iconData,
    this.icon2,
  }) : super(key: key);

  @override
  State<_ContactButton> createState() => _ContactButtonState();
}

class _ContactButtonState extends State<_ContactButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _controller.forward();
      },
      onExit: (_) {
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: widget.backgroundColor.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: widget.iconData != null
                  ? Icon(
                      widget.iconData,
                      color: Colors.white,
                      size: 24.w,
                    )
                  : widget.useAsset
                      ? Image.asset(
                          widget.icon??Assets.imagesWhatsapp,
                          width: 24.w,
                          height: 24.w,
                          color: Colors.white,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.error,
                              color: Colors.white,
                              size: 24.w,
                            );
                          },
                        )
                      : SvgPicture.asset(
                Assets.imagesWhatsapp,
                width: 24.w,
                height: 24.w,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

