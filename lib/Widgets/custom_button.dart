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
              ? (widget.hoverBackgroundColor ?? const Color(0xFF8B0000))
              : (widget.normalBackgroundColor ?? const Color(0xFFFFC700)),
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
                ? (widget.hoverTextColor ?? const Color(0xFFFFC700))
                : (widget.normalTextColor ?? Colors.black),
            padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 4.r),
            ),
            elevation: 0,
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: widget.fontSize ?? 18.sp,
              fontWeight: widget.fontWeight ?? FontWeight.bold,
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
      text: 'EXPLORE US',
      onPressed: onPressed,
      enabled: enabled,
      normalBackgroundColor: const Color(0xFFFFC700),
      normalTextColor: Colors.black,
      hoverBackgroundColor: const Color(0xFF8B0000),
      hoverTextColor: const Color(0xFFFFC700),
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
      normalBackgroundColor: const Color(0xFF8B0000),
      normalTextColor: Colors.white,
      hoverBackgroundColor: const Color(0xFFFFC700),
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
      normalTextColor: const Color(0xFFFFC700),
      hoverBackgroundColor: const Color(0xFFFFC700),
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
      borderRadius: 24.r,
      enabled: enabled,
      normalBackgroundColor: const Color(0xFF8B0000),
      normalTextColor: const Color(0xFFFFC700),
      hoverBackgroundColor: const Color(0xFFFFC700),
      hoverTextColor: const Color(0xFF8B0000),
      fontSize: 18.sp,
    );
  }

  static Widget submitButton({
    required VoidCallback onPressed,
    bool enabled = true,
    double? width,
  }) {
    return CustomButton(
      text: 'SUBMIT',
      onPressed: onPressed,
      enabled: enabled,
      width: width ?? double.infinity,
      normalBackgroundColor: const Color(0xFF8B0000),
      normalTextColor: Colors.white,
      hoverBackgroundColor: const Color(0xFFFFC700),
      hoverTextColor: Colors.black,
      fontSize: 16.sp,
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
    );
  }
}
