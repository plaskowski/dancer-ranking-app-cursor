import 'package:flutter/material.dart';

// Interface for tab components to define their available actions
abstract class EventTabActions {
  Future<void> onFabPressed(BuildContext context, VoidCallback onRefresh);
  String get fabTooltip;
  IconData get fabIcon;
}
