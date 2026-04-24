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
import '../../core/Language/locales.dart';
import '../../core/Language/app_languages.dart';
import '../../core/Contact/contact_form_phone.dart';
import '../../core/Contact/contact_info_provider.dart';
import '../../core/Contact/contact_submission_service.dart';
import '../../core/responsive/native_layout.dart';
import '../../Utilities/font_helper.dart';
import '../../generated/assets.dart';
import 'package:provider/provider.dart';

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
  bool _isSubmitting = false;

  // Form controllers
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _areaController = TextEditingController();
  final _locationController = TextEditingController();
  final _emailController = TextEditingController();

  // Country code
  String _selectedCountryCode = '+20'; // Egypt as default

  List<String> locations = [
    "Alexandria",
    "6th Settlement",
    "Northern Expansion",
    "El Gouna",
    "North Coast-Sahel",
    "El Shorouk",
    "El Choueifat",
    "New Zayed",
    "El Sheikh Zayed",
    "Al Dabaa",
    "New Capital City",
    "Al Alamein",
    "Ain Sokhna",
    "Hurghada",
    "New Cairo",
    "Old Cairo",
    "Central Cairo",
    "El Lotus",
    "South Investors",
    "North Investors",
    "Maadi",
    "South New Cairo",
    "Golden Square",
    "October Gardens",
    "New Capital Gardens",
    "Ras El Hekma",
    "Ras Sudr",
    "New Sphinx",
    "Sahl Hasheesh",
    "Somabay",
    "Sidi Heneish",
    "Sidi Abdel Rahman",
    "Ghazala Bay",
    "6th of October City",
    "Mostakbal City",
    "Madinaty",
    "Mokattam",
    "New Heliopolis",
    "Heliopolis",
  ];
  String? selectedLocation;

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

  Future<void> _handleSubmit() async {
    if (_fullNameController.text.trim().isEmpty) {
      _showToast('PLEASE_ENTER_FULL_NAME'.tr(context));
      return;
    }

    if (_fullNameController.text.trim().length < 3) {
      _showToast('FULL_NAME_MIN_CHARS'.tr(context));
      return;
    }

    if (_phoneController.text.trim().isEmpty) {
      _showToast('PLEASE_ENTER_PHONE'.tr(context));
      return;
    }

    if (!_validatePhone(_phoneController.text.trim())) {
      _showToast('PLEASE_ENTER_VALID_PHONE'.tr(context));
      return;
    }

    if (_areaController.text.trim().isEmpty) {
      _showToast('PLEASE_ENTER_MESSAGE'.tr(context));
      return;
    }

    if (selectedLocation == null || selectedLocation!.isEmpty) {
      _showToast('PLEASE_SELECT_LOCATION'.tr(context));
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      _showToast('PLEASE_ENTER_EMAIL'.tr(context));
      return;
    }

    if (!_validateEmail(_emailController.text.trim())) {
      _showToast('PLEASE_ENTER_VALID_EMAIL'.tr(context));
      return;
    }

    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    final name = _fullNameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final fullPhone = contactFullPhone(_selectedCountryCode, phone);
    final buf = StringBuffer(_areaController.text.trim());
    buf.writeln('\n---\nLocation: ${selectedLocation!}');

    try {
      final result = await ContactSubmissionService.instance.submit(
        name: name,
        fullPhone: fullPhone,
        email: email,
        message: buf.toString(),
        emailSubject: 'Contact — Contact page — $name',
        formSourceSlug: 'contact_page',
        formSourceLabel: 'FORM_SOURCE_CONTACT_PAGE'.tr(context),
        contactSettingsHint: context.read<ContactInfoProvider>().contactInfo,
      );

      if (!mounted) return;

      if (!result.firestoreSaved) {
        _showToast('CONTACT_SUBMISSION_FAILED'.tr(context));
        return;
      }

      if (!result.emailSent) {
        _showToast('CONTACT_SAVED_EMAIL_PENDING'.tr(context), isError: false);
      } else {
        _showToast('FORM_SUBMITTED_SUCCESS'.tr(context), isError: false);
      }

      _fullNameController.clear();
      _phoneController.clear();
      _areaController.clear();
      setState(() {
        selectedLocation = null;
      });
      _emailController.clear();
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
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
        bottomNavigationBar: useNativeBottomNavigationBar(context) ? const BottomNavBarWidget(selected: SelectedBottomNavBar.contacts) : null,

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
              child: useWebDesktopAppBar(context)
                  ? const CustomAppBar()
                  : const CustomAppBarMob(),
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
          fit: BoxFit.fill ,
        ),
      ),
      width: double.infinity,
      //height: isMobile ? 1280.h : (isTablet ? 2000.h : 2074.h),
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
                  Gap(isMobile? 30.h : isTablet ? 70.h : 80.h),
                  Text(
                    'CONTACT_US'.tr(context),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: getLocalizedFont(context, 'OptimalBold'),
                      color: const Color(0xFFF4ED47),
                      fontSize: isMobile ? 22.sp : (isTablet ? 50.sp : 70.sp),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isMobile ? 14.h : (isTablet ? 20.h : 30.h)),
                  _buildContactForm(context, isMobile, isTablet),
                  Gap(isMobile ? 16.h : (isTablet ? 20.h : 60.h)),
                  _buildGetInTouchSection(context, isMobile, isTablet),

                  Gap(isMobile ? 32.h : (isTablet ? 40.h : 120.h)),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFC63424),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.h),
                    child: Text(
                      'OUR_LOCATION'.tr(context),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: getLocalizedFont(context, 'OptimalBold'),
                        color: const Color(0xFFF4ED47),
                        fontSize: isMobile ? 20.sp : (isTablet ? 38.sp : 50.sp),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Gap(isMobile ? 12.h : 24.h),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => setState(() => _isAddressHovered = true),
                    onExit: (_) => setState(() => _isAddressHovered = false),
                    child: Consumer<ContactInfoProvider>(
                      builder: (context, contactProvider, _) {
                        final info = contactProvider.contactInfo;
                        return GestureDetector(
                          onTap: () => _openLink(info.mapLink),
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
                                fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                fontWeight: FontWeight.w700,
                                decorationColor: _isAddressHovered
                                    ? const Color(0xFFC63424)
                                    : const Color(0xFFFFFFFF),
                              ),
                              child: Text(
                                info.address,
                                textDirection: TextDirection.ltr,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Gap(isMobile ? 15.h : (isTablet ? 70.h : 20.h)),

                    Consumer<ContactInfoProvider>(
                      builder: (context, contactProvider, _) {
                        final info = contactProvider.contactInfo;
                        return InkWell(
                          onTap: () => _openLink(info.mapLink),
                          child: Container(
                            height: isMobile ? 225.h : 550.h,
                          ),
                        );
                      },
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
            'FULL_NAME'.tr(context),
            context: context,
            controller: _fullNameController,
            keyboardType: TextInputType.name,
            isMobile: isMobile,
            isTablet: isTablet,
          ),
          SizedBox(height: 15.h),
          _buildPhoneField(context: context, isMobile: isMobile, isTablet: isTablet),
          SizedBox(height: 15.h),
          _buildFormField(
            'E_MAIL'.tr(context),
            context: context,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            isMobile: isMobile,
            isTablet: isTablet,
          ),
          SizedBox(height: 15.h),
          _buildDropdownField('LOCATION'.tr(context),'SELECT_LOCATION'.tr(context),
            context: context,
            value: selectedLocation,
            items: locations,
            isMobile: isMobile,
            isTablet: isTablet,
            onChanged: (val) {
              setState(() {
                selectedLocation = val;
              });
            },
          ),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: _buildFormField(
                  'FULL_NAME'.tr(context),
                  context: context,
                  controller: _fullNameController,
                  keyboardType: TextInputType.name,
                  isMobile: isMobile,
                  isTablet: isTablet,
                ),
              ),
              SizedBox(width: isTablet ? 75.w : 150.w),
              Expanded(
                child: _buildPhoneField(context: context, isMobile: isMobile, isTablet: isTablet),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 40.h : 60.h),
          Row(
            children: [
              Expanded(
                child: _buildFormField(
                  'E_MAIL'.tr(context),
                  context: context,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  isMobile: isMobile,
                  isTablet: isTablet,
                ),
              ),
              SizedBox(width: isTablet ? 75.w : 150.w),
              Expanded(
                child: _buildDropdownField('LOCATION'.tr(context),'CHOOSE'.tr(context),
                  context: context,
                  value: selectedLocation,
                  items: locations,
                  isMobile: isMobile,
                  isTablet: isTablet,
                  onChanged: (val) {
                    setState(() {
                      selectedLocation = val;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
        SizedBox(height: isMobile ? 15.h : isTablet ? 40.h : 60.h),
        _buildMessageField(
          'MESSAGE'.tr(context),
          context: context,
          hint: 'TYPE_YOUR_MESSAGE'.tr(context),
          controller: _areaController,
          isMobile: isMobile,
          isTablet: isTablet,
        ),
        SizedBox(height: isMobile ? 20.h : (isTablet ? 70.h : 40.h)),
        if(isMobile)
          ButtonStyles.submitButtonMob(
            width: 75.w,
            context: context,
            enabled: !_isSubmitting,
            onPressed: () => _handleSubmit(),
          ),
        if(!isMobile)
        ButtonStyles.submitButton(
          context: context,
          fontSize: isMobile ? 20.sp : (isTablet ? 26.sp : 43.sp),
          width: isMobile ? 100.w : (isTablet ? 120.w : 180.w),
          enabled: !_isSubmitting,
          onPressed: () => _handleSubmit(),
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
            'GET_IN_TOUCH'.tr(context),
            style: TextStyle(
              color: const Color(0xFFFFFFFF),
              fontSize: 22.sp,
              fontFamily: getLocalizedFont(context, 'OptimalBold'),
              fontWeight: FontWeight.w700,
            ),
          ),

          _buildSocialMediaRow(isMobile, isTablet),
          Gap(10.h),
          if(isMobile)
            Column(
              children: [
                Text(
                  'WORKING_HOURS'.tr(context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'FROM_SUNDAY_TO_THURSDAY'.tr(context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),

              ],
            ),
          _buildContactInfoColumn(isMobile, isTablet),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Gap(60.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GET_IN_TOUCH'.tr(context),
              style: TextStyle(
                color: const Color(0xFFFFFFFF),
                fontSize: isTablet ? 48.sp : 70.sp,
                fontFamily: getLocalizedFont(context, 'OptimalBold'),
                fontWeight: FontWeight.w700,
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
          'FOLLOW_US'.tr(context),
          style: TextStyle(
            color: const Color(0xFFFFFFFF),
            fontSize: isMobile ? 14.sp : (isTablet ? 32.sp : 50.sp),
            fontWeight: FontWeight.w700
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
    return Consumer<ContactInfoProvider>(
      builder: (context, contactProvider, _) {
        final info = contactProvider.contactInfo;
        return isMobile ? Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContactInfo(
              icon: Assets.iconsMail,
              text: info.email,
              iconColor: const Color(0xFFF4ED47),
              textColor: Colors.white,
              iconSize: 24.r,
              textSize: 12.sp,
              isClickable: true,
              onTap: () => _sendEmail(info.email),
            ),
            const Spacer(),
            AnimatedContactInfo(
              icon: Assets.iconsCall,
              text: info.phone,
              iconColor: const Color(0xFFF4ED47),
              textColor: Colors.white,
              iconSize: 24.r,
              textSize: 12.sp,
              isClickable: true,
              onTap: () => _makePhoneCall(info.phone),
            ),
          ],
        ) : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContactInfo(
              icon: Assets.iconsCall,
              text: info.phone,
              iconColor: const Color(0xFFF4ED47),
              textColor: Colors.white,
              iconSize: isMobile ? 36.r : (isTablet ? 44.r : 52.r),
              textSize: isMobile ? 28.sp : (isTablet ? 38.sp : 42.sp),
              isClickable: true,
              onTap: () => _makePhoneCall(info.phone),
            ),
            AnimatedContactInfo(
              icon: Assets.iconsMail,
              text: info.email,
              iconColor: const Color(0xFFF4ED47),
              textColor: Colors.white,
              iconSize: isMobile ? 36.r : (isTablet ? 44.r : 52.r),
              textSize: isMobile ? 28.sp : (isTablet ? 38.sp : 42.sp),
              isClickable: true,
              onTap: () => _sendEmail(info.email),
            ),

            Text(
          'WORKING_HOURS'.tr(context),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 26.sp : (isTablet ? 30.sp : 38.sp),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'FROM_SUNDAY_TO_THURSDAY'.tr(context),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 26.sp : (isTablet ? 20.sp : 28.sp),
          ),
        ),
      ],
    );
      },
    );
  }



  Widget _buildFormField(
      String label, {
        required BuildContext context,
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
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: height ?? (isMobile ? 36.h : (isTablet ? 48.h : 60.h)),
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
                  hintText: hint,
                  hintStyle: TextStyle(
                    fontFamily: 'AloeveraDisplayBold',
                    color: Colors.grey[500],
                    fontSize: isMobile ? 14.sp : (isTablet ? 18.sp : 28.sp),
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

  Widget _buildMessageField(
      String label, {
        required BuildContext context,
        required TextEditingController controller,
        String? hint,
        double? height,
        required bool isMobile,
        required bool isTablet
      }) {
    final appLang = Provider.of<AppLanguage>(context, listen: false);
    final isArabic = appLang.appLang == Languages.ar;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label??'',
          style: TextStyle(
            fontFamily: 'AloeveraDisplayBold',
            color: Colors.white,
            fontSize: isMobile ? 14.sp : (isTablet ? 22.sp : 28.sp),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: height ?? (isMobile ? 70.h : (isTablet ? 100.h : 120.h)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              textAlignVertical: TextAlignVertical.top,
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
                hintText: hint,
                hintTextDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                hintStyle: TextStyle(
                  fontFamily: 'AloeveraDisplayBold',
                  color: Colors.grey[500],
                  fontSize: isMobile ? 14.sp : (isTablet ? 18.sp : 28.sp),
                ),
              ),
              style: TextStyle(
                fontSize: isMobile ? 14.sp : 28.sp,
                color: Colors.black,
                fontFamily: 'AloeveraDisplayBold',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField({required BuildContext context, required bool isMobile, required bool isTablet}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'PHONE'.tr(context),
          style: TextStyle(
            fontFamily: 'AloeveraDisplayBold',
            color: Colors.white,
            fontSize: isMobile ? 14.sp : (isTablet ? 22.sp : 28.sp),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: isMobile ? 36.h : (isTablet ? 48.h : 60.h),
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

                  child: Center(
                    child: DropdownButton<String>(
                      value: _selectedCountryCode,
                      underline: const SizedBox(),
                      isExpanded: false,
                      icon: Icon(Icons.arrow_drop_down, size: 18.sp),
                      alignment: Alignment.center,
                      items: _countryCodes.map((country) {
                        return DropdownMenuItem<String>(
                          value: country['code'],
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
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
                          fontSize: isMobile ? 14.sp : (isTablet ? 18.sp : 22.sp),
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

  Widget _buildDropdownField(
      String label,
      String hint, {
        required BuildContext context,
        required String? value,
        required List<String> items,
        required Function(String?) onChanged,
        required bool isMobile,
        required bool isTablet,
      }) {

    double fontSize() {
      if (isMobile) return 14.sp;
      if (isTablet) return 18.sp;
      return 20.sp; // Web
    }

    double dropdownHeight() {
      if (isMobile) return 36.h;
      if (isTablet) return 48.h;
      return 60.h; // Web
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'AloeveraDisplayBold',
            color: Colors.white,
            fontSize: isMobile ? 14.sp : (isTablet ? 22.sp : 28.sp),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: isMobile ? 4.h : 10.h),

        Container(
          height: dropdownHeight(),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
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
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              borderRadius: BorderRadius.circular(15.r),
              icon: Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: value != null
                      ? const Color(0xFFF4ED47)
                      : Colors.grey[600],
                  size: fontSize() + 6,
                ),
              ),

              hint: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  hint,
                  style: TextStyle(
                    fontSize: fontSize(),
                    color: Colors.grey[500],
                  ),
                ),
              ),

              dropdownColor: Colors.white,
              style: TextStyle(
                fontSize: fontSize(),
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),

              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.w,
                        margin: EdgeInsets.only(right: 10.w),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF4ED47),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: fontSize(),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),

              onChanged: onChanged,
              menuMaxHeight: 300.h,
            ),
          ),
        ),
      ],
    );
  }
}