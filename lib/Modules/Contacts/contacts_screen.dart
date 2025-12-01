import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../Widgets/bottom_navbar_widget.dart';
import '../../Widgets/contacts_content_section.dart';
import '../../Widgets/contacts_content_section_mob.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/custom_app_bar_mob.dart';
import '../../Widgets/custom_button.dart';
import '../../Widgets/floating_contact_buttons.dart';
import '../../Widgets/scroll_to_top_button.dart';
import '../../Widgets/animated_contact_info.dart';
import '../../generated/assets.dart';

class ContactsScreen extends StatefulWidget {
  static const String routeName = '/contacts';

  const ContactsScreen({Key? key}) : super(key: key);

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _hasAnimated = false;
  final ScrollController _scrollController = ScrollController();
  bool _isAddressHovered = false;

  // Form controllers
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _areaController = TextEditingController();
  final _locationController = TextEditingController();
  final _emailController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!_hasAnimated && info.visibleFraction >= 0.3) {
      _hasAnimated = true;
      _animationController.forward();
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _openLink(String link) async {
    final Uri googleMapsUri = Uri.parse(link);

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _areaController.dispose();
    _locationController.dispose();
    _emailController.dispose();
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

    if (_areaController.text.trim().isEmpty) {
      _showToast('Please enter the area');
      return;
    }

    if (_locationController.text.trim().isEmpty) {
      _showToast('Please enter the location');
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

    _showToast('Form submitted successfully!', isError: false);

    _fullNameController.clear();
    _phoneController.clear();
    _areaController.clear();
    _locationController.clear();
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

  // Helper method to determine if screen is desktop
  bool _isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = _isMobile(context);
    final isTablet = _isTablet(context);

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
                child: Column(
                  children: [
                    _buildContactFormSection(context, isMobile, isTablet),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: isMobile ? const CustomAppBarMob() : const CustomAppBar(),
            ),
            const FloatingContactButtons(),
            ScrollToTopButton(scrollController: _scrollController),
          ],
        ),
      ),
    );
  }

  Widget _buildContactFormSection(BuildContext context, bool isMobile, bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(isMobile ? Assets.imagesContactPageMob : Assets.imagesContactPage),
          fit: BoxFit.fill,
        ),
      ),
      width: double.infinity,
      height: isMobile ? 1280.h : (isTablet ? 2000.h : 2074.h),
      child: Center(
        child: SingleChildScrollView(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: child,
              );
            },
            child: Container(
              width: isMobile
                  ? MediaQuery.of(context).size.width * 0.9
                  : (isTablet
                  ? MediaQuery.of(context).size.width * 0.85
                  : MediaQuery.of(context).size.width * 0.8),
              padding: EdgeInsets.all(isMobile ? 20.w : (isTablet ? 30.w : 40.w)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Gap(isMobile? 60.h : isTablet ? 70.h : 80.h),
                  Text(
                    'CONTACT US',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'OptimalBold',
                      color: const Color(0xFFF4ED47),
                      fontSize: isMobile ? 26.sp : (isTablet ? 50.sp : 70.sp),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: isMobile ? 20.h : (isTablet ? 20.h : 30.h)),
                  _buildContactForm(context, isMobile, isTablet),
                  Gap(isMobile ? 50.h : (isTablet ? 20.h : 100.h)),
                  _buildGetInTouchSection(context, isMobile, isTablet),

                  Gap(isMobile ? 15.h : (isTablet ? 40.h : 180.h)),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFC63424),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.h),
                    child: Text(
                      'OUR LOCATION',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'OptimalBold',
                        color: const Color(0xFFF4ED47),
                        fontSize: isMobile ? 20.sp : (isTablet ? 38.sp : 50.sp),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Gap(4.h),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => setState(() => _isAddressHovered = true),
                    onExit: (_) => setState(() => _isAddressHovered = false),
                    child: GestureDetector(
                      onTap: () => _openLink('https://maps.app.goo.gl/xcCQnFRxJymzVune6'),
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 200),
                        tween: Tween<double>(
                          begin: 0,
                          end: _isAddressHovered ? -10 : 0,
                        ),
                        builder: (context, dy, child) {
                          return Transform.translate(
                            offset: Offset(0, dy),
                            child: child,
                          );
                        },
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            color: _isAddressHovered
                                ? const Color(0xFFC63424)
                                : const Color(0xFFFFFFFF),
                            fontSize: isMobile ? 14.sp : (isTablet ? 30.sp : 40.sp),
                            fontFamily: 'OptimalBold',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                            decorationColor: _isAddressHovered
                                ? const Color(0xFFC63424)
                                : const Color(0xFFFFFFFF),
                          ),
                          child: const Text('14 A/2 Admin building. New Cairo, Egypt'),
                        ),
                      ),
                    ),
                  ),
                  Gap(isMobile ? 15.h : (isTablet ? 70.h : 20.h)),

                    InkWell(
                        onTap: ()=> _openLink('https://maps.app.goo.gl/xcCQnFRxJymzVune6'),
                        child: Container(
                          height: isMobile ? 225.h : 550.h,
                        )
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactForm(BuildContext context, bool isMobile, bool isTablet) {
    return Column(
      children: [
        if (isMobile) ...[
          _buildFormField(
            'FULL NAME',
            controller: _fullNameController,
            keyboardType: TextInputType.name,
            isMobile: isMobile,
            isTablet: isTablet,
          ),
          SizedBox(height: 15.h),
          _buildPhoneField(isMobile: isMobile, isTablet: isTablet),
          SizedBox(height: 15.h),
          _buildFormField(
            'E-MAIL',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            isMobile: isMobile,
            isTablet: isTablet,
          ),
          SizedBox(height: 15.h),
          _buildFormField(
            'LOCATION',
            controller: _locationController,
            isMobile: isMobile,
            isTablet: isTablet,
          ),
        ] else ...[
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
                child: _buildFormField(
                  'LOCATION',
                  controller: _locationController,
                  isMobile: isMobile,
                  isTablet: isTablet,
                ),
              ),
            ],
          ),
        ],
        SizedBox(height: isMobile ? 15.h : isTablet ? 40.h : 60.h),
        _buildFormField(
          'MESSAGE',
          hint: 'type your message',
          controller: _areaController,
          isMobile: isMobile,
          isTablet: isTablet,
        ),
        SizedBox(height: isMobile ? 70.h : (isTablet ? 70.h : 80.h)),
        if(isMobile)
          ButtonStyles.submitButtonMob(
            width: isMobile ? 90.w : (isTablet ? 120.w : 180.w),
            onPressed: _handleSubmit,
          ),
        if(!isMobile)
        ButtonStyles.submitButton(
          fontSize: isMobile ? 20.sp : (isTablet ? 26.sp : 43.sp),
          width: isMobile ? 100.w : (isTablet ? 120.w : 180.w),
          onPressed: _handleSubmit,
        ),
      ],
    );
  }

  Widget _buildGetInTouchSection(BuildContext context, bool isMobile, bool isTablet) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'GET IN TOUCH',
            style: TextStyle(
              color: const Color(0xFFFFFFFF),
              fontSize: 22.sp,
              fontFamily: 'OptimalBold',
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),

          _buildSocialMediaRow(isMobile, isTablet),
          Gap(10.h),
          if(isMobile)
            Column(
              children: [
                Gap(24.h),
                Text(
                  'WORKING HOURS: 10AM TO 6PM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '  FROM SUNDAY TO THURSDAY',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
                Gap(24.h),
              ],
            ),
          _buildContactInfoColumn(isMobile, isTablet),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Gap(60.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GET IN TOUCH',
              style: TextStyle(
                color: const Color(0xFFFFFFFF),
                fontSize: isTablet ? 48.sp : 70.sp,
                fontFamily: 'OptimalBold',
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            _buildSocialMediaRow(isMobile, isTablet),
          ],
        ),
        Gap(isTablet ? 20.w : 30.w),
        Container(
          height: isTablet ? 120.h : 150.h,
          width: 3.w,
          color: const Color(0xFFF4ED47),
        ),
        Gap(isTablet ? 20.w : 30.w),
        _buildContactInfoColumn(isMobile, isTablet),
      ],
    );
  }

  Widget _buildSocialMediaRow(bool isMobile, bool isTablet) {
    final iconSize = isMobile ? 24.r : (isTablet ? 40.r : 48.r);
    final spacing = isMobile ? 8.w : 20.w;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'FOLLOW US',
          style: TextStyle(
            color: const Color(0xFFFFFFFF),
            fontSize: isMobile ? 14.sp : (isTablet ? 32.sp : 50.sp),
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        SizedBox(width: spacing),
        AnimatedContactInfo(icon: Assets.iconsFace, text: '',isClickable: true, iconColor: const Color(0xFFF4ED47),
          onTap: () => _openLink('https://www.facebook.com/Incomercial.egypt'),iconSize: isMobile ? 20.r : (isTablet ? 36.r : 40.r)),
        SizedBox(width: isMobile ? 4.w : (isTablet ? 10.w : 14.w)),
        AnimatedContactInfo(icon: Assets.iconsInsta, text: '',isClickable: true, iconColor: const Color(0xFFF4ED47),
          onTap: () => _openLink('https://www.instagram.com/incomercial.egypt/'),iconSize: isMobile ? 20.r : (isTablet ? 36.r : 40.r)),
        SizedBox(width: isMobile ? 4.w : (isTablet ? 10.w : 14.w)),
        AnimatedContactInfo(icon: Assets.iconsLinked, text: '',isClickable: true, iconColor: const Color(0xFFF4ED47),
          onTap: () => _openLink('https://www.facebook.com/Incomercial.egypt'),iconSize: isMobile ? 20.r : (isTablet ? 36.r : 40.r)),
        SizedBox(width: isMobile ? 4.w : (isTablet ? 10.w : 14.w)),
        AnimatedContactInfo(icon: Assets.iconsTik, text: '',isClickable: true, iconColor: const Color(0xFFF4ED47),
          onTap: () => _openLink('https://www.tiktok.com/@incomercial.egypt'),iconSize: isMobile ? 20.r : (isTablet ? 36.r : 40.r)),
      ],
    );
  }

  Widget _buildContactInfoColumn(bool isMobile, bool isTablet) {
    return isMobile ? Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedContactInfo(
          icon: Assets.iconsMail,
          text: 'Incomercial@gmail.com',
          iconColor: const Color(0xFFF4ED47),
          textColor: Colors.white,
          iconSize: 24.r,
          textSize: 12.sp,
          isClickable: true,
          onTap: () => _sendEmail('Incomercial@gmail.com'),
        ),
        const Spacer(),
        AnimatedContactInfo(
          icon: Assets.iconsCall,
          text: '0111-032-7777',
          iconColor: const Color(0xFFF4ED47),
          textColor: Colors.white,
          iconSize: 24.r,
          textSize: 12.sp,
          isClickable: true,
          onTap: () => _makePhoneCall('0111-032-7777'),
        ),
        


      ],
    ) : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContactInfo(
          icon: Assets.iconsCall,
          text: '0111-032-7777',
          iconColor: const Color(0xFFF4ED47),
          textColor: Colors.white,
          iconSize: isMobile ? 36.r : (isTablet ? 44.r : 52.r),
          textSize: isMobile ? 28.sp : (isTablet ? 38.sp : 42.sp),
          isClickable: true,
          onTap: () => _makePhoneCall('0111-032-7777'),
        ),
        //SizedBox(height: isMobile ? 16.h : 16.h),
        AnimatedContactInfo(
          icon: Assets.iconsMail,
          text: 'Incomercial@gmail.com',
          iconColor: const Color(0xFFF4ED47),
          textColor: Colors.white,
          iconSize: isMobile ? 36.r : (isTablet ? 44.r : 52.r),
          textSize: isMobile ? 28.sp : (isTablet ? 38.sp : 42.sp),
          isClickable: true,
          onTap: () => _sendEmail('Incomercial@gmail.com'),
        ),

        Text(
          'WORKING HOURS: 10AM TO 6PM',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 26.sp : (isTablet ? 30.sp : 38.sp),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '  FROM SUNDAY TO THURSDAY',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 26.sp : (isTablet ? 20.sp : 28.sp),
          ),
        ),
      ],
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
            color: Colors.white,
            fontSize: isMobile ? 16.sp : (isTablet ? 22.sp : 28.sp),
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: height ?? (isMobile ? 34.h : (isTablet ? 48.h : 60.h)),
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

  Widget _buildPhoneField({required bool isMobile, required bool isTablet}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'PHONE',
          style: TextStyle(
            fontFamily: 'AloeveraDisplayBold',
            color: Colors.white,
            fontSize: isMobile ? 16.sp : (isTablet ? 22.sp : 28.sp),
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: isMobile ? 34.h : (isTablet ? 48.h : 60.h),
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
                  child: Center(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: '01XXXXXXXXX',
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 0.h,
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
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}