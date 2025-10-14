import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soapy/util/colors.dart';

class MyPinCodeField extends StatefulWidget {
  final int length;
  final ValueChanged<String> onChanged;
  final double size; // circle size
  final Color activeColor;
  final Color inactiveColor;

  const MyPinCodeField({
    Key? key,
    this.length = 4, // default 4 digits
    required this.onChanged,
    this.size = 55,
    this.activeColor = Colors.black,
    this.inactiveColor = Colors.grey,
  }) : super(key: key);

  @override
  State<MyPinCodeField> createState() => _MyPinCodeFieldState();
}

class _MyPinCodeFieldState extends State<MyPinCodeField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    _controller.addListener(() {
      widget.onChanged(_controller.text);
      setState(() {});

      // ✅ Close keyboard when PIN is complete
      if (_controller.text.length == widget.length) {
        _focusNode.unfocus();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String text = _controller.text;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_focusNode);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Hidden TextField with inputFormatters
          Opacity(
            opacity: 0,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              keyboardType: TextInputType.number,
              maxLength: widget.length,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(widget.length),
              ],
              autofocus: true,
            ),
          ),

          // Circles UI
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.length, (index) {
              bool filled = index < text.length;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.loginText,
                  border: Border.all(
                    color: filled ? widget.activeColor : widget.inactiveColor,
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: filled
                    ? const Text(
                        "●", // Masked pin
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : const SizedBox(),
              );
            }),
          ),
        ],
      ),
    );
  }
}
