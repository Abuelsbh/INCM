import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/services_content_section.dart';
import '../../Widgets/footer_section.dart';
import '../../Widgets/footer_section_mob.dart';
import '../../Widgets/custom_app_bar_mob.dart';
import '../../core/responsive/native_layout.dart';

class ServicesScreen extends StatelessWidget {
  static const String routeName = '/services';

  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          useWebDesktopAppBar(context)
              ? const CustomAppBar()
              : const CustomAppBarMob(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const ServicesContentSection(),
                  SizedBox(height: 100.h),
                  if (kIsWeb)
                    (MediaQuery.sizeOf(context).width >= 600
                        ? const FooterSection()
                        : const FooterSectionMob()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
