import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
/* import 'package:youtube_player_flutter/youtube_player_flutter.dart'; */
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

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
                  /* .getRange(0, min(3, widget.imageUrls.length)) */
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
  final List<String> videoUrls;

  const PackageImageSlider({
    Key? key,
    required this.imageUrls,
    required this.videoUrls,
  }) : super(key: key);

  @override
  State<PackageImageSlider> createState() => _PackageImageSliderState();
}

class _PackageImageSliderState extends State<PackageImageSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> carouselItems = [];

    // Add image items
    carouselItems.addAll(widget.imageUrls.map(
      (url) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.cover,
          ),
        ),
      ),
    ));

    // Add video thumbnails with a play button
    carouselItems.addAll(widget.videoUrls.map((url) {
      final videoId = extractVideoId(url);

      if (videoId.isEmpty) {
        // Skip adding this item if the video ID is invalid
        return Container(); // Return an empty container or a placeholder widget
      }

      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  YoutubePlayerController.getThumbnail(videoId: videoId),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.play_circle_fill),
            iconSize: 64.0,
            color: Colors.red, // YouTube red play button color
            onPressed: () {
              final controller = YoutubePlayerController.fromVideoId(
                videoId: videoId,
                autoPlay: false,
                params: const YoutubePlayerParams(
                  showControls: true,
                  showFullscreenButton: false,
                ),
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerPage(controller: controller),
                ),
              );
            },
          ),
        ],
      );
    }).toList());

    return Column(
      children: [
        SizedBox(
          height: 260.0,
          width: MediaQuery.of(context).size.width,
          child: PageView.builder(
            itemCount: carouselItems.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return carouselItems[index];
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            carouselItems.length,
            (index) => Container(
              width: 8.0,
              height: 8.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String extractVideoId(String url) {
    try {
      final Uri uri = Uri.parse(url);

      // Check if the URL contains a valid video ID parameter
      final String? videoId = uri.queryParameters['v'];
      if (videoId != null && videoId.isNotEmpty) {
        return videoId;
      }

      // Use regular expression to extract video ID from URL path
      final RegExp regExp = RegExp(r'v=([^&]+)');
      final Match? match = regExp.firstMatch(uri.toString());
      if (match != null && match.groupCount > 0) {
        return match.group(1) ?? '';
      }

      // Return empty string if video ID is not found
      return '';
    } catch (e) {
      // Log the error or handle it appropriately
      if (kDebugMode) {
        print('Error extracting video ID: $e');
      }
      return ''; // Return empty string if any exception occurs
    }
  }
}

class VideoPlayerPage extends StatefulWidget {
  final YoutubePlayerController controller;

  const VideoPlayerPage({Key? key, required this.controller}) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  @override
  void initState() {
    super.initState();
    // Ensure the video is paused when the page is initialized
    widget.controller.pauseVideo();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    // Dispose of the controller when the page is disposed
    widget.controller.close();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  void _exitVideoPlayer() {
    // Reset the orientation to portrait before exiting
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]).then((_) {
      Navigator.pop(context); // Navigate back to the previous page
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.black, // Status bar color
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: WillPopScope(
          onWillPop: () async {
            return false; // Prevent back press
          },
          child: Stack(
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: YoutubePlayer(
                    controller: widget.controller,
                  ),
                ),
              ),
              Positioned(
                top: 30,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  color: Colors.white,
                  onPressed: _exitVideoPlayer, // Exit the video player
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






/* --- Youtube iFrame Player & Carousel Image Slider without dots : Working --- */
/* class PackageImageSlider extends StatefulWidget {
  final List<String> imageUrls;
  final List<String> videoUrls;

  const PackageImageSlider({
    Key? key,
    required this.imageUrls,
    required this.videoUrls,
  }) : super(key: key);

  @override
  State<PackageImageSlider> createState() => _PackageImageSliderState();
}

class _PackageImageSliderState extends State<PackageImageSlider> {
  final CarouselController _carouselController = CarouselController();
  YoutubePlayerController? _currentVideoController;

  @override
  Widget build(BuildContext context) {
    List<Widget> carouselItems = [];

    // Add image items
    carouselItems.addAll(widget.imageUrls.map((url) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(url),
              fit: BoxFit.cover,
            ),
          ),
        )));

    // Add valid video items
    final validVideoUrls = widget.videoUrls.where((url) {
      try {
        final videoId = extractVideoId(url);
        return videoId.isNotEmpty; // Ensure the videoId is not empty
      } catch (e) {
        return false; // Invalid URL
      }
    }).toList();

    carouselItems.addAll(validVideoUrls.map((url) {
      final videoId = extractVideoId(url);

      final controller = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        autoPlay: false,
        params: const YoutubePlayerParams(
          showControls: true, // Show default controls including play/pause
          showFullscreenButton: true,
        ),
      );

      return ClipRect(
        child: SizedBox(
          width: double.infinity, // Ensure it covers the full width
          child: FittedBox(
            fit: BoxFit.cover, // Make the video cover the entire slider
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 9 / 16,
              child: YoutubePlayer(
                controller: controller,
                aspectRatio:
                    16 / 9, // Aspect ratio to keep the video proportional
              ),
            ),
          ),
        ),
      );
    }).toList());

    return Container(
      color: Colors.amberAccent,
      height: 26.h,
      width: MediaQuery.of(context).size.width,
      child: CarouselSlider(
        carouselController: _carouselController,
        options: CarouselOptions(
          onPageChanged: (index, _) {
            setState(() {});
            _handleVideoFocus(index);
          },
          enableInfiniteScroll:
              widget.imageUrls.length + validVideoUrls.length < 2
                  ? false
                  : true,
          autoPlay: false,
          enlargeFactor: 0,
          viewportFraction: 1.0, // Make sure the slider covers the entire width
        ),
        items: carouselItems,
      ),
    );
  }

  void _handleVideoFocus(int index) {
    // Pause the current video if the slide changes
    if (_currentVideoController != null) {
      _currentVideoController!.pauseVideo();
    }

    if (index >= widget.imageUrls.length) {
      // This is a video slide
      int videoIndex = index - widget.imageUrls.length;
      final videoId = extractVideoId(widget.videoUrls[videoIndex]);

      setState(() {
        _currentVideoController = YoutubePlayerController.fromVideoId(
          videoId: videoId,
          autoPlay: false,
          params: const YoutubePlayerParams(
            showControls: true, // Use default controls
            showFullscreenButton: true,
          ),
        );
      });
    }
  }
}

String extractVideoId(String url) {
  final Uri uri = Uri.parse(url);
  final String? videoId = uri.queryParameters['v'];
  if (videoId != null) {
    return videoId;
  } else {
    // Handle other URL formats or invalid URLs
    final RegExp regExp = RegExp(r'v=([^&]+)');
    final Match? match = regExp.firstMatch(url);
    if (match != null && match.groupCount > 0) {
      return match.group(1) ?? '';
    } else {
      throw ArgumentError('Invalid YouTube URL');
    }
  }
} */

/* --- Only Image Slider --- */
/* 
class PackageImageSlider extends StatefulWidget {
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

/* --- Video player from assets --- : Without Gesture does not work */
/* 
class PackageImageSlider extends StatefulWidget {
  final List<String> imageUrls;

  const PackageImageSlider({Key? key, required this.imageUrls})
      : super(key: key);

  @override
  State<PackageImageSlider> createState() => _PackageImageSliderState();
}

class _PackageImageSliderState extends State<PackageImageSlider> {
  int _currentCarouselIndex = 0;
  final CarouselController _carouselController = CarouselController();
  late VideoPlayerController _videoController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.asset('assets/videos/ElephantsDream.mp4')
          ..initialize().then((_) {
            setState(() {});
          });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _videoController.pause();
      } else {
        _videoController.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    if (index == widget.imageUrls.length) {
                      if (!_isPlaying) {
                        _videoController.play();
                        _isPlaying = true;
                      }
                    } else {
                      _videoController.pause();
                      _isPlaying = false;
                    }
                  });
                },
                enableInfiniteScroll: true,
                autoPlay: false,
                enlargeFactor: 0,
                viewportFraction: 1.0,
              ),
              items: [
                ...widget.imageUrls.map((url) {
                  return Container(
                    constraints: const BoxConstraints.expand(),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(url),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
                Container(
                  color: Colors.black,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _videoController.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _videoController.value.aspectRatio,
                              child: VideoPlayer(_videoController),
                            )
                          : const CircularProgressIndicator(),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: _togglePlayPause,
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                count: widget.imageUrls.length + 1,
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
*/

/* --- Video player from assets --- : With Gesture which does not work */
/* 
class PackageImageSlider extends StatefulWidget {
  final List<String> imageUrls;

  const PackageImageSlider({Key? key, required this.imageUrls})
      : super(key: key);

  @override
  State<PackageImageSlider> createState() => _PackageImageSliderState();
}

class _PackageImageSliderState extends State<PackageImageSlider> {
  int _currentCarouselIndex = 0;
  final CarouselController _carouselController = CarouselController();
  late VideoPlayerController _videoController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.asset('assets/videos/ElephantsDream.mp4')
          ..initialize().then((_) {
            setState(() {});
          });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _videoController.pause();
      } else {
        _videoController.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    if (index == widget.imageUrls.length) {
                      if (!_isPlaying) {
                        _videoController.play();
                        _isPlaying = true;
                      }
                    } else {
                      _videoController.pause();
                      _isPlaying = false;
                    }
                  });
                },
                enableInfiniteScroll: true,
                autoPlay: false,
                enlargeFactor: 0,
                viewportFraction: 1.0,
              ),
              items: [
                ...widget.imageUrls.map((url) {
                  return Container(
                    constraints: const BoxConstraints.expand(),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(url),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
                Container(
                  color: Colors.black,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _videoController.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _videoController.value.aspectRatio,
                              child: VideoPlayer(_videoController),
                            )
                          : const CircularProgressIndicator(),
                      Positioned.fill(
                        child: Container(
                          color: Colors.transparent, // To debug overlay issues
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            if (kDebugMode) {
                              print('==> Play/Pause icon tapped');
                            }
                            _togglePlayPause();
                          },
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
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
                count: widget.imageUrls.length + 1,
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
*/

/* --- With iFrame Youtube Player & Image Slider : Shows Thumbnail but can't play --- */

/* 
class PackageImageSlider extends StatefulWidget {
  final List<String> imageUrls;
  final List<String> videoUrls;

  const PackageImageSlider({
    Key? key,
    required this.imageUrls,
    required this.videoUrls,
  }) : super(key: key);

  @override
  State<PackageImageSlider> createState() => _PackageImageSliderState();
}

class _PackageImageSliderState extends State<PackageImageSlider> {
  int _currentCarouselIndex = 0;
  final CarouselController _carouselController = CarouselController();
  YoutubePlayerController? _currentVideoController;

  @override
  Widget build(BuildContext context) {
    List<Widget> carouselItems = [];

    // Add image items
    carouselItems.addAll(widget.imageUrls.map((url) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(url),
              fit: BoxFit.cover,
            ),
          ),
        )));

    // Add valid video items
    final validVideoUrls = widget.videoUrls.where((url) {
      try {
        final videoId = extractVideoId(url);
        return videoId.isNotEmpty; // Ensure the videoId is not empty
      } catch (e) {
        return false; // Invalid URL
      }
    }).toList();

    carouselItems.addAll(validVideoUrls.map((url) {
      final videoId = extractVideoId(url);

      final controller = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        autoPlay: false,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
        ),
      );

      return Stack(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: YoutubePlayer(
                controller: controller,
                aspectRatio: 16 / 9,
              ),
            ),
          ),
          Center(
            child: YoutubeValueBuilder(
              controller: controller,
              builder: (context, value) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    iconSize: 48.0,
                    icon: Icon(
                      value.playerState == PlayerState.playing
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (value.playerState == PlayerState.playing) {
                        controller.pauseVideo();
                      } else {
                        controller.playVideo();
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      );
    }).toList());

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
                onPageChanged: (index, _) {
                  setState(() {
                    _currentCarouselIndex = index;
                  });
                  _handleVideoFocus(index);
                },
                enableInfiniteScroll:
                    widget.imageUrls.length + validVideoUrls.length < 2
                        ? false
                        : true,
                autoPlay: false,
                enlargeFactor: 0,
                viewportFraction: 0.9999,
              ),
              items: carouselItems,
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
                count: widget.imageUrls.length + validVideoUrls.length,
                effect: const ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  dotColor: Colors.white,
                  activeDotColor: Colors.white,
                  expansionFactor: 2,
                  spacing: 4,
                ),
                activeIndex: _currentCarouselIndex,
                onDotClicked: (index) {
                  setState(() {
                    _currentCarouselIndex = index;
                  });
                  _carouselController.animateToPage(index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleVideoFocus(int index) {
    // Pause the current video if the slide changes
    if (_currentVideoController != null) {
      _currentVideoController!.pauseVideo();
    }

    if (index >= widget.imageUrls.length) {
      // This is a video slide
      int videoIndex = index - widget.imageUrls.length;
      final videoId = extractVideoId(widget.videoUrls[videoIndex]);

      setState(() {
        _currentVideoController = YoutubePlayerController.fromVideoId(
          videoId: videoId,
          autoPlay: false,
          params: const YoutubePlayerParams(
            showControls: false,
            showFullscreenButton: true,
          ),
        );
      });
    }
  }
}

String extractVideoId(String url) {
  final Uri uri = Uri.parse(url);
  final String? videoId = uri.queryParameters['v'];
  if (videoId != null) {
    return videoId;
  } else {
    // Handle other URL formats or invalid URLs
    final RegExp regExp = RegExp(r'v=([^&]+)');
    final Match? match = regExp.firstMatch(url);
    if (match != null && match.groupCount > 0) {
      return match.group(1) ?? '';
    } else {
      throw ArgumentError('Invalid YouTube URL');
    }
  }
} 
 */

/* --- With Youtube Player & Image Slider : Not Working --- */

/* 
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
  late YoutubePlayerController _youtubeController;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    if (widget.videoUrls != null && widget.videoUrls!.isNotEmpty) {
      _initializeYouTubePlayer(widget.videoUrls!.first);
    }
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  void _initializeYouTubePlayer(String videoUrl) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    if (videoId != null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      )..addListener(_listener);
    } else {
      if (kDebugMode) {
        print('==> Invalid YouTube URL: $videoUrl');
      }
    }
  }

  void _listener() {
    if (_youtubeController.value.isReady && mounted && !_isPlayerReady) {
      setState(() {
        _isPlayerReady = true;
      });
    }
    if (_youtubeController.value.hasError) {
      if (kDebugMode) {
        print(
            '==> YouTube player error: ${_youtubeController.value.errorCode}');
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
                    if (index == widget.imageUrls.length && _isPlayerReady) {
                      _youtubeController.play();
                      if (kDebugMode) {
                        print('==> Playing video at index: $index');
                      }
                    } else if (_isPlayerReady) {
                      _youtubeController.pause();
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
                    child: _isPlayerReady
                        ? YoutubePlayer(
                            controller: _youtubeController,
                            showVideoProgressIndicator: true,
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
 */



/* 
 @override
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
  }
   */



