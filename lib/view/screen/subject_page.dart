import 'package:flutter/material.dart';
import 'package:paper_genarate_app/controller/home_provider.dart';
import 'package:paper_genarate_app/utils/color.dart';
import 'package:provider/provider.dart';

import '../../utils/custom_appbar.dart';
import 'chapter_page.dart';

class SubjectsPage extends StatelessWidget {
  final String title;
  const SubjectsPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      body: Column(
        spacing: 20,
        children: [
          CustomAppbar(title: title, subtitle: 'Subjects'),

          Expanded(
            child: Consumer<HomeProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.subNames.length,
                  itemBuilder: (context, index) {
                    return SubjectTile(
                      icon: Icons.title,
                      title: provider.subNames[index],
                      onTap: () {
                        provider.selectAllQuestions();
                        provider.getChapterData(provider.subNames[index]);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChapterPage(title: provider.subNames[index])));
                        // Navigate to subject details page
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SubjectTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SubjectTile({super.key, required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: .1), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: CustomColors.blueColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: CustomColors.blueColor, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 24),
        onTap: onTap,
      ),
    );
  }
}
