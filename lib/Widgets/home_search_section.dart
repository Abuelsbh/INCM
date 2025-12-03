import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import '../Modules/About/about_screen.dart';
import '../Modules/Buy/buy_screen.dart';
import '../Modules/Career/career_screen.dart';
import '../Modules/Contacts/contacts_screen.dart';
import '../Modules/Home/home_screen.dart';
import '../Modules/Lease/lease_screen.dart';
import '../Modules/Sell/sell_screen.dart';
import '../Modules/Services/Consultation/consultation_screen.dart';
import '../Modules/Services/CorporateLeasing/corporate_leasing_screen.dart';
import '../Modules/Services/FacilityManagement/facility_management_screen.dart';
import '../Modules/Services/FranchiseInvestment/franchise_investment_screen.dart';
import '../Modules/Services/Marketing/marketing_screen.dart';
import '../Modules/Services/MedicalLeasing/medical_leasing_screen.dart';
import '../Modules/Services/PrimaryInvestment/primary_investment_screen.dart';
import '../Modules/Services/RetailLeasing/retail_leasing_screen.dart';
import '../generated/assets.dart';

class HomeSearchSection extends StatefulWidget {
  const HomeSearchSection({super.key});

  @override
  State<HomeSearchSection> createState() => _HomeSearchSectionState();
}

class _HomeSearchSectionState extends State<HomeSearchSection> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<Map<String, String>> _searchResults = [];
  bool _showResults = false;

  // List of all searchable pages
  final List<Map<String, String>> _searchableItems = [
    {'name': 'Home', 'route': HomeScreen.routeName, 'category': 'Main'},
    {'name': 'About Us', 'route': AboutScreen.routeName, 'category': 'Main'},
    {'name': 'Contacts', 'route': ContactsScreen.routeName, 'category': 'Main'},
    {'name': 'Buy', 'route': BuyScreen.routeName, 'category': 'Main'},
    {'name': 'Sell', 'route': SellScreen.routeName, 'category': 'Main'},
    {'name': 'Lease', 'route': LeaseScreen.routeName, 'category': 'Main'},
    {'name': 'Career', 'route': CareerScreen.routeName, 'category': 'Main'},
    {'name': 'Corporate Leasing', 'route': CorporateLeasingScreen.routeName, 'category': 'Services'},
    {'name': 'Consultation', 'route': ConsultationScreen.routeName, 'category': 'Services'},
    {'name': 'Marketing', 'route': MarketingScreen.routeName, 'category': 'Services'},
    {'name': 'Medical Leasing', 'route': MedicalLeasingScreen.routeName, 'category': 'Services'},
    {'name': 'Facility Management', 'route': FacilityManagementScreen.routeName, 'category': 'Services'},
    {'name': 'Primary Investment', 'route': PrimaryInvestmentScreen.routeName, 'category': 'Services'},
    {'name': 'Retail Leasing', 'route': RetailLeasingScreen.routeName, 'category': 'Services'},
    {'name': 'Franchise Investment', 'route': FranchiseInvestmentScreen.routeName, 'category': 'Services'},
  ];

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onFocusChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _showResults = false;
      });
    } else {
      setState(() {
        _searchResults = _searchableItems
            .where((item) => item['name']!.toLowerCase().contains(query))
            .toList();
        _showResults = _searchResults.isNotEmpty && _searchFocusNode.hasFocus;
      });
    }
  }

  void _onFocusChanged() {
    setState(() {
      _showResults = _searchController.text.isNotEmpty && 
                     _searchResults.isNotEmpty && 
                     _searchFocusNode.hasFocus;
    });
  }

  void _navigateToPage(String route) {
    _searchController.clear();
    _searchFocusNode.unfocus();
    setState(() {
      _showResults = false;
    });
    context.go(route);
  }

  void _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.asset(Assets.videosWebsite);
      await _videoController.initialize();
      _videoController.setLooping(true);
      _videoController.setVolume(0.0); // Mute the video for background
      await _videoController.play();
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }
    } catch (e) {
      print('Error initializing video: $e');
      if (mounted) {
        setState(() {
          _isVideoInitialized = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1200.h,
      width: double.infinity,
      child: Stack(
        children: [
          // Video Background
          Positioned.fill(
            child: _isVideoInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoController.value.size.width,
                      height: _videoController.value.size.height,
                      child: VideoPlayer(_videoController),
                    ),
                  )
                : Container(

                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
          ),
          // Background INCM text/logo

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'EXPLORE INCM WORLD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'AloeveraDisplayBold',
                    color: const Color(0xFFF4ED47),
                    fontSize: 112.sp,
                    height: 0.2,
                  ),
                ),
                Text(
                  'STEP INTO A WORLD WHERE REAL ESTATE MEETS INNOVATION AND EXCELLENCE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'AloeveraDisplayRegular',
                    color: Colors.white,
                    fontSize: 30.sp,
                  ),
                ),
                Gap(50.h),
                // Search Bar
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(maxWidth: 900.w),
                  child: Column(
                    children: [
                      Container(
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.w),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: const Color(0xFFF4ED47),
                                size: 50.sp,
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: SizedBox(
                                  height: 60,
                                  child: TextField(
                                    controller: _searchController,
                                    focusNode: _searchFocusNode,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                      hintText: 'Search...',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 32.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    style: TextStyle(
                                      fontSize: 32.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Search Results Dropdown
                      if (_showResults && _searchResults.isNotEmpty)
                        Container(
                          margin: EdgeInsets.only(top: 8.h),
                          constraints: BoxConstraints(
                            maxHeight: 400.h,
                            maxWidth: 900.w,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final item = _searchResults[index];
                              return InkWell(
                                onTap: () => _navigateToPage(item['route']!),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 25.w,
                                    vertical: 20.h,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[300]!,
                                        width: index < _searchResults.length - 1 ? 1 : 0,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.search,
                                        color: Colors.grey[600],
                                        size: 24.sp,
                                      ),
                                      SizedBox(width: 15.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['name']!,
                                              style: TextStyle(
                                                fontSize: 28.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              item['category']!,
                                              style: TextStyle(
                                                fontSize: 20.sp,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 20.sp,
                                        color: Colors.grey[400],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}