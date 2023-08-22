import 'package:flutter/material.dart';

class AnimSearchBar extends StatefulWidget {
  final bool hideCloseButton;
  final String hintText;
  final Color? color;
  final Duration duration;
  final FocusNode focusNode;
  final BorderRadius borderRadius;
  final TextEditingController textController;
  final Function(String)? onSubmitted;
  final Function(String)? onChange;
  AnimSearchBar(
      {super.key,
      this.duration = const Duration(milliseconds: 300),
      this.hintText = 'Search...',
      this.color,
      BorderRadius? borderRadius,
      FocusNode? focusNode,
      TextEditingController? textController,
      this.hideCloseButton = false,
      this.onSubmitted,
      this.onChange})
      : borderRadius = borderRadius ?? BorderRadius.circular(16),
        focusNode = focusNode ?? FocusNode(),
        textController = textController ?? TextEditingController();

  @override
  State<AnimSearchBar> createState() => _AnimSearchBarState();
}

class _AnimSearchBarState extends State<AnimSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  @override
  void initState() {
    _animController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addListener(() {
        if (_animController.value == 1) {
          widget.focusNode.requestFocus();
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    widget.focusNode.dispose();
    widget.textController.dispose();
    super.dispose();
  }

  bool get isOpen => _animController.value != 0;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        var width = _animController.value * MediaQuery.of(context).size.width;
        var inputBorder = OutlineInputBorder(
            borderRadius: widget.borderRadius,
            borderSide: BorderSide(color: Theme.of(context).primaryColor));
        return Container(
          height: kToolbarHeight,
          width: width > kToolbarHeight ? width : kToolbarHeight,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: widget.color ?? Theme.of(context).colorScheme.outlineVariant,
            borderRadius: widget.borderRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isOpen)
                Expanded(
                    child: TextField(
                  controller: widget.textController,
                  focusNode: widget.focusNode,
                  onEditingComplete: () => _animController.reverse(),
                  onSubmitted: widget.onSubmitted,
                  onChanged: widget.onChange,
                  decoration: InputDecoration(
                      hintText: widget.hintText,
                      border: inputBorder,
                      enabledBorder: inputBorder,
                      focusedBorder: inputBorder,
                      errorBorder: inputBorder,
                      disabledBorder: inputBorder,
                      focusedErrorBorder: inputBorder,
                      suffixIcon: _animController.isAnimating
                          ? null
                          : IconButton(
                              enableFeedback: true,
                              onPressed: () {
                                widget.textController.clear();
                                setState(() {});
                              },
                              iconSize: 22,
                              icon: const Icon(Icons.cleaning_services_rounded),
                            )),
                )),
              if (!isOpen || !widget.hideCloseButton) dynamicSearchButton()
            ],
          ),
        );
      },
    );
  }

  IconButton dynamicSearchButton() {
    return IconButton(
        onPressed: () {
          if (_animController.isAnimating) return;
          if (_animController.value == 1) {
            _animController.reverse();
          } else {
            _animController.forward();
          }
        },
        icon: Icon(isOpen ? Icons.close_rounded : Icons.search));
  }
}
