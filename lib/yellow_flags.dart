import 'package:flutter/material.dart';

class YellowFlags 
{
  IconData flagIcon = Icons.outlined_flag;
  Color iconColor = Colors.yellow;
  bool active = false;
  String sessionState = "Running";

  activate()
  {
    flagIcon = Icons.flag;
    active = true;
    sessionState = "Yellow Flags";
  }

  deactivate()
  {
    flagIcon = Icons.outlined_flag;
    active = false;
    sessionState = "Running";
  }
}