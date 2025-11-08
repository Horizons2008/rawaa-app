import 'package:rawaa_app/styles/constants.dart';
import 'package:flutter/material.dart';

Widget WidgetStatus(int status) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Constants.getStatusColor(status).withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Constants.getStatusColor(status),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(
          Constants.getStatusLabel(status),
          style: TextStyle(
            fontSize: 10,
            color: Constants.getStatusColor(status),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
