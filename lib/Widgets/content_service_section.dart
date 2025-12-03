import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../generated/assets.dart';
import 'clients_logos_section.dart';
import 'custom_button.dart';

class ContentServiceSection extends StatefulWidget {
  final TextEditingController? fullNameController;
  final TextEditingController? phoneController;
  final TextEditingController? messageController;
  final TextEditingController? locationController;
  final TextEditingController? emailController;
  final VoidCallback? onSubmit;

  const ContentServiceSection({
    super.key,
    this.fullNameController,
    this.phoneController,
    this.messageController,
    this.locationController,
    this.emailController,
    this.onSubmit,
  });

  @override
  State<ContentServiceSection> createState() => _ContentServiceSectionState();
}

class _ContentServiceSectionState extends State<ContentServiceSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _hasAnimated = false;

  // Form controllers - use provided or create new ones
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _messageController;
  late final TextEditingController _locationController;
  late final TextEditingController _emailController;
  
  // Track if we created the controllers (to dispose them)
  bool _shouldDisposeControllers = false;

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
    
    // Initialize controllers - use provided ones or create new
    _fullNameController = widget.fullNameController ?? TextEditingController();
    _phoneController = widget.phoneController ?? TextEditingController();
    _messageController = widget.messageController ?? TextEditingController();
    _locationController = widget.locationController ?? TextEditingController();
    _emailController = widget.emailController ?? TextEditingController();
    
    // Track if we need to dispose controllers (only if we created them)
    _shouldDisposeControllers = widget.fullNameController == null &&
        widget.phoneController == null &&
        widget.messageController == null &&
        widget.locationController == null &&
        widget.emailController == null;
    
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
    // Only dispose controllers if we created them
    if (_shouldDisposeControllers) {
      _fullNameController.dispose();
      _phoneController.dispose();
      _messageController.dispose();
      _locationController.dispose();
      _emailController.dispose();
    }
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
    // If custom submit handler is provided, use it
    if (widget.onSubmit != null) {
      widget.onSubmit!();
      return;
    }

    // Default validation and submission logic
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
    _messageController.clear();
    _locationController.clear();
    _emailController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return VisibilityDetector(
      key: const Key('contacts-content-section'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Container(

      width: double.infinity,
        height: 800.h,
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

                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                 Text( 'CONTACT US',
                   style: TextStyle(
                     fontFamily: 'OptimalBold',
                     color: const Color(0xFFF4ED47),
                     fontSize: isMobile? 32.sp : 72.sp,
                     fontWeight: FontWeight.bold,
                     letterSpacing: 2,
                   ),),



                  SizedBox(height: 65.h),

                  // Contact form
                  Column(
                    children: [
                      // Full Name and Phone Number row

                      isMobile
                          ? Column(
                        children: [
                          _buildFormField(
                            'FULL NAME',
                            controller: _fullNameController,
                            keyboardType: TextInputType.name,
                          ),
                          SizedBox(height: 20.w),
                          _buildPhoneField(),
                          SizedBox(height: 20.h),
                          _buildFormField(
                            'E-MAIL',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 20.h),
                          _buildFormField(
                            'LOCATION',
                            controller: _locationController,
                          ),
                        ],
                      )
                          : Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildFormField(
                                  'FULL NAME',
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
                          Row(
                            children: [
                              Expanded(
                                child:_buildFormField(
                                  'E-MAIL',
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                              SizedBox(width: 60.w),
                              Expanded(
                                child: _buildFormField(
                                  'LOCATION',
                                  controller: _locationController,
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),


                      SizedBox(height: 20.h),
                      // Location field
                      _buildFormField(
                        'MESSAGE',
                        hint: 'type your message',
                        height: 82.h,
                        controller: _messageController,
                      ),

                      SizedBox(height: 40.h),
                      // Submit button
                      ButtonStyles.submitButton(
                        fontSize: isMobile? 18.sp: 32.sp,
                            width: isMobile? 85.w : 185.w,
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
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'AloeveraDisplayBold',
            color: Colors.white,
            fontSize: isMobile? 14.sp :26.sp,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: height != null ? height : isMobile ? 42.h : 60.h, // 🔹 الارتفاع الثابت لكل الحقول
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
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildPhoneField() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PHONE',
          style: TextStyle(
            fontFamily: 'OptimalBold',
            color: Colors.white,
            fontSize: isMobile? 14.sp : 26.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: isMobile? 42.h :60.h, // 🔹 نفس الارتفاع
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
                              style: TextStyle( fontFamily: 'OptimalBold',fontSize: 14.sp),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              country['code']!,
                              style: TextStyle(
                                fontFamily: 'OptimalBold',
                                fontSize: isMobile? 12.sp :20.sp,
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
                        fontSize: isMobile? 14.sp :26.sp,
              ),
            ),
            style: TextStyle(
                      fontSize: isMobile? 14.sp : 26.sp,
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
