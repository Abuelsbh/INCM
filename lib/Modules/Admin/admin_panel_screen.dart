import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../core/Content/content_provider.dart';
import '../../core/Content/services_provider.dart';
import '../../core/Firebase/firebase_logos_service.dart';
import '../../Models/content_model.dart';
import '../../Models/logo_model.dart';
import '../../Models/service_model.dart';
import '../../Modules/About/about_screen.dart';
import '../../Modules/AllLogos/all_logos_screen.dart';
import '../../Modules/Buy/buy_screen.dart';
import '../../Modules/Career/career_screen.dart';
import '../../Modules/Contacts/contacts_screen.dart';
import '../../Modules/ExclusiveLeasingProjects/exclusive_leasing_projects_screen.dart';
import '../../Modules/Home/home_screen.dart';
import '../../Modules/Lease/lease_screen.dart';
import '../../Modules/Sell/sell_screen.dart';
import '../../Modules/Services/Consultation/consultation_screen.dart';
import '../../Modules/Services/CorporateLeasing/corporate_leasing_screen.dart';
import '../../Modules/Services/FacilityManagement/facility_management_screen.dart';
import '../../Modules/Services/FranchiseInvestment/franchise_investment_screen.dart';
import '../../Modules/Services/Marketing/marketing_screen.dart';
import '../../Modules/Services/GenericService/generic_service_screen.dart';
import '../../Modules/Services/MedicalLeasing/medical_leasing_screen.dart';
import '../../Modules/Services/PrimaryInvestment/primary_investment_screen.dart';
import '../../Modules/Services/RetailLeasing/retail_leasing_screen.dart';
import '../../Widgets/Admin/content_item_editor.dart';
import '../../Widgets/Admin/about_news_event_editor.dart';
import '../../Widgets/Admin/career_family_member_editor.dart';
import '../../Widgets/Admin/logo_editor.dart';
import '../../Widgets/Admin/service_editor.dart';
import '../../Widgets/Admin/batch_logo_editor.dart';
import '../../Widgets/Admin/contact_info_editor.dart';
import '../../Widgets/content_service_section.dart';
import '../../Widgets/footer_section.dart';
import '../../core/Language/locales.dart';

class AdminPanelScreen extends StatefulWidget {
  static const String routeName = '/admin';

  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> with SingleTickerProviderStateMixin {
  static final RegExp _aboutNewsSectionPattern =
      RegExp(r'^latest-news-item-(\d+)-(title|description|image)$');
  static final RegExp _careerFamilySectionPattern =
      RegExp(r'^career-family-member-(\d+)-(title|image)$');

  String? _selectedPageId;
  String? _selectedLogoPageId; // For filtering logos by page
  List<ContentModel> _currentPageContents = [];
  bool _isLoading = false;
  late TabController _tabController;
  List<LogoModel> _logos = [];
  final FirebaseLogosService _logosService = FirebaseLogosService();

  final Map<String, String> _pageNames = {
    'home': 'Home',
    'about': 'About Us',
    'contacts': 'Contacts',
    'career': 'Careers',
    'buy': 'Buy',
    'sell': 'Sell',
    'lease': 'Lease',
    'exclusive-leasing-projects': 'Exclusive Leasing Projects',
    'corporate-leasing': 'Corporate Leasing',
    'retail-leasing': 'Retail Leasing',
    'medical-leasing': 'Medical Leasing',
    'facility-management': 'Facility Management',
    'franchise-investment': 'Franchise Investment',
    'primary-investment': 'Primary Investment',
    'marketing': 'Marketing',
    'consultation': 'Consultation',
    'services': 'Services',
    'all-logos': 'All Logos',
  };

  // Built-in + custom service names (for logo display/filter)
  Map<String, String> _getServiceNamesEnglish(BuildContext context) {
    final map = <String, String>{
    'corporate-leasing': 'Corporate Leasing',
    'retail-leasing': 'Retail Leasing',
    'medical-leasing': 'Medical Leasing',
    'facility-management': 'Facility Management',
    'franchise-investment': 'Franchise Investment',
    'primary-investment': 'Primary Investment',
    'marketing': 'Marketing',
    'consultation': 'Consultation',
    };
    final customServices = Provider.of<ServicesProvider>(context, listen: false).customServices;
    for (final s in customServices) {
      map[s.pageId] = s.nameEn.isNotEmpty ? s.nameEn : s.nameAr;
    }
    return map;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
        if (_tabController.index == 1) {
          _loadLogos(pageId: _selectedLogoPageId);
        } else if (_tabController.index == 3) {
          Provider.of<ServicesProvider>(context, listen: false).loadServices();
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPages();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadLogos({String? pageId}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final logos = await _logosService.getAllLogos(pageId: pageId);
      setState(() {
        _logos = logos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveLogo(LogoModel logo) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Validate logo data
      if (logo.imageBase64.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ERROR_IMAGE_EMPTY'.tr(context)),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (logo.pageId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ERROR_SELECT_PAGE'.tr(context)),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      debugPrint('Saving logo: pageId=${logo.pageId}, imageBase64 length=${logo.imageBase64.length}');

      bool success;
      if (logo.id.isEmpty) {
        // Get max order
        final maxOrder = _logos.isEmpty ? 0 : _logos.map((l) => l.order).reduce((a, b) => a > b ? a : b);
        final newLogo = logo.copyWith(order: maxOrder + 1);
        debugPrint('Adding new logo with order: ${newLogo.order}');
        success = await _logosService.addLogo(newLogo);
      } else {
        debugPrint('Updating existing logo: ${logo.id}');
        success = await _logosService.updateLogo(logo);
      }

      if (success) {
        debugPrint('Logo saved successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('LOGO_SAVED_SUCCESS'.tr(context)),
            backgroundColor: Colors.green,
          ),
        );
        await _loadLogos(pageId: _selectedLogoPageId);
      } else {
        debugPrint('Failed to save logo');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ERROR_SAVING_LOGO'.tr(context)),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Error saving logo: $e');
      debugPrint('Stack trace: $stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteLogo(LogoModel logo) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('CONFIRM_DELETE'.tr(context)),
        content: Text('CONFIRM_DELETE_LOGO'.tr(context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('CANCEL'.tr(context)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('DELETE'.tr(context)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        _isLoading = true;
      });

      try {
        final success = await _logosService.deleteLogo(logo.id);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('LOGO_DELETED_SUCCESS'.tr(context)),
              backgroundColor: Colors.green,
            ),
          );
          await _loadLogos(pageId: _selectedLogoPageId);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ERROR_DELETING_LOGO'.tr(context)),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showAddLogoDialog() {
    showDialog(
      context: context,
      builder: (context) => LogoEditor(
        onSave: (logo) {
          Navigator.pop(context);
          _saveLogo(logo);
        },
        onSaveBatch: (logos) {
          Navigator.pop(context);
          _saveLogosBatch(logos);
        },
      ),
    );
  }

  void _showBatchAddLogoDialog() {
    showDialog(
      context: context,
      builder: (context) => BatchLogoEditor(
        onSave: (logos) {
          Navigator.pop(context);
          _saveLogosBatch(logos);
        },
      ),
    );
  }

  Future<void> _saveLogosBatch(List<LogoModel> logos) async {
    if (logos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('NO_LOGOS_TO_SAVE'.tr(context)),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get max order for the page
      final pageId = logos.first.pageId;
      final existingLogos = await _logosService.getAllLogos(pageId: pageId);
      final maxOrder = existingLogos.isEmpty
          ? 0
          : existingLogos.map((l) => l.order).reduce((a, b) => a > b ? a : b);

      debugPrint('Adding ${logos.length} logos in batch for page: $pageId');
      
      final success = await _logosService.addLogosBatch(logos, startOrder: maxOrder);

      if (success) {
        debugPrint('Batch logos saved successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('LOGOS_SAVED_SUCCESS'.tr(context).replaceAll('{count}', logos.length.toString())),
            backgroundColor: Colors.green,
          ),
        );
        await _loadLogos(pageId: _selectedLogoPageId);
      } else {
        debugPrint('Failed to save batch logos');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ERROR_SAVING_LOGOS'.tr(context)),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error saving batch logos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showEditLogoDialog(LogoModel logo) {
    showDialog(
      context: context,
      builder: (context) => LogoEditor(
        initialLogo: logo,
        onSave: (updatedLogo) {
          Navigator.pop(context);
          _saveLogo(updatedLogo);
        },
      ),
    );
  }

  Future<void> _loadPages() async {
    setState(() {
      _isLoading = true;
    });

    final contentProvider = Provider.of<ContentProvider>(context, listen: false);
    await contentProvider.getAllPagesContent();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadPageContent(String pageId) async {
    setState(() {
      _isLoading = true;
      _selectedPageId = pageId;
    });

    final contentProvider = Provider.of<ContentProvider>(context, listen: false);
    final contents = await contentProvider.getPageContent(pageId);
    contents.sort((a, b) => a.sectionId.compareTo(b.sectionId));

    setState(() {
      _currentPageContents = contents;
      _isLoading = false;
    });
  }

  Future<void> _saveContent(ContentModel content) async {
    final contentProvider = Provider.of<ContentProvider>(context, listen: false);
    final success = await contentProvider.saveContent(content);

    if (mounted) {
      if (success) {
        // Clear cache for the page to ensure fresh data is loaded
        contentProvider.clearPageCache(content.pageId);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('CONTENT_SAVED_SUCCESS'.tr(context)),
            backgroundColor: Colors.green,
          ),
        );
        if (_selectedPageId != null) {
          await _loadPageContent(_selectedPageId!);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ERROR_SAVING_CONTENT'.tr(context)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveContentsBatch(List<ContentModel> contents) async {
    if (contents.isEmpty) {
      return;
    }

    final contentProvider = Provider.of<ContentProvider>(context, listen: false);
    final success = await contentProvider.batchSaveContent(contents);

    if (!mounted) {
      return;
    }

    if (success) {
      for (final pageId in contents.map((e) => e.pageId).toSet()) {
        contentProvider.clearPageCache(pageId);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('CONTENT_SAVED_SUCCESS'.tr(context)),
          backgroundColor: Colors.green,
        ),
      );
      if (_selectedPageId != null) {
        await _loadPageContent(_selectedPageId!);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ERROR_SAVING_CONTENT'.tr(context)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteContent(ContentModel content) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('CONFIRM_DELETE'.tr(context)),
        content: Text('CONFIRM_DELETE_CONTENT'.tr(context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('CANCEL'.tr(context)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('DELETE'.tr(context)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final contentProvider = Provider.of<ContentProvider>(context, listen: false);
      final success = await contentProvider.deleteContent(
        content.id,
        content.pageId,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('CONTENT_DELETED_SUCCESS'.tr(context)),
              backgroundColor: Colors.green,
            ),
          );
          if (_selectedPageId != null) {
            await _loadPageContent(_selectedPageId!);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ERROR_DELETING_CONTENT'.tr(context)),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _deleteContentsBatch(
    List<ContentModel> contents, {
    String? confirmationMessage,
  }) async {
    final existingContents =
        contents.where((content) => content.id.isNotEmpty).toList();
    if (existingContents.isEmpty) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('CONFIRM_DELETE'.tr(context)),
        content: Text(
          confirmationMessage ?? 'CONFIRM_DELETE_CONTENT'.tr(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('CANCEL'.tr(context)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('DELETE'.tr(context)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) {
      return;
    }

    final contentProvider = Provider.of<ContentProvider>(context, listen: false);
    var allDeleted = true;
    for (final content in existingContents) {
      final success = await contentProvider.deleteContent(
        content.id,
        content.pageId,
      );
      if (!success) {
        allDeleted = false;
        break;
      }
    }

    if (!mounted) {
      return;
    }

    if (allDeleted) {
      for (final pageId in existingContents.map((e) => e.pageId).toSet()) {
        contentProvider.clearPageCache(pageId);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('CONTENT_DELETED_SUCCESS'.tr(context)),
          backgroundColor: Colors.green,
        ),
      );
      if (_selectedPageId != null) {
        await _loadPageContent(_selectedPageId!);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ERROR_DELETING_CONTENT'.tr(context)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showAddContentDialog() {
    if (_selectedPageId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PLEASE_SELECT_PAGE'.tr(context))),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => ContentItemEditor(
        pageId: _selectedPageId!,
        onSave: (content) {
          Navigator.pop(context);
          _saveContent(content);
        },
      ),
    );
  }

  void _showEditContentDialog(ContentModel content) {
    showDialog(
      context: context,
      builder: (context) => ContentItemEditor(
        initialContent: content,
        pageId: content.pageId,
        onSave: (updatedContent) {
          Navigator.pop(context);
          _saveContent(updatedContent);
        },
      ),
    );
  }

  bool _isAboutLatestNewsContent(ContentModel content) {
    return content.pageId == 'about' &&
        _aboutNewsSectionPattern.hasMatch(content.sectionId);
  }

  bool _isCareerFamilyMemberContent(ContentModel content) {
    return content.pageId == 'career' &&
        _careerFamilySectionPattern.hasMatch(content.sectionId);
  }

  List<ContentModel> _getVisibleContents() {
    return _currentPageContents
        .where(
          (content) =>
              !_isAboutLatestNewsContent(content) &&
              !_isCareerFamilyMemberContent(content),
        )
        .toList();
  }

  List<_AdminAboutNewsEventGroup> _getAboutNewsEvents() {
    final groups = <int, _AdminAboutNewsEventGroup>{};

    for (final content in _currentPageContents) {
      final match = _aboutNewsSectionPattern.firstMatch(content.sectionId);
      if (match == null) {
        continue;
      }

      final index = int.tryParse(match.group(1) ?? '');
      final field = match.group(2);
      if (index == null || field == null) {
        continue;
      }

      var group = groups[index] ?? _AdminAboutNewsEventGroup(index: index);
      switch (field) {
        case 'title':
          group = group.copyWith(titleContent: content);
          break;
        case 'description':
          group = group.copyWith(descriptionContent: content);
          break;
        case 'image':
          group = group.copyWith(imageContent: content);
          break;
      }
      groups[index] = group;
    }

    final sortedIndexes = groups.keys.toList()..sort();
    return sortedIndexes.map((index) => groups[index]!).toList();
  }

  int _getNextAboutNewsEventIndex() {
    final events = _getAboutNewsEvents();
    if (events.isEmpty) {
      return 1;
    }
    return events.map((event) => event.index).reduce((a, b) => a > b ? a : b) + 1;
  }

  void _showAddAboutNewsEventDialog() {
    final eventIndex = _getNextAboutNewsEventIndex();
    showDialog(
      context: context,
      builder: (dialogContext) => AboutNewsEventEditor(
        eventIndex: eventIndex,
        onSave: (draft) {
          Navigator.pop(dialogContext);
          _saveAboutNewsEvent(eventIndex: eventIndex, draft: draft);
        },
      ),
    );
  }

  void _showEditAboutNewsEventDialog(_AdminAboutNewsEventGroup event) {
    showDialog(
      context: context,
      builder: (dialogContext) => AboutNewsEventEditor(
        eventIndex: event.index,
        initialDraft: AboutNewsEventDraft(
          titleEn: event.titleContent?.values['en'] ?? '',
          titleAr: event.titleContent?.values['ar'] ?? '',
          descriptionEn: event.descriptionContent?.values['en'] ?? '',
          descriptionAr: event.descriptionContent?.values['ar'] ?? '',
          imageBase64: event.imageContent?.imageBase64 ?? '',
        ),
        onSave: (draft) {
          Navigator.pop(dialogContext);
          _saveAboutNewsEvent(
            eventIndex: event.index,
            draft: draft,
            existingEvent: event,
          );
        },
      ),
    );
  }

  Future<void> _saveAboutNewsEvent({
    required int eventIndex,
    required AboutNewsEventDraft draft,
    _AdminAboutNewsEventGroup? existingEvent,
  }) async {
    final now = DateTime.now();
    final contents = [
      ContentModel(
        id: existingEvent?.titleContent?.id ?? '',
        pageId: 'about',
        sectionId: 'latest-news-item-$eventIndex-title',
        type: ContentType.text,
        values: {
          'en': draft.titleEn,
          'ar': draft.titleAr,
        },
        imageBase64: null,
        createdAt: existingEvent?.titleContent?.createdAt ?? now,
        updatedAt: now,
      ),
      ContentModel(
        id: existingEvent?.descriptionContent?.id ?? '',
        pageId: 'about',
        sectionId: 'latest-news-item-$eventIndex-description',
        type: ContentType.text,
        values: {
          'en': draft.descriptionEn,
          'ar': draft.descriptionAr,
        },
        imageBase64: null,
        createdAt: existingEvent?.descriptionContent?.createdAt ?? now,
        updatedAt: now,
      ),
      ContentModel(
        id: existingEvent?.imageContent?.id ?? '',
        pageId: 'about',
        sectionId: 'latest-news-item-$eventIndex-image',
        type: ContentType.image,
        values: const {
          'en': '',
          'ar': '',
        },
        imageBase64: draft.imageBase64,
        createdAt: existingEvent?.imageContent?.createdAt ?? now,
        updatedAt: now,
      ),
    ];

    await _saveContentsBatch(contents);
  }

  Future<void> _deleteAboutNewsEvent(_AdminAboutNewsEventGroup event) async {
    await _deleteContentsBatch(
      event.contents,
      confirmationMessage: 'Delete event ${event.index}?',
    );
  }

  List<_AdminCareerFamilyMemberGroup> _getCareerFamilyMembers() {
    final groups = <int, _AdminCareerFamilyMemberGroup>{};

    for (final content in _currentPageContents) {
      final match = _careerFamilySectionPattern.firstMatch(content.sectionId);
      if (match == null) {
        continue;
      }

      final index = int.tryParse(match.group(1) ?? '');
      final field = match.group(2);
      if (index == null || field == null) {
        continue;
      }

      var group = groups[index] ?? _AdminCareerFamilyMemberGroup(index: index);
      switch (field) {
        case 'title':
          group = group.copyWith(titleContent: content);
          break;
        case 'image':
          group = group.copyWith(imageContent: content);
          break;
      }
      groups[index] = group;
    }

    final sortedIndexes = groups.keys.toList()..sort();
    return sortedIndexes.map((index) => groups[index]!).toList();
  }

  int _getNextCareerFamilyMemberIndex() {
    final members = _getCareerFamilyMembers();
    if (members.isEmpty) {
      return 1;
    }
    return members.map((member) => member.index).reduce((a, b) => a > b ? a : b) + 1;
  }

  void _showAddCareerFamilyMemberDialog() {
    final memberIndex = _getNextCareerFamilyMemberIndex();
    showDialog(
      context: context,
      builder: (dialogContext) => CareerFamilyMemberEditor(
        memberIndex: memberIndex,
        onSave: (draft) {
          Navigator.pop(dialogContext);
          _saveCareerFamilyMember(memberIndex: memberIndex, draft: draft);
        },
      ),
    );
  }

  void _showEditCareerFamilyMemberDialog(_AdminCareerFamilyMemberGroup member) {
    showDialog(
      context: context,
      builder: (dialogContext) => CareerFamilyMemberEditor(
        memberIndex: member.index,
        initialDraft: CareerFamilyMemberDraft(
          titleEn: member.titleContent?.values['en'] ?? '',
          titleAr: member.titleContent?.values['ar'] ?? '',
          imageBase64: member.imageContent?.imageBase64 ?? '',
        ),
        onSave: (draft) {
          Navigator.pop(dialogContext);
          _saveCareerFamilyMember(
            memberIndex: member.index,
            draft: draft,
            existingMember: member,
          );
        },
      ),
    );
  }

  Future<void> _saveCareerFamilyMember({
    required int memberIndex,
    required CareerFamilyMemberDraft draft,
    _AdminCareerFamilyMemberGroup? existingMember,
  }) async {
    final now = DateTime.now();
    final contents = [
      ContentModel(
        id: existingMember?.titleContent?.id ?? '',
        pageId: 'career',
        sectionId: 'career-family-member-$memberIndex-title',
        type: ContentType.text,
        values: {
          'en': draft.titleEn,
          'ar': draft.titleAr,
        },
        imageBase64: null,
        createdAt: existingMember?.titleContent?.createdAt ?? now,
        updatedAt: now,
      ),
      ContentModel(
        id: existingMember?.imageContent?.id ?? '',
        pageId: 'career',
        sectionId: 'career-family-member-$memberIndex-image',
        type: ContentType.image,
        values: const {
          'en': '',
          'ar': '',
        },
        imageBase64: draft.imageBase64,
        createdAt: existingMember?.imageContent?.createdAt ?? now,
        updatedAt: now,
      ),
    ];

    await _saveContentsBatch(contents);
  }

  Future<void> _deleteCareerFamilyMember(
    _AdminCareerFamilyMemberGroup member,
  ) async {
    await _deleteContentsBatch(
      member.contents,
      confirmationMessage: 'Delete family member ${member.index}?',
    );
  }

  bool get _isFirebaseInitialized {
    try {
      Firebase.app();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if Firebase is initialized
    if (!_isFirebaseInitialized) {
      return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text(
            'ADMIN_PANEL'.tr(context),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(40.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 80.sp,
                  color: Colors.red,
                ),
                SizedBox(height: 24.h),
                Text(
                  'FIREBASE_NOT_INITIALIZED'.tr(context),
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'FIREBASE_MUST_BE_INITIALIZED'.tr(context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[300],

                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'FIREBASE_WEB_SETUP'.tr(context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[400],

                  ),
                ),
                SizedBox(height: 24.h),
                ElevatedButton.icon(
                  onPressed: () {
                    // Show instructions
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('HOW_TO_SETUP_FIREBASE'.tr(context)),
                        content: Text('FIREBASE_SETUP_INSTRUCTIONS'.tr(context)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK'.tr(context)),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.info),
                  label: Text('SETUP_INSTRUCTIONS'.tr(context)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF4ED47),
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          'ADMIN_PANEL'.tr(context),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFF4ED47),
          labelColor: const Color(0xFFF4ED47),
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: 'TAB_CONTENT'.tr(context), icon: const Icon(Icons.description)),
            Tab(text: 'TAB_LOGOS'.tr(context), icon: const Icon(Icons.business)),
            Tab(text: 'TAB_CONTACT_INFO'.tr(context), icon: const Icon(Icons.contact_phone)),
            Tab(text: 'TAB_SERVICES'.tr(context), icon: const Icon(Icons.miscellaneous_services)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _tabController.index == 0
                ? _loadPages
                : _tabController.index == 1
                    ? () => _loadLogos(pageId: _selectedLogoPageId)
                    : _tabController.index == 3
                        ? () => Provider.of<ServicesProvider>(context, listen: false).loadServices()
                        : null,
            tooltip: 'REFRESH'.tr(context),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildContentTab(),
                _buildLogosTab(),
                _buildContactInfoTab(),
                _buildServicesTab(),
              ],
            ),
    );
  }

  Map<String, String> _getAllPageNames(BuildContext context) {
    final map = Map<String, String>.from(_pageNames);
    final customServices = Provider.of<ServicesProvider>(context, listen: false).customServices;
    for (final s in customServices) {
      map[s.pageId] = s.nameEn.isNotEmpty ? s.nameEn : s.nameAr;
    }
    return map;
  }

  Widget _buildContentTab() {
    return Consumer<ServicesProvider>(
      builder: (context, _, __) {
        final pageNames = _getAllPageNames(context);
        return Row(
              children: [
                // Sidebar with pages
                Container(
                  width: 250.w,
                  color: Colors.black,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: ElevatedButton.icon(
                          onPressed: _showAddContentDialog,
                          icon: const Icon(Icons.add),
                          label: Text('ADD_CONTENT'.tr(context)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF4ED47),
                            foregroundColor: Colors.black,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                        ),
                      ),
                      const Divider(color: Colors.grey),
                      Expanded(
                        child: ListView.builder(
                          itemCount: pageNames.length,
                          itemBuilder: (context, index) {
                            final pageId = pageNames.keys.elementAt(index);
                            final pageName = pageNames[pageId]!;
                            final isSelected = _selectedPageId == pageId;

                            return ListTile(
                              selected: isSelected,
                              selectedTileColor: Colors.grey[800],
                              title: Text(
                                pageName,
                                style: TextStyle(
                                  color: isSelected
                                      ? const Color(0xFFF4ED47)
                                      : Colors.white,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              leading: Icon(
                                Icons.description,
                                color: isSelected
                                    ? const Color(0xFFF4ED47)
                                    : Colors.grey,
                              ),
                              onTap: () => _loadPageContent(pageId),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Main content area
                Expanded(
                  child: _selectedPageId == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.dashboard,
                                size: 100.sp,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'SELECT_PAGE_TO_MANAGE'.tr(context),
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : _buildContentList(),
                ),
              ],
            );
      },
    );
  }

  Widget _buildContentList() {
    final isWideLayout = MediaQuery.of(context).size.width >= 1400;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CONTENT_FOR'.tr(context).replaceAll('{page}', _pageNames[_selectedPageId] ?? ''),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: [
                  if (_selectedPageId == 'about')
                    ElevatedButton.icon(
                      onPressed: _showAddAboutNewsEventDialog,
                      icon: const Icon(Icons.event),
                      label: const Text('Add Event'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  if (_selectedPageId == 'career')
                    ElevatedButton.icon(
                      onPressed: _showAddCareerFamilyMemberDialog,
                      icon: const Icon(Icons.people),
                      label: const Text('Add Family Member'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ElevatedButton.icon(
                    onPressed: _showAddContentDialog,
                    icon: const Icon(Icons.add),
                    label: Text('ADD_CONTENT'.tr(context)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF4ED47),
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            child: isWideLayout
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 7,
                        child: _buildPagePreviewPanel(),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        flex: 5,
                        child: _buildContentManagerPanel(),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: 360.h,
                        child: _buildPagePreviewPanel(),
                      ),
                      SizedBox(height: 16.h),
                      Expanded(
                        child: _buildContentManagerPanel(),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildPagePreviewPanel() {
    final previewWidget = _selectedPageId == null
        ? null
        : _buildPreviewForPage(_selectedPageId!);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.preview,
                  color: const Color(0xFFF4ED47),
                  size: 22.sp,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    'Page Preview',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              'Read-only mini preview for the selected page.',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.white10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: previewWidget == null
                      ? _buildUnsupportedPreview()
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            return ColoredBox(
                              color: Colors.black,
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  alignment: Alignment.topCenter,
                                  child: SizedBox(
                                    width: 1440,
                                    height: 900,
                                    child: previewWidget,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentManagerPanel() {
    final visibleContents = _getVisibleContents();
    final aboutNewsEvents =
        _selectedPageId == 'about' ? _getAboutNewsEvents() : <_AdminAboutNewsEventGroup>[];
    final careerFamilyMembers = _selectedPageId == 'career'
        ? _getCareerFamilyMembers()
        : <_AdminCareerFamilyMemberGroup>[];
    final hasAnyContent = visibleContents.isNotEmpty ||
        aboutNewsEvents.isNotEmpty ||
        careerFamilyMembers.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Icon(
                  Icons.edit_note,
                  color: const Color(0xFFF4ED47),
                  size: 22.sp,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    'Editable Sections',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          Expanded(
            child: !hasAnyContent
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox, size: 72.sp, color: Colors.grey),
                          SizedBox(height: 16.h),
                          Text(
                            'NO_CONTENT_ON_PAGE'.tr(context),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          ElevatedButton.icon(
                            onPressed: _selectedPageId == 'about'
                                ? _showAddAboutNewsEventDialog
                                : _selectedPageId == 'career'
                                    ? _showAddCareerFamilyMemberDialog
                                    : _showAddContentDialog,
                            icon: Icon(
                              _selectedPageId == 'about'
                                  ? Icons.event
                                  : _selectedPageId == 'career'
                                      ? Icons.people
                                      : Icons.add,
                            ),
                            label: Text(
                              _selectedPageId == 'about'
                                  ? 'Add Event'
                                  : _selectedPageId == 'career'
                                      ? 'Add Family Member'
                                  : 'ADD_NEW_CONTENT'.tr(context),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedPageId == 'about'
                                  ? Colors.blue
                                  : _selectedPageId == 'career'
                                      ? Colors.deepPurple
                                  : const Color(0xFFF4ED47),
                              foregroundColor: _selectedPageId == 'about'
                                  ? Colors.white
                                  : _selectedPageId == 'career'
                                      ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView(
                    padding: EdgeInsets.all(16.w),
                    children: [
                      if (_selectedPageId == 'about') ...[
                        _buildAboutNewsEventsSection(aboutNewsEvents),
                        SizedBox(height: 16.h),
                      ],
                      if (_selectedPageId == 'career') ...[
                        _buildCareerFamilyMembersSection(careerFamilyMembers),
                        SizedBox(height: 16.h),
                      ],
                      ...visibleContents.map(_buildContentCard),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutNewsEventsSection(List<_AdminAboutNewsEventGroup> events) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event, color: const Color(0xFFF4ED47), size: 20.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Latest News & Events',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showAddAboutNewsEventDialog,
                icon: const Icon(Icons.add),
                label: const Text('Add Event'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (events.isEmpty)
            Text(
              'No events added yet.',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
            )
          else
            ...events.map(_buildAboutNewsEventCard),
        ],
      ),
    );
  }

  Widget _buildAboutNewsEventCard(_AdminAboutNewsEventGroup event) {
    return Card(
      color: Colors.grey[800],
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 110.w,
              height: 90.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white24),
              ),
              child: event.imageContent?.imageBase64?.isNotEmpty == true
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        base64Decode(event.imageContent!.imageBase64!),
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.image, color: Colors.grey),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event ${event.index}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFF4ED47),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  if (event.titleContent?.values['en']?.isNotEmpty == true)
                    Text(
                      'EN: ${event.titleContent!.values['en']}',
                      style: TextStyle(fontSize: 14.sp, color: Colors.white),
                    ),
                  if (event.titleContent?.values['ar']?.isNotEmpty == true)
                    Text(
                      'AR: ${event.titleContent!.values['ar']}',
                      style: TextStyle(fontSize: 14.sp, color: Colors.white),
                    ),
                  SizedBox(height: 6.h),
                  if (event.descriptionContent?.values['en']?.isNotEmpty == true)
                    Text(
                      'EN Desc: ${event.descriptionContent!.values['en']}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13.sp, color: Colors.grey[300]),
                    ),
                  if (event.descriptionContent?.values['ar']?.isNotEmpty == true)
                    Text(
                      'AR Desc: ${event.descriptionContent!.values['ar']}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13.sp, color: Colors.grey[300]),
                    ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showEditAboutNewsEventDialog(event),
                  tooltip: 'EDIT'.tr(context),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteAboutNewsEvent(event),
                  tooltip: 'DELETE'.tr(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCareerFamilyMembersSection(
    List<_AdminCareerFamilyMemberGroup> members,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.people, color: const Color(0xFFF4ED47), size: 20.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Our Family Members',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showAddCareerFamilyMemberDialog,
                icon: const Icon(Icons.add),
                label: const Text('Add Family Member'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (members.isEmpty)
            Text(
              'No family members added yet.',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
            )
          else
            ...members.map(_buildCareerFamilyMemberCard),
        ],
      ),
    );
  }

  Widget _buildCareerFamilyMemberCard(_AdminCareerFamilyMemberGroup member) {
    return Card(
      color: Colors.grey[800],
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 110.w,
              height: 90.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white24),
              ),
              child: member.imageContent?.imageBase64?.isNotEmpty == true
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        base64Decode(member.imageContent!.imageBase64!),
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.image, color: Colors.grey),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Member ${member.index}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFF4ED47),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  if (member.titleContent?.values['en']?.isNotEmpty == true)
                    Text(
                      'EN: ${member.titleContent!.values['en']}',
                      style: TextStyle(fontSize: 14.sp, color: Colors.white),
                    ),
                  if (member.titleContent?.values['ar']?.isNotEmpty == true)
                    Text(
                      'AR: ${member.titleContent!.values['ar']}',
                      style: TextStyle(fontSize: 14.sp, color: Colors.white),
                    ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showEditCareerFamilyMemberDialog(member),
                  tooltip: 'EDIT'.tr(context),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteCareerFamilyMember(member),
                  tooltip: 'DELETE'.tr(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnsupportedPreview() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.web_asset_off,
              size: 72.sp,
              color: Colors.grey,
            ),
            SizedBox(height: 16.h),
            Text(
              'Preview is not available for this page yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'You can still edit all linked sections from the right panel.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildPreviewForPage(String pageId) {
    switch (pageId) {
      case 'home':
        return const HomeScreen();
      case 'about':
        return const AboutScreen();
      case 'contacts':
        return const ContactsScreen();
      case 'career':
        return const CareerScreen();
      case 'buy':
        return const BuyScreen();
      case 'sell':
        return const SellScreen();
      case 'lease':
        return const LeaseScreen();
      case 'exclusive-leasing-projects':
        return const ExclusiveLeasingProjectsScreen();
      case 'corporate-leasing':
        return const CorporateLeasingScreen();
      case 'retail-leasing':
        return const RetailLeasingScreen();
      case 'medical-leasing':
        return const MedicalLeasingScreen();
      case 'facility-management':
        return const FacilityManagementScreen();
      case 'franchise-investment':
        return const FranchiseInvestmentScreen();
      case 'primary-investment':
        return const PrimaryInvestmentScreen();
      case 'marketing':
        return const MarketingScreen();
      case 'consultation':
        return const ConsultationScreen();
      case 'all-logos':
        return const AllLogosScreen();
      case 'services':
        return Scaffold(
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            child: Column(
              children: const [
                SizedBox(height: 40),
                ContentServiceSection(),
                FooterSection(),
              ],
            ),
          ),
        );
      default:
        // Custom services use GenericServiceScreen
        if (Provider.of<ServicesProvider>(context, listen: false).isCustomService(pageId)) {
          return GenericServiceScreen(pageId: pageId);
        }
        return null;
    }
  }

  Widget _buildContentCard(ContentModel content) {
    return Card(
      color: Colors.grey[800],
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SECTION_ID'.tr(context) + ' ${content.sectionId}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFF4ED47),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'TYPE'.tr(context) + ': ${_getTypeName(content.type)}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditContentDialog(content),
                      tooltip: 'EDIT'.tr(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteContent(content),
                      tooltip: 'DELETE'.tr(context),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            if (content.type == ContentType.text) ...[
              if (content.values['ar']?.isNotEmpty == true)
                Text(
                  'ARABIC'.tr(context) + ': ${content.values['ar']}',
                  style: TextStyle(fontSize: 14.sp, color: Colors.white),
                ),
              if (content.values['en']?.isNotEmpty == true)
                Text(
                  'ENGLISH'.tr(context) + ': ${content.values['en']}',
                  style: TextStyle(fontSize: 14.sp, color: Colors.white),
                ),
            ] else if (content.type == ContentType.image &&
                content.imageBase64 != null) ...[
              Container(
                height: 150.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    base64Decode(content.imageBase64!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ] else if (content.type == ContentType.video) ...[
              if (content.values['link']?.isNotEmpty == true)
                Text(
                  'VIDEO LINK: ${content.values['link']}',
                  style: TextStyle(fontSize: 14.sp, color: Colors.white),
                ),
              if (content.imageBase64?.isNotEmpty == true)
                Text(
                  'Base64 video attached',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[300]),
                ),
            ] else if (content.type == ContentType.link) ...[
              if (content.values['link']?.isNotEmpty == true)
                Text(
                  'LINK: ${content.values['link']}',
                  style: TextStyle(fontSize: 14.sp, color: Colors.white),
                ),
            ],
          ],
        ),
      ),
    );
  }

  String _getTypeName(ContentType type) {
    switch (type) {
      case ContentType.text:
        return 'TYPE_TEXT'.tr(context);
      case ContentType.image:
        return 'TYPE_IMAGE'.tr(context);
      case ContentType.video:
        return 'TYPE_VIDEO'.tr(context);
      case ContentType.link:
        return 'TYPE_LINK'.tr(context);
    }
  }

  Widget _buildContactInfoTab() {
    return const ContactInfoEditor();
  }

  Widget _buildServicesTab() {
    return Consumer<ServicesProvider>(
      builder: (context, servicesProvider, _) {
        final customServices = servicesProvider.customServices;
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MANAGE_CUSTOM_SERVICES'.tr(context),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showAddServiceDialog(servicesProvider),
                    icon: const Icon(Icons.add),
                    label: Text('ADD_SERVICE'.tr(context)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF4ED47),
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: customServices.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.miscellaneous_services, size: 100.sp, color: Colors.grey),
                          SizedBox(height: 16.h),
                          Text(
                            'NO_CUSTOM_SERVICES'.tr(context),
                            style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                          ),
                          SizedBox(height: 16.h),
                          ElevatedButton.icon(
                            onPressed: () => _showAddServiceDialog(servicesProvider),
                            icon: const Icon(Icons.add),
                            label: Text('ADD_SERVICE'.tr(context)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF4ED47),
                              foregroundColor: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(16.w),
                      itemCount: customServices.length,
                      itemBuilder: (context, index) {
                        final service = customServices[index];
                        return _buildServiceCard(service, servicesProvider);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  void _showAddServiceDialog(ServicesProvider servicesProvider) {
    showDialog(
      context: context,
      builder: (context) => ServiceEditor(
        onSave: (service) async {
          Navigator.pop(context);
          final success = await servicesProvider.addService(service);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(success ? 'SERVICE_ADDED'.tr(context) : 'ERROR_SAVING_CONTENT'.tr(context)),
                backgroundColor: success ? Colors.green : Colors.red,
              ),
            );
          }
        },
      ),
    );
  }

  void _showEditServiceDialog(ServiceModel service, ServicesProvider servicesProvider) {
    showDialog(
      context: context,
      builder: (context) => ServiceEditor(
        initialService: service,
        onSave: (updatedService) async {
          Navigator.pop(context);
          final success = await servicesProvider.updateService(updatedService);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(success ? 'SERVICE_UPDATED'.tr(context) : 'ERROR_SAVING_CONTENT'.tr(context)),
                backgroundColor: success ? Colors.green : Colors.red,
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _deleteService(ServiceModel service, ServicesProvider servicesProvider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('CONFIRM_DELETE'.tr(context)),
        content: Text('CONFIRM_DELETE_SERVICE'.tr(context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('CANCEL'.tr(context)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('DELETE'.tr(context)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success = await servicesProvider.deleteService(service.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'SERVICE_DELETED'.tr(context) : 'ERROR_DELETING_CONTENT'.tr(context)),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildServiceCard(ServiceModel service, ServicesProvider servicesProvider) {
    return Card(
      color: Colors.grey[800],
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Icon(Icons.miscellaneous_services, color: const Color(0xFFF4ED47), size: 40.sp),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${service.nameEn} / ${service.nameAr}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFF4ED47),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Page ID: ${service.pageId}',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[300]),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showEditServiceDialog(service, servicesProvider),
              tooltip: 'EDIT'.tr(context),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteService(service, servicesProvider),
              tooltip: 'DELETE'.tr(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogosTab() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MANAGE_LOGOS'.tr(context),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _showAddLogoDialog,
                        icon: const Icon(Icons.add),
                        label: Text('ADD_LOGO'.tr(context)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF4ED47),
                          foregroundColor: Colors.black,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      ElevatedButton.icon(
                        onPressed: _showBatchAddLogoDialog,
                        icon: const Icon(Icons.add_photo_alternate),
                        label: Text('ADD_MULTIPLE_LOGOS'.tr(context)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // Filter by page dropdown
              Row(
                children: [
                  SizedBox(
                    width: 300.w,
                    child: DropdownButtonFormField<String>(
                      value: _selectedLogoPageId,
                      decoration: InputDecoration(
                        labelText: 'FILTER_BY_PAGE'.tr(context),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.grey[800],
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                      dropdownColor: Colors.grey[800],
                      style: const TextStyle(color: Colors.white),
                      items: [
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text('ALL_PAGES'.tr(context)),
                        ),
                        ..._getServiceNamesEnglish(context).entries.map((entry) {
                          return DropdownMenuItem<String>(
                            value: entry.key,
                            child: Text(entry.value),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedLogoPageId = value;
                        });
                        _loadLogos(pageId: value);
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  if (_selectedLogoPageId != null)
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedLogoPageId = null;
                        });
                        _loadLogos();
                      },
                      icon: const Icon(Icons.clear),
                      label: Text('CLEAR_FILTER'.tr(context)),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: _logos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.business, size: 100.sp, color: Colors.grey),
                      SizedBox(height: 16.h),
                      Text(
                        'NO_LOGOS'.tr(context),
                        style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton.icon(
                        onPressed: _showAddLogoDialog,
                        icon: const Icon(Icons.add),
                        label: Text('ADD_NEW_LOGO'.tr(context)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF4ED47),
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: _logos.length,
                  itemBuilder: (context, index) {
                    final logo = _logos[index];
                    return _buildLogoCard(logo);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildLogoCard(LogoModel logo) {
    return Card(
      color: Colors.grey[800],
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            // Logo Preview
            Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: logo.imageBase64.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        base64Decode(logo.imageBase64),
                        fit: BoxFit.contain,
                      ),
                    )
                  : const Icon(Icons.business, color: Colors.grey),
            ),
            SizedBox(width: 16.w),
            // Logo Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    logo.name.isNotEmpty ? logo.name : 'Logo ${logo.order + 1}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFF4ED47),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'PAGE'.tr(context) + ': ${_getServiceNamesEnglish(context)[logo.pageId] ?? _pageNames[logo.pageId] ?? logo.pageId}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[300],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'ORDER'.tr(context) + ': ${logo.order + 1}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ),
            // Actions
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showEditLogoDialog(logo),
                  tooltip: 'EDIT'.tr(context),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteLogo(logo),
                  tooltip: 'DELETE'.tr(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminAboutNewsEventGroup {
  final int index;
  final ContentModel? titleContent;
  final ContentModel? descriptionContent;
  final ContentModel? imageContent;

  const _AdminAboutNewsEventGroup({
    required this.index,
    this.titleContent,
    this.descriptionContent,
    this.imageContent,
  });

  List<ContentModel> get contents => [
        if (titleContent != null) titleContent!,
        if (descriptionContent != null) descriptionContent!,
        if (imageContent != null) imageContent!,
      ];

  _AdminAboutNewsEventGroup copyWith({
    ContentModel? titleContent,
    ContentModel? descriptionContent,
    ContentModel? imageContent,
  }) {
    return _AdminAboutNewsEventGroup(
      index: index,
      titleContent: titleContent ?? this.titleContent,
      descriptionContent: descriptionContent ?? this.descriptionContent,
      imageContent: imageContent ?? this.imageContent,
    );
  }
}

class _AdminCareerFamilyMemberGroup {
  final int index;
  final ContentModel? titleContent;
  final ContentModel? imageContent;

  const _AdminCareerFamilyMemberGroup({
    required this.index,
    this.titleContent,
    this.imageContent,
  });

  List<ContentModel> get contents => [
        if (titleContent != null) titleContent!,
        if (imageContent != null) imageContent!,
      ];

  _AdminCareerFamilyMemberGroup copyWith({
    ContentModel? titleContent,
    ContentModel? imageContent,
  }) {
    return _AdminCareerFamilyMemberGroup(
      index: index,
      titleContent: titleContent ?? this.titleContent,
      imageContent: imageContent ?? this.imageContent,
    );
  }
}

