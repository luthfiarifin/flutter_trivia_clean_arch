import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_trivia_clean_arch/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_trivia_clean_arch/features/number_trivia/presentation/widgets/loading_widget.dart';
import 'package:flutter_trivia_clean_arch/features/number_trivia/presentation/widgets/message_display.dart';
import 'package:flutter_trivia_clean_arch/features/number_trivia/presentation/widgets/trivia_controls.dart';
import 'package:flutter_trivia_clean_arch/features/number_trivia/presentation/widgets/trivia_display.dart';
import 'package:flutter_trivia_clean_arch/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }

  buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Error) {
                    return MessageDisplay(message: state.message);
                  } else if (state is Loading) {
                    return LoadingWidget();
                  } else if (state is Loaded) {
                    return TriviaDisplay(trivia: state.trivia);
                  }
                  return MessageDisplay(message: 'Start Searching!');
                },
              ),
              SizedBox(
                height: 20,
              ),
              TriviaControls(),
            ],
          ),
        ),
      ),
    );
  }
}
