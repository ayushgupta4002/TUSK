import 'package:baki/models/exerciseinfo_data.dart';

class Exercise {
  final String exerciseName;
  final List<ExerciseInfo> exerciseInfo;

  // final String set;
  // final String reps;
  // final String weight;
  // bool isCompleted;

  Exercise({required this.exerciseName, required this.exerciseInfo});
}
