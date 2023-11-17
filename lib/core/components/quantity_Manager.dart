import 'package:customerapp/core/Constant/themData.dart';
import 'package:flutter/material.dart';

class QuantityManager extends StatelessWidget {
  final String qnty;
  final Function(String v) onChanged;
  final int minQnty;
  const QuantityManager({
    Key? key,
    required this.qnty,
    required this.onChanged,
    required this.minQnty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      width: 150,
      height: 50,
      child: Row(children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if (int.parse(qnty) > minQnty) {
                onChanged((int.parse(qnty) - 1).toString());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
            ),
            child: const Icon(Icons.remove),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: Text(
              qnty.isEmpty ? '0' : qnty,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              onChanged((int.parse(qnty) + 1).toString());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
              ),
            ),
            child: const Icon(Icons.add),
          ),
        ),
      ]),
    );
  }
}
