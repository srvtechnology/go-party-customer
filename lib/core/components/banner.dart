import 'dart:math';
import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class EcommerceBanner extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;

  const EcommerceBanner({super.key, required this.imageUrl, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, // Adjust the height as per your requirement
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl,),
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
                style:const TextStyle(
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
  const ImageSlider({Key? key,required this.imageUrls}) : super(key: key);

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _currentCarouselIndex = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Stack(
        children: [
          CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
                onPageChanged: (index,kwargs){
                  setState(() {
                    _currentCarouselIndex = index;
                  });
                },
                enableInfiniteScroll: widget.imageUrls.length<2?false:true,
                autoPlay:widget.imageUrls.length<2?false:true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration:const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeFactor: 0,
                viewportFraction: 1
            ),
            items: widget.imageUrls.getRange(0, min(3, widget.imageUrls.length)).map((e) => Container(
              width: double.infinity,
              child: Image.network(e,fit: BoxFit.fitWidth,),
            )).toList(),
          ),
          if(widget.imageUrls.length>1)
            Positioned.fill(
              top: 180,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:widget.imageUrls.mapIndexed((e,s) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),

                    height: 8,width: 8,decoration: BoxDecoration(
                      border: Border.all(color: Colors.white,width: 0.5),
                      shape: BoxShape.circle,color:_currentCarouselIndex==e?Colors.white:Colors.transparent),
                  )).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
