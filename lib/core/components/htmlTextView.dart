import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:html/dom.dart' as dom;

class HtmlTextView extends StatelessWidget {
  final String htmlText;
  const HtmlTextView({
    Key? key,
    required this.htmlText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: HtmlWidget(
      htmlText,
    ));
    // SingleChildScrollView(
    //   child: Html(
    //     padding: EdgeInsets.zero,
    //     blockSpacing: 2,
    //     data: htmlText,
    //     shrinkToFit: true,

    //     // padding: const EdgeInsets.all(8.0),
    //     onLinkTap: (url) {
    //       print("Opening $url...");
    //     },
    //     // customRender: (node, children) {
    //     //   if (node is dom.Element) {
    //     //     log(node.localName.toString());
    //     //     switch (node.localName) {
    //     //       case "<p>": // using this, you can handle custom tags in your HTML
    //     //         return FittedBox(
    //     //             child: Text(
    //     //           node.text,
    //     //           overflow: TextOverflow.visible,
    //     //           textAlign: TextAlign.left,
    //     //           style: const TextStyle(fontSize: 14, color: textColor),
    //     //         ));
    //     //     }
    //     //   }
    //     //   return null;
    //     // },
    //   ),
    // );
  }
}
