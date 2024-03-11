import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_auto_drive/utils/colors.dart';

class MkInputField extends StatelessWidget {
  const MkInputField(
      {super.key, required this.controller,
        required this.currentNode,
        this.label,
        this.hint,
        this.nextNode,
        this.isPassword = false,
        this.autoValidate = false,
        this.errorText,
        this.onChanged,
        this.validator,
        this.borderColor,
        this.onsaved,
        this.keyboard,
        this.initialValue,
        this.copy = false,
        this.isEnabled = true,
        this.onFieldSubmitted,
        this.textInputAction,
        this.maxLines = 1,
        this.showHint = true,
        this.isForgottenOption = false,
        this.inputFormatters,
      })
      : assert(controller != null && label != null);

  final String? label;
  final String? hint;
  final FocusNode? currentNode;
  final FocusNode? nextNode;
  final String? errorText;
  final bool isPassword;
  final Function(String)? onChanged;
  final Function(String)? validator;
  final Function(String?)? onsaved;
  final TextInputType? keyboard;
  final bool isEnabled;
  final bool copy;
  final bool autoValidate;
  final String? initialValue;
  final TextInputAction? textInputAction;
  final dynamic onFieldSubmitted;
  final int maxLines;
  final bool showHint;
  final TextEditingController controller;
  final bool isForgottenOption;
  final List<TextInputFormatter>? inputFormatters;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      enabled: isEnabled,
      initialValue: initialValue,
      keyboardType: keyboard,
      obscureText: isPassword,
      onChanged: onChanged,
      validator: validator as String? Function(String?)?,
      focusNode: currentNode,
      inputFormatters: inputFormatters,
      onSaved: (String? value) {
        FocusScope.of(context).requestFocus(nextNode);
        onsaved!(value);
      },
      onFieldSubmitted: (String value) {
        FocusScope.of(context).requestFocus(nextNode);
        onFieldSubmitted(value);
      },
      textInputAction: textInputAction,
      decoration: InputDecoration(
        hintText: hint,
        labelText: label ?? " ",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: XColors.primaryColor().withOpacity(0.3)),
        ),
        fillColor: XColors.primaryColor().withOpacity(0.03),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13.0),
      ),
    );
  }
}

class MkInputField2 extends StatelessWidget {
  const MkInputField2(
      {super.key, this.controller,
        required this.label,
        this.currentNode,
        this.hint,
        this.nextNode,
        this.isPassword = false,
        this.autoValidate = false,
        this.errorText,
        this.onChanged,
        this.validator,
        this.borderColor,
        this.onsaved,
        this.keyboard,
        this.initialValue,
        this.copy = false,
        this.isEnabled = true,
        this.onFieldSubmitted,
        this.textInputAction,
        this.maxLines = 1,
        this.showHint = true,
        this.isForgottenOption = false,
        this.suffixIcon,
        this.inputFormatters})
      : assert(label != null);

  final String label;
  final String? hint;
  final FocusNode? currentNode;
  final FocusNode? nextNode;
  final String? errorText;
  final bool isPassword;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validator;
  final Function(String?)? onsaved;
  final TextInputType? keyboard;
  final bool isEnabled;
  final bool copy;
  final bool autoValidate;
  final String? initialValue;
  final TextInputAction? textInputAction;
  final dynamic onFieldSubmitted;
  final int maxLines;
  final bool showHint;
  final TextEditingController? controller;
  final bool isForgottenOption;
  final List<TextInputFormatter>? inputFormatters;
  final Color? borderColor;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          enabled: isEnabled,
          initialValue: initialValue,
          keyboardType: keyboard,
          obscureText: isPassword,
          onChanged: onChanged,
          validator: validator,
          focusNode: currentNode,
          inputFormatters: inputFormatters,
          onSaved: (String? value) {
            FocusScope.of(context).requestFocus(nextNode);
            onsaved!(value);
          },
          onFieldSubmitted: (String? value) {
            FocusScope.of(context).requestFocus(nextNode);
            if(onFieldSubmitted != null) {
              onFieldSubmitted(value);
            }
          },
          textInputAction: textInputAction,
          decoration: InputDecoration(
            fillColor: XColors.primaryColor().withOpacity(0.0),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(11.0)),
              borderSide: BorderSide(
                color: XColors.primaryColor().withOpacity(0.1),
                width: 1
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(11.0)),
              borderSide: BorderSide(
                  color: XColors.primaryColor().withOpacity(0.1),
                  width: 1
              ),
            ),
            hintStyle: const TextStyle(color: Colors.grey),
            hintText: hint,
            focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                borderSide: BorderSide(color: XColors.primaryColor())),
            filled: true,
            contentPadding: const EdgeInsets.only(bottom: 17, left: 10.0, right: 10.0, top: 17),
            labelText: label,
            labelStyle: TextStyle(color: XColors.textColor(), fontWeight: FontWeight.w400),
          ),
          style: TextStyle(color: XColors.textColor(), fontWeight: FontWeight.w400, fontSize: 16),
        ),
        if(suffixIcon != null) ... [
          Positioned(
              right: 20,
              top: 0,
              bottom: 0,
              child: suffixIcon!
          )
        ]
      ],
    );
  }
}

class XCustomInputField extends StatelessWidget {
  const XCustomInputField(
      {Key? key, this.controller,
        this.currentNode,
        required this.label,
        this.hint,
        this.nextNode,
        this.isPassword = false,
        this.autoValidate = false,
        this.textAlign,
        this.errorText,
        this.onChanged,
        this.validator,
        this.borderColor,
        this.onsaved,
        this.filledColor,
        this.bottomLineColor,
        this.inputTextColor,
        this.hintTextColor,
        this.keyboard,
        this.initialValue,
        this.copy = false,
        this.isEnabled = true,
        this.focusColor,
        this.padding,
        this.autoFocus,
        this.onFieldSubmitted,
        this.textInputAction,
        this.maxLines = 1,
        this.showHint = true,
        this.suffixIcon,
        this.isForgottenOption = false,
        this.inputFormatters,
      })
      : assert( label != null), super(key: key);

  final String label;
  final String? hint;
  final FocusNode? currentNode;
  final FocusNode? nextNode;
  final String? errorText;
  final bool isPassword;
  final Function(String)? onChanged;
  final Function(String)? validator;
  final Function(String?)? onsaved;
  final TextInputType? keyboard;
  final bool isEnabled;
  final bool copy;
  final Color? filledColor;
  final Color? bottomLineColor;
  final Color? inputTextColor;
  final Color? hintTextColor;
  final bool autoValidate;
  final String? initialValue;
  final TextAlign? textAlign;
  final bool? autoFocus;
  final Color? focusColor;
  final Padding? padding;
  final TextInputAction? textInputAction;
  final dynamic onFieldSubmitted;
  final int maxLines;
  final bool showHint;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final bool isForgottenOption;
  final List<TextInputFormatter>? inputFormatters;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {

    return Container(
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        enabled: isEnabled,
        initialValue: initialValue,
        keyboardType: keyboard,
        obscureText: isPassword,
        onChanged: onChanged,
        focusNode: currentNode,
        autofocus: autoFocus ?? false,
        textAlign: textAlign ?? TextAlign.start,
        cursorColor: focusColor ?? XColors.background(),
        onSaved: (String? value) {
          FocusScope.of(context).requestFocus(nextNode);
          onsaved!(value);
        },
        onFieldSubmitted: (String value) {
          FocusScope.of(context).requestFocus(nextNode);
          onFieldSubmitted(value);
        },
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        style: TextStyle(color: inputTextColor),
        decoration: InputDecoration(
            border: UnderlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              borderSide: BorderSide(color: bottomLineColor ?? XColors.background()),
            ),
            focusedBorder: UnderlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              borderSide: BorderSide(color: bottomLineColor ?? XColors.background()),
            ),
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: bottomLineColor ?? XColors.background()),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: bottomLineColor ?? XColors.background()),
              borderRadius: const BorderRadius.all(Radius.circular(25.0)),
            ),
            focusColor: focusColor ?? XColors.background(),
            floatingLabelStyle: TextStyle(color: XColors.background()),
            filled: true,
            fillColor: filledColor ?? Colors.white,
            labelText: label,
            hintText: hint,
            hintStyle: TextStyle(
              color: hintTextColor ?? XColors.textColor(),
              fontSize: 16,
            ),
            suffixIcon: suffixIcon
        ),
      ),
    );
  }
}

class MkUnderlineInputField extends StatelessWidget {
  const MkUnderlineInputField(
      {super.key, required this.controller,
        required this.currentNode,
        this.hint,
        this.nextNode,
        this.isPassword = false,
        this.autoValidate = false,
        this.errorText,
        this.onChanged,
        this.validator,
        this.borderColor,
        this.onsaved,
        this.keyboard,
        this.initialValue,
        this.copy = false,
        this.isEnabled = true,
        this.onFieldSubmitted,
        this.textInputAction,
        this.maxLines = 1,
        this.showHint = true,
        this.isForgottenOption = false,
        this.inputFormatters,
        this.suffixIcon
      });

  final String? hint;
  final FocusNode currentNode;
  final FocusNode? nextNode;
  final String? errorText;
  final bool isPassword;
  final Function(String)? onChanged;
  final Function(String)? validator;
  final Function(String?)? onsaved;
  final TextInputType? keyboard;
  final bool isEnabled;
  final bool copy;
  final bool autoValidate;
  final String? initialValue;
  final TextInputAction? textInputAction;
  final dynamic onFieldSubmitted;
  final int maxLines;
  final bool showHint;
  final TextEditingController controller;
  final bool isForgottenOption;
  final List<TextInputFormatter>? inputFormatters;
  final Color? borderColor;
  final Icon? suffixIcon;

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      enabled: isEnabled,
      initialValue: initialValue,
      keyboardType: keyboard,
      obscureText: isPassword,
      onChanged: onChanged,
      validator: validator as String? Function(String?)?,
      focusNode: currentNode,
      inputFormatters: inputFormatters,
      onSaved: (String? value) {
        FocusScope.of(context).requestFocus(nextNode);
        onsaved!(value);
      },
      onFieldSubmitted: (String value) {
        FocusScope.of(context).requestFocus(nextNode);
        onFieldSubmitted(value);
      },
      textInputAction: textInputAction,
      //autovalidate: autoValidate,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hint,
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: XColors.primaryColor().withOpacity(0.4)),
        ),
        fillColor: XColors.primaryColor().withOpacity(0.03),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13.0),
      ),
    );
  }
}

class PasswordValidator {
  static String? validate(String? val) {
    Pattern pattern = r'(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])';
    RegExp regex = RegExp(pattern as String);
    if (val!.isEmpty) {
      return "Enter a password";
    } else if (val.length < 6 || (!regex.hasMatch(val))) {
      return "Password not strong enough";
    } else {
      return null;
    }
  }
}

class EmailValidator {
  static String? validate(String? val) {
    if (!val!.contains("@") || !val.contains(".")) {
      return "Enter a valid Email address";
    } else if (val.isEmpty) {
      return "Enter your Email address";
    } else {
      return null;
    }
  }
}

class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    required this.mask,
    required this.separator,
  }) { assert(mask != null); assert (separator != null); }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.text.length > 0) {
      if(newValue.text.length > oldValue.text.length) {
        if(newValue.text.length > mask.length) return oldValue;
        if(newValue.text.length < mask.length && mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text: '${oldValue.text}$separator${newValue.text.substring(newValue.text.length-1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}
