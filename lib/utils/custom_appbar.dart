import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paper_genarate_app/utils/color.dart';

class CustomAppbar extends StatelessWidget {
  final String title;
  final String subtitle;
  const CustomAppbar({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: CustomColors.blueColor,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(left: 16, top: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500, color: CustomColors.whiteColor),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: CustomColors.whiteColor),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 4.0),
            child: Text(
              subtitle,
              style: GoogleFonts.poppins(fontSize: 18, color: CustomColors.whiteColor, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
