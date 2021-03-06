import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class IllustrationContainer extends StatelessWidget {
  final String path;
  final bool reduceSizeByHalf;

  const IllustrationContainer({
    Key? key,
    required this.path,
    this.reduceSizeByHalf = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*if (path.toLowerCase().contains("svg"))
      return SvgPicture.asset(
        path,
        width: MediaQuery.of(context).size.height *
            (reduceSizeByHalf ? 0.3 / 2 : 0.3),
        height: MediaQuery.of(context).size.height *
            (reduceSizeByHalf ? 0.3 / 2 : 0.3),
      );
    else*/
    return Lottie.asset(path, repeat: true);
  }
}
