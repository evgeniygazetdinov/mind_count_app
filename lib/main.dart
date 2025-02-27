import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Тренажер устного счета',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MathTrainer(),
    );
  }
}

class MathTrainer extends StatefulWidget {
  const MathTrainer({super.key});

  @override
  State<MathTrainer> createState() => _MathTrainerState();
}

class _MathTrainerState extends State<MathTrainer> {
  final TextEditingController _answerController = TextEditingController();
  int currentSum = 0;
  int nextNumber = 0;
  int correctAnswers = 0;
  int currentLevel = 1;
  bool isFirstNumber = true;
  final Random _random = Random();
  List<String> exerciseHistory = [];

  @override
  void initState() {
    super.initState();
    _startNewExercise();
  }

  void _startNewExercise() {
    if (isFirstNumber) {
      currentSum = _generateNumber();
      isFirstNumber = false;
    }
    nextNumber = _generateNumber();
    setState(() {});
  }

  int _generateNumber() {
    int maxNumber = 5 * currentLevel;
    return _random.nextInt(maxNumber) + 1;
  }

  void _checkAnswer() {
    if (_answerController.text.isEmpty) return;

    int userAnswer = int.tryParse(_answerController.text) ?? 0;
    if (userAnswer == currentSum + nextNumber) {
      exerciseHistory.add('$currentSum + $nextNumber = $userAnswer');
      
      setState(() {
        correctAnswers++;
        if (correctAnswers % 5 == 0) {
          currentLevel++;
        }
        currentSum = userAnswer;
        _answerController.clear();
        _startNewExercise();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Правильно! Уровень: $currentLevel'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      exerciseHistory.add('$currentSum + $nextNumber = $userAnswer');
      
      setState(() {
        _answerController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Неправильно! Попробуй ещё раз!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Уровень $currentLevel'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Решено: $correctAnswers',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$currentSum + $nextNumber = ?',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _answerController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24),
                      decoration: const InputDecoration(
                        hintText: 'Ваш ответ',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                      onSubmitted: (_) => _checkAnswer(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _checkAnswer,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    child: const Text(
                      'Проверить',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[200],
              child: ListView.builder(
                reverse: true,
                itemCount: exerciseHistory.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      exerciseHistory[exerciseHistory.length - 1 - index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }
}