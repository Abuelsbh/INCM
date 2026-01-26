import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../core/Content/content_provider.dart';
import '../../core/Firebase/firebase_logos_service.dart';
import '../../Models/content_model.dart';
import '../../Models/page_content_model.dart';
import '../../Models/logo_model.dart';
import '../../Widgets/Admin/content_item_editor.dart';
import '../../Widgets/Admin/logo_editor.dart';
import '../../Widgets/Admin/batch_logo_editor.dart';
import '../../core/Language/locales.dart';

class AdminPanelScreen extends StatefulWidget {
  static const String routeName = '/admin';

  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> with SingleTickerProviderStateMixin {
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

  // English names for the 8 services (for logo display)
  final Map<String, String> _serviceNamesEnglish = {
    'corporate-leasing': 'Corporate Leasing',
    'retail-leasing': 'Retail Leasing',
    'medical-leasing': 'Medical Leasing',
    'facility-management': 'Facility Management',
    'franchise-investment': 'Franchise Investment',
    'primary-investment': 'Primary Investment',
    'marketing': 'Marketing',
    'consultation': 'Consultation',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
        if (_tabController.index == 1) {
          _loadLogos(pageId: _selectedLogoPageId);
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
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _tabController.index == 0 ? _loadPages : _loadLogos,
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
              ],
            ),
    );
  }

  Widget _buildContentTab() {
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
                          itemCount: _pageNames.length,
                          itemBuilder: (context, index) {
                            final pageId = _pageNames.keys.elementAt(index);
                            final pageName = _pageNames[pageId]!;
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
  }

  Widget _buildContentList() {
    if (_currentPageContents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 100.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'NO_CONTENT_ON_PAGE'.tr(context),
              style: TextStyle(fontSize: 18.sp, color: Colors.grey),
            ),
            SizedBox(height: 16.h),
            ElevatedButton.icon(
              onPressed: _showAddContentDialog,
              icon: const Icon(Icons.add),
              label: Text('ADD_NEW_CONTENT'.tr(context)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF4ED47),
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      );
    }

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
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: _currentPageContents.length,
            itemBuilder: (context, index) {
              final content = _currentPageContents[index];
              return _buildContentCard(content);
            },
          ),
        ),
      ],
    );
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
                        ..._serviceNamesEnglish.entries.map((entry) {
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
                    'PAGE'.tr(context) + ': ${_serviceNamesEnglish[logo.pageId] ?? _pageNames[logo.pageId] ?? logo.pageId}',
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

