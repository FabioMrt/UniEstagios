import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uniestagios/theme.dart';

class AppInput extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final double? height;
  final String? hintText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool obscureText;
  final Function(String?)? onSaved;
  final Function(String?)? onSubmitted;
  final Widget? prefixIcon;
  final Widget? suffix;
  final TextAlignVertical? textAlignVertical;
  final String? Function(String?)? validator;
  final double? width;
  final bool isObscure;
  final List<TextInputFormatter>? inputFormatters;

  const AppInput({
    Key? key,
    this.controller,
    this.focusNode,
    this.height,
    this.hintText,
    this.keyboardType,
    this.maxLines = 1,
    this.obscureText = false,
    this.onSaved,
    this.onSubmitted,
    this.prefixIcon,
    this.isObscure = false,
    this.suffix,
    this.textAlignVertical,
    this.validator,
    this.width,
    this.inputFormatters,
  }) : super(key: key);

  @override
  _AppInputState createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  bool _obscure = false;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isObscure;
  }

  changeObscure() {
    setState(() {
      _obscure = !_obscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      cursorColor: kPrimaryColor,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: _outlineBorder(color: kPrimaryColor),
        errorBorder: _outlineBorder(color: Colors.red),
        enabledBorder: _outlineBorder(color: Colors.grey),
        focusedBorder: _outlineBorder(color: kPrimaryColor),
        disabledBorder: _outlineBorder(color: Colors.grey),
        focusedErrorBorder: _outlineBorder(color: kPrimaryColor),
        fillColor: Colors.white,
        filled: true,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isObscure == true
            ? Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                  onPressed: () {
                    changeObscure();
                  },
                  icon: _obscure == false
                      ? Icon(Icons.visibility_off, color: kTextFieldColor)
                      : Icon(Icons.visibility, color: kPrimaryColor),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: widget.suffix,
              ),
      ),
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      obscureText: _obscure,
      onSaved: widget.onSaved,
      onFieldSubmitted: widget.onSubmitted,
      textAlignVertical: widget.textAlignVertical,
      validator: widget.validator,
      inputFormatters: widget.inputFormatters,
    );
  }

  InputBorder _outlineBorder({required Color color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: color, width: 1),
    );
  }
}
