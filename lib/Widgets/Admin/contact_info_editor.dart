import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Models/contact_info_model.dart';
import '../../core/Contact/contact_info_provider.dart';
import '../../core/Language/locales.dart';
import 'package:provider/provider.dart';

class ContactInfoEditor extends StatefulWidget {
  final VoidCallback? onSaved;

  const ContactInfoEditor({super.key, this.onSaved});

  @override
  State<ContactInfoEditor> createState() => _ContactInfoEditorState();
}

class _ContactInfoEditorState extends State<ContactInfoEditor> {
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _whatsappController;
  late TextEditingController _addressController;
  late TextEditingController _mapLinkController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _whatsappController = TextEditingController();
    _addressController = TextEditingController();
    _mapLinkController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final provider = context.read<ContactInfoProvider>();
    await provider.fetchContactInfo();
    if (mounted) {
        _emailController.text = provider.email;
      _phoneController.text = provider.phone;
      _whatsappController.text = provider.whatsapp;
      _addressController.text = provider.address;
      _mapLinkController.text = provider.mapLink;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _addressController.dispose();
    _mapLinkController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);

    var whatsapp = _whatsappController.text.trim().replaceAll(RegExp(r'[^\d]'), '');
    if (whatsapp.startsWith('0')) {
      whatsapp = '20${whatsapp.substring(1)}';
    } else if (!whatsapp.startsWith('20') && whatsapp.length >= 9) {
      whatsapp = '20$whatsapp';
    }
    final info = ContactInfoModel(
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      whatsapp: whatsapp,
      address: _addressController.text.trim(),
      mapLink: _mapLinkController.text.trim(),
    );

    final provider = context.read<ContactInfoProvider>();
    final success = await provider.saveContactInfo(info);

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('CONTACT_INFO_SAVED'.tr(context)),
            backgroundColor: Colors.green,
          ),
        );
        widget.onSaved?.call();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ERROR_SAVING_CONTACT_INFO'.tr(context)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'EDIT_CONTACT_INFO'.tr(context),
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFF4ED47),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'CONTACT_INFO_DESCRIPTION'.tr(context),
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
          ),
          SizedBox(height: 32.h),
          _buildField('E_MAIL'.tr(context), _emailController, TextInputType.emailAddress),
          SizedBox(height: 16.h),
          _buildField('PHONE_CALL'.tr(context), _phoneController, TextInputType.phone),
          SizedBox(height: 16.h),
          _buildField('WHATSAPP_NUMBER'.tr(context), _whatsappController, TextInputType.phone),
          SizedBox(height: 16.h),
          _buildField('ADDRESS'.tr(context), _addressController, TextInputType.streetAddress),
          SizedBox(height: 16.h),
          _buildField('MAP_LINK'.tr(context), _mapLinkController, TextInputType.url),
          SizedBox(height: 32.h),
          ElevatedButton.icon(
            onPressed: _isSaving ? null : _save,
            icon: _isSaving
                ? SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                  )
                : const Icon(Icons.save),
            label: Text(_isSaving ? 'SAVING'.tr(context) : 'SAVE'.tr(context)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF4ED47),
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, TextInputType type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          keyboardType: type,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          ),
        ),
      ],
    );
  }
}
