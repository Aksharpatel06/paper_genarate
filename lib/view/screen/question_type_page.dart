import 'package:flutter/material.dart';
import 'package:paper_genarate_app/controller/home_provider.dart';
import 'package:paper_genarate_app/utils/custom_appbar.dart';
import 'package:paper_genarate_app/view/screen/question_page.dart';
import 'package:provider/provider.dart';

import '../../utils/color.dart';

class QuestionTypePage extends StatelessWidget {
  final String title;
  const QuestionTypePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppbar(title: title, subtitle: 'Questions'),
          Expanded(child: QuestionTypeNames()),
        ],
      ),
    );
  }
}

class QuestionTypeNames extends StatelessWidget {
  const QuestionTypeNames({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        child: Consumer<HomeProvider>(
          builder: (context, provider, child) {
            return ListView.builder(
              itemCount: provider.questionTypes.length,
              itemBuilder: (context, index) => QuestionTypeTile(
                totalSelectedCount: selectedQuestCount(provider, provider.questionTypes[index]).toString(),
                onTap: () {
                  provider.getQuestions(provider.questionTypes[index]);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => QuestionsPage(title: provider.questionTypes[index])));
                },
                chapterNumber: provider.questionTypes[index],
              ),
            );
          },
        ),
      ),
    );
  }

  int selectedQuestCount(HomeProvider provider, String questionType) {
    int selectedCount = 0;

    for (dynamic question in provider.selectedQuestions) {
      if (question['type'] == questionType && question['subject'] == provider.selectedChapter) {
        selectedCount++;
      }
    }
    return selectedCount;
  }
}

class QuestionTypeTile extends StatelessWidget {
  final String chapterNumber;
  final String? title;
  final bool hasSubtitle;
  final VoidCallback onTap;
  final String? totalSelectedCount;

  const QuestionTypeTile({
    super.key,
    required this.chapterNumber,
    this.title,
    this.hasSubtitle = false,
    required this.onTap,
    this.totalSelectedCount = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: CustomColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        title: Row(
          children: [
            Text(
              chapterNumber,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            if (title != null) ...[
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title!,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black87),
                ),
              ),
            ],
          ],
        ),
        trailing: Column(
          children: [
            Visibility(
              visible: totalSelectedCount != null && totalSelectedCount!.isNotEmpty,
              child: Text(
                'Total - $totalSelectedCount',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: CustomColors.orangeColor),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 24),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
