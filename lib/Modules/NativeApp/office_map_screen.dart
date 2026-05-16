import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Widgets/bottom_navbar_widget.dart';
import '../../Widgets/custom_app_bar_mob.dart';
import '../../Widgets/floating_contact_buttons.dart';
import '../../core/Contact/contact_info_provider.dart';
import '../../core/Language/locales.dart';
import '../../core/responsive/native_layout.dart';

/// خريطة تفاعلية داخل التطبيق لموقع المكتب (مبدأ 4.2 — أكثر من مجرد فتح رابط خارجي).
class OfficeMapScreen extends StatelessWidget {
  static const String routeName = '/native-office-map';

  /// تقريب لمقر INCM — القاهرة الجديدة (يمكن ضبط الإحداثيات لاحقًا ليطابق [ContactInfoModel.mapLink])
  static final LatLng officePoint = LatLng(30.0326, 31.4773);

  const OfficeMapScreen({super.key});

  static const String _userAgentPackage = 'com.incm.realestate';

  Future<void> _openMapsExternally(BuildContext context) async {
    final address = Provider.of<ContactInfoProvider>(context, listen: false).address;
    final label = Uri.encodeComponent(address);
    final lat = officePoint.latitude;
    final lng = officePoint.longitude;

    final Uri uri = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS
        ? Uri.parse('https://maps.apple.com/?ll=$lat,$lng&q=$label')
        : Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final showNativeChrome = useNativeBottomNavigationBar(context);
    final bg = const Color(0xFF1a1a1a);

    return Scaffold(
      backgroundColor: bg,
      bottomNavigationBar: showNativeChrome
          ? const BottomNavBarWidget(selected: SelectedBottomNavBar.contacts)
          : null,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.paddingOf(context).top + 50.h,
                  ),
                  child: ClipRRect(
                    child: FlutterMap(
                    options: MapOptions(
                      initialCenter: officePoint,
                      initialZoom: 14,
                      minZoom: 3,
                      maxZoom: 19,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.all,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: _userAgentPackage,
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: officePoint,
                            width: 48,
                            height: 48,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.location_on,
                              color: const Color(0xFFF4ED47),
                              size: 44.sp,
                              shadows: const [
                                Shadow(blurRadius: 4, color: Colors.black54),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                    ),
                  ),
                ),
              ),
              Material(
                color: bg,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
                    child: Consumer<ContactInfoProvider>(
                      builder: (context, ci, _) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'NATIVE_MAP_OFFICE_ADDRESS'.tr(context),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              ci.address,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                height: 1.35,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFFF4ED47),
                                foregroundColor: Colors.black87,
                              ),
                              onPressed: () => _openMapsExternally(context),
                              icon: const Icon(Icons.open_in_new),
                              label: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Text('NATIVE_MAP_OPEN_IN_SYSTEM_MAPS'.tr(context)),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: useWebDesktopAppBar(context)
                ? const SizedBox.shrink()
                : SafeArea(bottom: false, child: SizedBox(height: 50.h, child: CustomAppBarMob())),
          ),
          if (showNativeChrome) const FloatingContactButtons(),
        ],
      ),
    );
  }
}
