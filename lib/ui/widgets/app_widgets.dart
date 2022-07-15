import 'package:fluent_ui/fluent_ui.dart';
import 'package:windows_app/ui/store.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  const CustomButton({Key? key, required this.title, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
        child: Text(title),
      ),
      onPressed: onPressed,
    );
  }
}

class Toggle extends StatefulWidget {
  const Toggle({Key? key}) : super(key: key);

  @override
  State<Toggle> createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
  bool _checked = true;
  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
        checked: _checked,
        onChanged: (v) => setState(() => _checked = v),
        content: const Text('Remove linking words'));
  }
}

class ShingleSlider extends StatefulWidget {
final FileStore store;

  const ShingleSlider({Key? key,required this.store}) : super(key: key);

  @override
  State<ShingleSlider> createState() => _ShingleSliderState();
}

class _ShingleSliderState extends State<ShingleSlider> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Slider(
        min: 3,
        max: 10,
        divisions: 7,
        value: widget.store.shingleLenght,
        onChanged: (v) => setState(() => widget.store.shingleLenght = v),
        label: '${widget.store.shingleLenght.toInt()}',
      ),
    );
  }
}

class FilterSlider extends StatefulWidget {
final FileStore store;

  const FilterSlider({Key? key,required this.store}) : super(key: key);

  @override
  State<FilterSlider> createState() => _FilterSliderState();
}

class _FilterSliderState extends State<FilterSlider> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Slider(
        min: 0,
        max: 100,
        divisions: 100,
        value: widget.store.filterResult.value,
        onChanged: (v) => setState(() => widget.store.filterResult.value = v),
        label: '${widget.store.filterResult.value.toInt()}',
      ),
    );
  }
}
