import 'package:baki/data/workout_data.dart';
import 'package:baki/pages/exercise_infopage.dart';
import 'package:baki/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExercisePage extends StatefulWidget {
  final String workoutName;
  final String date;

  const ExercisePage(
      {super.key, required this.workoutName, required this.date});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  var borderRadius = BorderRadius.circular(12);

  void backfn() {
    Navigator.of(context).pop();
  }

  void homefn() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false);
  }

  final newExerciseNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
        builder: (context, value, child) => Scaffold(
              backgroundColor: const Color(0xff0d0d0d),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 6, top: 2),
                    child: IconWidget(
                      icon: const Icon(Icons.home, color: Colors.white),
                      ontap: homefn,
                    ),
                  )
                ],
                leading: Padding(
                  padding: const EdgeInsets.only(left: 6, top: 2),
                  child: IconWidget(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ontap: backfn,
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.grey.shade700,
                child: const Icon(Icons.add),
                onPressed: () {
                  dialog(context);
                },
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(widget.date,
                        style: const TextStyle(
                            fontSize: 33,
                            color: Colors.white,
                            fontWeight: FontWeight.w500)),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    child: Text("Let's Go",
                        style: TextStyle(
                            fontSize: 23,
                            color: Colors.white,
                            fontWeight: FontWeight.w300)),
                  ),
                  const SizedBox(height: 23),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xffadff6f),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 1),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Container(
                                  width: 150,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color(0xff1a1a1a),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${value.totalWeight(widget.date, widget.workoutName)}",
                                        style: const TextStyle(
                                            fontSize: 30,
                                            color: Color(0xffadff6f)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4, top: 4),
                                        child: Text(
                                          "Kg",
                                          style: TextStyle(
                                              color: Color(0xffadff6f),
                                              fontSize: 24),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  width: 150,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color(0xff1a1a1a),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${value.calculateSets(widget.date, widget.workoutName)}",
                                        style: const TextStyle(
                                            fontSize: 30,
                                            color: Color(0xffadff6f)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4, top: 4),
                                        child: Text(
                                          "Sets",
                                          style: TextStyle(
                                              color: Color(0xffadff6f),
                                              fontSize: 24),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: value.numberofExercisesinWorkout(widget.date) > 0
                        ? ListView.builder(
                            itemCount:
                                value.numberofExercisesinWorkout(widget.date),
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ExerciseInfoPage(
                                            date: widget.date,
                                            exerciseName: value
                                                .getWorkout(widget.date)
                                                .exercises[index]
                                                .exerciseName,
                                          )));
                                },
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: borderRadius),
                                  tileColor: const Color(0xff1a1a1a),
                                  title: Text(
                                    value
                                        .getWorkout(widget.date)
                                        .exercises[index]
                                        .exerciseName,
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline_outlined,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      value.delExercise(
                                        widget.date,
                                        value
                                            .getWorkout(widget.date)
                                            .exercises[index]
                                            .exerciseName,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const Center(
                            child: Text(
                              'Please add a exercise in this workout !',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                  ),
                ],
              ),
            ));
  }

  Future<dynamic> dialog(BuildContext context) {
    var borderRadius = BorderRadius.circular(12);
    return showDialog(
      context: context,
      builder: ((context) => Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                backgroundColor: Colors.grey.shade900,
                shape: RoundedRectangleBorder(
                    borderRadius: borderRadius,
                    side: BorderSide(color: Colors.white)),
                title: Center(
                  child: const Text(
                    "Add Workout",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                content: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14)),
                      fillColor: Colors.grey.shade800,
                      hintText: "Exercise Name",
                      hintStyle: TextStyle(color: Colors.white)),
                  controller: newExerciseNameController,
                ),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      if (newExerciseNameController.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              "Please Add Exercise Name",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.amber,
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        Provider.of<WorkoutData>(context, listen: false)
                            .addExercise(
                                widget.date, newExerciseNameController.text);
                        newExerciseNameController.clear();
                      }

                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}

class IconWidget extends StatelessWidget {
  final Widget icon;
  final void Function()? ontap;
  const IconWidget({super.key, required this.icon, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Container(
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade900),
        child: IconButton(
          icon: icon,
          onPressed: ontap,
        ),
      ),
    );
  }
}
