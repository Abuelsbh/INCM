import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:incm/core/Contact/contact_form_phone.dart';
import 'package:incm/core/Contact/contact_submission_service.dart';
import 'package:incm/core/Language/locales.dart';
import '../../Utilities/font_helper.dart';
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
import '../../Widgets/footer_section.dart';
import '../../Widgets/footer_section_mob.dart';
import '../../generated/assets.dart';

class LeaseScreen extends StatefulWidget {
  static const String routeName = '/lease';

  const LeaseScreen({Key? key}) : super(key: key);

  @override
  State<LeaseScreen> createState() => _LeaseScreenState();
}

class _LeaseScreenState extends State<LeaseScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _hasAnimated = false;
  final ScrollController _scrollController = ScrollController();
  bool _isAddressHovered = false;
  bool _isSubmitting = false;

  // Form controllers
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _areaController = TextEditingController();
  final _locationController = TextEditingController();
  final _sizeController = TextEditingController();
  final _budgetController = TextEditingController();
  final _purposeController = TextEditingController();
  final _otherRoleController = TextEditingController();

  String? selectedRole; // 'buyer', 'seller', 'broker', or null

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

  List<String> get preferredPropertyTypeKeys => [
    "COMMERCIAL_UNIT",
    "ADMINISTRATIVE_OFFICE",
    "MEDICAL_CLINIC",
    "HOSPITAL",
    "BUILDING",
    "LAND"
  ];
  String? selectedPreferredPropertyType;

  List<String> get locationKeys => [
    "LOCATION_ALEXANDRIA",
    "LOCATION_6TH_SETTLEMENT",
    "LOCATION_NORTHERN_EXPANSION",
    "LOCATION_EL_GOUNA",
    "LOCATION_NORTH_COAST_SAHEL",
    "LOCATION_EL_SHOROUK",
    "LOCATION_EL_CHOUEIFAT",
    "LOCATION_NEW_ZAYED",
    "LOCATION_EL_SHEIKH_ZAYED",
    "LOCATION_AL_DABAA",
    "LOCATION_NEW_CAPITAL_CITY",
    "LOCATION_AL_ALAMEIN",
    "LOCATION_AIN_SOKHNA",
    "LOCATION_HURGHADA",
    "LOCATION_NEW_CAIRO",
    "LOCATION_OLD_CAIRO",
    "LOCATION_CENTRAL_CAIRO",
    "LOCATION_EL_LOTUS",
    "LOCATION_SOUTH_INVESTORS",
    "LOCATION_NORTH_INVESTORS",
    "LOCATION_MAADI",
    "LOCATION_SOUTH_NEW_CAIRO",
    "LOCATION_GOLDEN_SQUARE",
    "LOCATION_OCTOBER_GARDENS",
    "LOCATION_NEW_CAPITAL_GARDENS",
    "LOCATION_RAS_EL_HEKMA",
    "LOCATION_RAS_SUDR",
    "LOCATION_NEW_SPHINX",
    "LOCATION_SAHL_HASHEESH",
    "LOCATION_SOMABAY",
    "LOCATION_SIDI_HENEISH",
    "LOCATION_SIDI_ABDEL_RAHMAN",
    "LOCATION_GHAZALA_BAY",
    "LOCATION_6TH_OF_OCTOBER_CITY",
    "LOCATION_MOSTAKBAL_CITY",
    "LOCATION_MADINATY",
    "LOCATION_MOKATTAM",
    "LOCATION_NEW_HELIOPOLIS",
    "LOCATION_HELIOPOLIS",
  ];
  String? selectedLocation;

  @override
  void initState() {
    super.initState();
    _hasAnimated = false;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animationController.reset();

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Listen to other role text field changes
    _otherRoleController.addListener(() {
      if (_otherRoleController.text.trim().isNotEmpty && selectedRole != null) {
        setState(() {
          selectedRole = null;
        });
      }
    });
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
    _emailController.dispose();
    _areaController.dispose();
    _locationController.dispose();
    _sizeController.dispose();
    _budgetController.dispose();
    _purposeController.dispose();
    _otherRoleController.dispose();
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
    final context = this.context;
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
      _showToast('PLEASE_ENTER_AREA'.tr(context));
      return;
    }

    if (selectedLocation == null || selectedLocation!.isEmpty) {
      _showToast('PLEASE_SELECT_LOCATION'.tr(context));
      return;
    }

    if (_budgetController.text.trim().isEmpty) {
      _showToast('PLEASE_ENTER_UNIT_SIZE'.tr(context));
      return;
    }

    if (_sizeController.text.trim().isEmpty) {
      _showToast('PLEASE_ENTER_RENTAL_BUDGET'.tr(context));
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
    final buf = StringBuffer();
    buf.writeln('Details / area: ${_areaController.text.trim()}');
    buf.writeln('Location: ${selectedLocation!.tr(context)}');
    if (selectedPreferredPropertyType != null) {
      buf.writeln(
        'Property type: ${selectedPreferredPropertyType!.tr(context)}',
      );
    }
    buf.writeln('Unit size (SQM): ${_budgetController.text.trim()}');
    buf.writeln('Budget / rental price (EGP): ${_sizeController.text.trim()}');
    buf.writeln('Notes / purpose: ${_purposeController.text.trim()}');
    if (selectedRole != null) {
      buf.writeln('Role: $selectedRole');
    } else if (_otherRoleController.text.trim().isNotEmpty) {
      buf.writeln('Role (other): ${_otherRoleController.text.trim()}');
    }

    try {
      final result = await ContactSubmissionService.instance.submit(
        name: name,
        fullPhone: fullPhone,
        email: email,
        message: buf.toString(),
        emailSubject: 'Lease — $name',
        formSourceSlug: 'lease',
        formSourceLabel: 'FORM_SOURCE_LEASE'.tr(context),
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
      _emailController.clear();
      _areaController.clear();
      _sizeController.clear();
      _budgetController.clear();
      _purposeController.clear();
      _otherRoleController.clear();
      setState(() {
        selectedRole = null;
        selectedLocation = null;
        selectedPreferredPropertyType = null;
      });
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
        bottomNavigationBar: MediaQuery.of(context).size.width < 600 && !kIsWeb ? const BottomNavBarWidget(selected: SelectedBottomNavBar.contacts) : null,

        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: VisibilityDetector(
                key: const Key('lease-content-section'),
                onVisibilityChanged: _onVisibilityChanged,
                child: Column(
                  children: [
                    _buildContactFormSection(context, isMobile, isTablet),
                    // Footer
                    if(MediaQuery.of(context).size.width >= 600)
                      const FooterSection()
                    else if(kIsWeb)
                      const FooterSectionMob(),
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
      width: double.infinity,
      height: isMobile ? 1000.h : (isTablet ? 1200.h : 1200.h),
      child:  Center(
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
                  ? MediaQuery.of(context).size.width * 0.8
                  : MediaQuery.of(context).size.width * 0.75),
              padding: EdgeInsets.all(isMobile ? 20.w : (isTablet ? 30.w : 40.w)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Gap(isMobile? 40.h : isTablet ? 70.h : 80.h),
                  Text(
                    'LEASE_YOUR_UNIT'.tr(context),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: getLocalizedFont(context, 'OptimalBold'),
                      color: const Color(0xFFF4ED47),
                      fontSize: isMobile ? 26.sp : (isTablet ? 50.sp : 70.sp),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isMobile ? 20.h : (isTablet ? 20.h : 30.h)),
                  _buildContactForm(context, isMobile, isTablet),
                  SizedBox(height: isMobile ? 10.h : (isTablet ? 20.h : 20.h)),
                  if(isMobile)
                    ButtonStyles.submitButtonMob(
                      context: context,
                      width: isMobile ? 80.w : (isTablet ? 120.w : 180.w),
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactForm(BuildContext context, bool isMobile, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile? 12.w : 36.w, vertical: isMobile? 12.h : 36.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          // Title
          Text(
            'ARE_YOU'.tr(context),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: getLocalizedFont(context, 'OptimalBold'),
              color: const Color(0xFFF4ED47),
              fontSize: isMobile ? 18.sp : (isTablet ? 28.sp : 38.sp),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isMobile ? 15.h : 20.h),

          // Role Selection
          isMobile || isTablet
              ? Container(
                  // Mobile/Tablet: 2 rows with 2 columns each
                  width: double.infinity,
                  child: Column(
                    children: [
                      // First Row: BUYER and SELLER
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(isMobile ? 12.w : 20.w),
                              child: _buildCheckboxOption(
                                'buyer',
                                'BUYER'.tr(context),
                                isMobile,
                                isTablet,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(isMobile ? 12.w : 20.w),
                              child: _buildCheckboxOption(
                                'seller',
                                'SELLER'.tr(context),
                                isMobile,
                                isTablet,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Second Row: BROKER and OTHER
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(isMobile ? 12.w : 20.w),
                              child: _buildCheckboxOption(
                                'broker',
                                'BROKER'.tr(context),
                                isMobile,
                                isTablet,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(isMobile ? 12.w : 20.w),
                              child: _buildOtherCheckboxOption(
                                isMobile,
                                isTablet,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Container(
                  // Desktop: All 4 options in one row
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: _buildCheckboxOption(
                          'buyer',
                          'BUYER'.tr(context),
                          isMobile,
                          isTablet,
                        ),
                      ),
                      SizedBox(width: 30.w),
                      Flexible(
                        child: _buildCheckboxOption(
                          'seller',
                          'SELLER'.tr(context),
                          isMobile,
                          isTablet,
                        ),
                      ),
                      SizedBox(width: 30.w),
                      Flexible(
                        child: _buildCheckboxOption(
                          'broker',
                          'BROKER'.tr(context),
                          isMobile,
                          isTablet,
                        ),
                      ),
                      SizedBox(width: 30.w),
                      Flexible(
                        flex: 1,
                        child: _buildOtherCheckboxOptionDesktop(
                          isMobile,
                          isTablet,
                        ),
                      ),
                    ],
                  ),
                ),
          SizedBox(height: 15.h),

          if (isMobile) ...[
            _buildFormField(
              'FULL_NAME'.tr(context),
              controller: _fullNameController,
              keyboardType: TextInputType.name,
              isMobile: isMobile,
              isTablet: isTablet,
            ),
            SizedBox(height: 15.h),
            _buildPhoneField(isMobile: isMobile, isTablet: isTablet),
            SizedBox(height: 15.h),
            _buildFormField(
              'E_MAIL'.tr(context),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              isMobile: isMobile,
              isTablet: isTablet,
            ),
            SizedBox(height: 15.h),
            _buildDropdownField("PREFERRED_PROPERTY_TYPE".tr(context),"CHOOSE".tr(context),
              value: selectedPreferredPropertyType,
              items: preferredPropertyTypeKeys,
              isMobile: isMobile,
              isTablet: isTablet,
              onChanged: (val) {
                setState(() {
                  selectedPreferredPropertyType = val;
                });
              },
            ),
            SizedBox(height: 15.h),
            _buildDropdownField("LOCATION".tr(context),"SELECT_LOCATION".tr(context),
              value: selectedLocation,
              items: locationKeys,
              isMobile: isMobile,
              isTablet: isTablet,
              onChanged: (val) {
                setState(() {
                  selectedLocation = val;
                });
              },
            ),
            SizedBox(height: 15.h),
            _buildFormField(
              'UNIT_SIZE_SQM'.tr(context),
              controller: _budgetController,
              keyboardType: TextInputType.number,
              isMobile: isMobile,
              isTablet: isTablet,
            ),
            SizedBox(height: 15.h),
            _buildFormField(
              'BUDGET_RENTAL_PRICE_EGP'.tr(context),
              controller: _sizeController,
              keyboardType: TextInputType.number,
              isMobile: isMobile,
              isTablet: isTablet,
            ),
            SizedBox(height: 15.h),
          ] else ...[






            SizedBox(height: isTablet ? 20.h : 30.h),

            Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    'FULL_NAME'.tr(context),
                    controller: _fullNameController,
                    keyboardType: TextInputType.name,
                    isMobile: isMobile,
                    isTablet: isTablet,
                  ),
                ),
                SizedBox(width: isTablet ? 50.w : 100.w),
                Expanded(
                  child: _buildPhoneField(isMobile: isMobile, isTablet: isTablet),
                ),
              ],
            ),
            SizedBox(height: isTablet ? 20.h : 30.h),
            Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    'E_MAIL'.tr(context),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    isMobile: isMobile,
                    isTablet: isTablet,
                  ),
                ),
              ],
            ),
            SizedBox(height: isTablet ? 20.h : 30.h),
            Row(
              children: [
                Expanded(
                    child: _buildDropdownField("PREFERRED_PROPERTY_TYPE".tr(context),"CHOOSE".tr(context),
                      value: selectedPreferredPropertyType,
                      items: preferredPropertyTypeKeys,
                      isMobile: isMobile,
                      isTablet: isTablet,
                      onChanged: (val) {
                        setState(() {
                          selectedPreferredPropertyType = val;
                        });
                      },
                    )
                ),
                SizedBox(width: isTablet ? 50.w : 100.w),
                Expanded(
                    child: _buildDropdownField("LOCATION".tr(context),"CHOOSE".tr(context),
                      value: selectedLocation,
                      items: locationKeys,
                      isMobile: isMobile,
                      isTablet: isTablet,
                      onChanged: (val) {
                        setState(() {
                          selectedLocation = val;
                        });
                      },
                    )
                ),

              ],
            ),

            SizedBox(height: isTablet ? 20.h : 30.h),
            Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    'BUDGET_RENTAL_PRICE_EGP'.tr(context),
                    controller: _sizeController,
                    keyboardType: TextInputType.number,
                    isMobile: isMobile,
                    isTablet: isTablet,
                  ),
                ),
                SizedBox(width: isTablet ? 50.w : 100.w),
                Expanded(
                  child: _buildFormField(
                    'UNIT_SIZE_SQM'.tr(context),
                    controller: _budgetController,
                    keyboardType: TextInputType.number,
                    isMobile: isMobile,
                    isTablet: isTablet,
                  ),
                ),

              ],
            ),

          ],
          SizedBox(height: isMobile ? 10.h : isTablet ? 20.h : 30.h),
          _buildFormField(
            'DESCRIPTION_ADDITIONAL_DETAILS'.tr(context),
            controller: _areaController,
            isMobile: isMobile,
            isTablet: isTablet,
          ),

        ],
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
    double dropdownHeight() {
      if (isMobile) return 40.h;
      if (isTablet) return 48.h;
      return 55.h; // Web
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label??'',
          style: TextStyle(
            color: const Color(0xFFF4ED47),
            fontSize: isMobile ? 14.sp : (isTablet ? 22.sp : 30.sp),
            fontWeight: FontWeight.w900, // هنا السُمك
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: dropdownHeight(),
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

  Widget _buildCheckboxOption(String value, String label, bool isMobile, bool isTablet) {
    final isSelected = selectedRole == value;
    return InkWell(
      onTap: () {
        setState(() {
          selectedRole = value;
          _otherRoleController.clear();
        });
      },
      child: Row(
        children: [
          // Square Checkbox
          Container(
            width: isMobile ? 20.w : 24.w,
            height: isMobile ? 20.w : 24.w,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFF4ED47) : Colors.transparent,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    color: Colors.black,
                    size: isMobile ? 14.sp : 16.sp,
                  )
                : null,
          ),
          SizedBox(width: 12.w),
          // Label
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 14.sp : (isTablet ? 16.sp : 18.sp),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherCheckboxOption(bool isMobile, bool isTablet) {
    final isOtherSelected = _otherRoleController.text.trim().isNotEmpty;
    final isSelected = selectedRole == 'other' || isOtherSelected;
    
    return Row(
      children: [
        // Square Checkbox
        InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedRole = null;
                _otherRoleController.clear();
              } else {
                selectedRole = 'other';
              }
            });
          },
          child: Container(
            width: isMobile ? 20.w : 24.w,
            height: isMobile ? 20.w : 24.w,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFF4ED47) : Colors.transparent,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    color: Colors.black,
                    size: isMobile ? 14.sp : 16.sp,
                  )
                : null,
          ),
        ),
        SizedBox(width: 12.w),
        // Text Field
        Expanded(
          child: Container(
            height: isMobile ? 35.h : (isTablet ? 40.h : 45.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: TextField(
              controller: _otherRoleController,
              keyboardType: TextInputType.text,
              onChanged: (value) {
                setState(() {
                  if (value.trim().isNotEmpty) {
                    selectedRole = 'other';
                  } else if (selectedRole == 'other') {
                    selectedRole = null;
                  }
                });
              },
              decoration: InputDecoration(
                hintText: 'OTHER'.tr(context),
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: isMobile ? 12.sp : (isTablet ? 14.sp : 16.sp),
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: TextStyle(
                fontSize: isMobile ? 12.sp : (isTablet ? 14.sp : 16.sp),
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtherCheckboxOptionDesktop(bool isMobile, bool isTablet) {
    final isOtherSelected = _otherRoleController.text.trim().isNotEmpty;
    final isSelected = selectedRole == 'other' || isOtherSelected;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Square Checkbox
        InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedRole = null;
                _otherRoleController.clear();
              } else {
                selectedRole = 'other';
              }
            });
          },
          child: Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFF4ED47) : Colors.transparent,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 16.sp,
                  )
                : null,
          ),
        ),
        SizedBox(width: 12.w),
        // Text Field
        Expanded(
          child: Container(
            height: 45.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: TextField(
              textAlign: TextAlign.center,
              controller: _otherRoleController,
              keyboardType: TextInputType.text,
              onChanged: (value) {
                setState(() {
                  if (value.trim().isNotEmpty) {
                    selectedRole = 'other';
                  } else if (selectedRole == 'other') {
                    selectedRole = null;
                  }
                });
              },
              decoration: InputDecoration(
                hintText: 'OTHER'.tr(context),
                isDense: true,
                border: InputBorder.none,

                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField({required bool isMobile, required bool isTablet}) {
    double dropdownHeight() {
      if (isMobile) return 40.h;
      if (isTablet) return 48.h;
      return 55.h; // Web
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'PHONE_NUMBER'.tr(context),
          style: TextStyle(
            color: const Color(0xFFF4ED47),
            fontSize: isMobile ? 14.sp : (isTablet ? 22.sp : 30.sp),
            fontWeight: FontWeight.w900, // هنا السُمك
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: dropdownHeight(),
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
                                fontSize: isMobile ? 12.sp : 14.sp,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              country['code']!,
                              style: TextStyle(
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

  Widget _buildDropdownField(
      String label,
      String hint, {
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
      if (isMobile) return 40.h;
      if (isTablet) return 48.h;
      return 55.h; // Web
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFFF4ED47),
            fontSize: isMobile ? 14.sp : (isTablet ? 22.sp : 30.sp),
            fontWeight: FontWeight.w900, // هنا السُمك
          ),
        ),
        SizedBox(height: isMobile ? 4.h : 10.h),

        Container(
          height: dropdownHeight(),
          //width: isMobile ? double.infinity : 350.w, // 🔥 مهم للويب
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
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              borderRadius: BorderRadius.circular(12.r),
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

              selectedItemBuilder: (BuildContext context) {
                return items.map<Widget>((String item) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      value != null ? value!.tr(context) : hint,
                      style: TextStyle(
                        fontSize: fontSize(),
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList();
              },

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
                          item.tr(context),
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