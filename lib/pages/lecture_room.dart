import 'package:elms/widgets/default_appbar.dart';
import 'package:flutter/material.dart';

class LectureRoom extends StatelessWidget {
  const LectureRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: defaultAppbar("Lecture Room"),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(
            height: 10,
          ),
        ]),
      ),
    );
  }
}
