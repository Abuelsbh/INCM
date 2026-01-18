import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScrollToTopButton extends StatefulWidget {
  final ScrollController scrollController;

  const ScrollToTopButton({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<ScrollToTopButton> createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<ScrollToTopButton>
    with SingleTickerProviderStateMixin {
  bool _showButton = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    
    // إعداد الـ Animation Controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    // الاستماع لتغيرات التمرير
    widget.scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // إظهار الزر عندما يتم التمرير لأكثر من 200 بكسل
    if (widget.scrollController.offset > 200 && !_showButton) {
      setState(() {
        _showButton = true;
      });
      _animationController.forward();
    } else if (widget.scrollController.offset <= 200 && _showButton) {
      setState(() {
        _showButton = false;
      });
      _animationController.reverse();
    }
  }

  void _scrollToTop() {
    widget.scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return _showButton
            ? Positioned(
                right: 20.w,
                bottom: 30.h,
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: _AnimatedArrowButton(
                      onTap: _scrollToTop,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }
}

class _AnimatedArrowButton extends StatefulWidget {
  final VoidCallback onTap;

  const _AnimatedArrowButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  State<_AnimatedArrowButton> createState() => _AnimatedArrowButtonState();
}

class _AnimatedArrowButtonState extends State<_AnimatedArrowButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _bounceAnimation = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
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
        child:AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _bounceAnimation.value),
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4ED47),
                    borderRadius: BorderRadius.circular(10), // 🔹 هنا الكيرف
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x66C63424),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.keyboard_arrow_up_rounded,
                      color: const Color(0xFFC63424),
                      size: 36.sp,
                    ),
                  ),
                ),
              ),
            );
          },
        )

      ),
    );
  }
}

