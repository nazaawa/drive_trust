import 'package:drive_trust/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _sceneryController;
  late final AnimationController _carpetController;
  late final AnimationController _titleController;
  late final AnimationController _carsController;
  late final AnimationController _infoController;
  late final AnimationController _buttonController;
  late final AnimationController _carFloatController;
  late final AnimationController _wheelRotationController;

  late final Animation<double> _sceneryOpacity;
  late final Animation<double> _carpetSlide;
  late final Animation<double> _titleScale;
  late final Animation<double> _subtitleOpacity;
  late final Animation<Offset> _carsSlide;
  late final Animation<double> _carFloat;
  late final Animation<double> _infoScale;
  late final Animation<double> _buttonScale;
  late final Animation<double> _wheelRotation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: AppTheme.primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    _startAnimations();
  }

  void _initializeAnimations() {
    // Scenery animation (0-0.8s)
    _sceneryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _sceneryOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sceneryController, curve: Curves.easeIn),
    );

    // Carpet animation (0-0.8s)
    _carpetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _carpetSlide = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _carpetController, curve: Curves.easeOut),
    );

    // Title animations (0.6-1.4s)
    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _titleScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeOutBack),
    );
    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _titleController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    // Cars animation (1.2-2.0s)
    _carsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _carsSlide = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _carsController, curve: Curves.easeOutCubic));

    // Continuous car float animation
    _carFloatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _carFloat = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _carFloatController, curve: Curves.easeInOut),
    );
    _carFloatController.repeat(reverse: true);

    // Info container animation (1.8-2.4s)
    _infoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _infoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _infoController, curve: Curves.easeOutBack),
    );

    // Button animation (2.2-2.8s)
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _buttonScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOutBack),
    );

    // Wheel rotation animation
    _wheelRotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _wheelRotation = Tween<double>(begin: 0, end: 0.05).animate(
      CurvedAnimation(
          parent: _wheelRotationController, curve: Curves.easeInOut),
    );
    _wheelRotationController.repeat(reverse: true);
  }

  void _startAnimations() {
    Future.delayed(Duration.zero, () => _sceneryController.forward());
    Future.delayed(Duration.zero, () => _carpetController.forward());
    Future.delayed(
        const Duration(milliseconds: 600), () => _titleController.forward());
    Future.delayed(
        const Duration(milliseconds: 1200), () => _carsController.forward());
    Future.delayed(
        const Duration(milliseconds: 1800), () => _infoController.forward());
    Future.delayed(
        const Duration(milliseconds: 2200), () => _buttonController.forward());
  }

  @override
  void dispose() {
    _sceneryController.dispose();
    _carpetController.dispose();
    _titleController.dispose();
    _carsController.dispose();
    _carFloatController.dispose();
    _infoController.dispose();
    _buttonController.dispose();
    _wheelRotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Stack(
        children: [
          // Scenery
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _sceneryOpacity,
              child: Image.asset('assets/images/scenery.png'),
            ),
          ),
          // Carpet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _carpetSlide,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, _carpetSlide.value),
                child: child,
              ),
              child: Image.asset('assets/images/carpet.png'),
            ),
          ),
          // Cars
          Positioned(
            bottom: 180,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _carsSlide,
              child: AnimatedBuilder(
                animation: _carFloat,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, _carFloat.value),
                  child: child,
                ),
                child: Image.asset('assets/images/cars_splash.png'),
              ),
            ),
          ),
          // Title
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: ScaleTransition(
                scale: _titleScale,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DRIVE TRUST',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    FadeTransition(
                      opacity: _subtitleOpacity,
                      child: const Text(
                        'Ride Anywhere Forever',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Info Container
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: ScaleTransition(
              scale: _infoScale,
              child: Container(
                width: 100,
                height: 90,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      "CAB Booking Made Smooth",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Get Faster Anywhere and Everywhere you will need to Go , Easy Booking and Comfortable Ride Experience',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ScaleTransition(
              scale: _buttonScale,
              child: Container(
                width: 100,
                height: 50,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: "Let's Gooo",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: AnimatedBuilder(
                              animation: _wheelRotation,
                              builder: (context, child) => Transform.rotate(
                                angle: _wheelRotation.value,
                                child: child,
                              ),
                              child: Image.asset(
                                'assets/images/steering-wheel.png',
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
