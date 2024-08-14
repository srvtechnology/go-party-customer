import 'dart:math';
import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../constant/themData.dart';

class EcommerceBanner extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;

  const EcommerceBanner(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, // Adjust the height as per your requirement
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            imageUrl,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black.withOpacity(0.2),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ImageSlider extends StatefulWidget {
  final List<String> imageUrls;
  const ImageSlider({Key? key, required this.imageUrls}) : super(key: key);

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _currentCarouselIndex = 0;
  final CarouselController _carouselController = CarouselController();
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5, right: 0, left: 10),
      // padding: EdgeInsets.symmetric(vertical: 2.h),
      height: 20.h,
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   border: Border.all(width: 0.15, color: Colors.grey),
      //   borderRadius: BorderRadius.circular(10),
      // ),
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          SizedBox(
            height: 21.h,
            width: MediaQuery.of(context).size.width,
            child: CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                  onPageChanged: (index, kwargs) {
                    setState(() {
                      _currentCarouselIndex = index;
                    });
                  },
                  enableInfiniteScroll: false,
                  // enableInfiniteScroll:
                  //     widget.imageUrls.length < 2 ? false : true,
                  autoPlay: widget.imageUrls.length < 2 ? false : true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeFactor: 0,
                  viewportFraction: 1.0),
              items: widget.imageUrls
                  .getRange(0, min(3, widget.imageUrls.length))
                  .map((e) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(e),
                            fit: BoxFit.cover,
                          ),
                        ),
                        margin: EdgeInsets.only(right: 2.w),
                      ))
                  .toList(),
            ),
          ),
          if (widget.imageUrls.length > 1)
            Positioned.fill(
              top: 180,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.imageUrls
                      .mapIndexed((e, s) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 0.5),
                                shape: BoxShape.circle,
                                color: _currentCarouselIndex == e
                                    ? Colors.white
                                    : Colors.transparent),
                          ))
                      .toList(),
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AnimatedSmoothIndicator(
                count: widget.imageUrls.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  dotColor: Colors.white.withOpacity(0.9),
                  activeDotColor: primaryColor,
                  expansionFactor: 2,
                  spacing: 4,
                ),
                onDotClicked: (index) {},
                activeIndex: _currentCarouselIndex,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PackageImageSlider extends StatefulWidget {
  final List<String> imageUrls;
  final List<String>? videoUrls;

  const PackageImageSlider({
    Key? key,
    required this.imageUrls,
    this.videoUrls,
  }) : super(key: key);

  @override
  State<PackageImageSlider> createState() => _PackageImageSlideState();
}

class _PackageImageSlideState extends State<PackageImageSlider> {
  int _currentCarouselIndex = 0;
  final CarouselController _carouselController = CarouselController();
  YoutubePlayerController? _youtubeController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.videoUrls != null && widget.videoUrls!.isNotEmpty) {
      _initializeYouTubePlayer(widget.videoUrls!.first);
    }
  }

  /* @override
  void didUpdateWidget(covariant PackageImageSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoUrls != oldWidget.videoUrls &&
        widget.videoUrls != null &&
        widget.videoUrls!.isNotEmpty) {
      final newVideoUrl = widget.videoUrls!.first;
      if (_youtubeController == null ||
          YoutubePlayer.convertUrlToId(newVideoUrl) !=
              _youtubeController!.initialVideoId) {
        _initializeYouTubePlayer(newVideoUrl);
      }
    }
  } */

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  void _initializeYouTubePlayer(String videoUrl) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    if (videoId != null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      )..addListener(() {
          if (_youtubeController!.value.isReady && !_isVideoInitialized) {
            setState(() {
              _isVideoInitialized = true;
              if (kDebugMode) {
                print('==> YouTube player error initialized');
              }
            });
          }
          if (_youtubeController!.value.hasError) {
            if (kDebugMode) {
              print(
                  '==> YouTube player error: ${_youtubeController!.value.errorCode}');
            }
          }
        });
    } else {
      if (kDebugMode) {
        print('==> Invalid YouTube URL: $videoUrl');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasVideo = widget.videoUrls != null && widget.videoUrls!.isNotEmpty;
    final totalItems = widget.imageUrls.length + (hasVideo ? 1 : 0);

    return Container(
      color: Colors.amberAccent,
      height: 26.h,
      child: Stack(
        children: [
          SizedBox(
            height: 26.h,
            width: MediaQuery.of(context).size.width,
            child: CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentCarouselIndex = index;
                    if (index == widget.imageUrls.length &&
                        _isVideoInitialized) {
                      _youtubeController!.play();
                      if (kDebugMode) {
                        print('==> Playing video at index: $index');
                      }
                    } else if (_isVideoInitialized) {
                      _youtubeController!.pause();
                      if (kDebugMode) {
                        print('==> Pausing video at index: $index');
                      }
                    }
                  });
                },
                enableInfiniteScroll: totalItems > 1,
                autoPlay: false,
                enlargeFactor: 0,
                viewportFraction: 0.9999,
                scrollPhysics: const BouncingScrollPhysics(), // Enable swiping
              ),
              items: [
                ...widget.imageUrls.map((e) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(e),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
                if (hasVideo)
                  SizedBox(
                    height: 26.h,
                    child: _isVideoInitialized
                        ? YoutubePlayer(
                            controller: _youtubeController!,
                            showVideoProgressIndicator: true,
                            onReady: () {
                              _youtubeController!.addListener(() {
                                if (_youtubeController!.value.isReady &&
                                    !_isVideoInitialized) {
                                  setState(() {
                                    _isVideoInitialized = true;
                                  });
                                }
                              });
                            },
                          )
                        : const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
          Container(
            height: 26.h,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(bottom: 2.h),
              child: AnimatedSmoothIndicator(
                count: totalItems,
                effect: const ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  dotColor: Colors.white,
                  activeDotColor: Colors.white,
                  expansionFactor: 2,
                  spacing: 4,
                ),
                onDotClicked: (index) {
                  _carouselController.animateToPage(index);
                },
                activeIndex: _currentCarouselIndex,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/* class PackageImageSlider extends StatefulWidget {
  final List<String> imageUrls;
  const PackageImageSlider({Key? key, required this.imageUrls})
      : super(key: key);

  @override
  State<PackageImageSlider> createState() => _PackageImageSlideState();
}

class _PackageImageSlideState extends State<PackageImageSlider> {
  int _currentCarouselIndex = 0;
  final CarouselController _carouselController = CarouselController();
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amberAccent,
      // padding: EdgeInsets.symmetric(vertical: 4.h),
      height: 26.h,
      child: Stack(
        // alignment: Alignment.topLeft,
        children: [
          SizedBox(
            height: 26.h,
            width: MediaQuery.of(context).size.width,
            child: CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                  onPageChanged: (index, kwargs) {
                    setState(() {
                      _currentCarouselIndex = index;
                    });
                  },
                  enableInfiniteScroll:
                      widget.imageUrls.length < 2 ? false : true,
                  autoPlay: widget.imageUrls.length < 2 ? false : true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  // autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeFactor: 0,
                  viewportFraction: 0.9999),
              items: widget.imageUrls
                  .getRange(0, min(3, widget.imageUrls.length))
                  .map((e) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(e),
                            fit: BoxFit.cover,
                          ),
                        ),
                        // margin: EdgeInsets.only(right: 2.w),
                      ))
                  .toList(),
            ),
          ),
          Container(
            height: 26.h,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(bottom: 2.h),
              child: AnimatedSmoothIndicator(
                count: widget.imageUrls.length,
                effect: const ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  dotColor: Colors.white,
                  activeDotColor: Colors.white,
                  expansionFactor: 2,
                  spacing: 4,
                ),
                onDotClicked: (index) {},
                activeIndex: _currentCarouselIndex,
              ),
            ),
          )
        ],
      ),
    );
  }
}
 */