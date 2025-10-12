import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Utilities/theme_helper.dart';
import '../generated/assets.dart';

class BottomNavBarWidget extends StatelessWidget {
  final SelectedBottomNavBar selected;

  const BottomNavBarWidget({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 85.h,
      decoration: BoxDecoration(
        color: const Color(0xFFf6e848),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, -2),
            blurRadius: 20.r,
            spreadRadius: 0,
          ),
        ],
        border: Border(
          top: BorderSide(
            color: ThemeClass.of(context).backGroundColor.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              _BottomNavBarItemWidget(
                model: _BottomNavBarItemModel.sellYourUnit,
                currentItem: selected,
              ),
              _BottomNavBarItemWidget(
                model: _BottomNavBarItemModel.services,
                currentItem: selected,
              ),
              _BottomNavBarItemWidget(
                model: _BottomNavBarItemModel.home,
                currentItem: selected,
              ),
              _BottomNavBarItemWidget(
                model: _BottomNavBarItemModel.aboutUs,
                currentItem: selected,
              ),
              _BottomNavBarItemWidget(
                model: _BottomNavBarItemModel.contacts,
                currentItem: selected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavBarItemWidget extends StatefulWidget {
  final _BottomNavBarItemModel model;
  final SelectedBottomNavBar currentItem;

  const _BottomNavBarItemWidget({
    required this.model,
    required this.currentItem,
  });

  bool get isSelected => model.type == currentItem;

  @override
  State<_BottomNavBarItemWidget> createState() => _BottomNavBarItemWidgetState();
}

class _BottomNavBarItemWidgetState extends State<_BottomNavBarItemWidget> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: widget.model.onTap ?? () {},
      child: Container(
      width: 60.w,
      height: 60.h,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // Icon
          Image.asset(
            widget.model.iconPath,
            width: 20.r,
            height: 20.r,
          ),

          SizedBox(height: 4.h),

          // Title
          Text(
            widget.model.title,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
              color: const Color(0xFF8B0000),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),

    );
  }
}

class _BottomNavBarItemModel {
  final String iconPath;
  final String title;
  final String routeName;
  final SelectedBottomNavBar type;
  final Function()? onTap;

  _BottomNavBarItemModel({
    this.onTap,
    required this.iconPath,
    required this.title,
    required this.type,
    this.routeName = '',
  });

  static _BottomNavBarItemModel sellYourUnit = _BottomNavBarItemModel(
    title: 'SELL YOUR UNIT',
    iconPath: Assets.iconsSellYourUnit,
    type: SelectedBottomNavBar.sellYourUnit,
    //routeName: DraftScreen.routeName,
  );

  static _BottomNavBarItemModel services = _BottomNavBarItemModel(
    title: 'SERVICES',
    iconPath: Assets.iconsServices,
    type: SelectedBottomNavBar.services,
    //routeName: AiScreen.routeName,
  );

  static _BottomNavBarItemModel home = _BottomNavBarItemModel(
    title: 'HOME',
    iconPath: Assets.iconsHome,
    type: SelectedBottomNavBar.home,
    //routeName: InboxScreen.routeName,
  );

  static _BottomNavBarItemModel aboutUs = _BottomNavBarItemModel(
    title: 'ABOUT US',
    iconPath: Assets.iconsAboutUs,
    type: SelectedBottomNavBar.aboutUs,
    //routeName: OutboxScreen.routeName,
  );

  static _BottomNavBarItemModel contacts = _BottomNavBarItemModel(
      title: 'CONTACTS',
      iconPath: Assets.iconsContacts,
      type: SelectedBottomNavBar.contacts,
      //routeName: "menu"
  );
}

enum SelectedBottomNavBar {sellYourUnit, services, home, aboutUs, contacts }
