import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:game_boy/app/modules/snake/presentation/widgets/blank_pixel.dart';
import 'package:game_boy/app/modules/snake/presentation/widgets/food_pixel.dart';
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
  var currentDirection = snake_Direction.RIGHT;

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
                        const TextField(
                          decoration: InputDecoration(hintText: 'Enter name'),
                        )
                      ],
                    ),
                    actions: [
                      MaterialButton(
                        onPressed: () {
                          Modular.to.pop();
                          newGame();
                          submitScore();
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

  void submitScore() {}

  void newGame() {
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
                Column(
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
                const Text(
                  'highscores..',
                  style: TextStyle(color: Colors.white),
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
