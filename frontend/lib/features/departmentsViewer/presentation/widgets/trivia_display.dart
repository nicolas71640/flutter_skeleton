import 'package:avecpaulette/features/departmentsViewer/domain/entities/number_trivia.dart';
import 'package:flutter/material.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia numberTrivia;

  const TriviaDisplay({
    Key? key,
    required this.numberTrivia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(numberTrivia.number.toString(),
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  )),
              Text(
                numberTrivia.text,
                style: const TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
