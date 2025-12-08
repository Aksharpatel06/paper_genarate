import 'package:flutter/material.dart';
import 'package:paper_genarate_app/controller/home_provider.dart';
import 'package:paper_genarate_app/utils/custom_appbar.dart';
import 'package:paper_genarate_app/view/screen/event_page.dart';
import 'package:provider/provider.dart';

class QuestionsPage extends StatefulWidget {
  final String title;
  const QuestionsPage({super.key, required this.title});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).loadQuestions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          CustomAppbar(title: widget.title, subtitle: 'Select Questions for PDF'),

          // Selection Controls
          Consumer<HomeProvider>(
            builder: (context, provider, child) {
              var summary = provider.getSelectionSummary();

              return Container(
                padding: EdgeInsets.all(16),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${summary['selected']} selected',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[700]),
                      ),
                    ),
                    TextButton(onPressed: provider.selectAllQuestions, child: Text('Select All')),
                    SizedBox(width: 8),
                    TextButton(onPressed: provider.clearAllSelections, child: Text('Clear All')),
                  ],
                ),
              );
            },
          ),

          Expanded(
            child: Consumer<HomeProvider>(
              builder: (context, provider, child) {
                if (provider.questionList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.quiz_outlined, size: 64, color: Colors.grey[400]),
                        SizedBox(height: 16),
                        Text(
                          'No questions available',
                          style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: provider.questionList.length,
                  itemBuilder: (context, index) {
                    final question = provider.questionList[index];
                    final questionId = question['question'];
                    bool isSelected = provider.selectedQuestions.any((element) => element['question'].contains(questionId));
                    final hasOptions = question['options'] != null && question['options'].isNotEmpty;
                    return InkWell(
                      onTap: () => provider.toggleQuestionSelection(provider.questionList[index]),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isSelected ? Color(0xFF6366F1) : Colors.grey[300]!, width: isSelected ? 2 : 1),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 2))],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Selection checkbox and question header
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    margin: EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      color: isSelected ? Color(0xFF6366F1) : Colors.transparent,
                                      border: Border.all(color: isSelected ? Color(0xFF6366F1) : Colors.grey[400]!, width: 2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: isSelected ? Icon(Icons.check, color: Colors.white, size: 16) : null,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: _getTypeColor(question['type']).withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(6),
                                                border: Border.all(color: _getTypeColor(question['type']).withOpacity(0.3)),
                                              ),
                                              child: Text(
                                                question['type'] ?? 'Question',
                                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _getTypeColor(question['type'])),
                                              ),
                                            ),
                                            Spacer(),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                                              child: Text(
                                                '${question['marks'] ?? 1} Mark${(question['marks'] ?? 1) > 1 ? 's' : ''}',
                                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.blue[700]),
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 12),

                                        // Question Text
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${index + 1}.',
                                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                                            ),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                question['question'] ?? 'No question text',
                                                style: TextStyle(fontSize: 15, color: Colors.grey[800], height: 1.5, fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Options preview for MCQ (not selectable)
                                        if (hasOptions) ...[
                                          SizedBox(height: 12),
                                          Column(
                                            children: question['options'].take(2).map<Widget>((option) {
                                              return Padding(
                                                padding: EdgeInsets.only(bottom: 4),
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 24),
                                                    Expanded(
                                                      child: Text(
                                                        '${option['id']}) ${option['text']}',
                                                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                          if (question['options'].length > 2) ...[
                                            Padding(
                                              padding: EdgeInsets.only(left: 24),
                                              child: Text(
                                                '... and ${question['options'].length - 2} more options',
                                                style: TextStyle(fontSize: 12, color: Colors.grey[500], fontStyle: FontStyle.italic),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Generate PDF Button
          Consumer<HomeProvider>(
            builder: (context, provider, child) {
              var summary = provider.getSelectionSummary();
              bool hasSelection = summary['selected']! > 0;

              return Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
                ),
                child: Column(
                  children: [
                    // Selection Summary
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     _buildSummaryItem('Total', summary['total'].toString(), Colors.blue),
                    //     _buildSummaryItem('Selected', summary['selected'].toString(), Colors.green),
                    //     _buildSummaryItem('Remaining', summary['unselected'].toString(), Colors.grey),
                    //   ],
                    // ),
                    SizedBox(height: 16),

                    // Generate PDF Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: hasSelection
                            ? () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => EventPage(totalQuestions: provider.selectedQuestions.length.toString())),
                                );
                              }
                            : null,
                        icon: Icon(Icons.picture_as_pdf, color: hasSelection ? Colors.white : Colors.grey),
                        label: Text(
                          hasSelection ? 'Next' : 'Select questions to generate PDF',
                          style: TextStyle(color: hasSelection ? Colors.white : Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hasSelection ? Color(0xFF6366F1) : Colors.grey[300],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: hasSelection ? 2 : 0,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Widget _buildSummaryItem(String label, String count, Color color) {
  //   return Column(
  //     children: [
  //       Text(
  //         count,
  //         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
  //       ),
  //       SizedBox(height: 4),
  //       Text(
  //         label,
  //         style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500),
  //       ),
  //     ],
  //   );
  // }

  Color _getTypeColor(String? type) {
    switch (type) {
      case 'MCQ':
        return Colors.purple;
      case '1-mark':
        return Colors.green;
      case '2-mark':
        return Colors.blue;
      case '3-mark':
        return Colors.orange;
      case '4-mark':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
