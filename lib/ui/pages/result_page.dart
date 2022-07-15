import 'package:fluent_ui/fluent_ui.dart';
import 'package:windows_app/models/shingle_result_model.dart';
import 'package:windows_app/ui/shingle_app.dart';
import 'package:windows_app/ui/store.dart';
import 'package:windows_app/ui/widgets/app_widgets.dart';

class ResultPage extends StatelessWidget {
  final FileStore fileStore;

  const ResultPage({Key? key, required this.fileStore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.2),
      width: double.maxFinite,
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Card(
                      backgroundColor: Colors.white,
                      child: ValueListenableBuilder(
                        valueListenable: store.result,
                        builder: (BuildContext context,
                            List<ShingleResult> content, child) {
                          if (content.isEmpty) {
                            return const Text('No data yet');
                          } else {
                            return ResultsBuilder(results: store.result.value);
                          }
                        },
                      )),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Card(
                      backgroundColor: Colors.white,
                      child: ValueListenableBuilder(
                          valueListenable: store.cluster,
                          builder: (context, List<List<String>> value, child) {
                            return ListView(
                              controller: ScrollController(),
                              children: [
                                const Text("Clusters"),
                                const Divider(),
                                ...value.map((e) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Text(e.toString()),
                                    ))
                              ],
                            );
                          })),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              FilterSlider(store: store),
              const SizedBox(
                width: 20,
              ),
              ValueListenableBuilder(
                  valueListenable: store.filterResult,
                  builder: (context, double val, child) {
                    return Text("Filter value:  ${val.toStringAsFixed(2)} %");
                  }),
              const SizedBox(
                width: 80,
              ),
              Expanded(
                child: CustomButton(
                  title: 'Calculate Cluster',
                  onPressed: () {
                    store.runCluster();
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ResultsBuilder extends StatelessWidget {
  final List<ShingleResult> results;

  const ResultsBuilder({Key? key, required this.results}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            final result = results[index];
            return ValueListenableBuilder(
                valueListenable: store.filterResult,
                builder: (context, double val, child) {
                  return result.results.values.any((element) => element >= val)
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Base File Name : ${result.baseFileName}",
                                    style: const TextStyle(fontSize: 20),
                                  )),
                                  const Text('Percent Plagarism '),
                                ],
                              ),
                              const Divider(),
                              ...result.results.entries
                                  .map((entry) => SizedBox(
                                      child: entry.value >= val
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: Text(entry.key)),
                                                  Text(
                                                      "${entry.value > 100 ? 100.00 : entry.value} %")
                                                ],
                                              ),
                                            )
                                          : null))
                                  .toList(),
                              FractionallySizedBox(
                                widthFactor: 1 / 2,
                                child: IconButton(
                                    icon: Icon(
                                      FluentIcons.cancel,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      store.deleteResult(index);
                                    }),
                              )
                            ],
                          ),
                        )
                      : const SizedBox.shrink();
                });
          }, childCount: results.length, addAutomaticKeepAlives: false))
        ],
      ),
    );
  }
}
