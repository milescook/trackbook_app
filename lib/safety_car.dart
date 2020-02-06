import 'package:flutter/material.dart';

class SafetyCar 
{
  IconData icon = Icons.directions_car;
  Color iconColor = Colors.grey;
  bool active = false;
  String sessionState = "Running";

  activate()
  {
    icon = Icons.local_car_wash;
    active = true;
    sessionState = "Safety Car";
    iconColor = Colors.orangeAccent;
  }

  deactivate()
  {
    icon = Icons.directions_car;
    active = false;
    sessionState = "Running";
    iconColor = Colors.grey;
  }
}