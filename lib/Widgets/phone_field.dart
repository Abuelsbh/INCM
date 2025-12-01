import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class PhoneField extends StatefulWidget {
  const PhoneField({super.key, required this.isMobile, required this.isTablet});
  final bool isMobile;
  final bool isTablet;
  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
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

  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'PHONE',
          style: TextStyle(
            fontFamily: 'AloeveraDisplayBold',
            color: Colors.white,
            fontSize: widget.isMobile ? 16.sp : (widget.isTablet ? 22.sp : 28.sp),
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: widget.isMobile ? 42.h : (widget.isTablet ? 55.h : 60.h),
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
                    minWidth: widget.isMobile ? 70.w : 80.w,
                    maxWidth: widget.isMobile ? 90.w : 100.w,
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
                                fontSize: widget.isMobile ? 12.sp : 14.sp,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              country['code']!,
                              style: TextStyle(
                                fontFamily: 'AloeveraDisplayBold',
                                fontSize: widget.isMobile ? 14.sp : (widget.isTablet ? 16.sp : 20.sp),
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
                        vertical: 12.h,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: widget.isMobile ? 16.sp : (widget.isTablet ? 18.sp : 22.sp),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: widget.isMobile ? 14.sp : 28.sp,
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

