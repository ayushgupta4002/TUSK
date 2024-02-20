import 'exercise.dart';

class Workout {
  final String name;
  final String date;
  final String time;
  final List<Exercise> exercises;

  Workout(
      {required this.name,
      required this.exercises,
      required this.date,
      required this.time});
}
