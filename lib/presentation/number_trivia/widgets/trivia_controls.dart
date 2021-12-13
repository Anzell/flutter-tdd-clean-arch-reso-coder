import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tddflutter/presentation/number_trivia/controller/bloc/number_trivia_controller_bloc.dart';

class TriviaControls extends StatefulWidget {
  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();
  late String inputStr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Input a number",
          ),
          onChanged: (value) => inputStr = value,
          onSubmitted: (_) => _dispatchConcrete(),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _dispatchConcrete(),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)),
                child: Text("Search"),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _dispatchRandom(),
                child: Text("Get random trivia"),
              ),
            )
          ],
        )
      ],
    );
  }

  void _dispatchConcrete() {
    controller.clear();
    BlocProvider.of<NumberTriviaControllerBloc>(context).add(GetTriviaForConcreteNumber(numberString: inputStr));
  }

  void _dispatchRandom() {
    controller.clear();
    BlocProvider.of<NumberTriviaControllerBloc>(context).add(GetTriviaForRandomNumber());
  }
}
