import 'package:flutter/material.dart';

Widget customSearchBar(
  TextEditingController textController,
  String hint,

  ValueChanged<String>? onChanged,
) {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.all(10),

    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(10),
    ),
    height: 40,

    child: TextField(
      controller: textController,
      onChanged: onChanged,
      keyboardType: TextInputType.text,
      style: TextStyle(),
      textAlignVertical: TextAlignVertical.center,

      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(0),
        border: InputBorder.none,
        hintText: hint,
        prefixIcon: Icon(Icons.search, size: 20),
        suffixIcon: textController.text.isNotEmpty
            ? InkWell(
                onTap: () {
                  textController.text = "";
                },
                child: Icon(Icons.close),
              )
            : SizedBox(),
      ),
    ),
  );
}
