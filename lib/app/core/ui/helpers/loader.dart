import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

mixin Loader<T extends StatefulWidget> on State<T> {
  var isOpen = false;
   showLoader() {
    if (!isOpen) {
      isOpen = true;
      showDialog(
          context: context,
          builder: (context) => LoadingAnimationWidget.threeArchedCircle(
              color:  const Color(0xFFEDFFDE), size: 60));
    }
  }

   hideLoader() {
    if (isOpen) {
      isOpen = false;
      Navigator.of(context).pop();
    }
  }
}
