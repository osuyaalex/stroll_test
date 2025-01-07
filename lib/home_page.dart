import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stroll_test/constants/STColors.dart';
import 'package:stroll_test/extensions/sizes_ext.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

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
            child: _wavePicture()
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 100.pW,
              height: 35.pH,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Colors.black,
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                  stops: const [
                    0.0,
                    0.7,
                    0.9,
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
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Widget _wavePicture(){
    return Container(
      padding: EdgeInsets.only(top: 10.pH),
      height: 70.pH,
      width: 100.pW,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/video.png',),
              fit: BoxFit.fill
          )
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _titleText('Stroll Bonfire',30,FontWeight.bold,STColors.primary),
              Padding(
                padding: const EdgeInsets.only(left: 8.0,top: 8),
                child:  GestureDetector(
                  onTap: _toggleExpand,
                  child: AnimatedRotation(
                    duration: const Duration(milliseconds: 300),
                    turns: _isExpanded ? 0 : 0.5,
                    child: const Icon(Icons.keyboard_arrow_down_sharp,color: Colors.white,),
                  ),
                ),
              ),
            ],
          ),
          SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _iconWithShadow('assets/clock.svg'),
                  _subTitleText('22h 00m', 13,FontWeight.w100, Colors.white),
                  1.gap,
                  _iconWithShadow('assets/profile.svg',),
                  _subTitleText('103', 13,FontWeight.normal, Colors.white),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _titleText(String text, double fontSize,FontWeight fontWeight, Color color){
    return Text(text,
      style: TextStyle(
        // color: STColors.primary.withOpacity(0.5),
        fontWeight: fontWeight,
        fontSize: fontSize,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = color,
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.3),
            offset: Offset(2, 2),
            blurRadius: 3,
          ),
        ],
      ),

    );
  }
  Widget _subTitleText(String text, double fontSize,FontWeight fontWeight, Color color){
    return Text(text,
      style: TextStyle(
        // color: STColors.primary.withOpacity(0.5),
        fontWeight: fontWeight,
        fontSize: fontSize,
        foreground: Paint()
          // ..style = PaintingStyle.stroke
          // ..strokeWidth = 2
          ..color = color,
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.3),
            offset: Offset(0, 2),
            blurRadius: 3,
          ),
        ],
      ),

    );
  }
  Widget _iconWithShadow(String asset,){
    return Stack(
      children: [
        SizedBox(height: 5.pW,),
        Positioned(
          top: 1.5,
          child: SvgPicture.asset(
            asset,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2),
                BlendMode.srcIn),
          ),
        ),
        // Actual SVG layer
        SvgPicture.asset(asset),
      ],
    );
  }
}
