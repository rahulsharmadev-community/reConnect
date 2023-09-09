import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jars/jars.dart';
import 'package:reConnect/utility/extensions.dart';

class SwitchTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Function(bool)? onChanged;
  final bool value;
  final Icon selectedThumb;
  final Icon? unSelectedThumb;

  const SwitchTile({
    super.key,
    this.subtitle,
    this.onChanged,
    required this.title,
    required this.value,
    this.unSelectedThumb,
    this.selectedThumb = const Icon(Icons.check),
  });

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle!).opacity(0.7) : null,
        onTap: onChanged != null ? () => onChanged!(!value) : null,
        trailing: Switch(
          activeColor: context.appTheme.colorScheme.primary,
          thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Icon(selectedThumb.icon,
                  color: Theme.of(context).colorScheme.background);
            }
            return unSelectedThumb; // All other states will use the default thumbIcon.
          }),
          onChanged: onChanged,
          value: value,
        ),
      );
}

class SliderTile extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Function(double)? onDone;
  final Icon selectedThumb;
  final Icon? unSelectedThumb;
  final double min, max, initalValue;
  final int? divisions;

  const SliderTile({
    super.key,
    this.subtitle,
    this.onDone,
    required this.initalValue,
    required this.title,
    this.unSelectedThumb,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.selectedThumb = const Icon(Icons.check),
  });

  @override
  State<SliderTile> createState() => _SliderTileState();
}

class _SliderTileState extends State<SliderTile> {
  late ValueNotifier<double> value;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    value = ValueNotifier(widget.initalValue);
  }

  onChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      widget.onDone!(value.value);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.subtitle != null) Text(widget.subtitle!).opacity(0.7),
          Card(
            child: ValueListenableBuilder<double>(
              valueListenable: value,
              builder: (ctx, value, child) => Slider.adaptive(
                  max: widget.max,
                  min: widget.min,
                  divisions: widget.divisions,
                  label: this.value.value.toString(),
                  value: this.value.value,
                  onChanged: (value) {
                    this.value.value = value;
                    onChanged();
                  }),
            ),
          )
        ],
      ),
    );
  }
}

class DialogTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String trailing;
  final List<String> list;
  final Function(String)? onChanged;

  const DialogTile({
    super.key,
    this.subtitle,
    this.onChanged,
    required this.title,
    required this.trailing,
    required this.list,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle!).opacity(0.7) : null,
        onTap: onChanged != null
            ? () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: Text(title),
                      children: list
                          .map((e) => RadioListTile<bool>(
                                title: Text(e),
                                value: true,
                                groupValue: e == trailing,
                                onChanged: (bool? value) {
                                  onChanged!(e);
                                  context.pop();
                                },
                              ))
                          .toList(),
                    );
                  },
                );
              }
            : null,
        trailing: Text(trailing,
            style: context.appTheme.textTheme.labelLarge!
                .copyWith(color: context.appTheme.colorScheme.primary)),
      );
}

class DialogCheckBoxTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<String> list;
  final List<String> selected;
  final Function(List<String>) onSelected;

  const DialogCheckBoxTile({
    super.key,
    this.subtitle,
    required this.onSelected,
    required this.title,
    required this.list,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    var ls = list.map((e) => (selected.contains(e), e)).toList();
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!).opacity(0.7) : null,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, state) {
              var list = <CheckboxListTile>[];
              for (var i = 0; i < ls.length; i++) {
                list.add(CheckboxListTile(
                  title: Text(ls[i].$2),
                  value: ls[i].$1,
                  onChanged: (bool? value) {
                    state(() {
                      ls[i] = (value ?? false, ls[i].$2);
                    });
                  },
                ));
              }
              return AlertDialog(
                title: Text(title),
                content: Column(mainAxisSize: MainAxisSize.min, children: list),
                actionsAlignment: MainAxisAlignment.spaceAround,
                actions: [
                  TextButton(
                      onPressed: context.pop, child: const Text('Cancel')),
                  OutlinedButton(
                      onPressed: () {
                        var temp = <String>[];
                        for (var e in ls) {
                          if (e.$1) temp.add(e.$2);
                        }
                        onSelected(temp);
                        context.pop();
                      },
                      child: const Text('Done'))
                ],
              );
            });
          },
        );
      },
    );
  }
}
