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

  // Form controllers
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
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

  List<String> preferredPropertyType = [
    "Commercial Unit",
    "Administrative Office",
    "Medical Clinic",
    "Hospital",
    "Building",
    "Land"
  ];
  String? selectedPreferredPropertyType;

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

  List<String> purposeOfPurchase = [
    "Investment",
    "Own Use",
    "Expansion",
    "Other"
  ];
  String? selectedPurposeOfPurchase;

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

    if (_sizeController.text.trim().isEmpty) {
      _showToast('Please enter your email');
      return;
    }

    if (!_validateEmail(_sizeController.text.trim())) {
      _showToast('Please enter a valid email address');
      return;
    }

    _showToast('Form submitted successfully!', isError: false);

    _fullNameController.clear();
    _phoneController.clear();
    _areaController.clear();
    _locationController.clear();
    _sizeController.clear();
    _budgetController.clear();
    _purposeController.clear();
    _otherRoleController.clear();
    setState(() {
      selectedRole = null;
    });
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
          image: AssetImage(isMobile ? Assets.imagesLeastBackgroundMob : Assets.imagesLeastBackground),
          fit: BoxFit.fill,
        ),
      ),
      width: double.infinity,
      height: isMobile ? 786.h : (isTablet ? 1200.h : 1200.h),
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
                  Gap(isMobile? 60.h : isTablet ? 70.h : 80.h),
                  Text(
                    'LEASE YOUR UNIT',
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
                  SizedBox(height: isMobile ? 10.h : (isTablet ? 20.h : 20.h)),
                  if(isMobile)
                    ButtonStyles.submitButtonMob(
                      width: isMobile ? 80.w : (isTablet ? 120.w : 180.w),
                      onPressed: _handleSubmit,
                    ),
                  if(!isMobile)
                    ButtonStyles.submitButton(
                      fontSize: isMobile ? 20.sp : (isTablet ? 26.sp : 43.sp),
                      width: isMobile ? 100.w : (isTablet ? 120.w : 180.w),
                      onPressed: _handleSubmit,
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
          Text(
            'ARE YOU',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'OptimalBold',
              color: const Color(0xFFF4ED47),
              fontSize: isMobile ? 18.sp : (isTablet ? 28.sp : 38.sp),
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),

          if (isMobile) ...[
            // Radio buttons for BUYER, SELLER, BROKER, OTHER (Mobile)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // BUYER
                Flexible(
                  child: RadioTheme(
                    data: RadioThemeData(
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                            (states) {
                          if (states.contains(MaterialState.selected)) {
                            return const Color(0xFFF4ED47); // عند الاختيار
                          }
                          return Colors.white; // عند عدم الاختيار
                        },
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: 'buyer',
                          groupValue: selectedRole,
                          onChanged: (value) {
                            setState(() {
                              selectedRole = value;
                              _otherRoleController.clear();
                            });
                          },
                          activeColor: const Color(0xFFF4ED47),
                        ),
                        const Text(
                          "BUYER",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                // SELLER
                Flexible(
                  child: RadioTheme(
                    data: RadioThemeData(
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                            (states) {
                          if (states.contains(MaterialState.selected)) {
                            return const Color(0xFFF4ED47); // عند الاختيار
                          }
                          return Colors.white; // عند عدم الاختيار
                        },
                      ),
                    ),
                    child:Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: 'seller',
                          groupValue: selectedRole,
                          onChanged: (value) {
                            setState(() {
                              selectedRole = value;
                              _otherRoleController.clear();
                            });
                          },
                          activeColor: const Color(0xFFF4ED47),
                        ),
                        const Text(
                          "SELLER",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: RadioTheme(
                    data: RadioThemeData(
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                            (states) {
                          if (states.contains(MaterialState.selected)) {
                            return const Color(0xFFF4ED47); // عند الاختيار
                          }
                          return Colors.white; // عند عدم الاختيار
                        },
                      ),
                    ),
                    child:Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: 'broker',
                          groupValue: selectedRole,
                          onChanged: (value) {
                            setState(() {
                              selectedRole = value;
                              _otherRoleController.clear();
                            });
                          },
                          activeColor: const Color(0xFFF4ED47),
                        ),
                        const Text(
                          "BROKER",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 24.h),
                // OTHER text field (Mobile)
                Expanded(
                  child: _buildOtherField(isMobile: isMobile, isTablet: isTablet),
                ),
              ],
            ),
            SizedBox(height: 15.h),

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
            _buildDropdownField("PREFERRED PROPERTY TYPE","CHOOSE",
              value: selectedPreferredPropertyType,
              items: preferredPropertyType,
              isMobile: isMobile,
              isTablet: isTablet,
              onChanged: (val) {
                setState(() {
                  selectedPreferredPropertyType = val;
                });
              },
            ),
            SizedBox(height: 15.h),
            _buildFormField(
              'LOCATION',
              controller: _locationController,
              keyboardType: TextInputType.emailAddress,
              isMobile: isMobile,
              isTablet: isTablet,
            ),
            SizedBox(height: 15.h),
            _buildFormField(
              'UNIT SIZE (SQM)',
              controller: _budgetController,
              keyboardType: TextInputType.emailAddress,
              isMobile: isMobile,
              isTablet: isTablet,
            ),
            SizedBox(height: 15.h),


            _buildFormField(
              'BUDGET / RENTAL PRICE (EGP)',
              controller: _sizeController,
              keyboardType: TextInputType.emailAddress,
              isMobile: isMobile,
              isTablet: isTablet,
            ),
            SizedBox(height: 15.h),
          ] else ...[





            // Radio buttons for BUYER, SELLER, BROKER, OTHER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // BUYER


                RadioTheme(
                  data: RadioThemeData(
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                          (states) {
                        if (states.contains(MaterialState.selected)) {
                          return const Color(0xFFF4ED47); // عند الاختيار
                        }
                        return Colors.white; // عند عدم الاختيار
                      },
                    ),
                  ),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'buyer',
                        groupValue: selectedRole,
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value;
                            _otherRoleController.clear();
                          });
                        },
                        activeColor: const Color(0xFFF4ED47),
                      ),
                      const Text(
                        "BUYER",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),


                // SELLER
                RadioTheme(
                  data: RadioThemeData(
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                          (states) {
                        if (states.contains(MaterialState.selected)) {
                          return const Color(0xFFF4ED47); // عند الاختيار
                        }
                        return Colors.white; // عند عدم الاختيار
                      },
                    ),
                  ),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'seller',
                        groupValue: selectedRole,
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value;
                            _otherRoleController.clear();
                          });
                        },
                      ),
                      const Text(
                        "SELLER",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),


                RadioTheme(
                  data: RadioThemeData(
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                          (states) {
                        if (states.contains(MaterialState.selected)) {
                          return const Color(0xFFF4ED47); // عند الاختيار
                        }
                        return Colors.white; // عند عدم الاختيار
                      },
                    ),
                  ),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'broker',
                        groupValue: selectedRole,
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value;
                            _otherRoleController.clear();
                          });
                        },
                        activeColor: const Color(0xFFF4ED47),
                      ),
                      const Text(
                        "BROKER",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // BROKER


                // OTHER text field
                _buildOtherField(isMobile: isMobile, isTablet: isTablet),
              ],
            ),

            SizedBox(height: isTablet ? 20.h : 30.h),

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
                    child: _buildDropdownField("PREFERRED PROPERTY TYPE","CHOOSE",
                      value: selectedPreferredPropertyType,
                      items: preferredPropertyType,
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
                  child: _buildFormField(
                    'LOCATION',
                    controller: _locationController,
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
                  child: _buildFormField(
                    'BUDGET / RENTAL PRICE (EGP)',
                    controller: _sizeController,
                    keyboardType: TextInputType.emailAddress,
                    isMobile: isMobile,
                    isTablet: isTablet,
                  ),
                ),
                SizedBox(width: isTablet ? 50.w : 100.w),
                Expanded(
                  child: _buildFormField(
                    'UNIT SIZE (SQM)',
                    controller: _budgetController,
                    keyboardType: TextInputType.emailAddress,
                    isMobile: isMobile,
                    isTablet: isTablet,
                  ),
                ),

              ],
            ),

          ],
          SizedBox(height: isMobile ? 10.h : isTablet ? 20.h : 30.h),
          _buildFormField(
            'DESCRIPTION / ADDITIONAL DETAILS',
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
            fontSize: isMobile ? 14.sp : (isTablet ? 22.sp : 28.sp),
            letterSpacing: 1,
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

  Widget _buildOtherField({required bool isMobile, required bool isTablet}) {
    double dropdownHeight() {
      if (isMobile) return 40.h;
      if (isTablet) return 48.h;
      return 55.h; // Web
    }
    return Container(
      width: 200,
      height: dropdownHeight(),
      margin: EdgeInsets.only(left: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Center(
        child: TextField(
          controller: _otherRoleController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'OTHER',
            isDense: true,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 12.h,
            ),
            hintStyle: TextStyle(
              fontFamily: 'AloeveraDisplayBold',
              color: Colors.grey[500],
              fontSize: isMobile ? 14.sp : (isTablet ? 16.sp : 20.sp),
            ),
          ),
          style: TextStyle(
            fontSize: isMobile ? 14.sp : (isTablet ? 16.sp : 20.sp),
            color: Colors.black,
          ),
        ),
      ),
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
          'PHONE NUMBER',
          style: TextStyle(
            color: const Color(0xFFF4ED47),
            fontSize: isMobile ? 14.sp : (isTablet ? 22.sp : 28.sp),
            letterSpacing: 1,
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
            fontSize: isMobile ? 14.sp : (isTablet ? 22.sp : 28.sp),
            letterSpacing: 1,
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