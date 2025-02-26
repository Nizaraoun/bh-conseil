import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FieldSms extends StatelessWidget {
  final String? Function(String?) validator;
  final void Function(String?) onchanged;
  const FieldSms({super.key, required this.validator, required this.onchanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        mouseCursor: SystemMouseCursors.text,
        validator: validator,
        focusNode: FocusNode(canRequestFocus: true),
        keyboardType: TextInputType.number,
        onChanged: onchanged,
        autofillHints: const [AutofillHints.telephoneNumber],
        cursorHeight: 40,
        cursorColor: Color.fromARGB(255, 183, 106, 58),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          counterStyle: const TextStyle(
            height: double.minPositive,
          ),
          constraints: const BoxConstraints(maxHeight: 70),
          focusColor: Colors.deepPurple,
          fillColor: Color.fromARGB(255, 211, 204, 204),
          filled: true,
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        maxLength: 1,
        textInputAction: TextInputAction.newline,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.top,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
