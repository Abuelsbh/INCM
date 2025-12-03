import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class ClientsLogosSection extends StatefulWidget {
  final List<String> logos;
  final Color? titleColor;
  final Color? backgroundColor;
  final double? logoWidth;
  final double? logoHeight;
  final int visibleLogosCount;

  const ClientsLogosSection({
    super.key,
    required this.logos,
    this.titleColor,
    this.backgroundColor,
    this.logoWidth,
    this.logoHeight,
    this.visibleLogosCount = 5,
  });

  @override
  State<ClientsLogosSection> createState() => _ClientsLogosSectionState();
}

class _ClientsLogosSectionState extends State<ClientsLogosSection> {
  final ScrollController _scrollController = ScrollController();
  bool _showArrows = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfArrowsNeeded();
    });
    _scrollController.addListener(_onScroll);
  }

  void _checkIfArrowsNeeded() {
    if (_scrollController.hasClients) {
      setState(() {
        _showArrows = widget.logos.length > widget.visibleLogosCount;
      });
    }
  }

  void _onScroll() {
    setState(() {});
  }

  void _scrollLeft() {
    if (_scrollController.hasClients) {
      final currentPosition = _scrollController.position.pixels;
      final scrollAmount = MediaQuery.of(context).size.width * 0.3;
      final newPosition = (currentPosition - scrollAmount).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );
      _scrollController.animateTo(
        newPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollRight() {
    if (_scrollController.hasClients) {
      final currentPosition = _scrollController.position.pixels;
      final scrollAmount = MediaQuery.of(context).size.width * 0.3;
      final newPosition = (currentPosition + scrollAmount).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );
      _scrollController.animateTo(
        newPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool get _canScrollLeft {
    if (!_scrollController.hasClients) return false;
    return _scrollController.position.pixels > 0;
  }

  bool get _canScrollRight {
    if (!_scrollController.hasClients) return false;
    return _scrollController.position.pixels <
        _scrollController.position.maxScrollExtent;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final titleColor = widget.titleColor ?? const Color(0xFFF4ED47);
    final backgroundColor = widget.backgroundColor ?? Colors.grey[900]!.withOpacity(0.4);
    final logoWidth = widget.logoWidth ?? (isMobile ? 40.w : 180.w);
    final logoHeight = widget.logoHeight ?? (isMobile ? 30.h : 80.h);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: isMobile ? 0.h :30.h),
          child: Text(
            'OUR CLIENTS',
            style: TextStyle(
              fontFamily: 'OptimalBold',
              color: titleColor,
              fontSize: isMobile ? 24.sp : 60.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),

        Gap(12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: isMobile ? 8.h : 20.h,horizontal: isMobile ? 8.h : 20.w),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: Column(
            children: [
              // Logos Container with Arrows
              Stack(
                alignment: Alignment.center,
                children: [
                  // Logos List
                  Container(
                    height: logoHeight + (isMobile ? 14.h : 40.h),
                    margin: EdgeInsets.symmetric(horizontal: _showArrows ? isMobile ? 32.w : 60.w : 0),
                    child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: widget.logos.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: isMobile ? 4.w : 25.w,
                          ),
                          width: logoWidth,
                          height: logoHeight,
                          child: _buildLogoItem(widget.logos[index], logoWidth, logoHeight),
                        );
                      },
                    ),
                  ),

                  // Left Arrow
                  if (_showArrows)
                    Positioned(
                      left: 0,
                      child: _buildArrowButton(
                        icon: Icons.arrow_back_ios,
                        onPressed: _canScrollLeft ? _scrollLeft : null,
                      ),
                    ),

                  // Right Arrow
                  if (_showArrows)
                    Positioned(
                      right: 0,
                      child: _buildArrowButton(
                        icon: Icons.arrow_forward_ios,
                        onPressed: _canScrollRight ? _scrollRight : null,
                      ),
                    ),
                ],
              ),
            ],
          ),
        )

      ],
    );




  }

  Widget _buildLogoItem(String logoPath, double width, double height) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(isMobile ? 2.w : 8.w),
      child: Builder(
        builder: (_) {
          try {
            // Try SVG first
            if (logoPath.toLowerCase().endsWith('.svg')) {
              return SvgPicture.asset(
                logoPath,
                width: width,
                height: height,
                fit: BoxFit.contain,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              );
            } else {
              // Try Image
              return Image.asset(
                logoPath,
                width: width,
                height: height,
                fit: BoxFit.contain,
              );
            }
          } catch (e) {
            debugPrint('Error loading logo $logoPath: $e');
            return Icon(
              Icons.business,
              color: Colors.white.withOpacity(0.5),
              size: width * 0.5,
            );
          }
        },
      ),
    );
  }

  Widget _buildArrowButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30.r),
        child: Container(
          width: isMobile ? 34.r: 50.r,
          height: isMobile ? 34.r: 50.r,
          decoration: BoxDecoration(
            color: onPressed != null
                ? Colors.white.withOpacity(0.2)
                : Colors.white.withOpacity(0.05),
            shape: BoxShape.circle,
            border: Border.all(
              color: onPressed != null
                  ? Colors.white.withOpacity(0.3)
                  : Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: onPressed != null
                ? Colors.white
                : Colors.white.withOpacity(0.3),
            size: isMobile ? 14 .sp : 24.sp,
          ),
        ),
      ),
    );
  }
}








