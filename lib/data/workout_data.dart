import 'package:baki/models/exercise.dart';
import 'package:baki/models/exerciseinfo_data.dart';
import 'package:baki/models/workout.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkoutData extends ChangeNotifier {
  List<Workout> workoutList = [
    Workout(
      name: "Chest",
      exercises: [
        Exercise(exerciseName: "Bench Press", exerciseInfo: [
          ExerciseInfo(reps: "8", sets: "1", weight: "40"),
          ExerciseInfo(reps: "8", sets: "2", weight: "45"),
          ExerciseInfo(reps: "7", sets: "3", weight: "45"),
        ])
      ],
      date: "12 jan 2024",
      time: "5:00 pm",
    )
  ];

  //get all list
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  //Total Weight

  int totalWeight(String date, String workoutname) {
    Workout findWorkout = getWorkout(date);
    int total = 0;
    findWorkout.exercises.forEach((exercise) {
      exercise.exerciseInfo.forEach((exercisedata) {
        total += int.parse(exercisedata.weight);
      });
    });
    return total;
  }

//remove workout
  void removeWorkout(String date, String time) {
    workoutList
        .removeWhere((workout) => workout.date == date && workout.time == time);
    notifyListeners();
  }

  //add workout
  void addWorkout(String name) {
    final now = DateTime.now();
    String formatter = DateFormat.yMMMMd('en_US').format(now);

    workoutList.add(Workout(
        name: name,
        date: formatter.toString(),
        time: DateFormat.jm().format(now),
        exercises: []));
    notifyListeners();
  }

  //add exercise

  void addExercise(String date, String ExerciseName) {
    Workout findWorkout = getWorkout(date);
    findWorkout.exercises
        .add(Exercise(exerciseName: ExerciseName, exerciseInfo: []));
    notifyListeners();
  }

  //add exercise info

  void addExerciseInfo(String date, String ExerciseName, String weight,
      String reps, String set) {
    Exercise findExercise = getExercise(date, ExerciseName);
    findExercise.exerciseInfo
        .add(ExerciseInfo(reps: reps, sets: set, weight: weight));
  }

  //checkoff the box
  // void checkBox(String workoutName, String exercise) {
  //   Exercise findExercise = getExercise(workoutName, exercise);
  //   findExercise.ex = !findExercise.isCompleted;
  //   notifyListeners();
  // }

  int numberofExercisesinWorkout(String date) {
    Workout findWorkout = getWorkout(date);

    return findWorkout.exercises.length;
  }

  //find a Workout
  Workout getWorkout(String date) {
    Workout findWorkout =
        workoutList.firstWhere((workout) => workout.date == date);
    return findWorkout;
  }

  //find exercise
  Exercise getExercise(String date, String exerciseName) {
    Workout findWorkout = getWorkout(date);
    Exercise findExercise = findWorkout.exercises
        .firstWhere((exercise) => exercise.exerciseName == exerciseName);
    return findExercise;
  }
}
