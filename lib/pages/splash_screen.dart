import 'package:elms/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return AnnotatedRegion(
        value: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light),
        child: Scaffold(
          backgroundColor: AppColors.primaryColor,
          body: Center(
            // ignore: sized_box_for_whitespace
            child: Container(height: 180, child: Image.asset("assets/coffee.png")),
          ),
        ),
      );
    });
  }
}
