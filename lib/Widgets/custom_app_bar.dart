import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Modules/Home/home_screen.dart';
import '../generated/assets.dart';
import 'custom_button.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool isMenuOpen = false;

  void _scrollToSection(String sectionId) {
    HomeScreen.scrollToSection(sectionId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 80.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            border: Border(
              bottom: BorderSide(
                color: const Color(0xFFFFC700).withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
            // Logo Section (Left) - INCOMERCIAL with tagline
            GestureDetector(
              onTap: () => _scrollToSection('home'),
              child: Image.asset(Assets.imagesINCMLogo, width: 200.w, height: double.infinity,fit: BoxFit.cover,)
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     Text(
              //       'INCOMERCIAL',
              //       style: TextStyle(
              //         color: const Color(0xFFFFC700),
              //         fontSize: 20.sp,
              //         fontWeight: FontWeight.w600,
              //         letterSpacing: 0.5,
              //       ),
              //     ),
              //     Text(
              //       'Consult. Manage. Lease.',
              //       style: TextStyle(
              //         color: const Color(0xFFFFC700).withOpacity(0.8),
              //         fontSize: 12.sp,
              //         fontWeight: FontWeight.w400,
              //         letterSpacing: 0.3,
              //       ),
              //     ),
              //   ],
              // ),
            ),

                const Spacer(),

            // Desktop Menu Items (Center) with separators
            if (MediaQuery.of(context).size.width > 768)
              Row(
                children: [
                  _buildMenuItemWithSeparator('HOME', 'home', true),
                  _buildMenuItemWithSeparator('ABOUT US', 'about', true),
                  _buildMenuItemWithSeparator('SERVICES', 'services', true),
                  _buildMenuItemWithSeparator('CONTACTS', 'contacts', false),
                ],
              ),

            const Spacer(),

            // Explore Us Button (Right side)
            if (MediaQuery.of(context).size.width > 768)
              ButtonStyles.exploreUsButton(
                onPressed: () => _scrollToSection('about'),
              ),

            SizedBox(width: 16.w),

            // Mobile Menu Button (Right)
            IconButton(
              onPressed: () {
                setState(() {
                  isMenuOpen = !isMenuOpen;
                });
              },
              icon: Icon(
                isMenuOpen ? Icons.close : Icons.menu,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
              ],
            ),
          ),
        ),

        // Mobile Menu Dropdown
        if (isMenuOpen && MediaQuery.of(context).size.width <= 768)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.95),
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFFFFC700).withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                _buildMobileMenuItem('HOME', 'home'),
                _buildMobileMenuItem('ABOUT US', 'about'),
                _buildMobileMenuItem('SERVICES', 'services'),
                _buildMobileMenuItem('CONTACTS', 'contacts'),
                SizedBox(height: 16.h),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMenuItem(String text, String sectionId) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTap: () => _scrollToSection(sectionId),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItemWithSeparator(String text, String sectionId, bool showSeparator) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _scrollToSection(sectionId),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.8,
            ),
          ),
        ),
        if (showSeparator) ...[
          SizedBox(width: 20.w),
          Container(
            height: 12.h,
            width: 1.w,
            color: const Color(0xFFFFC700),
          ),
          SizedBox(width: 20.w),
        ],
      ],
    );
  }

  Widget _buildMobileMenuItem(String text, String sectionId) {
    return InkWell(
      onTap: () {
        setState(() {
          isMenuOpen = false;
        });
        _scrollToSection(sectionId);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: const Color(0xFFFFC700).withOpacity(0.1),
              width: 0.5,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

}