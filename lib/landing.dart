import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:testt/home.dart';

class Logo extends StatefulWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  _LogoState createState() => _LogoState();
}

class _LogoState extends State<Logo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0.0, 5.0 * _controller.value),
          child: child,
        );
      },
      child: Image.asset(
        'assets/images/logo.png',
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      ),
    );
  }
}

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B3C3D), 
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
        child: Column(
          children: [
            const Logo(),
            const SizedBox(height: 30), 
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text(
                  'Welcome to BonTable!',
                  style: TextStyle(
                    fontFamily: 'BigshotOne',
                    color: Color(0xFFEEF0E5),
                    fontSize: 64,
                  ),
                ),
                Text(
                  'Your Appetite, Our Inspiration',
                  style: TextStyle(
                    fontFamily: 'Calistoga',
                    color: Color(0xFFEEF0E5),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Spacer(), 
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'CONTINUE',
                      mouseCursor: SystemMouseCursors.click,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                   HomeScreen(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const curve = Curves.easeInOut;
                                var curvedAnimation = CurvedAnimation(
                                  parent: animation,
                                  curve: curve,
                                );
                                return ScaleTransition(
                                  scale: Tween(begin: 0.0, end: 1.0).animate(curvedAnimation),
                                  child: FadeTransition(
                                    opacity: Tween(begin: 0.0, end: 1.0).animate(curvedAnimation),
                                    child: child,
                                  ),
                                );
                              },
                              transitionDuration: const Duration(milliseconds: 500),
                            ),
                          );
                        },
                      style: const TextStyle(
                        fontFamily: 'Calistoga',
                        fontSize: 18,
                        color: Colors.white,
                        decoration: TextDecoration.underline, 
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20), 
          ],
        ),
      ),
    );
  }
}
