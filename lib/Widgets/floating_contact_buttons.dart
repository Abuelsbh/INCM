import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../generated/assets.dart';
import '../Utilities/contact_info.dart';
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
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
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
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          onTap: () => _sendEmail(ContactInfo.email),
                          backgroundColor: const Color(0xFFC63424),
                          useAsset: true,
                        ),
                      ),
                    ),
                  
                  if (_isExpanded) SizedBox(height: 12.h),
                  
                  // زر الواتساب
                  if (_isExpanded)
                    Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: _ContactButton(
                          icon: Assets.iconsCall,
                          onTap: () => _openWhatsApp(ContactInfo.whatsappNumber),
                          backgroundColor: const Color(0xFF4CAF50),
                          useAsset: true,
                          iconData: Icons.chat_bubble_outline,
                        ),
                      ),
                    ),
                  
                  if (_isExpanded) SizedBox(height: 12.h),
                  
                  // زر الاتصال
                  if (_isExpanded)
                    Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: _ContactButton(
                          icon: Assets.iconsCall,
                          onTap: () => _makePhoneCall(ContactInfo.phoneNumber),
                          backgroundColor: const Color(0xFFF4ED47),
                          iconColor: const Color(0xFFC63424),
                          useAsset: true,
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
  }
}

class _ContactButton extends StatefulWidget {
  final String icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color? iconColor;
  final bool useAsset;
  final IconData? iconData;


  const _ContactButton({
    Key? key,
    required this.icon,
    required this.onTap,
    required this.backgroundColor,
    this.useAsset = true,
    this.iconData, this.iconColor,
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
            width: MediaQuery.of(context).size.width < 600 ? 48.r : 60.r,
            height: MediaQuery.of(context).size.width < 600 ? 48.r : 60.r,
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
                      color: widget.iconColor ?? Colors.white,
                      size: MediaQuery.of(context).size.width < 600 ? 18.sp : 28.sp,
                    )
                  : widget.useAsset
                      ? Image.asset(
                          widget.icon,
                          width: MediaQuery.of(context).size.width < 600 ? 18.r : 28.r,
                          height: MediaQuery.of(context).size.width < 600 ? 18.r : 28.r,
                          color: widget.iconColor ?? Colors.white,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.error,
                              color: widget.iconColor ?? Colors.white,
                              size: 24.w,
                            );
                          },
                        )
                      : Icon(
                          Icons.phone,
                          color: widget.iconColor ?? Colors.white,
                          size: MediaQuery.of(context).size.width < 600 ? 18.sp : 28.sp,
                        ),
            ),
          ),
        ),
      ),
    );
  }
}

