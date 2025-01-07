import 'package:flutter/material.dart';
import 'package:stroll_test/extensions/sizes_ext.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: 100.pH,
            width: 100.pW,
          ),
          Positioned(
            top: 0,
            child: Container(
              height: 63.pH,
              width: 100.pW,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/video.png',),
                  fit: BoxFit.fill
                )
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 100.pW,
              height: 43.pH,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,              // Solid black
                    Colors.black,              // Still solid black
                    Colors.black.withOpacity(0.6),  // Start fading
                    Colors.transparent,
                  ],
                  stops: const [
                    0.0,    // Start with solid black
                    0.7,    // Keep solid black until here
                    0.9,    // Start fading
                    1.0,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
