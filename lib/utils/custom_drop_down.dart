import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color.dart';

class CustomeDropDown extends StatelessWidget {
  final List<String> categories;
  final String category;
  final ValueChanged<String?>? onChanged;
  const CustomeDropDown({super.key, required this.categories, required this.category, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        items: categories
            .map(
              (String item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: const TextStyle(fontSize: 14)),
              ),
            )
            .toList(),
        value: category,
        onChanged: onChanged,
        customButton: Container(
          height: 50,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: CustomColors.whiteColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(category, style: GoogleFonts.poppins(fontSize: 14, color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.keyboard_arrow_down, color: Colors.black54),
              ),
            ],
          ),
        ),
        buttonStyleData: const ButtonStyleData(padding: EdgeInsets.symmetric(horizontal: 16), height: 40, width: 140, decoration: BoxDecoration()),
        menuItemStyleData: const MenuItemStyleData(height: 40, overlayColor: WidgetStatePropertyAll(Colors.blueAccent)),
      ),
    );
  }
}
