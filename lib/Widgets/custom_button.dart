import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? normalBackgroundColor;
  final Color? normalTextColor;
  final Color? hoverBackgroundColor;
  final Color? hoverTextColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? letterSpacing;
  final List<BoxShadow>? boxShadow;
  final bool enabled;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.normalBackgroundColor,
    this.normalTextColor,
    this.hoverBackgroundColor,
    this.hoverTextColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.fontSize,
    this.fontWeight,
    this.letterSpacing,
    this.boxShadow,
    this.enabled = true,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (widget.enabled) {
          setState(() {
            isHovering = true;
          });
        }
      },
      onExit: (_) {
        if (widget.enabled) {
          setState(() {
            isHovering = false;
          });
        }
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: isHovering 
              ? (widget.hoverBackgroundColor ?? const Color(0xFFC63424))
              : (widget.normalBackgroundColor ?? const Color(0xFFF4ED47)),
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 4.r),
          boxShadow: widget.boxShadow ?? [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: widget.enabled ? widget.onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: isHovering 
                ? (widget.hoverTextColor ?? const Color(0xFFF4ED47))
                : (widget.normalTextColor ?? Colors.black),
            padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 4.r),
            ),
            elevation: 0,
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              fontFamily: 'OptimalBold',
              fontSize: widget.fontSize ?? 18.sp,
              fontWeight: widget.fontWeight ?? FontWeight.w900,
              letterSpacing: widget.letterSpacing ?? 0.8,
            ),
          ),
        ),
      ),
    );
  }
}

// Predefined button styles for common use cases
class ButtonStyles {
  static Widget exploreUsButton({
    required VoidCallback onPressed,
    bool enabled = true,
  }) {
    return CustomButton(
      text: 'CONTACT US',
      onPressed: onPressed,
      enabled: enabled,
      normalBackgroundColor: const Color(0xFFF4ED47),
      normalTextColor: Colors.black,
      hoverBackgroundColor: const Color(0xFFC63424),
      hoverTextColor: const Color(0xFFF4ED47),
      fontSize: 20.sp,
      fontWeight: FontWeight.w900,
    );
  }

  static Widget getAppButton({
    required VoidCallback onPressed,
    bool enabled = true,
    double? width,
  }) {
    return CustomButton(
      text: 'GET APP',
      onPressed: onPressed,
      enabled: enabled,
      normalBackgroundColor: const Color(0xFFF4ED47),
      normalTextColor: Colors.black,
      hoverBackgroundColor: const Color(0xFFC63424),
      hoverTextColor: const Color(0xFFF4ED47),
      fontSize: 11.sp,
      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
      width: width,
      fontWeight: FontWeight.w900,
    );
  }

  static Widget primaryButton({
    required String text,
    required VoidCallback onPressed,
    bool enabled = true,
    double? width,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      enabled: enabled,
      width: width,
      normalBackgroundColor: const Color(0xFFC63424),
      normalTextColor: Colors.white,
      hoverBackgroundColor: const Color(0xFFF4ED47),
      hoverTextColor: Colors.black,
    );
  }

  static Widget secondaryButton({
    required String text,
    required VoidCallback onPressed,
    bool enabled = true,
    double? width,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      enabled: enabled,
      width: width,
      normalBackgroundColor: Colors.transparent,
      normalTextColor: const Color(0xFFF4ED47),
      hoverBackgroundColor: const Color(0xFFF4ED47),
      hoverTextColor: Colors.black,
      boxShadow: [],
    );
  }

  static Widget learnMoreButton({
    required VoidCallback onPressed,
    bool enabled = true,
  }) {
    return CustomButton(
      text: 'LEARN MORE',
      onPressed: onPressed,
      borderRadius: 12.r,
      enabled: enabled,
      normalBackgroundColor: const Color(0xFFC63424),
      normalTextColor: const Color(0xFFF4ED47),
      hoverBackgroundColor: const Color(0xFFF4ED47),
      hoverTextColor: const Color(0xFFC63424),
      fontSize: 24.sp,
    );
  }

  static Widget learnMoreButtonMob({
    required VoidCallback onPressed,
    bool enabled = true,
  }) {
    return CustomButton(
      text: 'LEARN MORE',
      onPressed: onPressed,
      borderRadius: 8.r,
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
      width: 100.w,
      enabled: enabled,
      normalBackgroundColor: const Color(0xFFC63424),
      normalTextColor: const Color(0xFFF4ED47),
      hoverBackgroundColor: const Color(0xFFF4ED47),
      hoverTextColor: const Color(0xFFC63424),
      fontSize: 12.sp,
    );
  }

  static Widget submitButton({
    required VoidCallback onPressed,
    bool enabled = true,
    double? width,
    double? fontSize,
  }) {
    return CustomButton(
      text: 'SUBMIT',
      onPressed: onPressed,
      enabled: enabled,
      width: width ?? double.infinity,
      normalBackgroundColor: const Color(0xFFC63424),
      normalTextColor:  const Color(0xFFF4ED47),
      hoverBackgroundColor: const Color(0xFFF4ED47),
      hoverTextColor: const Color(0xFFC63424),
      fontSize: fontSize??26.sp,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
    );
  }

  static Widget submitButtonMob({
    required VoidCallback onPressed,
    bool enabled = true,
    double? width,
  }) {
    return CustomButton(
      text: 'SUBMIT',
      onPressed: onPressed,
      enabled: enabled,
      borderRadius: 2.r,
      width: width ?? double.infinity,
      normalBackgroundColor: const Color(0xFFC63424),
      normalTextColor:  const Color(0xFFF4ED47),
      hoverBackgroundColor: const Color(0xFFF4ED47),
      hoverTextColor: const Color(0xFFC63424),
      fontSize: 18.sp,
    );
  }
}
