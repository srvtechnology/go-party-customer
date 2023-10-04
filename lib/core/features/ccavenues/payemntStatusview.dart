import 'package:customerapp/core/features/ccavenues/models/payment_res.dart';
import 'package:customerapp/core/routes/mainpage.dart';
import 'package:flutter/material.dart';

class PaymentStatusView extends StatelessWidget {
  final PaymentRes? paymentRes;
  const PaymentStatusView({
    Key? key,
    required this.paymentRes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainPageRoute()),
              (route) => route.isFirst);
        }
        return Future.value(false);
      },
      child: Scaffold(
          appBar: AppBar(
              title: const Text("Order Status"),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainPageRoute()),
                        (route) => route.isFirst);
                  }
                },
              )),
          body: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: (paymentRes?.code ?? 400) == 200 ||
                      (paymentRes?.code ?? 400) == 202
                  ? _buildPaymentStatus(context, true)
                  : _buildPaymentStatus(context, false))),
    );
  }

  Widget _buildPaymentStatus(BuildContext context, bool isPaymentSuccess) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        isPaymentSuccess
            ? const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              )
            : const Icon(
                Icons.cancel,
                color: Colors.red,
                size: 100,
              ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: MediaQuery.of(context).size.width,
          child: Text(
            isPaymentSuccess ? "Payment Successful" : "Payment Failed",
            style: TextStyle(
                fontSize: 20,
                color: isPaymentSuccess ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: MediaQuery.of(context).size.width,
          child: Text(
            paymentRes?.type?.statusMessage ?? "",
            style: const TextStyle(
                fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        const Divider(),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Order ID: ${paymentRes?.type?.orderId ?? ""}",
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "Tracking ID: ${paymentRes?.type?.trackingId ?? ""}",
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          "Payment Mode: ${paymentRes?.type?.paymentMode ?? ""}",
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
