import 'package:flutter/services.dart';

import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class QuestionPaperPDF {
  static Future<File> generatePDF({
    required String subject,
    required String standard,
    required String marks,
    required String examTime,
    required List<Map<String, dynamic>> questions,
    required String date,
    required String instituteName,
    required String testName,
    required String pageEndingText,
    File? watermarkImage,
  }) async {
    final pdf = pw.Document();

    // Load fonts that support Unicode (including Gujarati)
    final regularFont = await _loadFont('assets/std/NotoSans-Regular.ttf');
    final gujaratiFont = await _loadFont('assets/std/NotoSansGujarati-Regular.ttf');

    final Uint8List? logoBytes = watermarkImage?.readAsBytesSync();

    final pageTheme = pw.PageTheme(
      margin: const pw.EdgeInsets.all(24),
      pageFormat: PdfPageFormat.a4,
      buildBackground: (context) {
        if (logoBytes != null) {
          return pw.FullPage(
            ignoreMargins: true,
            child: pw.Center(
              child: pw.Opacity(
                opacity: 0.5,
                child: pw.Image(
                  pw.MemoryImage(logoBytes),
                  width: 300, // Adjust size as needed
                  fit: pw.BoxFit.contain,
                ),
              ),
            ),
          );
        }
        return pw.Container();
      },
    );

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        build: (pw.Context context) {
          final List<pw.Widget> content = [];

          // Header
          if (logoBytes != null) {
            content.add(_buildHeader(subject, standard, marks, examTime, date, instituteName, testName, logoBytes, regularFont, gujaratiFont));
          } else {
            // Fallback header without logo if needed, or just standard header (logic below assumes logoBytes exists for header currently, keeping it safe)
            content.add(
              _buildHeader(subject, standard, marks, examTime, date, instituteName, testName, logoBytes ?? Uint8List(0), regularFont, gujaratiFont),
            );
          }

          content.add(pw.SizedBox(height: 20));

          // Dynamic Sections
          final List<String> questionTypes = ['mcq', '1-mark', '2-mark', '3-mark', '4-mark', '5-mark']; // Added 4-mark just in case
          int questionCounter = 1;
          int sectionIndex = 0;
          final List<String> sectionLetters = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];

          for (final type in questionTypes) {
            final sectionQuestions = questions.where((q) => q['type'] == type).toList();
            if (sectionQuestions.isNotEmpty) {
              final sectionLetter = sectionLetters[sectionIndex % sectionLetters.length];

              content.add(_buildSection(sectionQuestions, sectionLetter, questionCounter, regularFont, gujaratiFont, type == 'mcq'));

              content.add(pw.SizedBox(height: 20));

              questionCounter += sectionQuestions.length;
              sectionIndex++;
            }
          }

          content.add(pw.SizedBox(height: 30));
          content.add(_buildFooter(pageEndingText, regularFont, gujaratiFont));

          return content;
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/question_paper_${standard}_${subject}_${instituteName}_${testName}_.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future<pw.Font> _loadFont(String fontPath) async {
    try {
      final fontData = await rootBundle.load(fontPath);
      return pw.Font.ttf(fontData);
    } catch (e) {
      print('Error loading font $fontPath: $e');
      // Fallback to basic font (though it may not support all characters)
      return pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSans-Regular.ttf'));
    }
  }

  static pw.TextStyle _getTextStyle(
    pw.Font regularFont,
    pw.Font gujaratiFont, {
    double fontSize = 11,
    pw.FontWeight fontWeight = pw.FontWeight.normal,
    bool isSectionHeader = false,
  }) {
    return pw.TextStyle(
      font: regularFont,
      fontFallback: [gujaratiFont], // Fallback for unsupported characters
      fontSize: fontSize,
      fontWeight: fontWeight,
      decoration: isSectionHeader ? pw.TextDecoration.underline : null,
    );
  }

  static pw.Widget _buildHeader(
    String subject,
    String standard,
    String marks,
    String examTime,
    String date,
    String instituteName,
    String testName,
    Uint8List logoBytes,
    pw.Font regularFont,
    pw.Font gujaratiFont,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          decoration: pw.BoxDecoration(border: pw.Border.all(width: 2)),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              if (logoBytes.isNotEmpty)
                pw.Padding(padding: pw.EdgeInsets.all(8.0), child: pw.Image(pw.MemoryImage(logoBytes), width: 50, height: 50)),
              pw.SizedBox(width: 10),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [pw.Text(instituteName, style: _getTextStyle(regularFont, gujaratiFont, fontSize: 20, fontWeight: pw.FontWeight.bold))],
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Divider(thickness: 1),
        pw.Column(
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Subject: $subject', style: _getTextStyle(regularFont, gujaratiFont)),
                // pw.Spacer(),
                pw.Text(testName, style: _getTextStyle(regularFont, gujaratiFont, fontSize: 14, fontWeight: pw.FontWeight.bold)),
                // pw.Spacer(),
                pw.Text('Date: $date', style: _getTextStyle(regularFont, gujaratiFont)),
              ],
            ),
            pw.SizedBox(height: 5),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Standard: $standard', style: _getTextStyle(regularFont, gujaratiFont)),
                // pw.Spacer(),
                pw.Text('Marks: $marks', style: _getTextStyle(regularFont, gujaratiFont)),
              ],
            ),
            pw.SizedBox(height: 5),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                // pw.Spacer(),
                pw.Container(),
                pw.Text('Exam Time: $examTime', style: _getTextStyle(regularFont, gujaratiFont)),
              ],
            ),
          ],
        ),
        pw.Divider(thickness: 1),
      ],
    );
  }

  static pw.Widget _buildSection(
    List<Map<String, dynamic>> questions,
    String sectionLetter,
    int startNumber,
    pw.Font regularFont,
    pw.Font gujaratiFont,
    bool isMcq,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Align(
          alignment: pw.Alignment.center,
          child: pw.Text(
            'Section - $sectionLetter',
            style: _getTextStyle(regularFont, gujaratiFont, fontSize: 14, fontWeight: pw.FontWeight.bold, isSectionHeader: true),
          ),
        ),
        pw.SizedBox(height: 10),
        ...questions.asMap().entries.map((entry) {
          int index = entry.key;
          var question = entry.value;
          int questionNum = startNumber + index;

          if (isMcq) {
            return _buildMCQQuestion(question, questionNum, regularFont, gujaratiFont);
          } else {
            // Assuming marks are stored in the question map or we parse it from type?
            // The previous code passed marks explicitly.
            // We can extract marks from 'marks' key in question map if available, or parse 'type'
            int marks = question['marks'] ?? 1; // Default to 1 if not found
            return _buildShortQuestion(question, questionNum, marks, regularFont, gujaratiFont);
          }
        }).toList(),
      ],
    );
  }

  static pw.Widget _buildMCQQuestion(Map<String, dynamic> question, int number, pw.Font regularFont, pw.Font gujaratiFont) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('$number. ', style: _getTextStyle(regularFont, gujaratiFont, fontWeight: pw.FontWeight.bold)),
            pw.Expanded(child: pw.Text(_getQuestionText(question), style: _getTextStyle(regularFont, gujaratiFont, fontSize: 11))),
          ],
        ),
        pw.SizedBox(height: 5),
        if (question['options'] != null)
          ...question['options'].map<pw.Widget>((option) {
            return pw.Padding(
              padding: pw.EdgeInsets.only(left: 15, bottom: 2),
              child: pw.Text('${option['id']}. ${_getOptionText(option)}', style: _getTextStyle(regularFont, gujaratiFont, fontSize: 10)),
            );
          }).toList(),
        pw.SizedBox(height: 8),
      ],
    );
  }

  static pw.Widget _buildShortQuestion(Map<String, dynamic> question, int number, int marks, pw.Font regularFont, pw.Font gujaratiFont) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('$number. ', style: _getTextStyle(regularFont, gujaratiFont, fontWeight: pw.FontWeight.bold)),
            pw.Expanded(child: pw.Text(_getQuestionText(question), style: _getTextStyle(regularFont, gujaratiFont, fontSize: 11))),
            pw.Text('[$marks]', style: _getTextStyle(regularFont, gujaratiFont, fontWeight: pw.FontWeight.bold)),
          ],
        ),
        pw.SizedBox(height: 10),
      ],
    );
  }

  static pw.Widget _buildFooter(String pageEndingText, pw.Font regularFont, pw.Font gujaratiFont) {
    return pw.Center(
      child: pw.Column(
        children: [pw.Text(pageEndingText, style: _getTextStyle(regularFont, gujaratiFont, fontSize: 25, fontWeight: pw.FontWeight.bold))],
      ),
    );
  }

  static String _getQuestionText(Map<String, dynamic> question) {
    return question['question'] ?? '';
  }

  static String _getOptionText(Map<String, dynamic> option) {
    return option['text'] ?? '';
  }
}
