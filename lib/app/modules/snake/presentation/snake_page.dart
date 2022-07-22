import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:game_boy/app/modules/snake/presentation/widgets/blank_pixel.dart';
import 'package:game_boy/app/modules/snake/presentation/widgets/food_pixel.dart';
import 'package:game_boy/app/modules/snake/presentation/widgets/highscore_tile.dart';
import 'package:game_boy/app/modules/snake/presentation/widgets/snake_pixel.dart';

class SnakePage extends StatefulWidget {
  const SnakePage({Key? key}) : super(key: key);

  @override
  State<SnakePage> createState() => _SnakePageState();
}

enum snake_Direction { UP, DOWN, LEFT, RIGHT }

class _SnakePageState extends State<SnakePage> {
  int rowSize = 10;
  int totalNumberOfSquares = 110;
  List<int> snakePosition = [0, 1, 2];
  int foodPosition = 55;
  int currentScore = 0;
  bool gameHasStarted = false;
  List<String> highscoreDocsId = [];
  late final Future? letsGetDocids;
  final _gameController = TextEditingController();
  var currentDirection = snake_Direction.RIGHT;

  @override
  void initState() {
    letsGetDocids = getDocId();
    super.initState();
  }

  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('highscores')
        .orderBy('score', descending: true)
        .limit(10)
        .get()
        .then(
          (value) => value.docs.forEach(
            (element) {
              highscoreDocsId.add(element.reference.id);
            },
          ),
        );
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(
      const Duration(milliseconds: 200),
      (timer) {
        setState(
          () {
            moveSnake();
            if (gameOver()) {
              timer.cancel();
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Game Over '),
                    content: Column(
                      children: [
                        Text(
                          'Your Score is: ' + currentScore.toString(),
                        ),
                        TextField(
                          controller: _gameController,
                          decoration:
                              const InputDecoration(hintText: 'Enter name'),
                        )
                      ],
                    ),
                    actions: [
                      MaterialButton(
                        onPressed: () {
                          submitScore();
                          Modular.to.pop();
                          newGame();
                        },
                        child: const Text('Submit'),
                        color: Colors.pink,
                      ),
                    ],
                  );
                },
              );
            }
          },
        );
      },
    );
  }

  void submitScore() {
    var database = FirebaseFirestore.instance;
    database.collection('highscores').add(
      {
        "name": _gameController.text,
        "score": currentScore,
      },
    );
  }

  Future newGame() async {
    highscoreDocsId = [];
    await getDocId();
    setState(
      () {
        snakePosition = [0, 1, 2];
        foodPosition = 55;
        currentDirection = snake_Direction.RIGHT;
        gameHasStarted = false;
        currentScore = 0;
      },
    );
  }

  void eatFood() {
    currentScore++;
    while (snakePosition.contains(foodPosition)) {
      foodPosition = Random().nextInt(totalNumberOfSquares);
    }
  }

  bool gameOver() {
    List<int> bodySnake = snakePosition.sublist(0, snakePosition.length - 1);

    if (bodySnake.contains(snakePosition.last)) {
      return true;
    }

    return false;
  }

  void moveSnake() {
    switch (currentDirection) {
      case snake_Direction.RIGHT:
        {
          if (snakePosition.last % rowSize == 9) {
            snakePosition.add(snakePosition.last + 1 - rowSize);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
        }
        break;
      case snake_Direction.LEFT:
        {
          if (snakePosition.last % rowSize == 0) {
            snakePosition.add(snakePosition.last - 1 + rowSize);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }
        }
        break;
      case snake_Direction.UP:
        {
          if (snakePosition.last < rowSize) {
            snakePosition
                .add(snakePosition.last - rowSize + totalNumberOfSquares);
          } else {
            snakePosition.add(snakePosition.last - rowSize);
          }
        }
        break;
      case snake_Direction.DOWN:
        {
          if (snakePosition.last + rowSize > totalNumberOfSquares) {
            snakePosition
                .add(snakePosition.last + rowSize - totalNumberOfSquares);
          } else {
            snakePosition.add(snakePosition.last + rowSize);
          }
        }
        break;
      default:
    }
    if (snakePosition.last == foodPosition) {
      eatFood();
    } else {
      snakePosition.removeAt(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Current Score',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        currentScore.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: gameHasStarted
                      ? Container()
                      : FutureBuilder(
                          future: letsGetDocids,
                          builder: ((context, snapshot) {
                            return ListView.builder(
                              itemCount: highscoreDocsId.length,
                              itemBuilder: ((context, index) {
                                return HighscoreTile(
                                  documentId: highscoreDocsId[index],
                                );
                              }),
                            );
                          }),
                        ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0 &&
                    currentDirection != snake_Direction.UP) {
                  currentDirection = snake_Direction.DOWN;
                } else if (details.delta.dy < 0 &&
                    currentDirection != snake_Direction.DOWN) {
                  currentDirection = snake_Direction.UP;
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0 &&
                    currentDirection != snake_Direction.LEFT) {
                  currentDirection = snake_Direction.RIGHT;
                } else if (details.delta.dx < 0 &&
                    currentDirection != snake_Direction.RIGHT) {
                  currentDirection = snake_Direction.LEFT;
                }
              },
              child: GridView.builder(
                itemCount: totalNumberOfSquares,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowSize,
                ),
                itemBuilder: (context, index) {
                  if (snakePosition.contains(index)) {
                    return const SnakePixel();
                  } else if (foodPosition == index) {
                    return const FoodPixel();
                  } else {
                    return const BlankPixel();
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: MaterialButton(
                child: const Text('PLAY'),
                color: gameHasStarted ? Colors.grey : Colors.pink,
                onPressed: gameHasStarted ? () {} : startGame,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
