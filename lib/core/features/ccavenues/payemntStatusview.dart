import 'package:customerapp/core/features/ccavenues/models/payment_res.dart';
import 'package:customerapp/core/routes/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/payment_status_provider.dart';

class PaymentStatusView extends StatefulWidget {
  final PaymentRes? paymentRes;

  const PaymentStatusView({
    Key? key,
    required this.paymentRes,
  }) : super(key: key);

  @override
  State<PaymentStatusView> createState() => _PaymentStatusViewState();
}

class _PaymentStatusViewState extends State<PaymentStatusView> {
  @override
  void initState() {
    super.initState();
    // 2 seconds delay and automatically navigate to main page
    Future.delayed(const Duration(seconds: 5), () {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainPageRoute()),
            (route) => route.isFirst);
      }
    });
  }

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
              child: (widget.paymentRes?.code ?? 400) == 200 ||
                      (widget.paymentRes?.code ?? 400) == 202
                  ? _buildPaymentStatus(context, true,widget.paymentRes?.type?.billingAddress,
                  widget.paymentRes?.type?.billingName!)
                  : _buildPaymentStatus(context, false,widget.paymentRes?.type?.billingAddress,
                  widget.paymentRes?.type?.billingName!))),
    );
  }

  Widget _buildPaymentStatus(BuildContext context, bool isPaymentSuccess,String? address,String? shippingto) {
    if(isPaymentSuccess){
      Provider.of<PaymentStatusProvider>(context, listen: false).isPaid=true;
      Provider.of<PaymentStatusProvider>(context, listen: false).address=address!;
      Provider.of<PaymentStatusProvider>(context, listen: false).shippingto=shippingto!;
    }else{
      Provider.of<PaymentStatusProvider>(context, listen: false).isPaid=false;
      Provider.of<PaymentStatusProvider>(context, listen: false).address=address!;
      Provider.of<PaymentStatusProvider>(context, listen: false).shippingto=shippingto!;
    }

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
            widget.paymentRes?.message ?? "",
            style: const TextStyle(
                fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        const Divider(),
      ],
    );
  }
}
