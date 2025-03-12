import 'package:customerapp/core/constant/themData.dart';
import 'package:html/parser.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

String? priceFormatter(String price) {
  if (price == "null" || price.isEmpty) {
    return "";
  }

  if (price.endsWith('.00')) {
    price = price.substring(0, price.length - 3);
  }

  if (price.length <= 3) {
    return "₹$price";
  } else if (price.length <= 6) {
    return '₹${price.substring(0, price.length - 3)},${price.substring(price.length - 3)}';
  } else if (price.length <= 9) {
    return '₹${price.substring(0, price.length - 6)},${price.substring(price.length - 6, price.length - 3)},${price.substring(price.length - 3)}';
  } else {
    return '₹${price.substring(0, price.length - 9)},${price.substring(price.length - 9, price.length - 6)},${price.substring(price.length - 6, price.length - 3)},${price.substring(price.length - 3)}';
  }
}

String parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body!.text).documentElement!.text;
  return parsedString;
}

class HtmlTextWidget extends StatefulWidget {
  final String htmlString;
  final int maxWords;
  final bool enableShowMore;
  final String showMoreText;
  final String showLessText;
  final TextStyle? showMoreStyle;
  final double fontSize;
  final double height;
  final Color textColor;

  const HtmlTextWidget({
    Key? key,
    required this.htmlString,
    this.maxWords = 100,
    this.enableShowMore = true,
    this.showMoreText = "Show More",
    this.showLessText = "Show Less",
    this.showMoreStyle,
    this.fontSize = 16,
    this.height = 1.5,
    this.textColor = Colors.grey,
  }) : super(key: key);

  @override
  State<HtmlTextWidget> createState() => _HtmlTextWidgetState();
}

class _HtmlTextWidgetState extends State<HtmlTextWidget> {
  bool isExpanded = false;
  late List<TextSpan> fullTextSpans;
  late List<TextSpan> limitedTextSpans;
  late int totalWordCount;

  @override
  void initState() {
    super.initState();
    processHtmlContent();
  }

  void processHtmlContent() {
    fullTextSpans = [];
    int wordCount = 0;
    final document = parse(widget.htmlString);

    void processNode(dom.Node node) {
      if (node is dom.Text) {
        List<String> words = node.text.trim().split(' ');
        wordCount += words.length;

        fullTextSpans.add(TextSpan(
          text: '${node.text}\n',
          style: TextStyle(
            fontSize: widget.fontSize,
            height: widget.height,
            color: widget.textColor,
          ),
        ));
      } else if (node is dom.Element) {
        switch (node.localName) {
          case 'b':
          case 'strong':
            for (var child in node.nodes) {
              fullTextSpans.add(TextSpan(
                text: '${child.text}\n',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: widget.fontSize,
                  height: widget.height,
                  color: widget.textColor,
                ),
              ));
            }
            break;

          case 'i':
          case 'em':
            for (var child in node.nodes) {
              fullTextSpans.add(TextSpan(
                text: child.text,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: widget.fontSize,
                  height: widget.height,
                  color: widget.textColor,
                ),
              ));
            }
            break;

          case 'br':
            fullTextSpans.add(const TextSpan(text: '\n'));
            break;

          case 'p':
            node.nodes.forEach(processNode);
            fullTextSpans.add(const TextSpan(text: '\n\n'));
            break;

          default:
            node.nodes.forEach(processNode);
        }
      }
    }

    document.body!.nodes.forEach(processNode);
    totalWordCount = wordCount;

    limitedTextSpans = [];
    int currentWords = 0;

    for (var span in fullTextSpans) {
      if (currentWords >= widget.maxWords) break;

      final words = span.text?.split(' ') ?? [];
      if (currentWords + words.length <= widget.maxWords) {
        limitedTextSpans.add(span);
        currentWords += words.length;
      } else {
        final remainingWords = widget.maxWords - currentWords;
        final truncatedText = words.take(remainingWords).join(' ');
        limitedTextSpans.add(TextSpan(
          text: '$truncatedText...',
          style: span.style,
        ));
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: isExpanded ? fullTextSpans : limitedTextSpans,
            style: TextStyle(
              fontSize: widget.fontSize,
              height: widget.height,
              color: widget.textColor,
            ),
          ),
        ),
        if (widget.enableShowMore && totalWordCount > widget.maxWords)
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Text(
                isExpanded ? widget.showLessText : widget.showMoreText,
                style: widget.showMoreStyle ??
                    Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontSize: 14, color: primaryColor),
              ),
            ),
          ),
      ],
    );
  }
}

Widget parseHtmlStringToRichText(
  String htmlString, {
  int maxWords = 100,
  bool enableShowMore = true,
  String showMoreText = "Show More",
  String showLessText = "Show Less",
  TextStyle? showMoreStyle,
  double fontSize = 16,
  double height = 1.5,
  Color textColor = Colors.black,
}) {
  return HtmlTextWidget(
    htmlString: htmlString,
    maxWords: maxWords,
    enableShowMore: enableShowMore,
    showMoreText: showMoreText,
    showLessText: showLessText,
    showMoreStyle: showMoreStyle,
    fontSize: fontSize,
    height: height,
    textColor: textColor,
  );
}
