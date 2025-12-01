import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../Modules/Home/home_screen.dart';
import '../Modules/Contacts/contacts_screen.dart';
import '../generated/assets.dart';
import 'custom_button.dart';

class CustomAppBarMob extends StatefulWidget {
  const CustomAppBarMob({super.key});

  @override
  State<CustomAppBarMob> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBarMob> {
  bool isMenuOpen = false;

  void _scrollToSection(String sectionId) {
    if (sectionId == 'contacts') {
      context.go(ContactsScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 60.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            border: Border(
              bottom: BorderSide(
                color: const Color(0xFFF4ED47).withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            // Logo Section (Left) - INCOMERCIAL with tagline
            GestureDetector(
              onTap: () =>  context.go(HomeScreen.routeName),
              child: Image.asset(kIsWeb ? Assets.imagesINCMLogo : Assets.imagesINCMLogoMob, height: double.infinity,fit: BoxFit.cover, width: kIsWeb ? 100.w : 50.w,)
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     Text(
              //       'INCOMERCIAL',
              //       style: TextStyle(
              //         color: const Color(0xFFFFC700),
              //         fontSize: 20.sp,
              //         fontWeight: FontWeight.w600,
              //         letterSpacing: 0.5,
              //       ),
              //     ),
              //     Text(
              //       'Consult. Manage. Lease.',
              //       style: TextStyle(
              //         color: const Color(0xFFFFC700).withOpacity(0.8),
              //         fontSize: 12.sp,
              //         fontWeight: FontWeight.w400,
              //         letterSpacing: 0.3,
              //       ),
              //     ),
              //   ],
              // ),
            ),


            const Spacer(),

            // Explore Us Button (Right side)
                if(kIsWeb)
                ButtonStyles.getAppButton(
                  onPressed: () => {},
                  width: 55.w
                ),

            SizedBox(width: 16.w),


                InkWell(
                  onTap: () {
                    setState(() {
                      isMenuOpen = !isMenuOpen;
                    });
                  },
                  child: Icon(
                    isMenuOpen ? Icons.close : Icons.menu,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                )
              ],
            ),
          ),
        ),


      ],
    );
  }

}