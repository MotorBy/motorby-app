import 'package:flutter/material.dart';

IconData getManeuverIcon(String maneuver) {
  switch (maneuver.toUpperCase()) {
    case 'TURN_RIGHT':
      return Icons.turn_right;
    case 'TURN_LEFT':
      return Icons.turn_left;
    case 'TURN_SLIGHT_RIGHT':
      return Icons.turn_slight_right;
    case 'TURN_SLIGHT_LEFT':
      return Icons.turn_slight_left;
    case 'TURN_SHARP_RIGHT':
      return Icons.turn_sharp_right;
    case 'TURN_SHARP_LEFT':
      return Icons.turn_sharp_left;
    case 'MERGE':
      return Icons.merge;
    case 'ROUNDABOUT_RIGHT':
    case 'ROUNDABOUT_LEFT':
      return Icons.roundabout_left;
    case 'DEPART':
      return Icons.departure_board;
    case 'ARRIVE':
      return Icons.location_on;
    case 'KEEP_RIGHT':
    case 'KEEP_LEFT':
      return Icons.fork_right;
    case 'UTURN_RIGHT':
    case 'UTURN_LEFT':
      return Icons.u_turn_left;
    default:
      return Icons.straight;
  }
}