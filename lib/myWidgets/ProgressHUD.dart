import 'package:flutter/material.dart';
import 'package:illustrashirt/constants.dart';

class ProgressHUD extends StatelessWidget {

  final Widget child;
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  final Animation<Color> valueColor;
  final double withh;
  final double heightt;

  ProgressHUD({
    this.withh,
    this.heightt,
    @required this.child,
    @required this.inAsyncCall,
    this.opacity = 0.3,
    this.color = Colors.grey,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = new List<Widget>();
    widgetList.add(child);
    if (inAsyncCall) {
      final modal = new Stack(
        alignment: AlignmentDirectional.center,
        children: [
          new Opacity(
            opacity: opacity,
            child: Container(
                width: withh,
                height: heightt,
                child: ModalBarrier(dismissible: false, color: color)),
          ),
          new Center(
              child: new CircularProgressIndicator(
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation<Color>(KprimaryColor),
              ),
          ),
        ],
      );
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}