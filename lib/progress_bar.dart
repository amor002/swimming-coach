import 'package:flutter/material.dart';


class ProgressBar extends StatelessWidget {

  double progress;
  Color progressColor;
  Color background;
  double width;

  ProgressBar({@required this.progress,
    @required this.progressColor,
    this.background: Colors.grey,
    this.width: double.infinity}): assert(progress >= 0 && progress <= 100);

  @override
  Widget build(BuildContext context) {

    return Container(
      width: width,
      height: 5,
      color: background,
      child: ClipPath(
        clipper: Clipper(progress),
        child: Container(
          height: 5,
          width: double.infinity,
          color: progressColor,
        ),
      ),
    );
  }

}


class Clipper extends CustomClipper<Path> {

  double progress;
  Clipper(this.progress);

  @override
  Path getClip(Size size) {
    Path path = new Path();
    double width = size.width*(progress/100);
    path.lineTo(width, 0);
    path.lineTo(width, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;

}