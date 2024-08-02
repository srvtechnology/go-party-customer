import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  int _openIndex = -1;

  void _handleExpansion(int index, bool isExpanded) {
    setState(() {
      _openIndex = isExpanded ? -1 : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ExpansionPanelList(
            expansionCallback: _handleExpansion,
            children: [
              _buildExpansionPanel(
                "What happens if I update my email address (or mobile number)?",
                "Your login email ID or mobile number changes, likewise. You will receive all your account-related communication on your updated email address (or mobile number).",
                0,
              ),
              _buildExpansionPanel(
                "When will my UtsavLife account be updated with the new email address (or mobile number)?",
                "This is the second item's accordion body. It is hidden by default, until the collapse plugin adds the appropriate classes that we use to style each element. These classes control the overall appearance, as well as the showing and hiding via CSS transitions. You can modify any of this with custom CSS or overriding our default variables. It's also worth noting that just about any HTML can go within the .accordion-body, though the transition does limit overflow.",
                1,
              ),
              _buildExpansionPanel(
                "What happens to my existing Flipkart account when I update my email address (or phone number)?",
                "Updating your email address (or mobile number) doesn't invalidate your account. Your account remains fully functional. You'll continue seeing your Order history, saved information, and personal details.",
                2,
              ),
              _buildExpansionPanel(
                "Does my Agent account get updated when I update my email address?",
                "Utsavlife has a 'single sign-on' policy. Any changes will reflect in your Agent account also.",
                3,
              ),
            ],
          ),
        ],
      ),
    );
  }

  ExpansionPanel _buildExpansionPanel(
      String question, String answer, int index) {
    return ExpansionPanel(
      headerBuilder: (context, isExpanded) {
        return ListTile(
          title: Text(
            question,
            style: const TextStyle(fontSize: 18.0),
          ),
        );
      },
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          answer,
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
      isExpanded: _openIndex == index,
      canTapOnHeader: true,
    );
  }
}
