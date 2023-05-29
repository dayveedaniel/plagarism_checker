import 'package:fluent_ui/fluent_ui.dart';
import 'package:windows_app/ui/pages/home_page.dart';
import 'package:windows_app/ui/pages/result_page.dart';
import 'package:windows_app/ui/store.dart';
import '3d_renderer_lab/renderer_page.dart';

final FileStore store = FileStore();

class ShingleApp extends StatefulWidget {
  const ShingleApp({Key? key}) : super(key: key);

  @override
  State<ShingleApp> createState() => _ShingleAppState();
}

class _ShingleAppState extends State<ShingleApp> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: store.hasNotif,
        builder: (context, bool hasNewResult, child) {
          return NavigationView(
            appBar: NavigationAppBar(
                backgroundColor: Colors.blue,
                height: 50,
                title: const Text(
                  "Plagarism",
                  style: TextStyle(
                    fontSize: 30,
                    overflow: TextOverflow.ellipsis,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                )),
            pane: NavigationPane(
              selected: _index,
              onChanged: ((value) => setState(() {
                    _index = value;
                    if (_index == 1) {
                      store.hasNotif.value = false;
                    }
                  })),
              items: [
                PaneItem(
                  icon: const Icon(FluentIcons.boards),
                  title: const Text("Home"),
                  body: MyHomePage(),
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.add_event),
                  title: const Text("Results"),
                  infoBadge: hasNewResult
                      ? InfoBadge(
                          color: Colors.blue,
                        )
                      : null,
                  body: ResultPage(
                    fileStore: store,
                  ),
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.admin),
                  title: const Text("RENDER"),
                  body: const RendererPage(),
                ),
              ],
              size: const NavigationPaneSize(openMaxWidth: 150),
            ),
          );
        });
  }
}
