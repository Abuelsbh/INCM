import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:video_player/video_player.dart';

import '../generated/assets.dart';

class HomeSearchSection extends StatefulWidget {
  const HomeSearchSection({super.key});

  @override
  State<HomeSearchSection> createState() => _HomeSearchSectionState();
}

class _HomeSearchSectionState extends State<HomeSearchSection> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
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
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(Assets.imagesSearchBackground),
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
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  Assets.imagesINCM,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
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
                          child: TextField(
                            decoration: InputDecoration(
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
                      ],
                    ),
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