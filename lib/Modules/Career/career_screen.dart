import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:incm/core/Contact/contact_form_phone.dart';
import 'package:incm/core/Contact/contact_info_provider.dart';
import 'package:incm/core/Contact/contact_submission_service.dart';
import 'package:incm/core/Firebase/career_cv_storage_service.dart';
import 'package:incm/core/Language/locales.dart';
import 'package:provider/provider.dart';
import '../../Utilities/font_helper.dart';
import 'package:incm/Utilities/router_config.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../Widgets/bottom_navbar_widget.dart';
import '../../Widgets/build_file_o_link_field.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/custom_app_bar_mob.dart';
import '../../Widgets/custom_button.dart';
import '../../Widgets/departments_grid_section.dart';
import '../../Widgets/floating_contact_buttons.dart';
import '../../Widgets/scroll_to_top_button.dart';
import '../../Widgets/footer_section.dart';
import '../../Widgets/footer_section_mob.dart';
import '../../core/Language/app_languages.dart';
import '../../core/Content/content_provider.dart';
import '../../Models/content_model.dart';
import '../../generated/assets.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CareerScreen extends StatefulWidget {
  static const String routeName = '/career';

  const CareerScreen({super.key});

  @override
  State<CareerScreen> createState() => _CareerScreenState();
}

class _CareerFamilyFallbackSpec {
  final String titleKey;
  final String assetPath;

  const _CareerFamilyFallbackSpec({
    required this.titleKey,
    required this.assetPath,
  });

  String title(BuildContext context) => titleKey.tr(context);
}

class _CareerFamilyItemData {
  final String title;
  final String fallbackAssetPath;
  final String? imageBase64;

  const _CareerFamilyItemData({
    required this.title,
    required this.fallbackAssetPath,
    this.imageBase64,
  });

  _CareerFamilyItemData copyWith({
    String? title,
    String? fallbackAssetPath,
    String? imageBase64,
  }) {
    return _CareerFamilyItemData(
      title: title ?? this.title,
      fallbackAssetPath: fallbackAssetPath ?? this.fallbackAssetPath,
      imageBase64: imageBase64 ?? this.imageBase64,
    );
  }
}

class _CareerScreenState extends State<CareerScreen> with SingleTickerProviderStateMixin{
  static const String _careerPageId = 'career';
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _hasAnimated = false;
  bool _isAddressHovered = false;
  bool _isSubmitting = false;
  late PageController _pageController;
  int _currentPage = 0;
  List<ContentModel> _careerContents = const [];



  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _emailController = TextEditingController();
  final _linkOrFileController = TextEditingController();
  Uint8List? _cvPickedBytes;
  String? _cvPickedDisplayName;
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

  String? selectedDepartment;
  List<String> get departments => [
    "SALES_TEAM",
    "LEASING",
    "CONSULTATION",
    "FRANCHISING",
    "FACILITY_MANAGEMENT",
    "OPERATIONS",
    "MARKETING",
    "HUMAN_RESOURCES",
    "FINANCE",
  ];
  List<String> get benefits => [
    "COMPETITIVE_SALARY",
    "EXCLUSIVE_PROJECTS",
    "TRAINING_PROGRAMS",
    "SUPPORTIVE_MANAGEMENT",
    "CAREER_GROWTH",
    "PROFESSIONAL_ENVIRONMENT",
    "TEAM_COLLABORATION",
    "RECOGNITION_REWARDS",
    "WORK_LIFE_BALANCE",
    "LEADERSHIP_DEVELOPMENT",
    "NETWORKING_OPPORTUNITIES",
    "HIGHEST_COMMISSION",
  ];

  List<_CareerFamilyFallbackSpec> get _familyFallbackItems => const [
    _CareerFamilyFallbackSpec(titleKey: 'FINAL_RAMADAN', assetPath: Assets.imagesPic3),
    _CareerFamilyFallbackSpec(titleKey: 'INTERNSHIP', assetPath: Assets.imagesPic2),
    _CareerFamilyFallbackSpec(titleKey: 'FUN_DAY', assetPath: Assets.imagesPic4),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: MediaQuery.of(currentContext_!).size.width > 600 ? 0.33 : 1);
    _loadCareerContent();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    // Start animation immediately to ensure content is visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _animationController.forward();
      }
    });
    _linkOrFileController.addListener(_onCvFieldChanged);
  }

  void _onCvFieldChanged() {
    if (!mounted) return;
    if (_cvPickedBytes != null &&
        _cvPickedDisplayName != null &&
        _linkOrFileController.text != _cvPickedDisplayName) {
      setState(() {
        _cvPickedBytes = null;
        _cvPickedDisplayName = null;
      });
    }
  }

  Future<void> _pickCvFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg', 'doc', 'docx'],
        withData: true,
      );
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final bytes = file.bytes;
        if (bytes == null || bytes.isEmpty) {
          if (!mounted) return;
          Fluttertoast.showToast(
            msg: 'Could not read file. Try a smaller file or paste a link.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
          );
          return;
        }
        if (!mounted) return;
        setState(() {
          _cvPickedBytes = bytes;
          _cvPickedDisplayName = file.name;
          _linkOrFileController.text = file.name;
        });
      }
    } catch (e) {
      if (!mounted) return;
      Fluttertoast.showToast(
        msg: 'Error picking file: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> _loadCareerContent() async {
    final contentProvider = Provider.of<ContentProvider>(context, listen: false);
    final contents = await contentProvider.getPageContent(_careerPageId);
    if (!mounted) return;
    setState(() {
      _careerContents = contents;
    });
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!_hasAnimated && info.visibleFraction >= 0.3) {
      _hasAnimated = true;
      if (!_animationController.isAnimating && !_animationController.isCompleted) {
        _animationController.forward();
      }
    }
  }


  @override
  void dispose() {
    _linkOrFileController.removeListener(_onCvFieldChanged);
    _animationController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _linkOrFileController.dispose();
    _jobTitleController.dispose();
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
    final context = this.context;
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

    if (_jobTitleController.text.trim().isEmpty) {
      _showToast('PLEASE_ENTER_JOB_TITLE'.tr(context));
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

    if (selectedDepartment == null || selectedDepartment!.isEmpty) {
      _showToast('PLEASE_SELECT_DEPARTMENT'.tr(context));
      return;
    }

    final cvField = _linkOrFileController.text.trim();
    if (cvField.isEmpty) {
      _showToast('PLEASE_UPLOAD_CV'.tr(context));
      return;
    }

    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    try {
      final name = _fullNameController.text.trim();
      final phone = _phoneController.text.trim();
      final email = _emailController.text.trim();
      final fullPhone = contactFullPhone(_selectedCountryCode, phone);
      final deptLabel = selectedDepartment!.tr(context);
      final jobTitle = _jobTitleController.text.trim();

      String? cvUrl;
      if (_cvPickedBytes != null && _cvPickedDisplayName != null) {
        cvUrl = await CareerCvStorageService.uploadCv(
          bytes: _cvPickedBytes!,
          originalFileName: _cvPickedDisplayName!,
          applicantEmail: email,
        );
        if (cvUrl == null) {
          if (!mounted) return;
          _showToast('CV_UPLOAD_FAILED'.tr(context));
          return;
        }
      } else if (cvField.startsWith('http://') || cvField.startsWith('https://')) {
        cvUrl = cvField;
      } else {
        if (!mounted) return;
        _showToast('PLEASE_UPLOAD_CV'.tr(context));
        return;
      }

      final buf = StringBuffer();
      buf.writeln('Department: $deptLabel');
      buf.writeln('Job title: $jobTitle');
      buf.writeln('CV (download / link): $cvUrl');

      final result = await ContactSubmissionService.instance.submit(
        name: name,
        fullPhone: fullPhone,
        email: email,
        message: buf.toString(),
        emailSubject: 'Career — $deptLabel — $name',
        formSourceSlug: 'career',
        formSourceLabel: 'FORM_SOURCE_CAREER'.tr(context),
        contactSettingsHint: context.read<ContactInfoProvider>().contactInfo,
        extraTemplateParams: {
          'department': deptLabel,
          'cv_link': cvUrl,
          'job_title': jobTitle,
        },
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
      _jobTitleController.clear();
      _emailController.clear();
      _linkOrFileController.clear();
      setState(() {
        _cvPickedBytes = null;
        _cvPickedDisplayName = null;
        selectedDepartment = null;
      });
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
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

  String _localizedValue(ContentModel content) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final primaryValue = isArabic ? content.values['ar'] : content.values['en'];
    final secondaryValue = isArabic ? content.values['en'] : content.values['ar'];
    return (primaryValue?.isNotEmpty == true ? primaryValue : secondaryValue) ?? '';
  }

  List<_CareerFamilyItemData> _resolveFamilyItems(List<ContentModel> contents) {
    final itemsByIndex = <int, _CareerFamilyItemData>{};
    for (var i = 0; i < _familyFallbackItems.length; i++) {
      final fallback = _familyFallbackItems[i];
      itemsByIndex[i + 1] = _CareerFamilyItemData(
        title: fallback.title(context),
        fallbackAssetPath: fallback.assetPath,
      );
    }

    final familyRegex =
        RegExp(r'^career-family-member-(\d+)-(title|image)$');

    for (final content in contents) {
      final match = familyRegex.firstMatch(content.sectionId);
      if (match == null) continue;

      final index = int.tryParse(match.group(1) ?? '');
      final field = match.group(2);
      if (index == null || index <= 0 || field == null) continue;

      var item = itemsByIndex[index] ??
          const _CareerFamilyItemData(
            title: '',
            fallbackAssetPath: Assets.imagesPic3,
          );

      switch (field) {
        case 'title':
          final title = _localizedValue(content);
          if (title.isNotEmpty) {
            item = item.copyWith(title: title);
          }
          break;
        case 'image':
          if (content.imageBase64?.isNotEmpty == true) {
            item = item.copyWith(imageBase64: content.imageBase64);
          }
          break;
      }

      itemsByIndex[index] = item;
    }

    final sortedIndexes = itemsByIndex.keys.toList()..sort();
    return sortedIndexes
        .map((index) => itemsByIndex[index]!)
        .where(
          (item) => item.title.isNotEmpty || (item.imageBase64?.isNotEmpty ?? false),
        )
        .toList();
  }

  List<_CareerFamilyItemData> get _currentFamilyItems =>
      _resolveFamilyItems(_careerContents);

  ContentModel? _findCareerContent(String sectionId) {
    try {
      return _careerContents.firstWhere((content) => content.sectionId == sectionId);
    } catch (_) {
      return null;
    }
  }

  String _resolveDefaultText(String defaultValue) {
    if (defaultValue.contains('_') && defaultValue == defaultValue.toUpperCase()) {
      return defaultValue.tr(context);
    }
    return defaultValue;
  }

  String _getCareerText(String sectionId, String defaultValue) {
    final content = _findCareerContent(sectionId);
    if (content != null && content.type == ContentType.text) {
      final localizedValue = _localizedValue(content);
      if (localizedValue.isNotEmpty) {
        return localizedValue.replaceAll(r'\n', '\n');
      }
    }
    return _resolveDefaultText(defaultValue).replaceAll(r'\n', '\n');
  }

  Widget _buildCareerImage({
    required String sectionId,
    required String fallbackAssetPath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    final content = _findCareerContent(sectionId);
    final rawBase64 = content?.imageBase64?.trim();
    if (rawBase64 != null && rawBase64.isNotEmpty) {
      try {
        final normalizedBase64 =
            rawBase64.contains(',') ? rawBase64.split(',').last.trim() : rawBase64;
        final bytes = base64Decode(normalizedBase64);
        return Image.memory(
          bytes,
          width: width,
          height: height,
          fit: fit,
        );
      } catch (_) {
        // Fall back to bundled asset on invalid base64.
      }
    }

    return Image.asset(
      fallbackAssetPath,
      width: width,
      height: height,
      fit: fit,
    );
  }

  ImageProvider _getCareerBackgroundImageProvider({
    required bool isMobile,
  }) {
    final content = _findCareerContent('career-background');
    final rawBase64 = content?.imageBase64?.trim();
    if (rawBase64 != null && rawBase64.isNotEmpty) {
      try {
        final normalizedBase64 =
            rawBase64.contains(',') ? rawBase64.split(',').last.trim() : rawBase64;
        return MemoryImage(base64Decode(normalizedBase64));
      } catch (_) {
        // Fall back to bundled asset on invalid base64.
      }
    }

    return AssetImage(
      isMobile ? Assets.imagesCareerViewMob : Assets.imagesCareerViewWeb,
    );
  }

  Widget _buildDynamicFamilyImage(
    _CareerFamilyItemData item, {
    required double height,
    double? width,
  }) {
    final rawBase64 = item.imageBase64?.trim();
    if (rawBase64 != null && rawBase64.isNotEmpty) {
      try {
        final normalizedBase64 =
            rawBase64.contains(',') ? rawBase64.split(',').last.trim() : rawBase64;
        final bytes = base64Decode(normalizedBase64);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          width: width ?? double.infinity,
          height: height,
        );
      } catch (_) {
        // Fall back to the bundled asset if the saved base64 is invalid.
      }
    }

    return Image.asset(
      item.fallbackAssetPath,
      fit: BoxFit.cover,
      width: width ?? double.infinity,
      height: height,
    );
  }

  void _nextPage() {
    final familyItems = _currentFamilyItems;
    if (familyItems.isEmpty) return;
    if (_currentPage < familyItems.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      // Loop: from last image go to first
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    final familyItems = _currentFamilyItems;
    if (familyItems.isEmpty) return;
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      // Loop: from first image go to last
      _pageController.animateToPage(
        familyItems.length - 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
  bool isDownloading = false;

  @override
  Widget build(BuildContext context) {

    final isMobile = MediaQuery.of(context).size.width < 600;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: MediaQuery.of(context).size.width < 600 && !kIsWeb ? const BottomNavBarWidget(selected: SelectedBottomNavBar.contacts) : null,
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: VisibilityDetector(
                key: const Key('contacts-content-section'),
                onVisibilityChanged: _onVisibilityChanged,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _getCareerBackgroundImageProvider(isMobile: isMobile),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Column(
                    children: [
                      if(MediaQuery.of(context).size.width > 600)
                        _buildINCMFamilySection(context),
                      if(MediaQuery.of(context).size.width > 600)
                        _buildJoinFamilySection(context),
                      if(MediaQuery.of(context).size.width > 600)
                        DepartmentsGridSection(departments: departments, context: context,),
                      if(MediaQuery.of(context).size.width > 600)
                        _buildCareerBenefitsSection(context),
                      if(MediaQuery.of(context).size.width > 600)
                        _buildLatestNewsSection(context),




                      if(MediaQuery.of(context).size.width < 600)
                        _buildINCMFamilySectionMob(context),
                      if(MediaQuery.of(context).size.width < 600)
                        _buildJoinFamilySectionMob(context),
                      if(MediaQuery.of(context).size.width < 600)
                        DepartmentsGridSection(departments: departments, context: context,),
                      if(MediaQuery.of(context).size.width < 600)
                        _buildCareerBenefitsSectionMob(context),
                      if(MediaQuery.of(context).size.width < 600)
                        _buildLatestNewsSectionMob(context),
                      // Footer
                      if(MediaQuery.of(context).size.width >= 600)
                        const FooterSection()
                      else if(kIsWeb)
                        const FooterSectionMob(),
                    ],
                  ),
                ),
              ),
            ),
            MediaQuery.of(context).size.width >= 600 ?
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomAppBar(),
            ) : const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomAppBarMob(),
            ),
            const FloatingContactButtons(),
            ScrollToTopButton(scrollController: _scrollController),
          ],
        ),
      ),
    );
  }

  Widget _buildINCMFamilySection(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(Assets.imagesCareerBackground),
      //     fit: BoxFit.fill,
      //   ),
      // ),
      width: double.infinity,
      height: 1200.h,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          );
        },
        child: Center( // 👈 centers everything vertically + horizontally
          child: Container(
            padding: EdgeInsets.all(40.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center, // 👈 vertical center
              children: [
                _buildDynamicSectionTitle(
                  sectionId: 'career-title',
                  defaultValue: 'WELCOME_TO_INCM_FAMILY',
                ),
                Gap(120.h),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFF4ED47),
                      width: 0.6,            // border width
                    ),
                  ),
                  child: _buildCareerImage(
                    sectionId: 'career-welcome-image',
                    fallbackAssetPath: Assets.imagesPic1,
                    height: 600.h,
                    fit: BoxFit.cover,
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJoinFamilySection(BuildContext context) {
    final isMobile = _isMobile(context);
    final isTablet = _isTablet(context);
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(Assets.imagesCareerBackground),
      //     fit: BoxFit.fill,
      //   ),
      // ),
      width: double.infinity,
      height: 1200.h,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          );
        },
        child: Center( // 👈 centers everything vertically + horizontally
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isMobile ? double.infinity : (isTablet ? 800.w : 1400.w),
            ),
            padding: EdgeInsets.all(40.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center, // 👈 vertical center
              children: [
                _buildDynamicSectionTitle(
                  sectionId: 'career-subtitle',
                  defaultValue: 'JOIN_INCM_FAMILY_NOW',
                ),
                Gap(60.h),
                Column(
                    children: [

                      Row(
                        children: [
                          Expanded(
                            child: _buildFormField(
                              'FULL_NAME'.tr(context),
                              controller: _fullNameController,
                              keyboardType: TextInputType.name,
                              isMobile: isMobile,
                              isTablet: isTablet,
                            ),
                          ),
                          SizedBox(width: isTablet ? 75.w : 150.w),
                          Expanded(
                            child: _buildPhoneField(isMobile: isMobile, isTablet: isTablet),
                          ),
                        ],
                      ),
                      SizedBox(height: isTablet ? 40.h : 60.h),
                      Row(
                        children: [
                          Expanded(
                            child: _buildFormField(
                              'E_MAIL'.tr(context),
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              isMobile: isMobile,
                              isTablet: isTablet,
                            ),
                          ),
                          SizedBox(width: isTablet ? 75.w : 150.w),
                          Expanded(
                              child:_buildDropdownField("DEPARTMENT".tr(context),"SELECT_DEPARTMENT".tr(context),
                                value: selectedDepartment,
                                items: departments,
                                isMobile: isMobile,
                                isTablet: isTablet,
                                onChanged: (val) {
                                  setState(() {
                                    selectedDepartment = val;
                                  });
                                },
                              )
                          ),
                        ],
                      ),

                      SizedBox(height: isTablet ? 40.h : 60.h),
                      Row(
                        children: [
                          Expanded(
                            child: _buildFormField(
                              'JOB_TITLE'.tr(context),
                              controller: _jobTitleController,
                              keyboardType: TextInputType.emailAddress,
                              isMobile: isMobile,
                              isTablet: isTablet,
                            ),
                          ),
                          SizedBox(width: isTablet ? 75.w : 150.w),
                          Expanded(
                              child: BuildFileOrLinkField(
                                  "UPLOAD_YOUR_CV".tr(context),
                                  controller: _linkOrFileController,
                                  isMobile: isMobile,
                                  isTablet: isTablet,
                                  onUploadTap: _pickCvFile,
                              )
                          ),
                        ],
                      ),
                      Gap(60.h),
                      ButtonStyles.submitButton(
                        context: context,
                        fontSize: isMobile ? 24.sp : (isTablet ? 26.sp : 42.sp),
                        width: isMobile ? 120.w : (isTablet ? 120.w : 180.w),
                        enabled: !_isSubmitting,
                        onPressed: () => _handleSubmit(),
                      ),
                    ]
                )


              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) => Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: getLocalizedFont(context, 'OptimalBold'),
          color: const Color(0xFFF4ED47),
          fontSize: MediaQuery.of(context).size.width > 600 ? 80.sp : 28.sp,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget _buildDynamicSectionTitle({
    required String sectionId,
    required String defaultValue,
    bool isMobile = false,
  }) {
    return Text(
      _getCareerText(sectionId, defaultValue),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: getLocalizedFont(context, 'OptimalBold'),
        color: const Color(0xFFF4ED47),
        fontSize: isMobile ? 28.sp : 80.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildCareerBenefitsTitle(BuildContext context, bool isMobile, bool isTablet) {
    final translated = _getCareerText('career-benefits-title', 'CAREER_BENEFITS');
    final parts = translated.split(' ');
    final firstPart = parts.isNotEmpty ? parts.first : '';
    final rest = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: firstPart + (rest.isNotEmpty ? ' ' : ''),
            style: TextStyle(
              fontFamily: getLocalizedFont(context, 'OptimalBold'),
              color: const Color(0xFFF4ED47),
              fontSize: isMobile ? 28.sp : (isTablet ? 48.sp : 80.sp),
            ),
          ),
          if (rest.isNotEmpty)
            TextSpan(
              text: rest,
              style: TextStyle(
                fontFamily: getLocalizedFont(context, 'OptimalBold'),
                color: Colors.white,
                fontSize: isMobile ? 32.sp : (isTablet ? 48.sp : 80.sp),
                fontWeight: FontWeight.w800,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDynamicBenefitText(
    String sectionId,
    String defaultKey, {
    required double fontSize,
    double? height,
  }) {
    return Text(
      _getCareerText(sectionId, defaultKey),
      style: TextStyle(
        fontFamily: getLocalizedFont(context, 'AloeveraDisplaySemiBold'),
        color: Colors.white,
        fontSize: fontSize,
        height: height,
      ),
    );
  }

  Widget _buildCareerBenefitsSection(BuildContext context) {
    final isMobile = _isMobile(context);
    final isTablet = _isTablet(context);
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(Assets.imagesCareerBackground),
      //     fit: BoxFit.fill,
      //   ),
      // ),
      width: double.infinity,
      height: isMobile ? 1600.h : 1200.h,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          );
        },
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: isMobile ? double.infinity : 1700.w,
              ),
              padding: EdgeInsets.all(isMobile ? 20.w : 40.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCareerBenefitsTitle(context, isMobile, isTablet),
                  Gap(isMobile ? 30.h : 50.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 30.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4ED47).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: benefits
                                .sublist(0, (benefits.length / 2).toInt())
                                .asMap()
                                .entries
                                .map((entry) {
                              final index = entry.key;
                              final text = entry.value;
                              return Padding(
                                padding: EdgeInsets.only(bottom: 20.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "•  ",
                                      style: TextStyle(
                                        fontFamily: getLocalizedFont(context, 'AloeveraDisplaySemiBold'),
                                        color: Colors.white,
                                        fontSize: isTablet ? 24.sp : 40.sp,
                                        height: 1.8,
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildDynamicBenefitText(
                                        'career-benefit-${index + 1}',
                                        text,
                                        fontSize: isTablet ? 24.sp : 40.sp,
                                        height: 1.8,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Gap(40.w),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 30.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4ED47).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: benefits
                                .sublist((benefits.length / 2).toInt(), benefits.length)
                                .asMap()
                                .entries
                                .map((entry) {
                              final index = entry.key + (benefits.length / 2).toInt();
                              final text = entry.value;
                              return Padding(
                                padding: EdgeInsets.only(bottom: 20.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "•  ",
                                      style: TextStyle(
                                        fontFamily: getLocalizedFont(context, 'AloeveraDisplaySemiBold'),
                                        color: Colors.white,
                                        fontSize: isTablet ? 24.sp : 40.sp,
                                        height: 1.8,
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildDynamicBenefitText(
                                        'career-benefit-${index + 1}',
                                        text,
                                        fontSize: isTablet ? 24.sp : 40.sp,
                                        height: 1.8,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLatestNewsSection(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(Assets.imagesAboutUsBackground2),
      //     fit: BoxFit.fill,
      //   ),
      // ),
      width: double.infinity,
      height: 1200.h,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          );
        },
        child: Center( // 👈 centers everything vertically + horizontally
          child: Container(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center, // 👈 vertical center
              children: [
                _buildDynamicSectionTitle(
                  sectionId: 'career-family-members-title',
                  defaultValue: 'OUR_FAMILY_MEMBERS',
                ),
                Gap(40.h),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 60.h),
                  child: _buildFamilyMembersCarousel(
                    context,
                    _currentFamilyItems,
                    isMobile: false,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildFamilyMembersCarousel(
    BuildContext context,
    List<_CareerFamilyItemData> familyItems, {
    required bool isMobile,
  }) {
    final imageHeight = isMobile ? 380.h : 500.h;
    final carouselHeight = isMobile ? 480.h : 650.h;
    final titleFontSize = isMobile ? 26.sp : 50.sp;
    final arrowTop = isMobile ? 130.0 : 165.0;
    final arrowSize = isMobile ? 28.0 : 40.0;
    final horizontalPadding = isMobile ? 20.w : 40.w;
    final itemHorizontalPadding = isMobile ? 20.w : 10.w;
    final imageWidth = isMobile ? 650.w : 800.w;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: carouselHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: familyItems.length,
                  onPageChanged: (index) {
                    _currentPage = index;
                  },
                  itemBuilder: (context, index) {
                    final item = familyItems[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: itemHorizontalPadding),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFF4ED47),
                                  width: 0.6,
                                ),
                              ),
                              height: imageHeight,
                              width: imageWidth,
                              child: _buildDynamicFamilyImage(
                                item,
                                height: imageHeight,
                                width: imageWidth,
                              ),
                            ),
                            SizedBox(height: isMobile ? 10.h : 30.h),
                            Text(
                              item.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                color: Colors.white,
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                left: 0,
                top: arrowTop,
                child: Builder(
                  builder: (context) {
                    final isArabic =
                        Provider.of<AppLanguage>(context, listen: false).appLang ==
                            Languages.ar;
                    return IconButton(
                      icon: Icon(
                        isArabic ? Icons.arrow_forward_ios : Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                      iconSize: arrowSize,
                      onPressed: _previousPage,
                    );
                  },
                ),
              ),
              Positioned(
                right: 0,
                top: arrowTop,
                child: Builder(
                  builder: (context) {
                    final isArabic =
                        Provider.of<AppLanguage>(context, listen: false).appLang ==
                            Languages.ar;
                    return IconButton(
                      icon: Icon(
                        isArabic ? Icons.arrow_back_ios_new : Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                      iconSize: arrowSize,
                      onPressed: _nextPage,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: isMobile ? 10 : 20),
      ],
    );
  }




  Widget _buildINCMFamilySectionMob(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(Assets.imagesCareerBackgroundMob),
      //     fit: BoxFit.fill,
      //   ),
      // ),
      width: double.infinity,
      height: 450.h,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          );
        },
        child: Center( // 👈 centers everything vertically + horizontally
          child: Container(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center, // 👈 vertical center
              children: [
                _buildDynamicSectionTitle(
                  sectionId: 'career-title',
                  defaultValue: 'WELCOME_TO_INCM_FAMILY',
                  isMobile: true,
                ),
                Gap(40.h),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFF4ED47),
                      width: 1,            // border width
                    ),
                  ),
                  child: _buildCareerImage(
                    sectionId: 'career-welcome-image',
                    fallbackAssetPath: Assets.imagesPic1,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJoinFamilySectionMob(BuildContext context) {
    final isMobile = _isMobile(context);
    final isTablet = _isTablet(context);
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(Assets.imagesCareerBackground),
      //     fit: BoxFit.fill,
      //   ),
      // ),
      width: double.infinity,
      height: 700.h,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          );
        },
        child: Center( // 👈 centers everything vertically + horizontally
          child: Container(

            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center, // 👈 vertical center
              children: [
                _buildDynamicSectionTitle(
                  sectionId: 'career-subtitle',
                  defaultValue: 'JOIN_INCM_FAMILY_NOW',
                  isMobile: true,
                ),
                Gap(30.h),
                Column(
                    children: [
                      _buildFormField(
                        'FULL_NAME'.tr(context),
                        controller: _fullNameController,
                        keyboardType: TextInputType.name,
                        isMobile: isMobile,
                        isTablet: isTablet,
                      ),
                      Gap(22.h),
                      _buildPhoneField(isMobile: isMobile, isTablet: isTablet),
                      Gap(22.h),
                      _buildFormField(
                        'E_MAIL'.tr(context),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        isMobile: isMobile,
                        isTablet: isTablet,
                      ),
                      Gap(22.h),
                      _buildDropdownField("DEPARTMENT".tr(context),"SELECT_DEPARTMENT".tr(context),
                        value: selectedDepartment,
                        items: departments,
                        isMobile: isMobile,
                        isTablet: isTablet,
                        onChanged: (val) {
                          setState(() {
                            selectedDepartment = val;
                          });
                        },
                      ),
                      Gap(22.h),
                      _buildFormField(
                        'JOB_TITLE'.tr(context),
                        controller: _jobTitleController,
                        keyboardType: TextInputType.emailAddress,
                        isMobile: isMobile,
                        isTablet: isTablet,
                      ),
                      Gap(22.h),
                      BuildFileOrLinkField(
                          "UPLOAD_YOUR_CV".tr(context),
                          controller: _linkOrFileController,
                          isMobile: isMobile,
                          isTablet: isTablet,
                          onUploadTap: _pickCvFile,
                      ),

                      Gap(28.h),
                      ButtonStyles.submitButtonMob(
                        context: context,
                        width: isMobile ? 80.w : (isTablet ? 120.w : 140.w),
                        enabled: !_isSubmitting,
                        onPressed: () => _handleSubmit(),
                      ),
                    ]
                )


              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCareerBenefitsSectionMob(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(Assets.imagesCareerBackgroundMob),
      //     fit: BoxFit.fill,
      //   ),
      // ),
      width: double.infinity,
      height: 820.h,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          );
        },
        child: Center(
          child: SingleChildScrollView(
            child: Container(

              padding: EdgeInsets.all(10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCareerBenefitsTitle(context, true, false),
                  Gap(20.h),
                 Column(
                    children: [
                      ...benefits.asMap().entries.map((entry) {
                        final index = entry.key;
                        final text = entry.value;
                        return Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 30.w,vertical: 4.h),
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4ED47).withOpacity(0.3),
                            //borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Center(
                            child: _buildDynamicBenefitText(
                              'career-benefit-${index + 1}',
                              text,
                              fontSize: 16.sp,
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLatestNewsSectionMob(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 650.h,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          );
        },
        child: Center(
          child: Container(
            padding: EdgeInsets.all(0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDynamicSectionTitle(
                  sectionId: 'career-family-members-title',
                  defaultValue: 'OUR_FAMILY_MEMBERS',
                  isMobile: true,
                ),
                Gap(10.h),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: _buildFamilyMembersCarousel(
                    context,
                    _currentFamilyItems,
                    isMobile: true,
                  ),
                )
              ],
            ),
          ),
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
        required bool isMobile,
        required bool isTablet
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label??'',
          style: TextStyle(
            fontFamily: 'AloeveraDisplayBold',
            color: const Color(0xFFF4ED47),
            fontSize: isMobile ? 16.sp : (isTablet ? 22.sp : 28.sp),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: height ?? (isMobile ? 36.h : (isTablet ? 55.h : 60.h)),
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
                    fontSize: isMobile ? 16.sp : (isTablet ? 18.sp : 28.sp),
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

  Widget _buildDropdownField(
      String label,
      String hint,{
        required String? value,
        required List<String> items,
        required Function(String?) onChanged,
        double? height,
        required bool isMobile,
        required bool isTablet,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'AloeveraDisplayBold',
            color: const Color(0xFFF4ED47),
            fontSize: isMobile ? 16.sp : (isTablet ? 22.sp : 28.sp),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: isMobile ? 0 : 8.h),

        Container(
          height: height ?? (isMobile ? 36.h : (isTablet ? 60.h : 65.h)),
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
                spreadRadius: value != null ? 1 : 0,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: Container(
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: value != null
                      ? const Color(0xFFF4ED47).withOpacity(0.1)
                      : Colors.grey[100],
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: value != null
                      ? const Color(0xFFF4ED47)
                      : Colors.grey[600],
                    size: isMobile ? 22.sp : 28.sp,
                  ),
                ),
                dropdownColor: Colors.white,
                hint: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    hint,
                    style: TextStyle(
                      fontSize: isMobile ? 14.sp : (isTablet ? 18.sp : 22.sp),
                      color: Colors.grey[500],
                      fontFamily: 'AloeveraDisplayBold',
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontSize: isMobile ? 14.sp : (isTablet ? 18.sp : 22.sp),
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
                selectedItemBuilder: (BuildContext context) {
                  return items.map((item) {
                    return Text(
                      item.tr(context),
                      style: TextStyle(
                        fontSize: isMobile ? 14.sp : (isTablet ? 18.sp : 22.sp),
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    );
                  }).toList();
                },
                items: items.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 4.w,
                            height: 4.w,
                            margin: EdgeInsets.only(right: 12.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4ED47),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item.tr(context),
                              style: TextStyle(
                                fontSize: isMobile ? 14.sp : (isTablet ? 18.sp : 20.sp),
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
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





  Widget _buildPhoneField({required bool isMobile, required bool isTablet}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'PHONE'.tr(context),
          style: TextStyle(
            fontFamily: 'AloeveraDisplayBold',
            color: const Color(0xFFF4ED47),
            fontSize: isMobile ? 16.sp : (isTablet ? 22.sp : 28.sp),
            fontWeight: FontWeight.bold,

          ),
        ),
        SizedBox(height: isMobile ? 0 : 2.h),
        SizedBox(
          height: isMobile ? 42.h : (isTablet ? 55.h : 60.h),
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
                                fontSize: isMobile ? 12.sp : 14.sp,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              country['code']!,
                              style: TextStyle(
                                fontFamily: 'AloeveraDisplayBold',
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
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: '01XXXXXXXXX',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}

