import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CustomFormField extends StatelessWidget {
  const CustomFormField({super.key, this.label, this.controller, this.keyboardType, this.hint, this.height, required this.isMobile,required this.isTablet});
  final String? label;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? hint;
  final double? height;
  final bool isMobile;
  final bool isTablet;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label??'',
          style: TextStyle(
            fontFamily: 'AloeveraDisplayBold',
            color: Colors.white,
            fontSize: isMobile ? 16.sp : (isTablet ? 22.sp : 28.sp),
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: height ?? (isMobile ? 36.h : (isTablet ? 55.h : 60.h)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Center(
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  hintStyle: TextStyle(
                    fontFamily: 'AloeveraDisplayBold',
                    color: Colors.grey[500],
                    fontSize: isMobile ? 16.sp : (isTablet ? 18.sp : 28.sp),
                  ),
                ),

                style: TextStyle(
                  fontSize: isMobile ? 14.sp : 28.sp,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

