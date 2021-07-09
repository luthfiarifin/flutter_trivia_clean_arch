import 'package:flutter/material.dart';
import 'package:flutter_trivia_clean_arch/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primaryColor: Colors.blue.shade800,
        accentColor: Colors.blue.shade600,
      ),
      home: NumberTriviaPage(),
    );
  }
}
