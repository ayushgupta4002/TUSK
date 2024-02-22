// import 'package:baki/models/exercise.dart';
// import 'package:baki/models/exerciseinfo_data.dart';
import 'package:baki/models/exercise.dart';
import 'package:baki/models/exerciseinfo_data.dart';
import 'package:baki/models/workout.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class HiveDb {
  final _mybox = Hive.box("Tusk_dbs");

  bool prevDataExists() {
    if (_mybox.isEmpty) {
      print("no prev data exist");
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(now);

      _mybox.put("START_DATE", formattedDate);
      return false;
    } else {
      print("prev data exists");
      return true;
    }
  }

  void saveToDb(List<Workout> workoutList) {
    //convert all three into lists
    final daysList = convertDaysInfotoList(workoutList);
    final exercisesAndInfo = exerciseInfoToList(workoutList);
    final exercise = convertExercisestoList(workoutList);
    _mybox.put("DAYSLIST", daysList);
    _mybox.put("EXERCISES", exercise);

    _mybox.put("EXERCISE_INFO", exercisesAndInfo);
  }

  List<Workout> readFromDb() {
    List<Workout> savedWorkout = [];
    print(_mybox.get("DAYSLIST"));
    print(_mybox.get("EXERCISES"));

    print(_mybox.get("EXERCISE_INFO"));

    final daysList = _mybox.get("DAYSLIST");
    final exercisesList = _mybox.get("EXERCISES");

    final exercisesInfo = _mybox.get("EXERCISE_INFO");

    for (int i = 0; i < daysList.length; i++) {
      String name = daysList[i][0].toString();
      String date = daysList[i][1].toString();
      String time = daysList[i][2].toString();
      List<Exercise> exercises = [];

      for (int j = 0; j < exercisesList[i].length; j++) {
        String exerciseNames = exercisesList[i][j];
        List<ExerciseInfo> exerciseInfo = [];

        for (int k = 0; k < exercisesInfo[i][j].length; k++) {
          exerciseInfo.add(ExerciseInfo(
              reps: exercisesInfo[i][j][k][1].toString(),
              sets: exercisesInfo[i][j][k][0].toString(),
              weight: exercisesInfo[i][j][k][2].toString()));
        }
        exercises.add(
            Exercise(exerciseName: exerciseNames, exerciseInfo: exerciseInfo));
      }
      savedWorkout.add(
        Workout(
          name: name,
          exercises: exercises,
          date: date,
          time: time,
        ),
      );
    }
    return savedWorkout;
  }
}

List<List<String>> convertExercisestoList(List<Workout> workoutList) {
  List<List<String>> exercises = [];
  for (var i = 0; i < workoutList.length; i++) {
    List<Exercise> exerciseobj = workoutList[i].exercises;
    List<String> individualExercise = [];
    for (var j = 0; j < exerciseobj.length; j++) {
      individualExercise.add(
        workoutList[i].exercises[j].exerciseName,
      );
    }
    exercises.add(individualExercise);
  }
  return exercises;
}

List<List<String>> convertDaysInfotoList(List<Workout> workoutList) {
  List<List<String>> days = [];
  for (var i = 0; i < workoutList.length; i++) {
    days.add([
      workoutList[i].name,
      workoutList[i].date,
      workoutList[i].time,
    ]);
  }
  return days;
}

List<List<List<List<String>>>> exerciseInfoToList(List<Workout> workoutList) {
  List<List<List<List<String>>>> alldayinfo = [];
  for (var i = 0; i < workoutList.length; i++) {
    List<List<List<String>>> dayinfo = [];
    for (var j = 0; j < workoutList[i].exercises.length; j++) {
      List<List<String>> exerciseInfo = [];
      for (var k = 0;
          k < workoutList[i].exercises[j].exerciseInfo.length;
          k++) {
        List<String> setInfo = [
          workoutList[i].exercises[j].exerciseInfo[k].sets,
          workoutList[i].exercises[j].exerciseInfo[k].reps,
          workoutList[i].exercises[j].exerciseInfo[k].weight,
        ];
        exerciseInfo.add(setInfo);
      }
      dayinfo.add(exerciseInfo);
    }
    alldayinfo.add(dayinfo);
  }

  return alldayinfo;
}



//[[12  jan 2024 , 5:08pm , chest ],[13  jan 2024 , 5:08pm , chest ],[14  jan 2024 , 5:08pm , chest ]]
// [
//   day1[
//     [["Bench Press"], [["1", "8", "40"], ["2", "8", "45"], ["3", "7", "50"]]],
//     ["Cable Fly", [["1", "10", "30"], ["2", "10", "35"], ["3", "8", "40"]]]
//   ],
//   day 2[
//     ["Chest Press", [["1", "8", "40"], ["2", "8", "45"], ["3", "7", "50"]]],
//     ["Shoulder Press", [["1", "10", "30"], ["2", "10", "35"], ["3", "8", "40"]]]
//   ]
// ]



//[[bench press, cable fly],[chest press, shoulder],[leg press, squats]];
//[
// day1[
//   bench press [[1,5,40],[2,5,40][3,5,50]]
//   cable fly   [[1,5,40],[2,5,40][3,5,50]]
// ]
//
// [
//   chest press [[1,5,40],[2,5,40][3,5,50]]
//    shoulder [1,5,40],[2,5,40][3,5,50]]
// ]
//]


//  [
//   [
//    Bench Press [[1, 8, 40], [2, 8, 45], [3, 7, 45]],
//     leg Press [[1, 8, 40], [2, 8, 45], [3, 7, 45]]
//   ], 
//   [
//    bench press [[1, 11, 45], [2, 11, 50], [3, 11, 50]],
//     chest fly [[1, 12, 12], [2, 10, 18], [3, 9, 18]]
//   ]
// ]
