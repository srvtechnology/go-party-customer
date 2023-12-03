import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/providers/orderProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:provider/provider.dart';

class RatingView extends StatelessWidget {
  final double? rating;
  final String? orderID;
  const RatingView({
    Key? key,
    this.rating,
    this.orderID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController feedbackController = TextEditingController();
    return ListenableProvider(
      create: (_) => OrderProvider(context.read<AuthProvider>()),
      child: Consumer<OrderProvider>(builder: (context, state, child) {
        state.rating = rating ?? 1;
        return Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              top: 10,
              left: 10,
              right: 10),
          // height: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Rate your experience',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              PannableRatingBar(
                rate: state.rating,
                items: List.generate(
                    5,
                    (index) => const RatingWidget(
                          selectedColor: Colors.yellow,
                          unSelectedColor: Colors.grey,
                          child: Icon(
                            Icons.star,
                            size: 36,
                          ),
                        )),
                onChanged: (value) {
                  // the rating value is updated on tap or drag.
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'Tap or drag to rate',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // feedback text area
              const SizedBox(height: 20),
              TextField(
                maxLines: 5,
                controller: feedbackController,
                decoration: const InputDecoration(
                  hintText: 'Write your feedback here',
                  border: OutlineInputBorder(),
                ),
              ),
              // submit button
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    state.rateOrder(
                      context.read<AuthProvider>(),
                      orderId: orderID!,
                      rate: state.rating,
                      feedback: feedbackController.text,
                    );
                    Navigator.pop(context);
                    // show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Thank you for your feedback'),
                      ),
                    );
                  },
                  child: state.isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
