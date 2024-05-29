import 'package:flutter/material.dart';

import 'ui.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final String label;

  PrimaryButton(
      {Key? key, this.onPressed, this.label = "button", this.title = "button"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.06,
      width: MediaQuery.of(context).size.width * 0.8,
      child: FilledButton(
        style: UI.primaryButtonStyle(context),
        child: Semantics(
            label: label,
            child: new Text(title, style: UI.primaryButtonTextStyle(context))),
        onPressed: onPressed,
      ),
    );
  }
}
