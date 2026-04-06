import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../core/Contact/contact_form_phone.dart';
import '../core/Contact/contact_info_provider.dart';
import '../core/Contact/contact_submission_service.dart';
import '../core/Language/locales.dart';
import '../Utilities/font_helper.dart';
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
  final bool showCategoryField;

  /// Shown in email subject and stored inside the message body (e.g. service name).
  final String? sourceTag;

  const ContentServiceSection({
    super.key,
    this.fullNameController,
    this.phoneController,
    this.messageController,
    this.locationController,
    this.emailController,
    this.onSubmit,
    this.showCategoryField = false,
    this.sourceTag,
  });

  @override
  State<ContentServiceSection> createState() => _ContentServiceSectionState();
}

class _ContentServiceSectionState extends State<ContentServiceSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _hasAnimated = false;
  bool _isSubmitting = false;

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

  List<String> categories = [
    "Coffee & Beverages",
    "Fast food",
    "Casual Dining / Restaurants",
    "Desserts & Bakery",
    "Cloud Kitchen",
    "Fashion & Apparel",
    "Beauty & Cosmetics",
    "Accessories & Lifestyle",
    "Health & Pharmacy",
    "Mini Market",
    "Grab & Go",
    "Daily Essentials",
  ];
  String? selectedCategory;

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

  Future<void> _handleSubmit() async {
    if (widget.onSubmit != null) {
      widget.onSubmit!();
      return;
    }

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

    if (_messageController.text.trim().isEmpty) {
      _showToast('PLEASE_ENTER_MESSAGE'.tr(context));
      return;
    }

    if (widget.showCategoryField) {
      if (selectedCategory == null || selectedCategory!.isEmpty) {
        _showToast('PLEASE_SELECT_CATEGORY'.tr(context));
        return;
      }
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
    final buf = StringBuffer(_messageController.text.trim());
    buf.writeln('\n---\nLocation: ${selectedLocation!}');
    if (widget.showCategoryField && selectedCategory != null) {
      buf.writeln('Category: ${selectedCategory!}');
    }
    if (widget.sourceTag != null && widget.sourceTag!.trim().isNotEmpty) {
      buf.writeln('Form: ${widget.sourceTag!.trim()}');
    }

    final tag = widget.sourceTag?.trim();
    final serviceLabel = (tag != null && tag.isNotEmpty)
        ? '${'FORM_SOURCE_SERVICE'.tr(context)} — $tag'
        : 'FORM_SOURCE_SERVICE'.tr(context);
    final subject = (tag != null && tag.isNotEmpty)
        ? 'Contact — $tag — $name'
        : 'Contact — $name';

    try {
      final result = await ContactSubmissionService.instance.submit(
        name: name,
        fullPhone: fullPhone,
        email: email,
        message: buf.toString(),
        emailSubject: subject,
        formSourceSlug: 'service',
        formSourceLabel: serviceLabel,
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
      _messageController.clear();
      setState(() {
        selectedLocation = null;
        if (widget.showCategoryField) {
          selectedCategory = null;
        }
      });
      _emailController.clear();
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
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
                 Text( 'CONTACT_US'.tr(context),
                   style: TextStyle(
                     fontFamily: getLocalizedFont(context, 'OptimalBold'),
                     color: const Color(0xFFF4ED47),
                     fontSize: isMobile? 32.sp : 72.sp,
                     fontWeight: FontWeight.bold,
                   ),),



                  SizedBox(height: 35.h),

                  // Contact form
                  Column(
                    children: [
                      // Full Name and Phone Number row

                      isMobile
                          ? Column(
                        children: [
                          _buildFormField(
                            'FULL_NAME'.tr(context),
                            controller: _fullNameController,
                            keyboardType: TextInputType.name,
                          ),
                          SizedBox(height: 20.w),
                          _buildPhoneField(),
                          SizedBox(height: 20.h),
                          _buildFormField(
                            'E_MAIL'.tr(context),
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 20.h),
                          if (widget.showCategoryField) ...[
                            _buildDropdownField(
                              'CATEGORY'.tr(context),
                              'SELECT_CATEGORY'.tr(context),
                              value: selectedCategory,
                              items: categories,
                              onChanged: (val) {
                                setState(() {
                                  selectedCategory = val;
                                });
                              },
                            ),
                            SizedBox(height: 20.h),
                          ],
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
                        ],
                      )
                          : Column(
                        children: [
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
                          Row(
                            children: [
                              Expanded(
                                child:_buildFormField(
                                  'E_MAIL'.tr(context),
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                              SizedBox(width: 60.w),
                              Expanded(
                                child: widget.showCategoryField
                                    ? _buildDropdownField(
                                        'CATEGORY'.tr(context),
                                        'SELECT_CATEGORY'.tr(context),
                                        value: selectedCategory,
                                        items: categories,
                                        onChanged: (val) {
                                          setState(() {
                                            selectedCategory = val;
                                          });
                                        },
                                      )
                                    : _buildDropdownField(
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
                              ),
                            ],
                          ),
                          if (widget.showCategoryField) ...[
                            SizedBox(height: 20.h),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDropdownField(
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
                                ),
                                SizedBox(width: 60.w),
                                Expanded(child: SizedBox()), // Empty space for alignment
                              ],
                            ),
                          ],

                        ],
                      ),


                      SizedBox(height: 20.h),
                      // Location field
                      _buildFormField(
                        'MESSAGE'.tr(context),
                        hint: 'TYPE_YOUR_MESSAGE'.tr(context),
                        height: 82.h,
                        controller: _messageController,
                      ),

                      SizedBox(height: 40.h),
                      // Submit button

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
                          fontSize: isMobile? 18.sp: 32.sp,
                          width: isMobile? 75.w : 130.w,
                          enabled: !_isSubmitting,
                          onPressed: () => _handleSubmit(),
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
          'PHONE'.tr(context),
          style: TextStyle(
            fontFamily: 'AloeveraDisplayBold',
            color: Colors.white,
            fontSize: isMobile? 14.sp : 26.sp,
            fontWeight: FontWeight.bold,
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
                              style: TextStyle( fontFamily: getLocalizedFont(context, 'OptimalBold'),fontSize: 14.sp),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              country['code']!,
                              style: TextStyle(
                                fontFamily: 'AloeveraDisplayBold',
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
                      contentPadding: EdgeInsets.zero,
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

  Widget _buildDropdownField(
      String label,
      String hint, {
        required String? value,
        required List<String> items,
        required Function(String?) onChanged,
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
            fontSize: isMobile? 14.sp : 26.sp,
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: isMobile? 42.h : 60.h,
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
                    size: isMobile? 18.sp : 26.sp,
                  ),
                ),
                hint: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    hint,
                    style: TextStyle(
                      fontSize: isMobile? 14.sp : 26.sp,
                      fontFamily: 'AloeveraDisplayBold',
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                dropdownColor: Colors.white,
                style: TextStyle(
                  fontSize: isMobile? 14.sp : 26.sp,
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
                              fontSize: isMobile? 14.sp : 26.sp,
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
