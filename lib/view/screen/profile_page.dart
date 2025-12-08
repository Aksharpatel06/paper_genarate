import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paper_genarate_app/utils/color.dart';
import 'package:provider/provider.dart';

import '../../controller/home_provider.dart';
import '../../utils/custom_drop_down.dart';
import '../../utils/custom_elevated_button.dart';
import 'subject_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          spacing: 25,
          children: [
            Container(
              height: 130,
              width: double.infinity,
              decoration: BoxDecoration(
                color: CustomColors.blueColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              ),
              padding: EdgeInsets.only(left: 16, top: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi Akshar',
                    style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.w500, color: CustomColors.whiteColor),
                  ),
                  Text(
                    'Ready to Generate a Question Paper?',
                    style: GoogleFonts.poppins(fontSize: 14, color: CustomColors.whiteColor.withValues(alpha: 0.7)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                spacing: 15,
                children: [
                  CircleAvatar(radius: 30, child: Icon(Icons.person, size: 40)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Akshar Patel',
                        style: GoogleFonts.poppins(fontSize: 18, color: CustomColors.blueColor, fontWeight: FontWeight.w700),
                      ),
                      Consumer<HomeProvider>(
                        builder: (context, provider, child) {
                          return Text('Class: ${provider.standard} ', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                spacing: 15,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Text(
                          'Board',
                          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: CustomColors.blueColor),
                        ),
                        Consumer<HomeProvider>(
                          builder: (context, provider, child) {
                            return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.2),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: Offset(0, 0), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: CustomeDropDown(
                                categories: provider.boards,
                                category: provider.board,
                                onChanged: (value) {
                                  if (value != null) {
                                    provider.setBoard(value);
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Text(
                          'Medium',
                          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: CustomColors.blueColor),
                        ),
                        Consumer<HomeProvider>(
                          builder: (context, provider, child) {
                            return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.2),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: Offset(0, 0), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: CustomeDropDown(
                                categories: provider.mediums,
                                category: provider.medium,
                                onChanged: (value) {
                                  if (value != null) {
                                    provider.setMedium(value);
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(
                    'Standard',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: CustomColors.blueColor),
                  ),
                  Consumer<HomeProvider>(
                    builder: (context, provider, child) {
                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.2),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: CustomeDropDown(
                          categories: provider.standards,
                          category: provider.standard,
                          onChanged: (value) {
                            if (value != null) {
                              provider.setStandard(value);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            Spacer(),
            Consumer<HomeProvider>(
              builder: (context, provider, child) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  height: 70,
                  width: double.infinity,
                  child: CustomElevatedButton(
                    text: 'Continue',
                    onPressed: () {
                      try {
                        provider.getDataSubject();

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SubjectsPage(title: '${provider.standard} ${provider.medium}')),
                        );
                      } catch (e) {
                        print('Error saving preferences: $e');
                      }
                    },
                    backgroundColor: CustomColors.blueColor,
                    textColor: CustomColors.whiteColor,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
