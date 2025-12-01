import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildFileOrLinkField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isMobile;
  final bool isTablet;
  final double? height;
  final void Function() onUploadTap;

  const BuildFileOrLinkField(
    this.label, {
    super.key,
    required this.controller,
    required this.isMobile,
    required this.isTablet,
    this.height,
    required this.onUploadTap,
  });

  @override
  State<BuildFileOrLinkField> createState() => _BuildFileOrLinkFieldState();
}

class _BuildFileOrLinkFieldState extends State<BuildFileOrLinkField> {
  bool _hasValue = false;

  @override
  void initState() {
    super.initState();
    _hasValue = widget.controller.text.isNotEmpty;
    widget.controller.addListener(_updateValue);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateValue);
    super.dispose();
  }

  void _updateValue() {
    final hasValue = widget.controller.text.isNotEmpty;
    if (_hasValue != hasValue) {
      setState(() {
        _hasValue = hasValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontFamily: 'AloeveraDisplayBold',
            color: const Color(0xFFF4ED47),
            fontSize: widget.isMobile ? 16.sp : (widget.isTablet ? 22.sp : 28.sp),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: widget.isMobile ? 0 : 8.h),

        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: widget.height ?? (widget.isMobile ? 36.h : (widget.isTablet ? 60.h : 65.h)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: _hasValue
                ? const Color(0xFFF4ED47).withOpacity(0.5)
                : Colors.grey[300]!,
              width: _hasValue ? 2 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _hasValue
                  ? const Color(0xFFF4ED47).withOpacity(0.2)
                  : Colors.black.withOpacity(0.05),
                blurRadius: _hasValue ? 8 : 4,
                offset: const Offset(0, 2),
                spreadRadius: _hasValue ? 1 : 0,
              ),
            ],
          ),
          child: Row(
            children: [
              /// TEXT FIELD
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: TextField(
                    controller: widget.controller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter link or upload file",
                      isDense: true,
                      hintStyle: TextStyle(
                        fontFamily: 'AloeveraDisplayBold',
                        color: Colors.grey[500],
                        fontSize: widget.isMobile ? 14.sp : (widget.isTablet ? 18.sp : 22.sp),
                        letterSpacing: 0.5,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: widget.isMobile ? 14.sp : (widget.isTablet ? 18.sp : 22.sp),
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                  ),
                ),
              ),

              /// UPLOAD BUTTON
              Container(
                margin: EdgeInsets.only(right: 8.w),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onUploadTap,
                    borderRadius: BorderRadius.circular(8.r),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.all(widget.isMobile ? 0 : 8.w),
                      decoration: BoxDecoration(
                        color: _hasValue
                          ? const Color(0xFFF4ED47).withOpacity(0.1)
                          : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: _hasValue
                            ? const Color(0xFFF4ED47).withOpacity(0.3)
                            : Colors.grey[300]!.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.attach_file_rounded,
                        size: widget.isMobile ? 14.sp : (widget.isTablet ? 24.sp : 28.sp),
                        color: _hasValue
                          ? const Color(0xFFF4ED47)
                          : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
