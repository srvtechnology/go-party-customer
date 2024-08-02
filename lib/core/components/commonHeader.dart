import '../constant/themData.dart';
import 'package:flutter/material.dart';

class CommonHeader {
  static PreferredSize header(
    BuildContext context, {
    VoidCallback? onBack,
    VoidCallback? onSearch,
  }) {
    return PreferredSize(
      preferredSize: Size(MediaQuery.of(context).size.width, 60),
      child: Material(
        elevation: 0.8,
        child: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          color: primaryColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_ios),
                color: Colors.white,
              ),
              Expanded(
                  child: Container(
                // margin: const EdgeInsets.only(right: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    onSearch!();
                  },
                  child: TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Search ...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  static PreferredSize headerMain(
    BuildContext context, {
    VoidCallback? onSearch,
    isShowLogo = true,
    double elevation = 0.8,
  }) {
    return PreferredSize(
      preferredSize: Size(MediaQuery.of(context).size.width, 60),
      child: Material(
        elevation: elevation,
        child: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          color: primaryColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isShowLogo)
                Image.asset("assets/images/logo/logo-white.png", width: 140),
              Expanded(
                  child: Container(
                // margin: const EdgeInsets.only(right: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    onSearch!();
                  },
                  child: TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Search ...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
