import 'package:flutter/material.dart';

import '../helpers/globals.dart';

class Button extends StatefulWidget {
  final String? text;
  final Function? onClick;
  final bool? disabled;
  const Button({Key? key, this.text, this.onClick, this.disabled = true}) : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0),
      width: double.infinity,
      child: ElevatedButton(
        // onPressed: () {
        //   widget.onClick!();
        // },
        onPressed: widget.disabled!
            ? () {
                widget.onClick!();
              }
            : null,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 20),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          // onSurface: red,
          disabledBackgroundColor: red.withOpacity(0.5),
        ),
        child: Text(
          '${widget.text}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: white,
          ),
        ),
      ),
    );
  }
}

class OutlinedButton extends StatefulWidget {
  final String? text;
  final Function? onClick;
  const OutlinedButton({Key? key, this.text, this.onClick}) : super(key: key);

  @override
  _OutlinedButtonState createState() => _OutlinedButtonState();
}

class _OutlinedButtonState extends State<OutlinedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          widget.onClick!();
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
          backgroundColor: white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: red),
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        // style: ElevatedButton.styleFrom(
        //   padding: EdgeInsets.symmetric(vertical: 16),
        //   elevation: 0,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        // ),
        child: Text(
          '${widget.text}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: red),
        ),
      ),
    );
  }
}

class Input extends StatefulWidget {
  final String? hintText;
  final Function? onChanged;
  final border;
  const Input({Key? key, this.hintText, this.onChanged, this.border}) : super(key: key);

  @override
  State<Input> createState() => InputState();
}

class InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: widget.border,
        focusedBorder: widget.border,
        enabledBorder: widget.border,
        hintText: widget.hintText,
      ),
    );
  }
}

class Shimmer extends StatefulWidget {
  const Shimmer({Key? key}) : super(key: key);

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
