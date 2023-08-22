import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'bloc/privacy_handling_bloc.dart';

class PrivacyHandlingScreen extends StatelessWidget {
  final String title;
  final String? about;
  final Privacy privacy;
  const PrivacyHandlingScreen({
    super.key,
    required this.privacy,
    required this.title,
    this.about,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrivacyHandlingBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            elevation: 8,
            title: Text(title),
            leading: BackButton(
              onPressed: () => AppNavigator.pop(
                  result: privacy.copyWith(
                      type: context.read<PrivacyHandlingBloc>().activeState)),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (about != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
                  child: Text(about!),
                ),
              PrivacySelectorWidget(privacy: privacy),
              const PrivacyContectSelecter()
            ]),
          ),
        );
      }),
    );
  }
}

class PrivacyContectSelecter extends StatelessWidget {
  const PrivacyContectSelecter({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrivacyHandlingBloc, PrivacyHandlingState>(
        builder: (context, state) {
      if (state is PrivacyHandlingOnly) return buildWidget(state.contects);
      if (state is PrivacyHandlingExcept) return buildWidget(state.contects);
      return const SizedBox();
    });
  }

  Expanded buildWidget(List<String> list) {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Contects excepts',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'No contacts excluded',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              )),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.checklist_rtl),
                onPressed: () {},
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index) => CheckboxListTile(
                title: Text('$index'),
                onChanged: (bool? value) {},
                value: true,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PrivacySelectorWidget extends StatefulWidget {
  final Privacy privacy;
  const PrivacySelectorWidget({super.key, required this.privacy});

  @override
  State<PrivacySelectorWidget> createState() => PrivacySelectorWidgetState();
}

class PrivacySelectorWidgetState extends State<PrivacySelectorWidget> {
  late Privacy initValue;
  @override
  void initState() {
    initValue = widget.privacy;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: PrivacyType.values.map<Widget>((e) {
        return RadioListTile<PrivacyType>(
          dense: true,
          contentPadding: EdgeInsets.zero,
          value: e,
          groupValue: initValue.type,
          onChanged: (value) async {
            setState(() {
              initValue = initValue.copyWith(type: value);
            });
            context.read<PrivacyHandlingBloc>().add(SetPrivacyState(initValue));
          },
          title: Text(
            e.name,
            style: const TextStyle(fontSize: 16),
          ),
        );
      }).toList(),
    );
  }
}
