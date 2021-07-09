import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_trivia_clean_arch/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key? key,
  }) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final triviaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: triviaController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => onGetTrivia(),
                child: Text('Search'),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () => onRandomTrivia(),
                child: Text('Get random trivia'),
              ),
            ),
          ],
        )
      ],
    );
  }

  void onGetTrivia() {
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaConcreteNumber(triviaController.text));
    triviaController.clear();
  }

  void onRandomTrivia() {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetRandomConcreteNumber());
  }
}
