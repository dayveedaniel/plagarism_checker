import 'package:fluent_ui/fluent_ui.dart';
import 'package:windows_app/ui/shingle_app.dart';
import 'package:windows_app/ui/widgets/app_widgets.dart';

const Widget _divider = Padding(
  padding: EdgeInsets.symmetric(vertical: 10.0),
  child: Divider(),
);

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.grey.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: const Card(child: PickedFileList()))),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    flex: 2,
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: ContentView()))
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                CustomButton(
                  title: 'Choose Files',
                  onPressed: () {
                    store.pickFiles();
                  },
                ),
                const SizedBox(width: 50),
                CustomButton(
                  title: 'Calculate All',
                  onPressed: () {
                    store.runAll();
                  },
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(FluentIcons.settings_add),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return ContentDialog(
                            constraints: const BoxConstraints(
                                maxHeight: 600, maxWidth: 360),
                            title: const Text('Settings'),
                            actions: [
                              CustomButton(
                                  title: 'OK',
                                  onPressed: () {
                                    store.initShingles();
                                    Navigator.pop(context);
                                  })
                            ],
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShingleSlider(store: store),
                                const Text('Shingle lenght'),
                                const SizedBox(height: 20),
                                const Toggle()
                              ],
                            ),
                          );
                        });
                  },
                  style: ButtonStyle(
                      iconSize: ButtonState.all(30.0),
                      foregroundColor: ButtonState.all(Colors.blue)),
                ),
                const SizedBox(width: 50),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PickedFileList extends StatelessWidget {
  const PickedFileList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: store.fileNames,
        builder: (BuildContext context, List<String> content, child) {
          return Column(
            children: [
              ProgressBar(),
              Text(
                'Selected Files  (${content.length})',
              ),
              _divider,
              Expanded(
                child: Scrollbar(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: content.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: FilledButton(
                                    child: Text(
                                      content[index],
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                    onPressed: () {
                                      store.setFileContent(
                                        key: content[index],
                                      );
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(FluentIcons.cancel),
                                  onPressed: () {
                                    store.deleteFile(index);
                                  },
                                )
                              ],
                            ),
                          );
                        })),
              ),
            ],
          );
        });
  }
}

class ContentView extends StatelessWidget {
  final _controller = ScrollController();
  ContentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const Text("File Contents"),
          _divider,
          Expanded(
            child: Scrollbar(
              controller: _controller,
              child: SingleChildScrollView(
                  controller: _controller,
                  child: ValueListenableBuilder(
                      valueListenable: store.fileContent,
                      builder: (BuildContext context, String content, child) {
                        return SelectableText(content);
                      })),
            ),
          )
        ],
      ),
    );
  }
}
