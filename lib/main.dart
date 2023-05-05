import 'dart:ui';

import 'package:flutter/material.dart';

import 'second_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _animationMovementController;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
      lowerBound: 0.25,
    );
    _animationMovementController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationMovementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
          color: Colors.black,
        ),
        title: const Text(
          'My Playlist',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final curvedValue = lerpDouble(0.25, 1.0,
                    Curves.elasticInOut.transform(_controller.value));

                return Expanded(
                  flex: 5,
                  child: LayoutBuilder(builder: (context, constraints) {
                    final itemHeight = constraints.maxHeight * .48;
                    return Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateX(
                          curvedValue! * (curvedValue * 0.3),
                        ),
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ...List.generate(
                            4,
                            (index) => AnimatedBuilder(
                                animation: _animationMovementController,
                                builder: (context, snapshot) {
                                  final movementCurvedValue =
                                      Curves.elasticInOut.transform(
                                          _animationMovementController.value);
                                  int movementY = 0;
                                  if (selectedIndex == null ||
                                      selectedIndex == index) {
                                    movementY = 0;
                                  } else if (selectedIndex! > index) {
                                    movementY = 1;
                                  } else {
                                    movementY = -1;
                                  }
                                  Color color = index == 0
                                      ? Colors.red
                                      : index == 1
                                          ? Colors.blue
                                          : index == 2
                                              ? Colors.green
                                              : Colors.yellow;
                                  String image = index == 0
                                      ? 'assets/ImagineDragonsEvolve.jpg'
                                      : index == 1
                                          ? 'assets/Elvis_Presley.jpg'
                                          : index == 2
                                              ? 'assets/thrillermj.jpg'
                                              : 'assets/Dua_Lipa.jpg';
                                  return Positioned(
                                    bottom:
                                        150 + 50 * (index - 2) * curvedValue,
                                    child: Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.identity()
                                        ..setEntry(3, 2, 0.001)
                                        ..translate(
                                            0.0,
                                            movementY *
                                                (size.height * .75) *
                                                movementCurvedValue,
                                            30.0 * index),
                                      child: GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            selectedIndex = index;
                                          });
                                          _animationMovementController
                                              .forward();
                                          await Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                      secondaryAnimation) =>
                                                  FadeTransition(
                                                opacity: animation,
                                                child: SeconPage(
                                                  index: index,
                                                  itemHeight: itemHeight,
                                                ),
                                              ),
                                              reverseTransitionDuration:
                                                  const Duration(
                                                      milliseconds: 1000),
                                              transitionDuration:
                                                  const Duration(
                                                      milliseconds: 1000),
                                            ),
                                          );
                                          _animationMovementController.reverse(
                                              from: 1.0);
                                        },
                                        child: Hero(
                                          tag: index,
                                          child: SizedBox(
                                            height: itemHeight,
                                            width: itemHeight,
                                            child: Card(
                                              clipBehavior: Clip.hardEdge,
                                              elevation: 8,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                              color: color,
                                              child: Image.asset(
                                                image,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ).reversed,
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 150),
                            left: 0,
                            bottom: 0,
                            right: 0,
                            height: _controller.isCompleted
                                ? constraints.maxHeight * 0.25
                                : constraints.maxHeight,
                            child: InkWell(
                              onTap: () {
                                if (_controller.isCompleted) {
                                  _controller.reverse();
                                } else {
                                  _controller.forward();
                                }
                              },
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                alignment: Alignment.topRight,
                                height: constraints.maxHeight * 0.25,
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Icon(Icons.touch_app),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                );
              }),
          Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Recentry Played'),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 20,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        String image = index % 4 == 0
                            ? 'assets/ImagineDragonsEvolve.jpg'
                            : index % 3 == 0
                                ? 'assets/Dua_Lipa.jpg'
                                : index % 2 == 0
                                    ? 'assets/Elvis_Presley.jpg'
                                    : 'assets/thrillermj.jpg';
                        return AspectRatio(
                          aspectRatio: 1,
                          child: Card(
                            clipBehavior: Clip.hardEdge,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            margin: const EdgeInsets.all(16),
                            color: Colors.red,
                            child: Image.asset(
                              image,
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
