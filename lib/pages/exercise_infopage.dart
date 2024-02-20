import 'dart:async';

import 'package:baki/data/workout_data.dart';
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
  static const minSeconds = 0;
  int seconds = minSeconds;
  Timer? timer;

  void backfn() {
    Navigator.of(context).pop();
  }

  void startTimer() {
    if (timer == null || !timer!.isActive) {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
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
                onPressed: () {},
              ),
              body: Column(
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
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    child: Text("Let's Go",
                        style: TextStyle(
                            fontSize: 23,
                            color: Colors.white,
                            fontWeight: FontWeight.w300)),
                  ),

                  SizedBox(height: 10),
                  //clock
                  Center(
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: Stack(fit: StackFit.expand, children: [
                        CircularProgressIndicator(
                          value: seconds / 60,
                          strokeWidth: 10,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                          backgroundColor: Colors.grey.shade800,
                        ),
                        Center(
                          child: Text(seconds.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 50)),
                        ),
                      ]),
                    ),
                  ),
                  SizedBox(height: 20),
                  //button for clock
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: ButtonWidget(
                              text: timer == null
                                  ? "Pause Timer"
                                  : timer!.isActive
                                      ? "Pause Timer"
                                      : "Resume Timer",
                              startTimer: timer == null
                                  ? pauseTimer
                                  : timer!.isActive
                                      ? pauseTimer
                                      : startTimer,
                            ),
                          ),
                          Expanded(
                            child: ButtonWidget(
                              text: "Start Timer",
                              startTimer: startTimer,
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
                  ),
                  Center(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.white),
                      child: DataTable(columns: const [
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
                      ], rows: [
                        DataRow(cells: [
                          DataCell(
                              Text('1', style: TextStyle(color: Colors.white))),
                          DataCell(Text('Arshik',
                              style: TextStyle(color: Colors.white))),
                          DataCell(Text('5644645',
                              style: TextStyle(color: Colors.white))),
                        ])
                      ]),
                    ),
                  )
                ],
              ),
            ));
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
