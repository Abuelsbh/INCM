import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../core/Language/locales.dart';
import '../Utilities/font_helper.dart';
import '../generated/assets.dart';
import 'custom_button.dart';

class ContactsContentSection extends StatefulWidget {
  const ContactsContentSection({super.key});

  @override
  State<ContactsContentSection> createState() => _ContactsContentSectionState();
}

class _ContactsContentSectionState extends State<ContactsContentSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _hasAnimated = false;

  // Form controllers
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
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

    // Fade animation: 0 -> 1
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
    // Start animation when at least 30% of the widget is visible
    if (!_hasAnimated && info.visibleFraction >= 0.3) {
      _hasAnimated = true;
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
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
    // Validate full name
    if (_fullNameController.text.trim().isEmpty) {
      _showToast('Please enter your full name');
      return;
    }

    if (_fullNameController.text.trim().length < 3) {
      _showToast('Full name must be at least 3 characters');
      return;
    }

    // Validate phone
    if (_phoneController.text.trim().isEmpty) {
      _showToast('Please enter your phone number');
      return;
    }

    if (!_validatePhone(_phoneController.text.trim())) {
      _showToast('Please enter a valid phone number (9-15 digits)');
      return;
    }

    // Validate area
    if (_messageController.text.trim().isEmpty) {
      _showToast('Please enter the message');
      return;
    }

    // Validate location
    if (selectedLocation == null || selectedLocation!.isEmpty) {
      _showToast('Please select a location');
      return;
    }

    // Validate email
    if (_emailController.text.trim().isEmpty) {
      _showToast('Please enter your email');
      return;
    }

    if (!_validateEmail(_emailController.text.trim())) {
      _showToast('Please enter a valid email address');
      return;
    }

    // All validations passed
    _showToast('Form submitted successfully!', isError: false);
    
    // Clear form after successful submission
    _fullNameController.clear();
    _phoneController.clear();
    _messageController.clear();
    setState(() {
      selectedLocation = null;
    });
    _emailController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('contacts-content-section'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.imagesContactUsBackground), // your background image asset
          fit: BoxFit.cover,colorFilter: ColorFilter.mode(
          Colors.black.withOpacity(0.4), // درجة التغميق – زوّدها أو قلّلها
          BlendMode.darken,
        ),
        ),
      ),
      width: double.infinity,
        height: 1200.h,
      child: Stack(
        children: [
          Center(
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
                width: MediaQuery.of(context).size.width * 0.8,
                constraints: BoxConstraints(
                    maxWidth: 950.w,
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                padding: EdgeInsets.all(40.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'NEED_EXPERTS_ADVICE'.tr(context).toUpperCase(),
                          style: TextStyle(
                            fontFamily: getLocalizedFont(context, 'OptimalBold'),
                            color: const Color(0xFFF4ED47),
                            fontSize: 60.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '?',
                          style: TextStyle(
                            color: const Color(0xFFF4ED47),
                            fontSize: 55.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),


                  
                  SizedBox(height: 65.h),
                  
                  // Contact form
                  Column(
                    children: [
                      // Full Name and Phone Number row
                      Row(
                        children: [
                          Expanded(
                                child: _buildFormField(
                                  'FULL_NAME'.tr(context),
                                  controller: _fullNameController,
                                  keyboardType: TextInputType.name,
                                ),
                          ),
                          SizedBox(width: 60.w),
                          Expanded(
                                child: _buildPhoneField(),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 20.h),

                      

                      // Email field
                      _buildFormField(
                        'E_MAIL'.tr(context),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      
                      SizedBox(height: 20.h),

                      // Location dropdown
                      _buildDropdownField(
                        'LOCATION'.tr(context),
                        'SELECT_LOCATION'.tr(context),
                        value: selectedLocation,
                        items: locations,
                        onChanged: (val) {
                          setState(() {
                            selectedLocation = val;
                          });
                        },
                      ),

                      SizedBox(height: 20.h),

                      // Location field
                      _buildFormField(
                        'MESSAGE'.tr(context),
                        hint: 'TYPE_YOUR_MESSAGE'.tr(context),
                        height: 100.h,
                        controller: _messageController,
                      ),

                      
                      SizedBox(height: 40.h),
                      
                      // Submit button
                      ButtonStyles.submitButton(
                            context: context,
                            width: 120.w,
                            onPressed: _handleSubmit,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'AloeveraDisplayBold',
            color: Colors.white,
            fontSize: 26.sp,
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: height ?? 48.h, // 🔹 الارتفاع الثابت لكل الحقول
          child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: TextField(
              controller: controller,
              keyboardType: keyboardType,
            decoration: InputDecoration(
                isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
              style: TextStyle(
                fontFamily: 'AloeveraDisplayBold',
                color: Colors.black,
                fontSize: 26.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PHONE'.tr(context),
          style: TextStyle(
            fontFamily: 'AloeveraDisplayBold',
            color: Colors.white,
            fontSize: 26.sp,
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 48.h, // 🔹 نفس الارتفاع
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Country code dropdown
                Container(
                  constraints: BoxConstraints(minWidth: 80.w, maxWidth: 100.w),
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
                              style: TextStyle( fontFamily: 'AloeveraDisplayBold',fontSize: 14.sp),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              country['code']!,
                              style: TextStyle(
                                fontFamily: 'AloeveraDisplayBold',
                                fontSize: 20.sp,
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
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                      hintText: '01XXXXXXXXX',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 26.sp,
                        fontFamily: 'AloeveraDisplayBold',
              ),
            ),
            style: TextStyle(
              fontFamily: 'AloeveraDisplayBold',
                      fontSize: 26.sp,
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

  Widget _buildDropdownField(
      String label,
      String hint, {
        required String? value,
        required List<String> items,
        required Function(String?) onChanged,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'AloeveraDisplayBold',
            color: Colors.white,
            fontSize: 26.sp,
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 48.h,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
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
                borderRadius: BorderRadius.circular(8.r),
                icon: Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: value != null
                        ? const Color(0xFFF4ED47)
                        : Colors.grey[600],
                    size: 26.sp,
                  ),
                ),
                hint: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    hint,
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontFamily: 'AloeveraDisplayBold',
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                dropdownColor: Colors.white,
                style: TextStyle(
                  fontSize: 26.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'AloeveraDisplayBold',
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
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'AloeveraDisplayBold',
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
        ),
      ],
    );
  }

}
