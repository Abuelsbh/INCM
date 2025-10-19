import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// الزر الرئيسي الذي يتوسع
class MainContactButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isExpanded;
  final Animation<double> rotationAnimation;

  const MainContactButton({
    Key? key,
    required this.onTap,
    required this.isExpanded,
    required this.rotationAnimation,
  }) : super(key: key);

  @override
  State<MainContactButton> createState() => _MainContactButtonState();
}

class _MainContactButtonState extends State<MainContactButton>
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
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedBuilder(
                animation: widget.rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: widget.rotationAnimation.value * 2 * 3.14159, // دوران 45 درجة
                    child: Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC63424),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Color(0x66C63424),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          widget.isExpanded ? Icons.close : Icons.call,
                          color: const Color(0xFFF4ED47),
                          size: 28.sp,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
