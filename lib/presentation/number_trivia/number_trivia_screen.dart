import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tddflutter/di/injector.dart';
import 'package:tddflutter/presentation/number_trivia/widgets/message_display.dart';
import 'package:tddflutter/presentation/number_trivia/widgets/trivia_controls.dart';
import 'package:tddflutter/presentation/number_trivia/widgets/trivia_display.dart';
import 'package:tddflutter/presentation/shared/widgets/loading_widget.dart';

import 'controller/bloc/number_trivia_controller_bloc.dart';

class NumberTriviaScreen extends StatelessWidget {
  const NumberTriviaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Number Trivia"),
      ),
      body: BlocProvider(
        create: (_) => getIt<NumberTriviaControllerBloc>(),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(height: 10),
                BlocBuilder<NumberTriviaControllerBloc, NumberTriviaControllerState>(
                  builder: (context, state) {
                    switch (state.runtimeType) {
                      case Empty:
                        return MessageDisplay(message: "Start searching");
                      case Loading:
                        return LoadingWidget();
                      case Loaded:
                        return TriviaDisplay(numberTrivia: (state as Loaded).trivia);
                      case Error:
                        return MessageDisplay(message: (state as Error).message);
                      default:
                        return Container(child: Text("Invalid state"));
                    }
                  },
                ),
                SizedBox(height: 20),
                TriviaControls(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
