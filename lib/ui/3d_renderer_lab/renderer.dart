import 'package:ditredi/ditredi.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:vector_math/vector_math_64.dart' as v;



class Renderer extends StatefulWidget {
  const Renderer({Key? key}) : super(key: key);

  @override
  State<Renderer> createState() => _RendererState();
}

class _RendererState extends State<Renderer> {

  late final DiTreDiController controller;
  @override
  void initState() {
    super.initState();
    controller = DiTreDiController();

  }
  @override
  Widget build(BuildContext context) {
    return DiTreDiDraggable(
      controller: controller,
      child: DiTreDi(
        controller: controller,
        figures: [
          Cube3D(
            10,
            v.Vector3(0, 0, 0),
            color: Colors.red
          ),
        ],
      ),
    );
  }
}
