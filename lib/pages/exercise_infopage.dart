import 'dart:async';

import 'package:baki/data/workout_data.dart';
import 'package:baki/models/exerciseinfo_data.dart';
import 'package:baki/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'exercise_page.dart';

class ExerciseInfoPage extends StatefulWidget {
  final String date;
  final String exerciseName;
  const ExerciseInfoPage(
      {super.key, required this.exerciseName, required this.date});

  @override
  State<ExerciseInfoPage> createState() => _ExerciseInfoPageState();
}

class _ExerciseInfoPageState extends State<ExerciseInfoPage> {
  final setController = TextEditingController();
  final repscontroller = TextEditingController();
  final weightcontroller = TextEditingController();
  static const minSeconds = 0;
  int seconds = minSeconds;
  Timer? timer;

  void clear() {
    setController.clear();
    repscontroller.clear();
    weightcontroller.clear();
  }

  void backfn() {
    Navigator.of(context).pop();
  }

  void startTimer() {
    if (timer == null || !timer!.isActive) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          seconds++;
        });
      });
    }
  }

  void pauseTimer() {
    timer?.cancel();
  }

  void resetTimer() {
    setState(() {
      seconds = 0;
      timer?.cancel();
    });
  }

  void homefn() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
        builder: (context, value, child) => Scaffold(
              backgroundColor: const Color(0xff0d0d0d),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                actions: [
                  IconWidget(
                    icon: const Icon(Icons.home, color: Colors.white),
                    ontap: homefn,
                  )
                ],
                leading: IconWidget(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ontap: backfn,
                ),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.grey.shade700,
                child: const Icon(Icons.add),
                onPressed: () {
                  dialog(context);
                },
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    //text exercise name
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(widget.exerciseName,
                          style: const TextStyle(
                              fontSize: 33,
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                    ),
                    //text subtitle
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      child: Text("Let's Go",
                          style: TextStyle(
                              fontSize: 23,
                              color: Colors.white,
                              fontWeight: FontWeight.w300)),
                    ),

                    const SizedBox(height: 10),
                    //clock
                    Center(
                      child: SizedBox(
                        height: 150,
                        width: 150,
                        child: Stack(fit: StackFit.expand, children: [
                          CircularProgressIndicator(
                            value: seconds / 60,
                            strokeWidth: 10,
                            valueColor:
                                const AlwaysStoppedAnimation(Colors.white),
                            backgroundColor: Colors.grey.shade800,
                          ),
                          Center(
                            child: Text(seconds.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 50)),
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 20),
                    //button for clock
                    buttons(),
                    Center(
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.white),
                        child: DataTable(
                            columns: const [
                              DataColumn(
                                label: Text(
                                  'Set',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataColumn(
                                label: Text('Reps',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              DataColumn(
                                label: Text('Weights',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                            rows: List.generate(
                                value
                                    .getExercise(
                                        widget.date, widget.exerciseName)
                                    .exerciseInfo
                                    .length, (index) {
                              ExerciseInfo exerciseInfo = value
                                  .getExercise(widget.date, widget.exerciseName)
                                  .exerciseInfo[index];

                              return DataRow(cells: [
                                DataCell(Text(exerciseInfo.sets.toString(),
                                    style:
                                        const TextStyle(color: Colors.white))),
                                DataCell(Text(exerciseInfo.reps,
                                    style:
                                        const TextStyle(color: Colors.white))),
                                DataCell(Text(exerciseInfo.weight,
                                    style:
                                        const TextStyle(color: Colors.white))),
                              ]);
                            })),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

  Future<dynamic> dialog(BuildContext context) {
    var borderRadius = BorderRadius.circular(12);
    int set = Provider.of<WorkoutData>(context, listen: false)
            .getExercise(widget.date, widget.exerciseName)
            .exerciseInfo
            .length +
        1;
    return showDialog(
      context: context,
      builder: ((context) => Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                backgroundColor: Colors.grey.shade100,
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
                title: const Text("Add Workout"),
                content: Column(
                  children: [
                    Text("Set " + set.toString()),
                    TextField(
                      decoration: const InputDecoration(hintText: "Reps Count"),
                      controller: repscontroller,
                    ),
                    TextField(
                      decoration: const InputDecoration(hintText: "Weight"),
                      controller: weightcontroller,
                    ),
                  ],
                ),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      if (repscontroller.text.isEmpty ||
                          weightcontroller.text.isEmpty) {
                        print("please write complete info");
                      } else {
                        int set = Provider.of<WorkoutData>(context,
                                    listen: false)
                                .getExercise(widget.date, widget.exerciseName)
                                .exerciseInfo
                                .length +
                            1;
                        Provider.of<WorkoutData>(context, listen: false)
                            .addExerciseInfo(
                                widget.date,
                                widget.exerciseName,
                                weightcontroller.text,
                                repscontroller.text,
                                set.toString());
                      }

                      Navigator.pop(context);
                      clear();
                    },
                    child: const Text("Save"),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                      clear();
                    },
                    child: const Text("Cancel"),
                  )
                ],
              ),
            ),
          )),
    );
  }

  Widget buttons() {
    final isRunning = timer == null ? false : timer!.isActive;
    return isRunning
        ? Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 58),
              child: Row(
                children: [
                  Expanded(
                    child: ButtonWidget(
                      startTimer: () {
                        if (isRunning) {
                          pauseTimer();
                        } else {
                          startTimer();
                        }
                      },
                      text: isRunning ? "Pause Timer" : "Resume Timer",
                    ),
                  ),
                  Expanded(
                    child: ButtonWidget(
                      text: "Reset Timer",
                      startTimer: resetTimer,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Center(
            child: ButtonWidget(
              text: "Start Timer",
              startTimer: startTimer,
            ),
          );
  }
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final Function()? startTimer;
  const ButtonWidget({super.key, required this.text, required this.startTimer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: ElevatedButton(
          onPressed: startTimer,
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12)),
          child: Text(
            text,
            style: const TextStyle(color: Colors.black, fontSize: 15),
          )),
    );
  }
}
