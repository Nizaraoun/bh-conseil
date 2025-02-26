import 'package:flutter/material.dart';

import '../../../../widgets/customText.dart';


class Button extends StatelessWidget {
  final String txt;
  final VoidCallback OnPressd;
  final Color color;
  final Color txtcolor;
  const Button(
      {super.key,
      required this.txt,
      required this.color,
      required this.txtcolor,
      required this.OnPressd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        bottom: 10,
        left: 20,
        right: 20,
      ),
      child: ElevatedButton(
          onPressed: OnPressd,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            minimumSize: const Size(130, 50),
          ),
          child: customText(
            text: txt,
            textStyle: TextStyle(
              color: txtcolor,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
            
          )),
    );
  }
}
