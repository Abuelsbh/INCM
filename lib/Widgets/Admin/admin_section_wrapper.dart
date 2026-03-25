import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../core/Admin/admin_mode_provider.dart';
import '../../core/Content/content_provider.dart';
import '../../core/Content/section_ids_config.dart';
import '../../core/Language/locales.dart';
import '../../Models/content_model.dart';
import 'content_item_editor.dart';

/// Wraps a section with an overlay edit button when in admin mode.
/// Uses Stack+Positioned so it does NOT affect layout - zero visual change for users.
class AdminSectionWrapper extends StatelessWidget {
  final Widget child;
  final String pageId;
  final List<String> sectionIds;

  const AdminSectionWrapper({
    super.key,
    required this.child,
    required this.pageId,
    required this.sectionIds,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminModeProvider>(
      builder: (context, adminProvider, _) {
        if (!adminProvider.isAdminMode) {
          return child;
        }
        return Stack(
          clipBehavior: Clip.none,
          children: [
            child,
            Positioned(
              top: 100.h, // تحت الـ AppBar عشان يبان واضح
              right: 12.w,
              child: _AdminEditButton(
                pageId: pageId,
                sectionIds: sectionIds,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AdminEditButton extends StatelessWidget {
  final String pageId;
  final List<String> sectionIds;

  const _AdminEditButton({
    required this.pageId,
    required this.sectionIds,
  });

  void _onEditPressed(BuildContext context) async {
    if (sectionIds.isEmpty) return;

    final contentProvider = Provider.of<ContentProvider>(context, listen: false);
    final pageContents = await contentProvider.getPageContent(pageId);
    final sectionOptions = SectionIdsConfig.getSectionIdsForPage(pageId);

    ContentModel? findExisting(String sid) {
      try {
        return pageContents.firstWhere((c) => c.sectionId == sid);
      } catch (_) {
        return null;
      }
    }

    if (sectionIds.length == 1) {
      final sectionId = sectionIds.first;
      final existing = findExisting(sectionId);
      if (!context.mounted) return;
      _showEditDialog(context, contentProvider, existing, sectionId);
      return;
    }

    if (!context.mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.25,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'EDIT_SECTION'.tr(ctx),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFF4ED47),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: sectionIds.length,
                        itemBuilder: (_, index) {
                          final sectionId = sectionIds[index];
                          final labelOpt = sectionOptions.where((o) => o.id == sectionId);
                          final label = labelOpt.isEmpty ? sectionId : labelOpt.first.label;
                          final existing = findExisting(sectionId);
                          return ListTile(
                            leading: Icon(
                              existing != null ? Icons.edit : Icons.add_circle_outline,
                              color: const Color(0xFFF4ED47),
                            ),
                            title: Text(
                              label,
                              style: TextStyle(color: Colors.white, fontSize: 16.sp),
                            ),
                            onTap: () {
                              Navigator.pop(ctx);
                              _showEditDialog(context, contentProvider, existing, sectionId);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEditDialog(
    BuildContext context,
    ContentProvider contentProvider,
    ContentModel? existing,
    String sectionId,
  ) {
    final sectionOptions = SectionIdsConfig.getSectionIdsForPage(pageId);
    SectionIdOption? option;
    try {
      option = sectionOptions.firstWhere((o) => o.id == sectionId);
    } catch (_) {
      option = null;
    }
    ContentType suggestedType = ContentType.text;
    if (option != null) {
      if (option.suggestedType == 'video') {
        suggestedType = ContentType.video;
      } else if (option.suggestedType == 'image') {
        suggestedType = ContentType.image;
      }
    }

    final defaultValues = <String, String>{'en': '', 'ar': ''};
    if (suggestedType == ContentType.video) {
      defaultValues['link'] = '';
    }
    final contentToEdit = existing ??
        ContentModel(
          id: '',
          pageId: pageId,
          sectionId: sectionId,
          type: suggestedType,
          values: defaultValues,
          imageBase64: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
    showDialog(
      context: context,
      builder: (ctx) => ContentItemEditor(
        initialContent: contentToEdit,
        pageId: pageId,
        onSave: (content) {
          Navigator.pop(ctx);
          contentProvider.saveContent(content).then((success) {
            if (success && context.mounted) {
              contentProvider.clearPageCache(pageId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('CONTENT_SAVED_SUCCESS'.tr(context)),
                  backgroundColor: Colors.green,
                ),
              );
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF4ED47).withOpacity(0.95),
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        onTap: () => _onEditPressed(context),
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.edit, size: 20.sp, color: Colors.black87),
              SizedBox(width: 6.w),
              Text(
                'EDIT'.tr(context),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

