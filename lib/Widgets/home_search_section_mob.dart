import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:video_player/video_player.dart';

import '../generated/assets.dart';

class HomeSearchSectionMob extends StatefulWidget {
  const HomeSearchSectionMob({super.key});

  @override
  State<HomeSearchSectionMob> createState() => _HomeSearchSectionMobState();
}

class _HomeSearchSectionMobState extends State<HomeSearchSectionMob> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.asset(Assets.videosMobile);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 786.h,
      width: double.infinity,
      child: Stack(
        children: [
          // Video Background
          Positioned.fill(
            child: _isVideoInitialized
                ? FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox(
                      width: _videoController.value.size.width,
                      height: _videoController.value.size.height,
                      child: VideoPlayer(_videoController),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(Assets.imagesSearchBackgroundMob),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
          ),
          // Background INCM text/logo

          // Main content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 50.h),
            child: Center(
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
                      fontSize: 26.sp,
                      height: 0.2,
                    ),
                  ),
                  Text(
                    'STEP INTO A WORLD WHERE REAL ESTATE MEETS INNOVATION AND EXCELLENCE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'AloeveraDisplayRegular',
                      color: Colors.white,

                    ),
                  ),
                  Gap(50.h),
                  // Search Bar
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(maxWidth: 900.w),
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
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: const Color(0xFFF4ED47),
                            size: 24.sp,
                          ),
                          SizedBox(width: 5.w),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
