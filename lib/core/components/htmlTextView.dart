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
  }
}
