import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/supported_countries.dart';
import 'package:mobile_auto_drive/widgets/inputfield.dart';
import 'package:mobile_auto_drive/widgets/list_selector.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

/// Phone number field with a dial-code picker in front of it.
///
/// The selected dial code is the only place sign-up learns the user's country,
/// so [onChanged] reports both parts together. Typing or pasting a full
/// international number ('+233...' or '00233...') switches the picker to that
/// country and strips the code, so pasting a number from contacts just works.
class PhoneNumberField extends StatefulWidget {
  const PhoneNumberField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.initialCountry,
    this.currentNode,
    this.label = 'Phone number',
  });

  final TextEditingController controller;

  /// Fires on every keystroke and whenever the country changes.
  final void Function(SupportedCountry country, String nationalNumber) onChanged;
  final SupportedCountry? initialCountry;
  final FocusNode? currentNode;
  final String label;

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  late SupportedCountry _country = widget.initialCountry ?? defaultCountry;

  @override
  void initState() {
    super.initState();
    // Report the default country up front so the form has a value even if the
    // user never opens the picker.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onChanged(_country, widget.controller.text);
    });
  }

  void _handleTextChanged(String value) {
    final detected = countryFromDialCode(value);
    if (detected != null) {
      final national = stripDialCode(value, detected);
      widget.controller.value = TextEditingValue(
        text: national,
        selection: TextSelection.collapsed(offset: national.length),
      );
      setState(() => _country = detected);
      widget.onChanged(detected, national);
      return;
    }
    widget.onChanged(_country, value);
  }

  void _pickCountry() {
    listHelperPicker(
      height: 320,
      context: context,
      title: 'Country code',
      listString: kSupportedCountries.map((c) => c.label).toList(),
      selected: (s) {
        final picked = kSupportedCountries.firstWhere((c) => c.label == s);
        setState(() => _country = picked);
        widget.onChanged(picked, widget.controller.text);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainInputField(
      label: widget.label,
      hint: _country.sampleNumber,
      controller: widget.controller,
      currentNode: widget.currentNode,
      keyboard: TextInputType.phone,
      // '+' is allowed so a pasted international number can be recognised.
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s\-()]'))],
      validator: (s) => validatePhoneNumber(s, _country),
      onChanged: _handleTextChanged,
      prefix: GestureDetector(
        onTap: _pickCountry,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              NormalText(
                text: _country.dialCode,
                textColor: XColors.textColor(),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              const Icon(Icons.keyboard_arrow_down_rounded, size: 19),
              Container(
                height: 22,
                width: 1,
                margin: const EdgeInsets.only(right: 8),
                color: XColors.primaryColor().withOpacity(0.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
