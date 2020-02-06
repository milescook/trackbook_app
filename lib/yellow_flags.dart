import 'package:flutter/material.dart';

class YellowFlags 
{
  IconData flagIcon = Icons.outlined_flag;
  Color iconColor = Colors.yellow;
  Color sessionStateColor = Colors.green;

  bool active = false;
  String sessionState = "Running";

  toggleState()
  {
    if(active)
      deactivate();
    else
      activate();
  }

  activate()
  {
    flagIcon = Icons.flag;
    active = true;
    sessionState = "Yellow Flags";
    sessionStateColor = Colors.yellow;
  }

  deactivate()
  {
    flagIcon = Icons.outlined_flag;
    active = false;
    sessionState = "Running";
    sessionStateColor = Colors.green;
  }
}