import 'package:flutter/material.dart';
Widget buildDropdownButton(heading, List<String> items,String selectedItem) {
    return
      Row(
        children: [
          Expanded(child: Text(heading)),
          Expanded(
            child: DropdownButtonFormField(
            value: selectedItem,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
              onChanged: (newvalue) =>
            {
                selectedItem = newvalue!}

    ),
          ),
        ],
      );
  }
