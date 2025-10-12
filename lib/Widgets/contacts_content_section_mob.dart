import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../generated/assets.dart';
import 'custom_button.dart';

class ContactsContentSectionMob extends StatefulWidget {
  const ContactsContentSectionMob({super.key});

  @override
  State<ContactsContentSectionMob> createState() => _ContactsContentSectionState();
}

class _ContactsContentSectionState extends State<ContactsContentSectionMob>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _hasAnimated = false;

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
    if (_areaController.text.trim().isEmpty) {
      _showToast('Please enter the area');
      return;
    }

    // Validate location
    if (_locationController.text.trim().isEmpty) {
      _showToast('Please enter the location');
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
    _areaController.clear();
    _locationController.clear();
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
            image: AssetImage(Assets.imagesContactUsBackgroundMob), // your background image asset
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5), // dark overlay for readability
              BlendMode.darken,
            ),
          ),
        ),
        width: double.infinity,
        height: 786.h,
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
                  width: MediaQuery.of(context).size.width,
                  constraints: BoxConstraints(
                    maxWidth: 750.w,
                    maxHeight: MediaQuery.of(context).size.height
                  ),
                  padding: EdgeInsets.all(40.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Text(
                        'CONTACT US',
                        style: TextStyle(
                          fontFamily: Assets.fontsOptimal,
                          color: const Color(0xFFFFC700),
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Subtitle
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: Assets.fontsOptimal, // 🔹 نفس الخط
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                          children: const [
                            TextSpan(text: 'READY TO BUILD SOMETHING '),
                            TextSpan(
                              text: 'GREAT',
                              style: TextStyle(color: Color(0xFFFFC700)), // 🔸 أصفر
                            ),
                            TextSpan(text: '?'),
                          ],
                        ),
                      ),


                      SizedBox(height: 40.h),

                      // Contact form
                      Column(
                        children: [

                          _buildFormField(
                            'FULL NAME',
                            controller: _fullNameController,
                            keyboardType: TextInputType.name,
                          ),
                          SizedBox(height: 20.h),
                          _buildPhoneField(),

                          SizedBox(height: 20.h),

                          // Area field
                          _buildFormField(
                            'AREA',
                            controller: _areaController,
                          ),

                          SizedBox(height: 20.h),

                          // Location field
                          _buildFormField(
                            'LOCATION',
                            controller: _locationController,
                          ),

                          SizedBox(height: 20.h),

                          // Email field
                          _buildFormField(
                            'E-MAIL',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          SizedBox(height: 40.h),

                          // Submit button
                          ButtonStyles.submitButtonMob(
                            width: 100.w,
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
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: Assets.fontsOptimal,
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 30.h, // ثابت لكل الحقول
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              textAlign: TextAlign.start, // 🔹 يبقي النص بمحاذاة اليسار
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h, // ✅ يجعل النص في المنتصف عموديًا
                ),
                hintText: label.toLowerCase(),
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16.sp,
                ),
              ),
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black,
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
          'YOUR NUMBER',
          style: TextStyle(
            fontFamily: Assets.fontsOptimal,
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 30.h, // 🔹 نفس الارتفاع
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
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
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              country['code']!,
                              style: TextStyle(
                                fontSize: 16.sp,
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
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h, // ✅ يجعل النص في المنتصف عموديًا
                      ),
                      hintText: 'your number',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 16.sp,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 16.sp,
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
