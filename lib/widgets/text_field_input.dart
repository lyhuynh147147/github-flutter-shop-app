import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/widgets/pallete.dart';


class TextInputField extends StatefulWidget {
  const TextInputField({
    this.errorText,
    this.isPassword = false,
    this.isNumber = false,
    this.inputType = TextInputType.text,
    @required this.icon = null,
    this.onValueChange,
    this.hintText = '',
    this.controller, this.inputAction,
  }) ;

  final bool isNumber;
  final TextInputType inputType;
  final String errorText;
  final bool isPassword;
  final IconData icon;
  final Function onValueChange;
  final String hintText;
  final TextInputAction inputAction;
  final TextEditingController controller;

  @override
  _TextInputFieldState createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  bool isShowPassword = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isPassword) {
      isShowPassword = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        /*height: size.height * 0.08,
        width: size.width * 0.8,*/
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          //color: Colors.white
        ),
        child: Center(
          child: TextField(
            autofocus: false,
            controller: widget.controller,
            decoration: InputDecoration(
              errorText: (widget.errorText == '')
                  ? null : widget.errorText,
              labelStyle: kBoldTextStyle.copyWith(fontSize: 15),
              suffixIcon: widget.isPassword
                  ? GestureDetector(child: Icon(
                isShowPassword
                    ? Icons.remove_red_eye
                    : Icons.visibility_off,),
                onTap: () {
                  setState(() {
                    isShowPassword = !isShowPassword;
                  });
                },
              ) : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                    color: (widget.errorText != '') ?
                    Colors.white : kColorRed),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Icon(
                  widget.icon,
                  size: 28,
                  color: Colors.white,
                ),
              ),
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontSize: 22,
                color: Colors.white,
                height: 1.5,
              ),
            ),
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              height: 1.5,
            ),
            keyboardType: widget.inputType,
            textInputAction: widget.inputAction,
            obscureText: isShowPassword,
            onChanged: widget.onValueChange,
          ),
        ),
      ),
    );
  }
}