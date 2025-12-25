import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:paper_genarate_app/utils/color.dart';
import 'package:paper_genarate_app/controller/auth_provider.dart';
import '../../controller/home_provider.dart';
import '../../utils/custom_drop_down.dart';
import '../../utils/custom_elevated_button.dart';
import '../../utils/interstitial_ad_util.dart';
import 'sign_in_page.dart';
import 'subject_page.dart';
import '../../utils/banner_ad_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final InterstitialAdUtil _adUtil = InterstitialAdUtil();

  @override
  void initState() {
    super.initState();
    _adUtil.loadAd();
  }

  @override
  void dispose() {
    _adUtil.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            spacing: 25,
            children: [
              const ProfileHeader(),
              const UserInfoSection(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  spacing: 20,
                  children: [
                    SelectionSection(
                      title: 'Board',
                      selector: (HomeProvider p) => p.board,
                      items: (HomeProvider p) => p.boards,
                      onChanged: (HomeProvider p, String? val) => p.setBoard(val!),
                    ),
                    SelectionSection(
                      title: 'Medium',
                      selector: (HomeProvider p) => p.medium,
                      items: (HomeProvider p) => p.mediums,
                      onChanged: (HomeProvider p, String? val) => p.setMedium(val!),
                    ),
                    SelectionSection(
                      title: 'Standard',
                      selector: (HomeProvider p) => p.standard,
                      items: (HomeProvider p) => p.standards,
                      onChanged: (HomeProvider p, String? val) => p.setStandard(val!),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ContinueButton(adUtil: _adUtil),
              const SizedBox(height: 20),
              const BannerAdWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: double.infinity,
      decoration: BoxDecoration(
        color: CustomColors.blueColor,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      padding: const EdgeInsets.only(left: 16, top: 40, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
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
          Consumer<AuthProvider>(
            builder: (context, auth, child) {
              return IconButton(
                onPressed: () async {
                  await auth.signOut();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const GoogleAuthPage()), (route) => false);
                },
                icon: const Icon(Icons.logout, color: Colors.white),
              );
            },
          ),
        ],
      ),
    );
  }
}

class UserInfoSection extends StatelessWidget {
  const UserInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        spacing: 15,
        children: [
          const CircleAvatar(radius: 30, child: Icon(Icons.person, size: 40)),
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
    );
  }
}

class SelectionSection extends StatelessWidget {
  final String title;
  final String Function(HomeProvider) selector;
  final List<String> Function(HomeProvider) items;
  final Function(HomeProvider, String?) onChanged;

  const SelectionSection({super.key, required this.title, required this.selector, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: CustomColors.blueColor),
        ),
        Consumer<HomeProvider>(
          builder: (context, provider, child) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), spreadRadius: 1, blurRadius: 1, offset: const Offset(0, 0))],
              ),
              child: CustomeDropDown(categories: items(provider), category: selector(provider), onChanged: (value) => onChanged(provider, value)),
            );
          },
        ),
      ],
    );
  }
}

class ContinueButton extends StatelessWidget {
  final InterstitialAdUtil adUtil;
  const ContinueButton({super.key, required this.adUtil});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          height: 70,
          width: double.infinity,
          child: CustomElevatedButton(
            text: 'Continue',
            onPressed: () {
              adUtil.showAd(() {
                try {
                  provider.getDataSubject();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SubjectsPage(title: '${provider.standard} ${provider.medium}')));
                } catch (e) {
                  print('Error saving preferences: $e');
                }
              });
            },
            backgroundColor: CustomColors.blueColor,
            textColor: CustomColors.whiteColor,
          ),
        );
      },
    );
  }
}
