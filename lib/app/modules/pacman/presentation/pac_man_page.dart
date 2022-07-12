import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_boy/app/modules/pacman/presentation/widgets/barrier.dart';
import 'package:game_boy/app/modules/pacman/presentation/widgets/ghost.dart';
import 'package:game_boy/app/modules/pacman/presentation/widgets/pixel.dart';
import 'package:game_boy/app/modules/pacman/presentation/widgets/player.dart';

class PacMan extends StatefulWidget {
  const PacMan({Key? key}) : super(key: key);

  @override
  State<PacMan> createState() => _PacManState();
}

class _PacManState extends State<PacMan> {
  static int numberInRow = 11;
  int numberOfSquares = numberInRow * 15;
  int player = numberInRow * 13 + 1;
  List<int> barriers = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    21,
    32,
    43,
    54,
    65,
    76,
    98,
    99,
    88,
    66,
    55,
    44,
    33,
    22,
    11,
    89,
    90,
    91,
    92,
    97,
    96,
    95,
    94,
    67,
    68,
    69,
    70,
    59,
    46,
    35,
    24,
    75,
    74,
    73,
    72,
    61,
    52,
    41,
    30,
    28,
    39,
    38,
    37,
    26,
    103,
    105,
    109,
    110,
    112,
    118,
    120,
    121,
    123,
    125,
    126,
    127,
    129,
    131,
    132,
    134,
    136,
    138,
    140,
    142,
    143,
    153,
    154,
    155,
    156,
    157,
    158,
    159,
    160,
    161,
    162,
    163,
    164,
  ];
  List<int> food = [];
  String direction = "right";
  bool mouthClosed = false;
  int score = 0;
  int ghost = numberInRow * 2 - 2;
  bool gameStarted = false;

  void startGame() {
    getFood();
    moveGhost();
    gameStarted = true;
    Timer.periodic(
      const Duration(milliseconds: 200),
      (timer) {
        mouthClosed = !mouthClosed;

        if (food.contains(player)) {
          food.remove(player);
          score++;
        }

        if (player == ghost) {
          ghost = -1;
        }

        switch (direction) {
          case "left":
            moveLeft();
            break;
          case "right":
            moveRight();

            break;
          case "up":
            moveUp();

            break;
          case "down":
            moveDown();

            break;
        }
      },
    );
  }

  void getFood() {
    for (int i = 0; i < numberOfSquares; i++) {
      if (!barriers.contains(i)) {
        food.add(i);
      }
    }
  }

  void moveLeft() {
    if (!barriers.contains(player - 1)) {
      setState(
        () {
          player--;
        },
      );
    }
  }

  void moveRight() {
    if (!barriers.contains(player + 1)) {
      setState(
        () {
          player++;
        },
      );
    }
  }

  void moveUp() {
    if (!barriers.contains(player - numberInRow)) {
      setState(
        () {
          player -= numberInRow;
        },
      );
    }
  }

  void moveDown() {
    if (!barriers.contains(player + numberInRow)) {
      setState(
        () {
          player += numberInRow;
        },
      );
    }
  }

  String ghostDirection = "left";
  void moveGhost() {
    Duration ghostSpeed = const Duration(milliseconds: 500);
    Timer.periodic(ghostSpeed, (timer) {
      if (!barriers.contains(ghost - 1) && ghostDirection != "right") {
        ghostDirection = "left";
      } else if (!barriers.contains(ghost - numberInRow) &&
          ghostDirection != "down") {
        ghostDirection = "up";
      } else if (!barriers.contains(ghost + numberInRow) &&
          ghostDirection != "up") {
        ghostDirection = "down";
      } else if (!barriers.contains(ghost + 1) && ghostDirection != "left") {
        ghostDirection = "right";
      }

      switch (ghostDirection) {
        case "right":
          setState(() {
            ghost++;
          });
          break;

        case "up":
          setState(() {
            ghost -= numberInRow;
          });
          break;

        case "left":
          setState(() {
            ghost--;
          });
          break;

        case "down":
          setState(() {
            ghost += numberInRow;
          });
          break;
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0) {
                  direction = "down";
                } else if (details.delta.dy < 0) {
                  direction = "up";
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0) {
                  direction = "right";
                } else if (details.delta.dx < 0) {
                  direction = "left";
                }
              },
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: numberOfSquares,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: numberInRow),
                itemBuilder: (BuildContext context, int index) {
                  if (player == index) {
                    if (mouthClosed) {
                      return Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.yellow,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    } else {
                      switch (direction) {
                        case "left":
                          return Transform.rotate(
                            angle: pi,
                            child: const Player(),
                          );

                        case "right":
                          return const Player();

                        case "up":
                          return Transform.rotate(
                            angle: 3 * pi / 2,
                            child: const Player(),
                          );

                        case "down":
                          return Transform.rotate(
                            angle: pi / 2,
                            child: const Player(),
                          );
                      }
                    }
                  } else if (ghost == index) {
                    return const Ghost();
                  } else if (barriers.contains(index)) {
                    return MyBarrier(
                      innerColor: Colors.blue[800],
                      outerColor: Colors.blue[900],
                    );
                  } else if (food.contains(index) || !gameStarted) {
                    return const Pixel(
                      innercolor: Colors.green,
                      outerColor: Colors.black,
                    );
                  } else {
                    return const Pixel(
                      innercolor: Colors.black,
                      outerColor: Colors.black,
                    );
                  }
                  return const Player();
                },
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Score: ' + score.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 40),
                ),
                GestureDetector(
                  onTap: startGame,
                  child: const Text(
                    'P L A Y',
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
