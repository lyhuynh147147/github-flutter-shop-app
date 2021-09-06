import 'package:flutter/material.dart';
import 'package:phone_verification/widgets/pallete.dart';


class TextInputFormField extends StatefulWidget {
  const TextInputFormField({
    Key key,
    @required this.icon,
    @required this.hint,
    this.inputType,
    this.inputAction, this.onChanged, this.labelText, this.validator, this.isPassword, this.maxLength,
  }) : super(key: key);

  final int maxLength;
  final bool isPassword;
  final IconData icon;
  final String hint;
  final Function(String) onChanged;
  final Function(String) validator;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final String labelText;

  @override
  _TextInputFormFieldState createState() => _TextInputFormFieldState();
}

class _TextInputFormFieldState extends State<TextInputFormField> {
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

    Size size = MediaQuery.of(context).size;
    return TextFormField(
      maxLength: widget.maxLength,
      style:  TextStyle(
        fontSize: 22
      ).copyWith(color: Colors.black),
      obscureText: isShowPassword,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        // focusedBorder: OutlineInputBorder(
        //   borderSide: BorderSide(
        //     color: Colors.white,
        //     width: 1,
        //   ),
        //   borderRadius: BorderRadius.circular(18),
        // ),
        // enabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(
        //     color: Colors.grey,
        //     width: 1,
        //   ),
        //   borderRadius: BorderRadius.circular(18),
        // ),

        labelText: widget.labelText,
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
        //border: InputBorder.none,
        // prefixIcon: Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
        //   child: Icon(
        //     icon,
        //     size: 28,
        //     color: Colors.white,
        //   ),
        // ),
        icon: Icon(widget.icon),
        hintText: widget.hint,
        labelStyle: TextStyle(fontSize: 20),
        hintStyle: kBodyText.copyWith(color: Colors.black),
        // prefix: Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 8),
        //   // child: Text(
        //   //   '(+62)',
        //   //   style: TextStyle(
        //   //     fontSize: 18,
        //   //     fontWeight: FontWeight.bold,
        //   //     color: Colors.black
        //   //   ),
        //   // ),
        //   child: TextFormField(
        //
        //   ),
        // ),
      ),
      validator: widget.validator,
      //style: kBodyText,
      keyboardType: widget.inputType,
      textInputAction: widget.inputAction,
    );
  }
}
/*TextFormField(
                                  enabled: !isLoading,
                                  obscureText: isShowPassword,
                                  controller: passwordController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      labelText: 'Password',
                                      suffixIcon: GestureDetector(
                                        child: Icon(
                                          isShowPassword
                                              ? Icons.remove_red_eye
                                              : Icons.visibility_off,
                                        ),
                                        onTap: (){
                                          setState(() {
                                            isShowPassword = !isShowPassword;
                                          });
                                        },
                                      )
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter password';
                                    }
                                  },
                                )*/