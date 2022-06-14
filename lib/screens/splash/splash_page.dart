import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:uniestagios/app_initial.dart';
import 'package:uniestagios/theme.dart';
import 'package:uniestagios/utils/overlay.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  final appInitial = Get.find<AppInitial>();

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
    Future.delayed(
      Duration(seconds: 2),
      () {
        appInitial.getAccess();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return Scaffold(
      body: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Center(
          child: Hero(
            tag: "logo",
            child: FadeTransition(
              opacity: _animation,
              child: Image.asset(
                'assets/images/logo.png',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
