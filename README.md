# Тренажер устного счета

Приложение для тренировки математических и логических навыков, разработанное на Flutter.

## Быстрый старт

1. **Автоматическая установка**:
   ```bash
   # Сделать скрипт исполняемым
   chmod +x setup.sh
   
   # Запустить установку
   ./setup.sh
   ```

2. **Ручная установка**:
   ```bash
   # Клонировать репозиторий
   git clone https://github.com/evgeniygazetdinov/mind_count.git
   cd mind_count
   
   # Установить зависимости
   flutter pub get

   # собрать апк 
   flutter build apk
   # путь апк build/app/outputs/flutter-apk/app-release.apk
   ```

## Возможности

### 1. Математические операции

#### Режимы работы:
- **Ascending Mode**: Числа увеличиваются последовательно (1, 2, 3, ...)
- **Random Mode**: Оба числа генерируются случайным образом

#### Система уровней:
- Уровень 1: числа от 1 до 5
- Уровень 2: числа от 1 до 10
- Уровень 3: числа от 1 до 15
- Повышение уровня каждые 5 правильных ответов

### 2. Логические операции

#### 2.1 Булевы операции
- Работа с логическими переменными (true/false)
- Операции: И, ИЛИ, НЕ
- Пошаговое выполнение с разными переменными
- История предыдущих операций

#### 2.2 Монотонные последовательности
- Работа со случайными числовыми последовательностями
- Определение характера последовательности (возрастающая/убывающая)
- Пошаговое сравнение элементов
- Анализ монотонности последовательности

## Как это работает

### Математический режим
1. Выберите режим (Ascending/Random)
2. Решайте примеры на сложение
3. Получайте мгновенный результат
4. Уровень повышается автоматически

### Логический режим
1. Выберите тип задач (Булевы/Монотонные)
2. Следуйте инструкциям на экране
3. Анализируйте последовательности или решайте логические выражения
4. Получайте обратную связь о правильности решения

## Технологии

- Flutter
- Dart

## Требования

- Flutter SDK
- Dart SDK
- Android Studio / VS Code с плагином Flutter

## Структура проекта

```
lib/
├── main.dart                      # Точка входа приложения
├── screens/           
│   ├── home_screen.dart          # Главный экран с выбором режима
│   ├── math_trainer_screen.dart  # Экран математических операций
│   ├── logic_expression_screen.dart # Экран логических операций
│   └── number_generator.dart     # Утилиты для генерации чисел
```

## Лицензия

MIT License