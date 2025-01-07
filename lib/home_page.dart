import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stroll_test/constants/STColors.dart';
import 'package:stroll_test/extensions/sizes_ext.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  bool _isExpanded = false;
  int? _selectedIndex;
  final List<Map<String, String>> _options = [
    {'label': 'A', 'text': 'The peace in the early mornings'},
    {'label': 'B', 'text': 'The magical golden hours'},
    {'label': 'C', 'text': 'Wind-down time after dinners'},
    {'label': 'D', 'text': 'The serenity past midnight'},
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _options.length,
          (index) => AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      ),
    );
    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ));
    }).toList();
    Future.delayed(Duration(milliseconds: 100), () {
      for (int i = 0; i < _controllers.length; i++) {
        Future.delayed(
          Duration(milliseconds: 100 * i),
              () => _controllers[i].forward(),
        );
      }
    });
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
            child: _blackGradient()
          ),
          Positioned(
              bottom: 36.pH,
              left: 20.pW,
              child: Container(
                padding: EdgeInsets.fromLTRB( 10.pW, 6, 6,6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: STColors.profileBorder
                ),
                child: Text('Angela, 28',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
          ),
          Positioned(
              bottom: 31.pH,
              left: 6.pW,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: STColors.profileBorder,
                child: CircleAvatar(
                  radius: 34,
                  backgroundImage: AssetImage('assets/Image.png'),
                ),
              )
          ),

        ],
      ),
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
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

  Widget _blackGradient(){
    return Container(
      width: 100.pW,
      height: 46.5.pH,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:  EdgeInsets.only(top:11.pH,left: 30.pW),
            child: SizedBox(
              width: 55.pW,
              child: Text('What is your favourite time of the day?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                height: 1.1,
                fontWeight: FontWeight.w600
              ),
              ),
            ),
          ),
          1.gap,
          Padding(
            padding:  EdgeInsets.only(left: 20.pW),
            child: Text('"Mine is definitely the peace in the morning"',
            style: GoogleFonts.montserrat(
              color: STColors.primary,
              fontStyle: FontStyle.italic,
              fontSize: 10
            ),
            ),
          ),
          1.gap,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: StaggeredGridView.countBuilder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              itemCount: _options.length,
              itemBuilder: (context, index){
                bool isSelected = _selectedIndex == index;
                return AnimatedBuilder(
                    animation: _animations[index],
                    builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 50 * (1 - _animations[index].value)),
                      child: Transform.scale(
                        scale: _animations[index].value,
                        child: FadeTransition(
                          opacity: _animations[index],
                          child: child,
                        ),
                      ),
                    );
                    },
                  child: GestureDetector(
                      onTap: (){
                        _controllers[index].reverse().then((_) {
                          _controllers[index].forward();
                          setState(() {
                            _selectedIndex = index;
                          });
                        });
                      },
                      child: _optionContainer(isSelected, index)
                  ),
                );
              },
                staggeredTileBuilder:  (context) => const StaggeredTile.fit(1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0,horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pick your option.\nSee who has a similar mind.',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white
                ),
                ),
                Row(
                  children: [
                    SvgPicture.asset('assets/Poll Act. Buttons.svg',height: 30,),
                    1.gap,
                    SvgPicture.asset('assets/Poll Act. Buttons (1).svg',height: 30,),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget _optionContainer(bool isSelected, int index){
    return Container(
      //margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: STColors.optionCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? STColors.primaryBorder : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: isSelected ? STColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                width: 2,
                color: isSelected ? STColors.primary : Colors.grey.shade500
              )
            ),
            child: Center(
              child: Text(
                _options[index]['label']!,
                style: TextStyle(
                  color:Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              _options[index]['text']!,
              style: TextStyle(
                fontSize: 9,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _wavePicture(){
    return Container(
      padding: EdgeInsets.only(top: 10.pH),
      height: 62.pH,
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
