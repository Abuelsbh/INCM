import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/Language/locales.dart';

class DepartmentsGridSection extends StatelessWidget {
  final List<String> departments;
  final BuildContext context;
  //final Function(String)? onDepartmentTap;

  const DepartmentsGridSection({
    super.key,
    required this.departments,
    required this.context,
    /*this.onDepartmentTap,*/
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 1024;

    return
      Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage(Assets.imagesCareerBackground),
        //     fit: BoxFit.fill,
        //   ),
        // ),
        width: double.infinity,
        height:  MediaQuery.of(context).size.width <= 600 ? 750: 1200.h,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(40.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center, // 👈 vertical center
              children: [

                Container(
                  padding: EdgeInsets.symmetric(vertical: 60.h),
                  child: Column(
                    children: [
                      _buildTitle(context, isMobile, isTablet),
                      SizedBox(height: isMobile ? 50.h : (isTablet ? 70.h : 90.h)),


                      MediaQuery.of(context).size.width <= 600 ?

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4ED47).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: departments.map((text) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child:Text(
                                text.tr(context),
                                style: TextStyle(
                                  fontFamily: 'AloeveraDisplaySemiBold',
                                  color: const Color(0xFFF4ED47), // Yellow/gold
                                  fontSize: 18.sp,
                                  height: 1.8,
                                  letterSpacing: 1,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ) :

                      // 3x3 Grid
                      _buildGrid(context, isMobile, isTablet),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );


  }

  Widget _buildTitle(BuildContext context, bool isMobile, bool isTablet) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          // "EXPLORE"
          TextSpan(
            text: 'EXPLORE_OUR'.tr(context),
            style: TextStyle(
              fontFamily: 'OptimalBold',
              fontSize: isMobile ? 30.sp : (isTablet ? 60.sp : 85.sp),
              fontWeight: FontWeight.bold,
              color: const Color(0xFFF4ED47), // Yellow/gold
              letterSpacing: 2,
            ),
          ),
          // "OUR"

          // "DEPARTMENTS"
          TextSpan(
            text: 'DEPARTMENTS'.tr(context),
            style: TextStyle(
              fontFamily: 'OptimalBold',
              fontSize: isMobile ? 30.sp : (isTablet ? 60.sp :85.sp),
              fontWeight: FontWeight.bold,
              color: Colors.white, // Yellow/gold
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context, bool isMobile, bool isTablet) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: isMobile ? double.infinity : (isTablet ? 800.w : 1450.w),
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: List.generate(3, (rowIndex) {
          return _buildGridRow(context, rowIndex, isMobile, isTablet);
        }),
      ),
    );
  }

  Widget _buildGridRow(BuildContext context, int rowIndex, bool isMobile, bool isTablet) {
    //final rowDepartments = departments.skip(rowIndex * 3).take(3).toList();
    
    return Column(
      children: [
        Row(
          children: List.generate(3, (colIndex) {
            final index = rowIndex * 3 + colIndex;
            final department = index < departments.length ? departments[index] : '';
            
            return Expanded(
              child: _buildGridCell(
                context,
                department,
                isMobile,
                isTablet,
                colIndex < 2, // Has right border
              ),
            );
          }),
        ),
        if (rowIndex < 2) // Add horizontal line between rows (not after last row)
          Container(
            height: 1.5,
            color: Colors.white.withOpacity(0.4),
            margin: EdgeInsets.symmetric(horizontal: 0),
          ),
      ],
    );
  }

  Widget _buildGridCell(
    BuildContext context,
    String department,
    bool isMobile,
    bool isTablet,
    bool hasRightBorder,
  ) {
    return Container(
      height: isMobile ? 100.h : (isTablet ? 140.h : 180.h),
      decoration: BoxDecoration(
        border: Border(
          right: hasRightBorder
              ? BorderSide(
            color: Colors.white.withOpacity(0.4),
            width: 1.5,
          )
              : BorderSide.none,
        ),
        color: department.isNotEmpty 
            ? const Color(0xFFF4ED47).withOpacity(0.08) 
            : Colors.transparent,
        gradient: department.isNotEmpty
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFF4ED47).withOpacity(0.05),
                  const Color(0xFFF4ED47).withOpacity(0.12),
                ],
              )
            : null,
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Text(
            department.isNotEmpty ? department.tr(context) : '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'AloeveraDisplayBold',
              fontSize: isMobile ? 12.sp : (isTablet ? 22.sp : 34.sp),
              fontWeight: FontWeight.bold,
              color: const Color(0xFFF4ED47), // Yellow/gold
              letterSpacing: 1.5,
              shadows: [
                Shadow(
                  color: const Color(0xFFF4ED47).withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
