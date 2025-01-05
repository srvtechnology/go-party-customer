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
            child: widget.imageUrls.isEmpty
                ? const SizedBox()
                : Padding(
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
                autoPlay: true,
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    widget.controller.playVideo();
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