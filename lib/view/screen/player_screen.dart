import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_v1/core/functions/duration_extensions%20.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/player_controller.dart';

class PlayerScreen extends GetView<PlayerController> {
  const PlayerScreen({super.key});

  PlayerController get playerController => controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF1C1B1B),
        body: Padding(
          padding: EdgeInsets.only(
            top: 2.h,
            left: 16.sp,
            bottom: 10.sp,
            right: 16.sp,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.sp, bottom: 5.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Music Player',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: 'Segoe UI',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final url = Uri.parse('https://github.com/vellt');
                        await launchUrl(url);
                      },
                      child: Text(
                        'GitHub/vellt',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontFamily: 'Segoe UI',
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF71B77A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Music list
              Flexible(
                child: Obx(
                  () => ListView.builder(
                    itemCount: playerController.streams.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final track = playerController.streams[index];

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.sp),
                        child: InkWell(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.sp),
                          ),
                          onTap: () async {
                            playerController.currentStreamIndex.value = index;
                            await playerController.play();
                          },
                          child: Obx(
                            () => Container(
                              height: 52.sp,
                              decoration: BoxDecoration(
                                color:
                                    playerController.currentStreamIndex.value ==
                                            index
                                        ? const Color(0xFF2A2A2A)
                                        : Colors.transparent,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.sp),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 13.sp,
                                    ),
                                    child: SizedBox(
                                      height: 35.sp,
                                      width: 35.sp,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15.sp),
                                        ),
                                        child: Image.network(
                                          track.picture ?? '',
                                          fit: BoxFit.cover,
                                          frameBuilder: (
                                            context,
                                            child,
                                            frame,
                                            wasSynchronouslyLoaded,
                                          ) {
                                            if (wasSynchronouslyLoaded ||
                                                frame != null) {
                                              return child;
                                            }

                                            return Padding(
                                              padding: EdgeInsets.all(8.sp),
                                              child: CircularProgressIndicator(
                                                strokeWidth: 5.sp,
                                                color: const Color(0xFF71B77A),
                                              ),
                                            );
                                          },
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Container(
                                              color: const Color(0xFF71B77A),
                                              alignment: Alignment.center,
                                              child: const Text('404'),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Track information
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                track.composer ?? '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  color: const Color(
                                                    0xFFACACAC,
                                                  ),
                                                  fontWeight: FontWeight.w300,
                                                  fontFamily: 'Segoe UI',
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: 15.sp,
                                                left: 5.sp,
                                              ),
                                              child: Text(
                                                track.long ?? '',
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  color: const Color(
                                                    0xFFACACAC,
                                                  ),
                                                  fontWeight: FontWeight.w300,
                                                  fontFamily: 'Segoe UI',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          track.title ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Segoe UI',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Bottom seek bar and controls
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1C1B1B),
                      blurRadius: 15.sp,
                      offset: const Offset(0, 0),
                      spreadRadius: 30.sp,
                    ),
                  ],
                ),
                child: Obx(() {
                  final totalSeconds =
                      playerController.duration.value.inSeconds.toDouble();

                  final positionSeconds =
                      playerController.position.value.inSeconds.toDouble();

                  final sliderMax = totalSeconds < 1.0 ? 1.0 : totalSeconds;

                  final sliderValue =
                      positionSeconds.clamp(0.0, sliderMax).toDouble();

                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 15.sp, left: 15.sp),
                        child: Row(
                          children: [
                            Text(
                              playerController.position.value.timeFormat,
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                activeColor: const Color(0xFF71B77A),
                                inactiveColor: const Color(0xFFEFEFEF),
                                value: sliderValue,
                                min: 0.0,
                                max: sliderMax,
                                onChanged: (double value) {
                                  playerController.setPositionValue(value);
                                },
                              ),
                            ),
                            Text(
                              playerController.duration.value.timeFormat,
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Previous, play/pause and next
                      /*  Padding(
                        padding: EdgeInsets.only(
                          right: 10.sp,
                          left: 10.sp,
                          top: 5.sp,
                          bottom: 16.sp,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                playerController.back();
                              },
                              iconSize: 35.sp,
                              icon: const Icon(
                                Icons.skip_previous,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                playerController.smartPlay();
                              },
                              iconSize: 60.sp,
                              icon: Icon(
                                playerController.playState.value ==
                                        PlayerState.playing
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                playerController.next();
                              },
                              iconSize: 35.sp,
                              icon: const Icon(
                                Icons.skip_next,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ), */

                      // Previous, play/pause and next
                      SizedBox(
                        height: 65,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              constraints: const BoxConstraints(
                                minWidth: 40,
                                minHeight: 40,
                              ),
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                playerController.back();
                              },
                              iconSize: 28,
                              icon: const Icon(
                                Icons.skip_previous,
                                color: Colors.white,
                              ),
                            ),

                            IconButton(
                              constraints: const BoxConstraints(
                                minWidth: 50,
                                minHeight: 50,
                              ),
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                playerController.smartPlay();
                              },
                              iconSize: 42,
                              icon: Icon(
                                playerController.playState.value ==
                                        PlayerState.playing
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                              ),
                            ),

                            IconButton(
                              constraints: const BoxConstraints(
                                minWidth: 40,
                                minHeight: 40,
                              ),
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                playerController.next();
                              },
                              iconSize: 28,
                              icon: const Icon(
                                Icons.skip_next,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
