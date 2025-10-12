import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rush/responsive/responsive_layout.dart';
import '../../generated/assets.dart';
import '../About/about_screen.dart';
import '../Contacts/contacts_screen.dart';
import '../Home/home_screen.dart';
import '../Search/search_screen.dart';
import '../Services/services_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  static const String routeName = '/main';

  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<Widget> _screens = [
    HomeScreen(),
    const AboutScreen(),
    const ServicesScreen(),
    const ContactsScreen(),
    const SearchScreen(),
  ];

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
      arabicLabel: 'الرئيسية',
    ),
    NavigationItem(
      icon: Icons.info_outline,
      activeIcon: Icons.info,
      label: 'About Us',
      arabicLabel: 'من نحن',
    ),
    NavigationItem(
      icon: Icons.work_outline,
      activeIcon: Icons.work,
      label: 'Services',
      arabicLabel: 'الخدمات',
    ),
    NavigationItem(
      icon: Icons.contact_phone_outlined,
      activeIcon: Icons.contact_phone,
      label: 'Contacts',
      arabicLabel: 'اتصل بنا',
    ),
    NavigationItem(
      icon: Icons.search_outlined,
      activeIcon: Icons.search,
      label: 'Search',
      arabicLabel: 'البحث',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RushWidget(
      smallScreen: _buildSmallScreenLayout(),
      mediumScreen: _buildSmallScreenLayout(),
      largeScreen: _buildLargeScreenLayout(),
    );
  }

  Widget _buildSmallScreenLayout() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: _screens,
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildLargeScreenLayout() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          // Side Navigation for Large Screens
          Container(
            width: 250.w,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.95),
              border: Border(
                right: BorderSide(
                  color: const Color(0xFFFFC700).withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // Logo Section
                Container(
                  padding: EdgeInsets.all(20.w),
                  child: Image.asset(
                    Assets.imagesINCMLogo,
                    height: 80.h,
                    fit: BoxFit.contain,
                  ),
                ),
                
                // Navigation Items
                Expanded(
                  child: ListView.builder(
                    itemCount: _navigationItems.length,
                    itemBuilder: (context, index) {
                      final item = _navigationItems[index];
                      final isSelected = _currentIndex == index;
                      
                      return _buildSideNavItem(
                        item: item,
                        index: index,
                        isSelected: isSelected,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Main Content Area
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: _screens,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.95),
        border: Border(
          top: BorderSide(
            color: const Color(0xFFFFC700).withOpacity(0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 70.h,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navigationItems.asMap().entries.map((entry) {
              int index = entry.key;
              NavigationItem item = entry.value;
              bool isSelected = _currentIndex == index;
              
              return _buildNavItem(
                item: item,
                index: index,
                isSelected: isSelected,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildSideNavItem({
    required NavigationItem item,
    required int index,
    required bool isSelected,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: InkWell(
        onTap: () => _onTabTapped(index),
        borderRadius: BorderRadius.circular(12.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: isSelected 
                ? const Color(0xFFFFC700).withOpacity(0.1)
                : Colors.transparent,
            border: isSelected
                ? Border.all(
                    color: const Color(0xFFFFC700).withOpacity(0.3),
                    width: 1,
                  )
                : null,
          ),
          child: Row(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isSelected ? item.activeIcon : item.icon,
                  key: ValueKey(isSelected),
                  color: isSelected 
                      ? const Color(0xFFFFC700)
                      : Colors.white.withOpacity(0.7),
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected 
                        ? const Color(0xFFFFC700)
                        : Colors.white.withOpacity(0.7),
                  ),
                  child: Text(
                    item.label,
                  ),
                ),
              ),
              if (isSelected)
                Container(
                  width: 4.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC700),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required NavigationItem item,
    required int index,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabTapped(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: isSelected 
                ? const Color(0xFFFFC700).withOpacity(0.1)
                : Colors.transparent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isSelected ? item.activeIcon : item.icon,
                  key: ValueKey(isSelected),
                  color: isSelected 
                      ? const Color(0xFFFFC700)
                      : Colors.white.withOpacity(0.7),
                  size: 24.sp,
                ),
              ),
              SizedBox(height: 4.h),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected 
                      ? const Color(0xFFFFC700)
                      : Colors.white.withOpacity(0.7),
                ),
                child: Text(
                  item.label, // You can add RTL support here
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String arabicLabel;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.arabicLabel,
  });
}
