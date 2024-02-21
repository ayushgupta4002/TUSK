import 'package:baki/data/workout_data.dart';
import 'package:baki/pages/exercise_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// void createWorkout(Context ) {
//   showDialog(context: context, builder: builder)
// }

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }

  var borderRadius = BorderRadius.circular(12);

  void save() {
    Provider.of<WorkoutData>(context, listen: false)
        .addWorkout(newWorkoutNameController.text);
    Navigator.pop(context);
    newWorkoutNameController.clear();
  }

  void goToExercisePage(String name, String date) {
    print(date);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ExercisePage(
          workoutName: name,
          date: date,
        ),
      ),
    );
  }

  final newWorkoutNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
        builder: (context, value, child) => Scaffold(
            backgroundColor: const Color(0xff0d0d0d),
            appBar: AppBar(
              titleTextStyle:
                  TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              title: const Center(child: Text("T U S K")),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.grey.shade700,
                child: const Icon(Icons.add),
                onPressed: () {
                  dialog(context);
                }),
            body: ListView.builder(
              itemCount: value.getWorkoutList().length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    goToExercisePage(value.getWorkoutList()[index].name,
                        value.getWorkoutList()[index].date);
                  },
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 17),
                    shape: RoundedRectangleBorder(borderRadius: borderRadius),
                    tileColor: const Color(0xff0b211f),
                    title: Text(
                      value.getWorkoutList()[index].date,
                      style: const TextStyle(fontSize: 22, color: Colors.white),
                    ),
                    subtitle: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Chip(
                              label: Text(value.getWorkoutList()[index].time)),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline_outlined),
                      color: Colors.white,
                      onPressed: () => value.removeWorkout(
                          value.getWorkoutList()[index].date,
                          value.getWorkoutList()[index].time),
                    ),
                  ),
                ),
              ),
            )));
  }

  Future<dynamic> dialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: const Text("Add Workout"),
            content: TextField(
              controller: newWorkoutNameController,
              decoration: const InputDecoration(hintText: "Remarks (Optional)"),
            ),
            actions: [
              MaterialButton(
                onPressed: save,
                child: const Text("Save"),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  newWorkoutNameController.clear();
                },
                child: const Text("Cancel"),
              )
            ],
          )),
    );
  }
}
