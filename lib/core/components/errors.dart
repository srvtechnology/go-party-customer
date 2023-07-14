import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  Color backgroundColor;
  IconData icon;
  String message;
  CustomErrorWidget({Key? key,required this.backgroundColor,required this.icon,required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        color: backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,size: 150,),
            Text(message,style: Theme.of(context).textTheme.titleLarge,textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }
}
