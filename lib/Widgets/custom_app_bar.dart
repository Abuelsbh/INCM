import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:incm/Modules/Career/career_screen.dart';
import 'package:incm/Modules/Lease/lease_screen.dart';
import 'package:incm/Modules/Sell/sell_screen.dart';
import '../Modules/About/about_screen.dart';
import '../Modules/Buy/buy_screen.dart';
import '../Modules/Home/home_screen.dart';
import '../Modules/Contacts/contacts_screen.dart';
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
    if (sectionId == 'home') {
      context.go(HomeScreen.routeName);
    }
    else if (sectionId == 'contacts') {
      context.go(ContactsScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Overlay to close menu when clicking outside
        if (isMenuOpen && MediaQuery.of(context).size.width <= 768)
          Positioned.fill(
            top: 80.h,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isMenuOpen = false;
                });
              },
              child: AnimatedOpacity(
                opacity: isMenuOpen ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
          ),
        
        // App Bar
        Container(
          height: 80.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            border: Border(
              bottom: BorderSide(
                color: const Color(0xFFF4ED47).withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

            // Logo Section (Left) - INCOMERCIAL with tagline
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () => _scrollToSection('home'),
                child: Image.asset(Assets.imagesIncomercialLogo, width: 340.w,height: 100.h,fit: BoxFit.cover,)
              ),
            ),


            // Desktop Menu Items (Center) with separators
            if (MediaQuery.of(context).size.width > 768)
              Expanded(
                flex: 7,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildMenuItemWithSeparator('HOME', true, () {context.go(HomeScreen.routeName);}),
                    _buildMenuItemWithSeparator('ABOUT US', true, () {context.go(AboutScreen.routeName);}),
                    _buildMenuItemWithSeparator('SERVICES', true, () {}),
                    _buildMenuItemWithSeparator('BUY', true, () {context.go(BuyScreen.routeName);}),
                    _buildMenuItemWithSeparator('SELL', true, () {context.go(SellScreen.routeName);}),
                    _buildMenuItemWithSeparator('CAREERS', true, () {context.go(CareerScreen.routeName);}),
                    _buildMenuItemWithSeparator('LEASE', false, () {context.go(LeaseScreen.routeName);}),
                  ],
                ),
              ),

            // Explore Us Button (Right side)
            if (MediaQuery.of(context).size.width > 768)
              Expanded(
              flex: 1,
                child: Container(
                  child: ButtonStyles.exploreUsButton(
                    onPressed: () => _scrollToSection('contacts'),
                  ),
                ),
              ),

            SizedBox(width: MediaQuery.of(context).size.width > 768 ? 32.w : 16.w),

            // Mobile Menu Button (Right)
            if (MediaQuery.of(context).size.width <= 768)
              IconButton(
                onPressed: () {
                  setState(() {
                    isMenuOpen = !isMenuOpen;
                  });
                },
                icon: Icon(
                  isMenuOpen ? Icons.close : Icons.menu,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
              ],
            ),
          ),
        ),

        // Side Menu (Mobile)
        if (MediaQuery.of(context).size.width <= 768)
          _buildSideMenu(context),
      ],
    );
  }

  Widget _buildSideMenu(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      top: 80.h,
      right: isMenuOpen ? 0 : -280.w,
      bottom: 0,
      width: 280.w,
      child: GestureDetector(
        onTap: () {}, // Prevent closing when tapping inside menu
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.98),
                Colors.black.withOpacity(0.95),
              ],
            ),
            border: Border(
              left: BorderSide(
                color: const Color(0xFFF4ED47).withOpacity(0.3),
                width: 2,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(-5, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              // Menu Header
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: const Color(0xFFF4ED47).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.menu,
                      color: const Color(0xFFF4ED47),
                      size: 24.sp,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'MENU',
                      style: TextStyle(
                        fontFamily: 'OptimalBold',
                        color: const Color(0xFFF4ED47),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Menu Items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  children: [
                    _buildSideMenuItem('HOME', Icons.home, 'home', (){ context.go(HomeScreen.routeName);}),
                    _buildSideMenuItem('ABOUT US', Icons.info, 'about', () { context.go(AboutScreen.routeName);}),
                    _buildSideMenuItem('SERVICES', Icons.work, 'services', () {}),
                    _buildSideMenuItem('CONTACTS', Icons.contact_phone, 'contacts',() {}),
                  ],
                ),
              ),
              
              // Footer
              Container(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  children: [
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            const Color(0xFFF4ED47).withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'INCM Real Estate',
                      style: TextStyle(
                        fontFamily: 'Optimal',
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSideMenuItem(String text, IconData icon, String sectionId, VoidCallback? onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: ()=> onTap,
        splashColor: const Color(0xFFF4ED47).withOpacity(0.2),
        highlightColor: const Color(0xFFF4ED47).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4ED47).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFFF4ED47),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontFamily: 'Optimal',
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: const Color(0xFFF4ED47).withOpacity(0.6),
                size: 14.sp,
              ),
            ],
          ),
        ),
      ),
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

  Widget _buildMenuItemWithSeparator(String text, bool showSeparator,  VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _HoverMenuItem(
            text: text,
            onTap: onTap,
          ),
          if (showSeparator) ...[
            SizedBox(width: 20.w),
            Container(
              height: 12.h,
              width: 2.w,
              color: const Color(0xFFF4ED47),
            ),
            SizedBox(width: 20.w),
          ],
        ],
      ),
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
              color: const Color(0xFFF4ED47).withOpacity(0.1),
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

// Hover Menu Item Widget
class _HoverMenuItem extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _HoverMenuItem({
    required this.text,
    required this.onTap,
  });

  @override
  State<_HoverMenuItem> createState() => _HoverMenuItemState();
}

class _HoverMenuItemState extends State<_HoverMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          transform: _isHovered
              ? (Matrix4.identity()..translate(0.0, -2.0, 0.0))
              : Matrix4.identity(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                style: TextStyle(
                  fontFamily: 'AloeveraDisplay',
                  color: _isHovered ? const Color(0xFFC63424) : Colors.white,
                  fontSize: 20.sp,
                  fontWeight: _isHovered ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: _isHovered ? 1.0 : 0.8,
                ),
                child: Text(widget.text),
              ),
              SizedBox(height: 4.h),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: 2.h,
                width: _isHovered ? 40.w : 0,
                decoration: BoxDecoration(
                  color: const Color(0xFFC63424),
                  borderRadius: BorderRadius.circular(1.r),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}