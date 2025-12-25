import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paper_genarate_app/controller/home_provider.dart';
import 'package:paper_genarate_app/utils/color.dart';
import 'package:paper_genarate_app/utils/custom_elevated_button.dart';
import 'package:paper_genarate_app/view/screen/profile_page.dart';
import 'package:provider/provider.dart';

import '../../utils/app_pref.dart';
import '../../utils/custom_drop_down.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.blueColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Category",
                style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.bold, color: CustomColors.whiteColor),
              ),
              Text('Please select your category', style: GoogleFonts.poppins(fontSize: 14, color: CustomColors.whiteColor.withValues(alpha: 0.7))),
              Image.asset('assets/img/cat_image.png'),
              Consumer<HomeProvider>(
                builder: (context, provider, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: CustomeDropDown(
                      categories: provider.categories,
                      category: provider.category,
                      onChanged: (value) {
                        if (value != null) {
                          provider.setCategory(value);
                        }
                      },
                    ),
                  );
                },
              ),

              Consumer<HomeProvider>(
                builder: (context, provider, child) {
                  return SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: CustomElevatedButton(
                      text: 'Continue',
                      onPressed: () async {
                        await AppPref.instance.setCategory(provider.category);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                      },
                      backgroundColor: CustomColors.whiteColor,
                      textColor: CustomColors.blueColor,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
