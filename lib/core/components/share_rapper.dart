import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareRapper extends StatelessWidget {
  final Widget child;
  final String? title;
  final String? url;
  const ShareRapper({
    Key? key,
    required this.child,
    this.title,
    this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
            top: 10,
            right: 20,
            child: InkWell(
              onTap: () {
                if (url != null) {
                  Share.share(url!, subject: title);
                }
              },
              borderRadius: BorderRadius.circular(30),
              child: Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.share,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            )),
      ],
    );
  }
}
