import 'package:flutter/material.dart';

class CustomReOrderableListScreen extends StatefulWidget {
  const CustomReOrderableListScreen({super.key});

  @override
  State<CustomReOrderableListScreen> createState() =>
      _CustomReOrderableListScreenState();
}

class _CustomReOrderableListScreenState
    extends State<CustomReOrderableListScreen> with TickerProviderStateMixin {
  late List<String> names;
  late List<AnimationController> widgetAnimationController;

  int clickedIndex = -1;
  bool isMovingUp = false;
  bool didUpdateValue = false;

  @override
  void initState() {
    super.initState();
    names = List.generate(10, (index) => 'Name: ${index + 1}');
    widgetAnimationController = List.generate(
        names.length,
        (index) => AnimationController(
            vsync: this, duration: const Duration(milliseconds: 800)));
  }

  changeColorOnComplete() {
    if (!didUpdateValue && clickedIndex != -1) {
      setState(() {
        final text = names[clickedIndex];
        names[clickedIndex] =
            names[isMovingUp ? (clickedIndex - 1) : (clickedIndex + 1)];

        names[isMovingUp ? (clickedIndex - 1) : (clickedIndex + 1)] = text;

        didUpdateValue = true;
      });
    }
  }

  addWidgetControllListener(int index) {
    if (widgetAnimationController[index].isCompleted) {
      widgetAnimationController[index].reset();
      changeColorOnComplete();
    }
  }

  animateWiget({required int index}) {
    widgetAnimationController[index].forward();
    widgetAnimationController[isMovingUp ? (index - 1) : (index + 1)].forward();
    widgetAnimationController[index]
        .addListener(() => addWidgetControllListener(index));
    widgetAnimationController[isMovingUp ? (index - 1) : (index + 1)]
        .addListener(() =>
            addWidgetControllListener(isMovingUp ? (index - 1) : (index + 1)));
  }

  handleArrowClick({required int index, required bool isMoving}) {
    setState(() {
      clickedIndex = index;
      didUpdateValue = false;
      isMovingUp = isMoving;
    });
    animateWiget(index: index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Reorderable List'),
      ),
      body: AnimatedList(
          shrinkWrap: true,
          initialItemCount: names.length,
          itemBuilder: (context, index, animation) {
            return AnimatedBuilder(
              animation: widgetAnimationController[index],
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    0,
                    widgetAnimationController[index].value *
                        (isMovingUp
                            ? ((clickedIndex == index) ? (-72) : (72))
                            : ((clickedIndex == index) ? (72) : (-72))),
                  ),
                  child: child ?? Container(),
                );
              },
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 56,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(color: Colors.blueGrey[50]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            if (index != 0) {
                              handleArrowClick(index: index, isMoving: true);
                            }
                          },
                          icon: Icon(
                            Icons.arrow_upward,
                            color:
                                index == 0 ? Colors.transparent : Colors.black,
                          )),
                      Text(
                        names[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20,
                            height: 1.2,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      IconButton(
                          onPressed: () {
                            if (index != names.length - 1) {
                              handleArrowClick(index: index, isMoving: false);
                            }
                          },
                          icon: Icon(
                            Icons.arrow_downward,
                            color: index == (names.length - 1)
                                ? Colors.transparent
                                : Colors.black,
                          )),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
