import 'package:flutter/material.dart';

class DashedDivider extends StatelessWidget {
  const DashedDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: List.generate(1500~/10, (index) => Expanded(
            child: Container(
              color: index%2==0?Colors.transparent
                  :Colors.grey,
              height: 2,
              width: 1,
            ),
          )),
        ),
      );
    }
}
