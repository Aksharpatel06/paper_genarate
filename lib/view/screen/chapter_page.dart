import 'package:flutter/material.dart';
import 'package:paper_genarate_app/controller/home_provider.dart';
import 'package:paper_genarate_app/utils/custom_appbar.dart';
import 'package:provider/provider.dart';

import '../../utils/color.dart';
import 'question_type_page.dart';

class ChapterPage extends StatelessWidget {
  final String title;
  const ChapterPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppbar(title: title, subtitle: 'Chapters'),
          Expanded(child: ChaptersNames()),
        ],
      ),
    );
  }
}

class ChaptersNames extends StatelessWidget {
  const ChaptersNames({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        child: Consumer<HomeProvider>(
          builder: (context, provider, child) {
            return ListView.builder(
              itemCount: provider.chapterNames.length,
              itemBuilder: (context, index) => ChapterTile(
                chapterNumber: '${index + 1}',
                title: provider.dataMap[provider.medium]['std-${provider.standard}'][provider.selectedSubject]['Chapter-${index + 1}']['name'],
                // totalSelectedCount: '5',
                onTap: () {
                  if (index > 1 && !provider.isPremium) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Premium Content"),
                        content: const Text("Unlock all chapters for just ₹1!"),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              provider.startPayment();
                            },
                            child: const Text("Pay Now"),
                          ),
                        ],
                      ),
                    );
                  } else {
                    provider.getQuestionType("Chapter-${index + 1}");
                    Navigator.push(context, MaterialPageRoute(builder: (context) => QuestionTypePage(title: 'Chapter-${index + 1}')));
                  }
                },
                isLocked: index > 1 && !provider.isPremium,
              ),
            );
          },
        ),
      ),
    );
  }
}

class ChapterTile extends StatelessWidget {
  final String chapterNumber;
  final String? title;
  final bool hasSubtitle;
  final VoidCallback onTap;
  final String? totalSelectedCount;
  final bool isLocked;

  const ChapterTile({
    super.key,
    required this.chapterNumber,
    this.title,
    this.hasSubtitle = false,
    required this.onTap,
    this.totalSelectedCount = '',
    this.isLocked = false,
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
              'Chapter $chapterNumber',
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
            if (isLocked) const Icon(Icons.lock, color: Colors.red, size: 24) else const Icon(Icons.chevron_right, color: Colors.grey, size: 24),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
