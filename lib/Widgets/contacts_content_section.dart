import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visibility_detector/visibility_detector.dart';
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
    super.dispose();
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
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5), // dark overlay for readability
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
                  width: MediaQuery.of(context).size.width * 0.6,
                  constraints: BoxConstraints(
                    maxWidth: 750.w,
                    maxHeight: MediaQuery.of(context).size.height * 0.9,
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
                          fontSize: 32.sp,
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
                            fontSize: 18.sp,
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
                          // Full Name and Phone Number row
                          Row(
                            children: [
                              Expanded(
                                child: _buildFormField('FULL NAME'),
                              ),
                              SizedBox(width: 60.w),
                              Expanded(
                                child: _buildFormField('YOUR NUMBER'),
                              ),
                            ],
                          ),

                          SizedBox(height: 20.h),

                          // Area field
                          _buildFormField('AREA'),

                          SizedBox(height: 20.h),

                          // Location field
                          _buildFormField('LOCATION'),

                          SizedBox(height: 20.h),

                          // Email field
                          _buildFormField('E-MAIL'),

                          SizedBox(height: 40.h),

                          // Submit button
                          ButtonStyles.submitButton(
                            onPressed: () {
                              // Add submit functionality
                            },
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

  Widget _buildFormField(String label) {
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
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: TextField(


            decoration: InputDecoration(
              isDense: true, // ← هذا يجعل الحقل أقل ارتفاعاً
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              hintText: label.toLowerCase(),
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 14.sp,
              ),
            ),
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
