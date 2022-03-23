import 'package:flutter/material.dart';
import 'package:streamer/src/constants.dart';
import 'package:streamer/src/ultils/migrates/spacing.dart';

class KTextField extends StatefulWidget {
  final double fontSize;
  final String? hintText;
  final String label;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final TextInputAction textInputAction;
  final String? initialValue;
  final bool isClearButton;

  const KTextField(
      {required this.label,
      Key? key,
      this.fontSize = Spacing.m,
      this.hintText,
      this.onSubmitted,
      this.onChanged,
      this.textInputAction = TextInputAction.done,
      this.isClearButton = true,
      this.initialValue})
      : super(key: key);

  @override
  State<KTextField> createState() => _KTextFieldState();
}

class _KTextFieldState extends State<KTextField> {
  late TextEditingController controller;
  late bool isHasValue;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue);
    isHasValue = controller.text.isNotEmpty;
    controller.addListener(_clearHandler);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  TextStyle get style =>
      TextStyle(fontSize: widget.fontSize, color: kBlackColor);

  final border = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(Spacing.m)),
      borderSide: BorderSide(color: kBlackColor, width: 1.0));

  Widget? get clearButton {
    if (!widget.isClearButton || !isHasValue) {
      return null;
    }
    return IconButton(
      onPressed: controller.clear,
      iconSize: 24.0,
      color: kBlackColor,
      icon: const Icon(Icons.clear_rounded),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: _onChanged,
      onSubmitted: widget.onSubmitted,
      cursorColor: kBlackColor,
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        /// label
        labelText: widget.label,
        labelStyle: style.copyWith(fontSize: widget.fontSize * 0.75),
        floatingLabelStyle: style,

        /// hint
        hintText: widget.hintText,
        hintStyle: style.copyWith(fontSize: widget.fontSize * 0.5),

        /// clearbutton
        suffixIcon: clearButton,

        /// input field border
        border: border,
        focusedBorder: border,
        enabledBorder: border,

        /// color
        focusColor: kBlackColor,
      ),
    );
  }

  void _onChanged(String value) {
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  void _clearHandler() {
    setState(() {
      isHasValue = controller.text.isNotEmpty;
    });
  }
}
