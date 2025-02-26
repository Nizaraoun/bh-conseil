import 'package:flutter/material.dart';

Widget customProfieImage({
  required double redius,
}) {
  return CircleAvatar(
      radius: redius,
      backgroundImage: const AssetImage("assets/images/userimg.png"));
}
