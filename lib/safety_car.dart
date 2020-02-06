import 'package:flutter/material.dart';

class SafetyCar 
{
  IconData icon = Icons.directions_car;
  Color iconColor = Colors.grey;
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
    icon = Icons.local_car_wash;
    active = true;
    sessionState = "Safety Car";
    iconColor = Colors.orangeAccent;
    sessionStateColor = Colors.yellow;
  }

  deactivate()
  {
    icon = Icons.directions_car;
    active = false;
    sessionState = "Running";
    iconColor = Colors.grey;
    sessionStateColor = Colors.green;
  }
}