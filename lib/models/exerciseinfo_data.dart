class ExerciseInfo {
  final String sets;
  final String reps;
  final String weight;
  bool isCompleted;

  ExerciseInfo(
      {required this.reps,
      required this.sets,
      required this.weight,
      this.isCompleted = false});
}
