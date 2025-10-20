import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Widget منفصل للتأثيرات الحركية
class AnimatedContactInfo extends StatefulWidget {
  final String icon;
  final String text;
  final bool isClickable;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? textColor;
  final double? iconSize;
  final double? textSize;

  const AnimatedContactInfo({
    Key? key,
    required this.icon,
    required this.text,
    this.isClickable = false,
    this.onTap, this.iconColor, this.textColor, this.iconSize, this.textSize,
  }) : super(key: key);

  @override
  State<AnimatedContactInfo> createState() => _AnimatedContactInfoState();
}

class _AnimatedContactInfoState extends State<AnimatedContactInfo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.2), // يتحرك للأعلى قليلاً
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = ColorTween(
      begin: widget.textColor ?? const Color(0xFF000000),
      end: const Color(0xFFC63424), // يتغير للون الأحمر
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.isClickable && widget.onTap != null) {
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: MouseRegion(
        cursor: widget.isClickable ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (_) {
          if (widget.isClickable) {
            _controller.forward();
          }
        },
        onExit: (_) {
          if (widget.isClickable) {
            _controller.reverse();
          }
        },
        child: GestureDetector(
          onTap: _handleTap,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _offsetAnimation.value.dy * 10), // تحريك بسيط
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      widget.icon,
                      height: widget.iconSize ?? 22.r,
                      width: widget.iconSize ?? 22.r,
                      color: widget.iconColor ?? Colors.black, // لون ثابت للأيقونة
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.email, // أيقونة بديلة
                          color: widget.iconColor ?? Colors.black,
                          size: widget.iconSize ?? 22.r,
                        );
                      },
                    ),
                    SizedBox(width: 12.w),
                    Flexible(
                      child: Text(
                        widget.text,
                        style: TextStyle(
                          color: _colorAnimation.value ?? Colors.black,
                          fontSize: widget.textSize ?? 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
