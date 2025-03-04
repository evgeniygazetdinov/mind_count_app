import 'package:flutter/material.dart';
import 'dart:math';

// Перечисление режимов логических операций
enum LogicMode { boolean, loop }

class LogicExpressionsScreen extends StatefulWidget {
  const LogicExpressionsScreen({super.key});

  @override
  State<LogicExpressionsScreen> createState() => _LogicExpressionsScreenState();
}

class _LogicExpressionsScreenState extends State<LogicExpressionsScreen> {
  LogicMode? selectedMode;

  @override
  Widget build(BuildContext context) {
    // Если режим не выбран, показываем экран выбора
    if (selectedMode == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Логические выражения'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  setState(() {
                    selectedMode = LogicMode.boolean;
                  });
                },
                child: const Text('Булевы операции'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  setState(() {
                    selectedMode = LogicMode.loop;
                  });
                },
                child: const Text('Циклические операции'),
              ),
            ],
          ),
        ),
      );
    }

    // Если выбран режим, показываем соответствующий контент
    return selectedMode == LogicMode.boolean
        ? BooleanOperationsScreen()
        : LoopOperationsScreen();
  }
}

// Экран для булевых операций
class BooleanOperationsScreen extends StatefulWidget {
  @override
  State<BooleanOperationsScreen> createState() => _BooleanOperationsScreenState();
}

class _BooleanOperationsScreenState extends State<BooleanOperationsScreen> {
  final Random _random = Random();
  List<bool> variables = [];
  List<String> operations = [];
  String currentExpression = '';
  bool correctAnswer = false;
  int score = 0;
  int currentStep = 0;
  int totalSteps = 3;

  @override
  void initState() {
    super.initState();
    _generateNewExpression();
  }

  void _generateNewExpression() {
    variables = List.generate(4, (index) => _random.nextBool());
    operations = List.generate(3, (index) => _getRandomOperation());
    currentStep = 0;
    _generateNextStep();
  }

  String _getRandomOperation() {
    final ops = ['И', 'ИЛИ', 'НЕ'];
    return ops[_random.nextInt(ops.length)];
  }

  void _generateNextStep() {
    if (currentStep >= totalSteps) {
      _generateNewExpression();
      return;
    }

    setState(() {
      String varA = 'a${currentStep}';
      String varB = 'a${currentStep + 1}';
      String operation = operations[currentStep];
      
      currentExpression = '''
Шаг ${currentStep + 1} из $totalSteps:
$varA = ${variables[currentStep]}
$varB = ${variables[currentStep + 1]}
Результат операции "$varA $operation $varB"?
''';

      correctAnswer = _calculateAnswer(
        variables[currentStep],
        variables[currentStep + 1],
        operation
      );
    });
  }

  bool _calculateAnswer(bool value1, bool value2, String operator) {
    switch (operator) {
      case 'И':
        return value1 && value2;
      case 'ИЛИ':
        return value1 || value2;
      case 'НЕ':
        return !value1;
      default:
        return false;
    }
  }

  void _handleAnswer(bool userAnswer) {
    bool isCorrect = userAnswer == correctAnswer;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? 'Правильно!' : 'Неправильно!'),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
        duration: const Duration(seconds: 1),
      ),
    );

    if (isCorrect) {
      setState(() {
        score++;
      });
    }

    currentStep++;
    if (currentStep < totalSteps) {
      _generateNextStep();
    } else {
      _generateNewExpression();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Булевы операции'),
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LogicExpressionsScreen(),
              ),
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Счет: $score',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                currentExpression,
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'Monospace',
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _handleAnswer(true),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('ИСТИНА'),
                ),
                ElevatedButton(
                  onPressed: () => _handleAnswer(false),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('ЛОЖЬ'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Экран для циклических операций
class LoopOperationsScreen extends StatefulWidget {
  @override
  State<LoopOperationsScreen> createState() => _LoopOperationsScreenState();
}

class _LoopOperationsScreenState extends State<LoopOperationsScreen> {
  final Random _random = Random();
  int currentStep = 0;
  int totalSteps = 3;  // Количество итераций цикла
  int variableA = 0;
  int variableB = 0;
  List<String> iterationHistory = [];
  String currentExpression = '';
  bool correctAnswer = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    _startNewLoop();
  }

  void _startNewLoop() {
    currentStep = 0;
    iterationHistory = [];
    _generateNextIteration();
  }

  void _generateNextIteration() {
    if (currentStep >= totalSteps) {
      _startNewLoop();
      return;
    }

    // Генерируем новые значения для переменных
    int prevA = variableA;
    int prevB = variableB;
    
    // Генерируем новые значения (от 1 до 20)
    variableA = _random.nextInt(20) + 1;
    variableB = _random.nextInt(20) + 1;

    // Добавляем в историю предыдущие значения и операцию
    if (currentStep > 0) {
      iterationHistory.add(
        'Шаг $currentStep: a = $prevA + $variableA = ${prevA + variableA}, '
        'b = $prevB + $variableB = ${prevB + variableB}'
      );
    }

    // Случайно выбираем тип сравнения
    bool compareFirst = _random.nextBool();
    String operation = _random.nextBool() ? '>' : '<';
    
    setState(() {
      currentExpression = '''
Итерация ${currentStep + 1} из $totalSteps:

${iterationHistory.join('\n')}

Текущие значения:
a = ${currentStep > 0 ? '${prevA + variableA}' : variableA}
b = ${currentStep > 0 ? '${prevB + variableB}' : variableB}

На следующем шаге:
a += $variableA
b += $variableB

Верно ли что: ${compareFirst ? 'a' : 'b'} $operation ${compareFirst ? 'b' : 'a'}?
''';

      // Вычисляем правильный ответ
      int finalA = currentStep > 0 ? prevA + variableA : variableA;
      int finalB = currentStep > 0 ? prevB + variableB : variableB;
      
      correctAnswer = compareFirst
          ? (operation == '>' ? finalA > finalB : finalA < finalB)
          : (operation == '>' ? finalB > finalA : finalB < finalA);
    });
  }

  void _handleAnswer(bool userAnswer) {
    bool isCorrect = userAnswer == correctAnswer;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? 'Правильно!' : 'Неправильно!'),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
        duration: const Duration(seconds: 1),
      ),
    );

    if (isCorrect) {
      setState(() {
        score++;
      });
    }

    currentStep++;
    _generateNextIteration();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Циклические операции'),
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LogicExpressionsScreen(),
              ),
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Счет: $score',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                currentExpression,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Monospace',
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _handleAnswer(true),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('ИСТИНА'),
                ),
                ElevatedButton(
                  onPressed: () => _handleAnswer(false),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('ЛОЖЬ'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}