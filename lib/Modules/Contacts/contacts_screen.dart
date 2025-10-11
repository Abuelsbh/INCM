import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/contacts_content_section.dart';
import '../../Widgets/footer_section.dart';

class ContactsScreen extends StatelessWidget {
  static const String routeName = '/contacts';

  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const CustomAppBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const ContactsContentSection(),
                  SizedBox(height: 50.h),
                  const FooterSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
