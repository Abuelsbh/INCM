import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:incm/Utilities/router_config.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../Widgets/bottom_navbar_widget.dart';
import '../../Widgets/build_file_o_link_field.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/custom_app_bar_mob.dart';
import '../../Widgets/custom_button.dart';
import '../../Widgets/departments_grid_section.dart';
import '../../Widgets/floating_contact_buttons.dart';
import '../../Widgets/scroll_to_top_button.dart';
import '../../generated/assets.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CareerScreen extends StatefulWidget {
  static const String routeName = '/career';

  const CareerScreen({super.key});

  @override
  State<CareerScreen> createState() => _CareerScreenState();
}

class _CareerScreenState extends State<CareerScreen> with SingleTickerProviderStateMixin{
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _hasAnimated = false;
  bool _isAddressHovered = false;
  late PageController _pageController;
  int _currentPage = 0;



  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _emailController = TextEditingController();
  final _linkOrFileController = TextEditingController();
  // Country code
  String _selectedCountryCode = '+20'; // Egypt as default

  final List<Map<String, String>> _countryCodes = [
    {'code': '+20', 'country': 'EG', 'flag': '🇪🇬'},
    {'code': '+966', 'country': 'SA', 'flag': '🇸🇦'},
    {'code': '+971', 'country': 'AE', 'flag': '🇦🇪'},
    {'code': '+965', 'country': 'KW', 'flag': '🇰🇼'},
    {'code': '+974', 'country': 'QA', 'flag': '🇶🇦'},
    {'code': '+973', 'country': 'BH', 'flag': '🇧🇭'},
    {'code': '+968', 'country': 'OM', 'flag': '🇴🇲'},
    {'code': '+962', 'country': 'JO', 'flag': '🇯🇴'},
    {'code': '+961', 'country': 'LB', 'flag': '🇱🇧'},
    {'code': '+1', 'country': 'US', 'flag': '🇺🇸'},
    {'code': '+44', 'country': 'GB', 'flag': '🇬🇧'},
  ];

  String? selectedDepartment;
  List<String> departments = [
    "SALES TEAM",
    "LEASING",
    "CONSULTATION",
    "FRANCHISING",
    "FACILITY MANAGEMENT",
    "OPERATIONS",
    "MARKETING",
    "HUMAN RESOURCES",
    "FINANCE",
  ];
  List<String> benefits = [
    "Competitive Salary",
    "Exclusive Projects",
    "Training Programs",
    "Supportive Management",
    "Career Growth Opportunities",
    "Professional Work Environment",
    "Team Collaboration",
    "Recognition & Rewards",
    "Work-Life Balance",
    "Leadership Development",
    "Networking Opportunities",
    "Highest Commission Scheme",
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: MediaQuery.of(currentContext_!).size.width > 600 ? 0.33 : 1);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    // تبديل اللون كل 5 ثواني
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _isPrimaryColor = !_isPrimaryColor;
      });
    });
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    // Start animation immediately to ensure content is visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!_hasAnimated && info.visibleFraction >= 0.3) {
      _hasAnimated = true;
      if (!_animationController.isAnimating && !_animationController.isCompleted) {
        _animationController.forward();
      }
    }
  }


  @override
  void dispose() {
    _animationController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _linkOrFileController.dispose();
    _jobTitleController.dispose();
    _animationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _showToast(String message, {bool isError = true}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: isError ? Colors.red : Colors.green,
      textColor: Colors.white,
      fontSize: 16.sp,
    );
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _validatePhone(String phone) {
    final phoneRegex = RegExp(r'^[0-9]{9,15}$');
    return phoneRegex.hasMatch(phone);
  }

  void _handleSubmit() {
    if (_fullNameController.text.trim().isEmpty) {
      _showToast('Please enter your full name');
      return;
    }

    if (_fullNameController.text.trim().length < 3) {
      _showToast('Full name must be at least 3 characters');
      return;
    }

    if (_phoneController.text.trim().isEmpty) {
      _showToast('Please enter your phone number');
      return;
    }

    if (!_validatePhone(_phoneController.text.trim())) {
      _showToast('Please enter a valid phone number (9-15 digits)');
      return;
    }

    if (_jobTitleController.text.trim().isEmpty) {
      _showToast('Please enter the job title');
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      _showToast('Please enter your email');
      return;
    }

    if (!_validateEmail(_emailController.text.trim())) {
      _showToast('Please enter a valid email address');
      return;
    }

    if (_linkOrFileController.text.trim().isEmpty) {
      _showToast('Please upload or send your CV');
      return;
    }

    _showToast('Form submitted successfully!', isError: false);

    _fullNameController.clear();
    _phoneController.clear();
    _jobTitleController.clear();
    _emailController.clear();
  }

  // Helper method to determine if screen is mobile
  bool _isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  // Helper method to determine if screen is tablet
  bool _isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1024;
  }

  final List<Map<String, String>> items = [
    {
      'title': 'FINAL RAMADAN',
      'image': Assets.imagesPic3,
    },
    {
      'title': 'INTERNSHIP',
      'image': Assets.imagesPic2,
    },
    {
      'title': 'FUN DAY',
      'image': Assets.imagesPic4,
    },

  ];

  void _nextPage() {
    if (_currentPage < items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
  bool _isPrimaryColor = true;
  late Timer _timer;


  bool isDownloading = false;
  double progress = 0;




  @override
  Widget build(BuildContext context) {

    final isMobile = MediaQuery.of(context).size.width < 600;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: MediaQuery.of(context).size.width < 600 && !kIsWeb ? const BottomNavBarWidget(selected: SelectedBottomNavBar.contacts) : null,
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: VisibilityDetector(
                key: const Key('contacts-content-section'),
                onVisibilityChanged: _onVisibilityChanged,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(isMobile ? Assets.imagesCareerViewMob : Assets.imagesCareerViewWeb),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Column(
                    children: [
                      if(MediaQuery.of(context).size.width > 600)
                        _buildINCMFamilySection(context),
                      if(MediaQuery.of(context).size.width > 600)
                        _buildJoinFamilySection(context),
                      if(MediaQuery.of(context).size.width > 600)
                        DepartmentsGridSection(departments: departments,),
                      if(MediaQuery.of(context).size.width > 600)
                        _buildCareerBenefitsSection(context),
                      if(MediaQuery.of(context).size.width > 600)
                        _buildLatestNewsSection(context),




                      if(MediaQuery.of(context).size.width < 600)
                        _buildINCMFamilySectionMob(context),
                      if(MediaQuery.of(context).size.width < 600)
                        _buildJoinFamilySectionMob(context),
                      if(MediaQuery.of(context).size.width < 600)
                        DepartmentsGridSection(departments: departments,),
                      if(MediaQuery.of(context).size.width < 600)
                        _buildCareerBenefitsSectionMob(context),
                      if(MediaQuery.of(context).size.width < 600)
                        _buildLatestNewsSectionMob(context),
                    ],
                  ),
                ),
              ),
            ),
            MediaQuery.of(context).size.width >= 600 ?
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomAppBar(),
            ) : const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomAppBarMob(),
            ),
            const FloatingContactButtons(),
            ScrollToTopButton(scrollController: _scrollController),
          ],
        ),
      ),
    );
  }

  Widget _buildINCMFamilySection(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(Assets.imagesCareerBackground),
      //     fit: BoxFit.fill,
      //   ),
      // ),
      width: double.infinity,
      height: 1200.h,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          );
        },
        child: Center( // 👈 centers everything vertically + horizontally
          child: Container(
            padding: EdgeInsets.all(40.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center, // 👈 vertical center
              children: [
                _buildSectionTitle('WELCOME TO INCM FAMILY'),
                Gap(120.h),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFF4ED47),
                      width: 0.6,            // border width
                    ),
                  ),
                  child: Image.asset(Assets.imagesPic1, height: 600.h,),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJoinFamilySection(BuildContext context) {
    final isMobile = _isMobile(context);
    final isTablet = _isTablet(context);
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(Assets.imagesCareerBackground),
      //     fit: BoxFit.fill,
      //   ),
      // ),
      width: double.infinity,
      height: 1200.h,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          );
        },
        child: Center( // 👈 centers everything vertically + horizontally
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isMobile ? double.infinity : (isTablet ? 800.w : 1400.w),
            ),
            padding: EdgeInsets.all(40.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center, // 👈 vertical center
              children: [
                _buildSectionTitle('JOIN INCM FAMILY NOW'),
                Gap(60.h),
                Column(
                    children: [

                      Row(
                        children: [
                          Expanded(
                            child: _buildFormField(
                              'FULL NAME',
                              controller: _fullNameController,
                              keyboardType: TextInputType.name,
                              isMobile: isMobile,
                              isTablet: isTablet,
                            ),
                          ),
                          SizedBox(width: isTablet ? 75.w : 150.w),
                          Expanded(
                            child: _buildPhoneField(isMobile: isMobile, isTablet: isTablet),
                          ),
                        ],
                      ),
                      SizedBox(height: isTablet ? 40.h : 60.h),
                      Row(
                        children: [
                          Expanded(
                            child: _buildFormField(
                              'E-MAIL',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              isMobile: isMobile,
                              isTablet: isTablet,
                            ),
                          ),
                          SizedBox(width: isTablet ? 75.w : 150.w),
                          Expanded(
                              child:_buildDropdownField("DEPARTMENT","SELECT DEPARTMENT",
                                value: selectedDepartment,
                                items: departments,
                                isMobile: isMobile,
                                isTablet: isTablet,
                                onChanged: (val) {
                                  setState(() {
                                    selectedDepartment = val;
                                  });
                                },
                              )
                          ),
                        ],
                      ),

                      SizedBox(height: isTablet ? 40.h : 60.h),
                      Row(
                        children: [
                          Expanded(
                            child: _buildFormField(
                              'JOB TITLE',
                              controller: _jobTitleController,
                              keyboardType: TextInputType.emailAddress,
                              isMobile: isMobile,
                              isTablet: isTablet,
                            ),
                          ),
                          SizedBox(width: isTablet ? 75.w : 150.w),
                          Expanded(
                              child: BuildFileOrLinkField(
                                  "UPLOAD YOUR CV",
                                  controller: _linkOrFileController,
                                  isMobile: isMobile,
                                  isTablet: isTablet,
                                  onUploadTap: () async {
                                    try {
                                      FilePickerResult? result;

                                      if (kIsWeb) {
                                        // Web version - works seamlessly
                                        result = await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg', 'doc', 'docx'],
                                          withData: false,
                                          withReadStream: false,
                                        );
                                      } else {
                                        // Mobile/Desktop version
                                        result = await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg', 'doc', 'docx'],
                                        );
                                      }

                                      if (result != null && result.files.isNotEmpty) {
                                        final file = result.files.first;
                                        setState(() {
                                          _linkOrFileController.text = file.name;
                                        });
                                      }
                                    } catch (e) {
                                      Fluttertoast.showToast(
                                        msg: "Error picking file: $e",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                    }
                                  }
                              )
                          ),
                        ],
                      ),
                      Gap(60.h),
                      ButtonStyles.submitButton(
                        fontSize: isMobile ? 24.sp : (isTablet ? 26.sp : 42.sp),
                        width: isMobile ? 120.w : (isTablet ? 120.w : 180.w),
                        onPressed: _handleSubmit,
                      ),
                    ]
                )


              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) => Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontFamily: 'OptimalBold',
      color: const Color(0xFFF4ED47),
      fontSize: MediaQuery.of(context).size.width > 600 ? 80.sp : 28.sp,
      fontWeight: FontWeight.bold,
      letterSpacing: 2,
    ),
  );

  Widget _buildCareerBenefitsSection(BuildContext context) {
    final isMobile = _isMobile(context);
    final isTablet = _isTablet(context);
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(Assets.imagesCareerBackground),
      //     fit: BoxFit.fill,
      //   ),
      // ),
      width: double.infinity,
      height: isMobile ? 1600.h : 1200.h,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          );
        },
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: isMobile ? double.infinity : 1700.w,
              ),
              padding: EdgeInsets.all(isMobile ? 20.w : 40.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'CAREER ',
                          style: TextStyle(
                            fontFamily: 'OptimalBold',
                            color: const Color(0xFFF4ED47),
                            fontSize: isMobile ? 32.sp : (isTablet ? 48.sp : 80.sp),
                            letterSpacing: 3,
                          ),
                        ),
                        TextSpan(
                          text: 'BENEFITS',
                          style: TextStyle(
                            fontFamily: 'OptimalBold',
                            color: Colors.white,
                            fontSize: isMobile ? 32.sp : (isTablet ? 48.sp : 80.sp),
                            fontWeight: FontWeight.w800,
                            letterSpacing: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(isMobile ? 30.h : 50.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 30.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4ED47).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: benefits
                                .sublist(0, (benefits.length / 2).toInt())
                                .map((text) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 20.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "•  ",
                                      style: TextStyle(
                                        fontFamily: 'AloeveraDisplaySemiBold',
                                        color: Colors.white,
                                        fontSize: isTablet ? 24.sp : 40.sp,
                                        height: 1.8,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        text,
                                        style: TextStyle(
                                          fontFamily: 'AloeveraDisplaySemiBold',
                                          color: Colors.white,
                                          fontSize: isTablet ? 24.sp : 40.sp,
                                          height: 1.8,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Gap(40.w),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 30.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4ED47).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: benefits
                                .sublist((benefits.length / 2).toInt(), benefits.length)
                                .map((text) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 20.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "•  ",
                                      style: TextStyle(
                                        fontFamily: 'AloeveraDisplaySemiBold',
                                        color: Colors.white,
                                        fontSize: isTablet ? 24.sp : 40.sp,
                                        height: 1.8,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        text,
                                        style: TextStyle(
                                          fontFamily: 'AloeveraDisplaySemiBold',
                                          color: Colors.white,
                                          fontSize: isTablet ? 24.sp : 40.sp,
                                          height: 1.8,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLatestNewsSection(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(Assets.imagesAboutUsBackground2),
      //     fit: BoxFit.fill,
      //   ),
      // ),
      width: double.infinity,
      height: 1200.h,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          );
        },
        child: Center( // 👈 centers everything vertically + horizontally
          child: Container(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center, // 👈 vertical center
              children: [
                _buildSectionTitle('OUR FAMILY MEMBERS'),
                Gap(40.h),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 60.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 600.h,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40.w),
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: items.length,
                                onPageChanged: (index) {
                                  setState(() => _currentPage = index);
                                },
                                itemBuilder: (context, index) {
                                  final item = items[index];
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color(0xFFF4ED47),
                                                width: 0.6,            // border width
                                              ),
                                            ),
                                            child: Image.asset(
                                              item['image']!,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            ),
                                            height: 500.h,
                                            width: 800.w,
                                          ),
                                          SizedBox(height: 30.h),
                                          Text(
                                            item['title']!,
                                            style: TextStyle(
                                              fontFamily: 'OptimalBold',
                                              color: Colors.white,
                                              fontSize: 50.sp,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Left arrow
                            Positioned(
                              left: 0,
                              top: 165,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                                iconSize: 40,
                                onPressed: _previousPage,
                              ),
                            ),

                            // Right arrow
                            Positioned(
                              right: 0,
                              top: 165,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                                iconSize: 40,
                                onPressed: _nextPage,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Dots indicator
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: List.generate(
                      //     items.length,
                      //         (index) => AnimatedContainer(
                      //       duration: const Duration(milliseconds: 300),
                      //       margin: const EdgeInsets.symmetric(horizontal: 4),
                      //       width: _currentPage == index ? 32 : 8,
                      //       height: 8,
                      //       decoration: BoxDecoration(
                      //         color: _currentPage == index
                      //             ? const Color(0xFFF4ED47)
                      //             : Colors.white.withOpacity(0.4),
                      //         borderRadius: BorderRadius.circular(4),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }




  Widget _buildINCMFamilySectionMob(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(Assets.imagesCareerBackgroundMob),
      //     fit: BoxFit.fill,
      //   ),
      // ),
      width: double.infinity,
      height: 786.h,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          );
        },
        child: Center( // 👈 centers everything vertically + horizontally
          child: Container(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center, // 👈 vertical center
              children: [
                _buildSectionTitle('WELCOME TO INCM FAMILY'),
                Gap(40.h),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFF4ED47),
                      width: 1,            // border width
                    ),
                  ),
                  child: Image.asset(Assets.imagesPic1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJoinFamilySectionMob(BuildContext context) {
    final isMobile = _isMobile(context);
    final isTablet = _isTablet(context);
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(Assets.imagesCareerBackground),
      //     fit: BoxFit.fill,
      //   ),
      // ),
      width: double.infinity,
      height: 786.h,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          );
        },
        child: Center( // 👈 centers everything vertically + horizontally
          child: Container(

            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center, // 👈 vertical center
              children: [
                _buildSectionTitle('JOIN INCM FAMILY NOW'),
                Gap(30.h),
                Column(
                    children: [
                      _buildFormField(
                        'FULL NAME',
                        controller: _fullNameController,
                        keyboardType: TextInputType.name,
                        isMobile: isMobile,
                        isTablet: isTablet,
                      ),
                      Gap(22.h),
                      _buildPhoneField(isMobile: isMobile, isTablet: isTablet),
                      Gap(22.h),
                      _buildFormField(
                        'E-MAIL',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        isMobile: isMobile,
                        isTablet: isTablet,
                      ),
                      Gap(22.h),
                      _buildDropdownField("DEPARTMENT","SELECT DEPARTMENT",
                        value: selectedDepartment,
                        items: departments,
                        isMobile: isMobile,
                        isTablet: isTablet,
                        onChanged: (val) {
                          setState(() {
                            selectedDepartment = val;
                          });
                        },
                      ),
                      Gap(22.h),
                      _buildFormField(
                        'JOB TITLE',
                        controller: _jobTitleController,
                        keyboardType: TextInputType.emailAddress,
                        isMobile: isMobile,
                        isTablet: isTablet,
                      ),
                      Gap(22.h),
                      BuildFileOrLinkField(
                          "UPLOAD YOUR CV",
                          controller: _linkOrFileController,
                          isMobile: isMobile,
                          isTablet: isTablet,
                          onUploadTap: () async {
                            try {
                              FilePickerResult? result;

                              if (kIsWeb) {
                                // Web version - works seamlessly
                                result = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg', 'doc', 'docx'],
                                  withData: false,
                                  withReadStream: false,
                                );
                              } else {
                                // Mobile/Desktop version
                                result = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg', 'doc', 'docx'],
                                );
                              }

                              if (result != null && result.files.isNotEmpty) {
                                final file = result.files.first;
                                setState(() {
                                  _linkOrFileController.text = file.name;
                                });
                              }
                            } catch (e) {
                              Fluttertoast.showToast(
                                msg: "Error picking file: $e",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                            }
                          }
                      ),

                      Gap(28.h),
                      ButtonStyles.submitButtonMob(
                        width: isMobile ? 80.w : (isTablet ? 120.w : 140.w),
                        onPressed: _handleSubmit,
                      ),
                    ]
                )


              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCareerBenefitsSectionMob(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(Assets.imagesCareerBackgroundMob),
      //     fit: BoxFit.fill,
      //   ),
      // ),
      width: double.infinity,
      height: 786.h,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          );
        },
        child: Center(
          child: SingleChildScrollView(
            child: Container(

              padding: EdgeInsets.all(10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'CAREER ',
                          style: TextStyle(
                            fontFamily: 'OptimalBold',
                            color: const Color(0xFFF4ED47),
                            fontSize: 28.sp,
                            letterSpacing: 3,
                          ),
                        ),
                        TextSpan(
                          text: 'BENEFITS',
                          style: TextStyle(
                            fontFamily: 'OptimalBold',
                            color: Colors.white,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(20.h),
                 Column(
                    children: [
                      ...benefits.map((text) {
                        return Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 30.w,vertical: 6.h),
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4ED47).withOpacity(0.3),
                            //borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Center(
                            child: Text(
                              text,
                              style: TextStyle(
                                fontFamily: 'AloeveraDisplaySemiBold',
                                color: Colors.white,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLatestNewsSectionMob(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(Assets.imagesAboutUsBackgroundMob2),
      //     fit: BoxFit.fill,
      //   ),
      // ),
      width: double.infinity,
      height: 786.h,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          );
        },
        child: Center( // 👈 centers everything vertically + horizontally
          child: Container(
            padding: EdgeInsets.all(0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center, // 👈 vertical center
              children: [
                _buildSectionTitle('OUR FAMILY MEMBERS'),
                Gap(10.h),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 480.h,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: items.length,
                                onPageChanged: (index) {
                                  setState(() => _currentPage = index);
                                },
                                itemBuilder: (context, index) {
                                  final item = items[index];
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color(0xFFF4ED47),
                                                width: 0.6,            // border width
                                              ),
                                            ),
                                            child: Image.asset(
                                              item['image']!,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            ),
                                            height: 380.h,
                                            width: 650.w,
                                          ),
                                          SizedBox(height: 10.h),
                                          Text(
                                            item['title']!,
                                            style: TextStyle(
                                              fontFamily: 'OptimalBold',
                                              color: Colors.white,
                                              fontSize: 26.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Left arrow
                            Positioned(
                              left: 0,
                              top: 130,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                                iconSize: 40,
                                onPressed: _previousPage,
                              ),
                            ),

                            // Right arrow
                            Positioned(
                              right: 0,
                              top: 130,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                                iconSize: 40,
                                onPressed: _nextPage,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }







  Widget _buildFormField(
      String label, {
        required TextEditingController controller,
        TextInputType? keyboardType,
        String? hint,
        double? height,
        required bool isMobile,
        required bool isTablet
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label??'',
          style: TextStyle(
            fontFamily: 'AloeveraDisplayBold',
            color: const Color(0xFFF4ED47),
            fontSize: isMobile ? 16.sp : (isTablet ? 22.sp : 28.sp),
            fontWeight: FontWeight.bold,
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

  Widget _buildDropdownField(
      String label,
      String hint,{
        required String? value,
        required List<String> items,
        required Function(String?) onChanged,
        double? height,
        required bool isMobile,
        required bool isTablet,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'AloeveraDisplayBold',
            color: const Color(0xFFF4ED47),
            fontSize: isMobile ? 16.sp : (isTablet ? 22.sp : 28.sp),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: isMobile ? 0 : 8.h),

        Container(
          height: height ?? (isMobile ? 36.h : (isTablet ? 60.h : 65.h)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: value != null 
                ? const Color(0xFFF4ED47).withOpacity(0.5)
                : Colors.grey[300]!,
              width: value != null ? 2 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: value != null
                  ? const Color(0xFFF4ED47).withOpacity(0.2)
                  : Colors.black.withOpacity(0.05),
                blurRadius: value != null ? 8 : 4,
                offset: const Offset(0, 2),
                spreadRadius: value != null ? 1 : 0,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: Container(
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: value != null
                      ? const Color(0xFFF4ED47).withOpacity(0.1)
                      : Colors.grey[100],
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: value != null
                      ? const Color(0xFFF4ED47)
                      : Colors.grey[600],
                    size: isMobile ? 22.sp : 28.sp,
                  ),
                ),
                dropdownColor: Colors.white,
                hint: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    hint,
                    style: TextStyle(
                      fontSize: isMobile ? 14.sp : (isTablet ? 18.sp : 22.sp),
                      color: Colors.grey[500],
                      fontFamily: 'AloeveraDisplayBold',
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontSize: isMobile ? 14.sp : (isTablet ? 18.sp : 22.sp),
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
                items: items.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 4.w,
                            height: 4.w,
                            margin: EdgeInsets.only(right: 12.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4ED47),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: isMobile ? 14.sp : (isTablet ? 18.sp : 20.sp),
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
                menuMaxHeight: 300.h,
              ),
            ),
          ),
        ),
      ],
    );
  }





  Widget _buildPhoneField({required bool isMobile, required bool isTablet}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'PHONE',
          style: TextStyle(
            fontFamily: 'AloeveraDisplayBold',
            color: const Color(0xFFF4ED47),
            fontSize: isMobile ? 16.sp : (isTablet ? 22.sp : 28.sp),
            fontWeight: FontWeight.bold,

          ),
        ),
        SizedBox(height: isMobile ? 0 : 2.h),
        SizedBox(
          height: isMobile ? 42.h : (isTablet ? 55.h : 60.h),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  constraints: BoxConstraints(
                    minWidth: isMobile ? 70.w : 80.w,
                    maxWidth: isMobile ? 90.w : 100.w,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedCountryCode,
                    underline: const SizedBox(),
                    isExpanded: false,
                    icon: Icon(Icons.arrow_drop_down, size: 18.sp),
                    items: _countryCodes.map((country) {
                      return DropdownMenuItem<String>(
                        value: country['code'],
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              country['flag']!,
                              style: TextStyle(
                                fontFamily: 'AloeveraDisplayBold',
                                fontSize: isMobile ? 12.sp : 14.sp,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              country['code']!,
                              style: TextStyle(
                                fontFamily: 'AloeveraDisplayBold',
                                fontSize: isMobile ? 14.sp : (isTablet ? 16.sp : 20.sp),
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCountryCode = value;
                        });
                      }
                    },
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: '01XXXXXXXXX',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: isMobile ? 16.sp : (isTablet ? 18.sp : 22.sp),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: isMobile ? 14.sp : 28.sp,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

