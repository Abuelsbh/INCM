import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final IconData? icon;
  final bool isLoading;
  final String? loadingText;

  const AnimatedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.icon,
    this.isLoading = false,
    this.loadingText,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() {
        _isPressed = true;
      });
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _onTapEnd();
  }

  void _onTapCancel() {
    _onTapEnd();
  }

  void _onTapEnd() {
    if (_isPressed) {
      setState(() {
        _isPressed = false;
      });
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onPressed != null && !widget.isLoading 
          ? () {
              // Add haptic feedback
              // HapticFeedback.lightImpact();
              widget.onPressed!();
            }
          : null,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Container(
                width: widget.width,
                height: widget.height ?? 48.h,
                padding: widget.padding ?? EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 12.h,
                ),
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? const Color(0xFFF4ED47),
                  borderRadius: widget.borderRadius ?? BorderRadius.circular(8.r),
                  border: widget.borderColor != null
                      ? Border.all(
                          color: widget.borderColor!,
                          width: 1,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: (widget.backgroundColor ?? const Color(0xFFF4ED47))
                          .withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: widget.isLoading
                    ? _buildLoadingContent()
                    : _buildNormalContent(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 16.w,
          height: 16.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              widget.textColor ?? Colors.black,
            ),
          ),
        ),
        if (widget.loadingText != null) ...[
          SizedBox(width: 8.w),
          Text(
            widget.loadingText!,
            style: TextStyle(
              color: widget.textColor ?? Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNormalContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(
            widget.icon,
            color: widget.textColor ?? Colors.black,
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
        ],
        Text(
          widget.text,
          style: TextStyle(
            color: widget.textColor ?? Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// Specialized button variants
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? loadingText;
  final IconData? icon;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.loadingText,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      text: text,
      onPressed: onPressed,
      backgroundColor: const Color(0xFFF4ED47),
      textColor: Colors.black,
      width: width,
      isLoading: isLoading,
      loadingText: loadingText,
      icon: icon,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? loadingText;
  final IconData? icon;
  final double? width;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.loadingText,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      text: text,
      onPressed: onPressed,
      backgroundColor: Colors.transparent,
      textColor: const Color(0xFFF4ED47),
      borderColor: const Color(0xFFF4ED47),
      width: width,
      isLoading: isLoading,
      loadingText: loadingText,
      icon: icon,
    );
  }
}

class OutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? loadingText;
  final IconData? icon;
  final double? width;
  final Color? borderColor;
  final Color? textColor;

  const OutlineButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.loadingText,
    this.icon,
    this.width,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      text: text,
      onPressed: onPressed,
      backgroundColor: Colors.transparent,
      textColor: textColor ?? Colors.white,
      borderColor: borderColor ?? Colors.white.withOpacity(0.3),
      width: width,
      isLoading: isLoading,
      loadingText: loadingText,
      icon: icon,
    );
  }
}
