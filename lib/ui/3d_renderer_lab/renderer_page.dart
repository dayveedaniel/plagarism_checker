import 'package:fluent_ui/fluent_ui.dart';
import 'package:windows_app/ui/3d_renderer_lab/renderer.dart';

class RendererPage extends StatefulWidget {
  const RendererPage({Key? key}) : super(key: key);

  @override
  State<RendererPage> createState() => _RendererPageState();
}

class _RendererPageState extends State<RendererPage> {
  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        SliverFillRemaining(
          child: Column(
            children: [
              _ToolBar(),
              Expanded(child: Renderer()),
            ],
          ),
        ),
      ],
    );
  }
}

class _ToolBar extends StatelessWidget {
  const _ToolBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            width:20,
            height: 20,
            decoration: BoxDecoration(
              border: Border.all(),
            ),
          )
        ],
      ),
    );
  }
}
