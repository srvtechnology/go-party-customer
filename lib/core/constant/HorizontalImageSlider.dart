import 'package:flutter/material.dart';

class HorizontalImageSlider extends StatefulWidget {
  final List<String> images; // List of image URLs

  const HorizontalImageSlider({Key? key, required this.images})
      : super(key: key);

  @override
  _HorizontalImageSliderState createState() => _HorizontalImageSliderState();
}

class _HorizontalImageSliderState extends State<HorizontalImageSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String fdurl = "https://utsavlife.com/storage/app/public/packages/featured/";

  void _onNext() {
    if (_currentPage < widget.images.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPrevious() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showFullScreenImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageView(imageUrl: imageUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // Image Slider
          SizedBox(
            height: 260, // Set height for the image container
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: widget.images.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _showFullScreenImage(widget.images[index]),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(widget.images[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // Previous Arrow
                if (_currentPage > 0)
                  Positioned(
                    left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 28),
                      color: Colors.black.withOpacity(0.6),
                      onPressed: _onPrevious,
                    ),
                  ),
                // Next Arrow
                if (_currentPage < widget.images.length - 1)
                  Positioned(
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 28),
                      color: Colors.black.withOpacity(0.6),
                      onPressed: _onNext,
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

// class FullScreenImageView extends StatelessWidget {
//   final String imageUrl;

//   const FullScreenImageView({Key? key, required this.imageUrl})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           Positioned.fill(
//             // Ensure the image fills the screen
//             child: InteractiveViewer(
//               panEnabled: true, // Allow panning
//               minScale: 1.0, // Minimum zoom scale
//               maxScale: 4.0, // Maximum zoom scale
//               child: Image.network(
//                 imageUrl,
//                 fit: BoxFit.cover, // Fill the screen
//               ),
//             ),
//           ),
//           Positioned(
//             top: 30,
//             right: 16,
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: const CircleAvatar(
//                 backgroundColor: Colors.black54,
//                 child: Icon(
//                   Icons.close,
//                   color: Colors.white,
//                   size: 24, // Adjust size if necessary
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class FullScreenImageView extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageView({Key? key, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            // Center the image
            child: InteractiveViewer(
              panEnabled: true,
              boundaryMargin:
                  const EdgeInsets.all(20), // Add margin around the image
              minScale: 0.5, // Allow zooming out slightly
              maxScale: 4.0,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain, // Changed from cover to contain
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const CircleAvatar(
                backgroundColor: Colors.black54,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
