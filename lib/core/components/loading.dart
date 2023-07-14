import 'dart:async';

import 'package:card_loading/card_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/AuthProvider.dart';
import '../routes/mainpage.dart';

class LoadingWidget extends StatefulWidget {
  bool willRedirect;
  LoadingWidget({Key? key,this.willRedirect=false}) : super(key: key);

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  Timer? t;
  @override
  void initState() {
    super.initState();
    if(widget.willRedirect){
      t = Timer(const Duration(seconds: 10), () {
        Provider.of<AuthProvider>(context,listen: false).logout();
        Navigator.pushReplacementNamed(context, MainPageRoute.routeName);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child:const CircularProgressIndicator(),
    );
  }
  @override
  void dispose() {
    super.dispose();
    t?.cancel();
  }
}

class ShimmerWidget extends StatefulWidget {
  const ShimmerWidget({Key? key}) : super(key: key);

  @override
  State<ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 40),
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        physics:const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _singleCard(),
            _singleCard(),
            _singleCard(),
            _singleCard(),
          ],
        ),
      ),
    );
  }
  Widget _singleCard(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CardLoading(
          height: 30,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          width: 100,
          margin: EdgeInsets.only(bottom: 10),
        ),
        CardLoading(
          height: 100,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          margin: EdgeInsets.only(bottom: 10),
        ),
        CardLoading(
          height: 30,
          width: 200,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          margin: EdgeInsets.only(bottom: 10),
        ),
      ],
    );
  }
}
