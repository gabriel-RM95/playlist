import 'dart:math';

import 'package:flutter/material.dart';

class SeconPage extends StatefulWidget {
  const SeconPage({Key? key, required this.index, required this.itemHeight})
      : super(key: key);

  final int index;
  final double itemHeight;

  @override
  State<SeconPage> createState() => _SeconPageState();
}

class _SeconPageState extends State<SeconPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _reproductionAnimationController;
  final _sliderValue = ValueNotifier<double>(0.5);

  @override
  void initState() {
    super.initState();
    _reproductionAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
  }

  @override
  void dispose() {
    _reproductionAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color color = widget.index == 0
        ? Colors.red
        : widget.index == 1
            ? Colors.blue
            : widget.index == 2
                ? Colors.green
                : Colors.yellow;
    String image = widget.index == 0
        ? 'assets/ImagineDragonsEvolve.jpg'
        : widget.index == 1
            ? 'assets/Elvis_Presley.jpg'
            : widget.index == 2
                ? 'assets/thrillermj.jpg'
                : 'assets/Dua_Lipa.jpg';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Hero(
              tag: widget.index,
              flightShuttleBuilder: (flightContext, animation, flightDirection,
                  fromHeroContext, toHeroContext) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    final curvedValue =
                        Curves.linearToEaseOut.transform(animation.value);
                    return Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.003)
                        ..rotateX(curvedValue * 2 * pi),
                      alignment: Alignment.center,
                      child: child,
                    );
                  },
                  child: SizedBox(
                    height: widget.itemHeight,
                    width: widget.itemHeight,
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      color: widget.index == 0
                          ? color
                          : widget.index == 1
                              ? color
                              : widget.index == 2
                                  ? color
                                  : color,
                      child: Image.asset(
                        image,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                );
              },
              child: SizedBox(
                height: widget.itemHeight,
                width: widget.itemHeight,
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  color: widget.index == 0
                      ? color
                      : widget.index == 1
                          ? color
                          : widget.index == 2
                              ? color
                              : color,
                  child: Image.asset(
                    image,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          const Text('Name of the song'),
          const Text('Album'),
          ValueListenableBuilder(
            valueListenable: _sliderValue,
            builder: (context, value, child) => Slider(
              value: _sliderValue.value,
              onChanged: (value) {
                _sliderValue.value = value;
              },
              activeColor: Colors.pink,
              inactiveColor: Colors.grey[200],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.shuffle),
                onPressed: () {},
              ),
              ElevatedButton(
                onPressed: () {
                  _reproductionAnimationController.isCompleted
                      ? _reproductionAnimationController.reverse(from: 1.0)
                      : _reproductionAnimationController.forward();
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                ),
                child: AnimatedIcon(
                  icon: AnimatedIcons.play_pause,
                  progress: _reproductionAnimationController,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.repeat),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox.shrink(),
          const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text('Other Text'),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Container(
                  height: 75,
                  width: 75,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(image: AssetImage(image)),
                  ),
                ),
                const Expanded(
                  child: Text('Some Description Here'),
                ),
                const Icon(
                  Icons.favorite,
                  color: Colors.red,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
