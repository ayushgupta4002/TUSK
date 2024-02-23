import 'package:baki/data/hive_db.dart';
import 'package:baki/models/exercise.dart';
import 'package:baki/models/exerciseinfo_data.dart';
import 'package:baki/models/workout.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkoutData extends ChangeNotifier {
  final db = HiveDb();
  List<Workout> workoutList = [
    Workout(
      name: "Demo Workout",
      exercises: [
        Exercise(exerciseName: "Demo Exercise", exerciseInfo: [
          ExerciseInfo(reps: "8", sets: "1", weight: "40"),
          ExerciseInfo(reps: "8", sets: "2", weight: "45"),
          ExerciseInfo(reps: "7", sets: "3", weight: "45"),
        ]),
        Exercise(exerciseName: "Demo Exercise", exerciseInfo: [
          ExerciseInfo(reps: "8", sets: "1", weight: "40"),
          ExerciseInfo(reps: "8", sets: "2", weight: "45"),
          ExerciseInfo(reps: "7", sets: "3", weight: "45"),
        ]),
      ],
      date: "Demo Workout",
      time: "5:00 pm",
    )
  ];

  void initializeWorkoutList() {
    if (db.prevDataExists()) {
      workoutList = db.readFromDb();
    } else {
      db.saveToDb(workoutList);
    }
  }

  //get all list
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  DateTime createDateTimeObj(String date) {
    DateFormat inputFormat = DateFormat('MMMM d, yyyy', 'en_US');

    // Parse the string into a DateTime object
    DateTime dateTime = inputFormat.parse(date);

    // Extract year, month, and date
    int year = dateTime.year;
    int month = dateTime.month;
    int day = dateTime.day;

    DateTime dateTimeObj = DateTime(year, month, day);

    return dateTimeObj;
  }
  //Total Weight

  double totalWeight(String date, String workoutname) {
    Workout findWorkout = getWorkout(date);
    double total = 0;
    findWorkout.exercises.forEach((exercise) {
      exercise.exerciseInfo.forEach((exercisedata) {
        total += double.parse(exercisedata.weight);
      });
    });
    return total;
  }

  // calculate sets

  int calculateSets(String date, String workoutname) {
    Workout findWorkout = getWorkout(date);
    int total = 0;
    findWorkout.exercises.forEach((exercise) {
      exercise.exerciseInfo.forEach((exercisedata) {
        total += 1;
      });
    });
    return total;
  }

//remove workout
  void removeWorkout(String date, String time) {
    workoutList
        .removeWhere((workout) => workout.date == date && workout.time == time);
    notifyListeners();
    db.saveToDb(workoutList);
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
    db.saveToDb(workoutList);
  }

  //add exercise

  void addExercise(String date, String ExerciseName) {
    Workout findWorkout = getWorkout(date);
    findWorkout.exercises
        .add(Exercise(exerciseName: ExerciseName, exerciseInfo: []));
    notifyListeners();
    db.saveToDb(workoutList);
  }

  //delete exercise

  void delExercise(String date, String exerciseName) {
    Workout findWorkout = getWorkout(date);
    findWorkout.exercises
        .removeWhere((exercise) => exercise.exerciseName == exerciseName);
    notifyListeners();
    db.saveToDb(workoutList);
  }
  //add exercise info

  void addExerciseInfo(String date, String ExerciseName, String weight,
      String reps, String set) {
    Exercise findExercise = getExercise(date, ExerciseName);
    findExercise.exerciseInfo
        .add(ExerciseInfo(reps: reps, sets: set, weight: weight));
    notifyListeners();
    db.saveToDb(workoutList);
  }

  // del exercise info

  void delExerciseInfo(String date, String exerciseName, String set) {
    Exercise findExercise = getExercise(date, exerciseName);
    findExercise.exerciseInfo.removeWhere((exercise) => exercise.sets == set);

    for (int i = 0; i < findExercise.exerciseInfo.length; i++) {
      findExercise.exerciseInfo[i] = ExerciseInfo(
        reps: findExercise.exerciseInfo[i].reps,
        sets: (i + 1).toString(),
        weight: findExercise.exerciseInfo[i].weight,
      );
    }

    notifyListeners();
    db.saveToDb(workoutList);
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

  //get start date
  String getStartDate() {
    return db.getStartDate();
  }

  Map<DateTime, int> heatMapDataset = {};
  void loadHeatMap() {
    DateTime startDate = createDateTimeObj(getStartDate());
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i < daysInBetween + 1; i++) {}
  }
}
