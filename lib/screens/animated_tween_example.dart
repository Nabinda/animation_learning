import 'package:flutter/material.dart';

class AnimatedTweenExample extends StatefulWidget {
  const AnimatedTweenExample({super.key});

  @override
  State<AnimatedTweenExample> createState() => _AnimatedTweenExampleState();
}

class _AnimatedTweenExampleState extends State<AnimatedTweenExample>
    with TickerProviderStateMixin {
  late AnimationController firstContainerController;
  late AnimationController secondContainerController;

  Color firstContainerColor = Colors.red;
  Color secondContainerColor = Colors.green;

  bool didChangeColor = false;

  changeColorOnComplete() {
    if (!didChangeColor) {
      setState(() {
        final color = firstContainerColor;
        firstContainerColor = secondContainerColor;
        secondContainerColor = color;
        didChangeColor = true;
      });
    }
  }

  firstContainerControllerListener() {
    if (firstContainerController.isCompleted) {
      firstContainerController.reset();
      changeColorOnComplete();
    }
  }

  secondContainerControllerListener() {
    if (secondContainerController.isCompleted) {
      secondContainerController.reset();
      changeColorOnComplete();
    }
  }

  @override
  void initState() {
    super.initState();

    firstContainerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    secondContainerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    firstContainerController
        .addListener(() => firstContainerControllerListener());
    secondContainerController
        .addListener(() => secondContainerControllerListener());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Tween Example'),
      ),
      body: Center(
        child: Column(
          children: [
            AnimatedBuilder(
                animation: firstContainerController,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      didChangeColor = false;
                    });
                    firstContainerController.forward();
                    secondContainerController.forward();
                  },
                  child: Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width * 0.6,
                    color: firstContainerColor,
                  ),
                ),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, firstContainerController.value * (100)),
                    child: child ?? Container(),
                  );
                }),
            const SizedBox(height: 20),
            AnimatedBuilder(
                animation: secondContainerController,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      didChangeColor = false;
                    });
                    firstContainerController.forward();
                    secondContainerController.forward();
                  },
                  child: Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width * 0.6,
                    color: secondContainerColor,
                  ),
                ),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, secondContainerController.value * (-100)),
                    child: child ?? Container(),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
