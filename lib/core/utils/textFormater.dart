import 'package:html/parser.dart';

// capitalize the first letter of the string
String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

String? priceFormatter(String price) {
  if (price.length <= 3) {
    return price;
  } else if (price.length <= 6) {
    return '${price.substring(0, price.length - 3)},${price.substring(price.length - 3)}';
  } else if (price.length <= 9) {
    return '${price.substring(0, price.length - 6)},${price.substring(price.length - 6, price.length - 3)},${price.substring(price.length - 3)}';
  } else {
    return '${price.substring(0, price.length - 9)},${price.substring(price.length - 9, price.length - 6)},${price.substring(price.length - 6, price.length - 3)},${price.substring(price.length - 3)}';
  }
}

//here goes the function
String parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body!.text).documentElement!.text;

  return parsedString;
}
