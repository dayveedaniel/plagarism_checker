import 'package:fluent_ui/fluent_ui.dart';
import 'package:windows_app/ui/shingle_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FluentApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            //primarySwatch: Colors.blue,
            ),
        home: const ShingleApp()

        );
  }
}
