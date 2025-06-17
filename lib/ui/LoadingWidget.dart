import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget{
  const LoadingWidget({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.dotsTriangle(
      color: Colors.blueAccent,
      size: 100,
    );
  }
}
