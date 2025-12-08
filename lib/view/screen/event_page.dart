import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:paper_genarate_app/controller/home_provider.dart';
import 'package:paper_genarate_app/view/screen/pdf_view.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../utils/custom_appbar.dart';

class EventPage extends StatelessWidget {
  final String totalQuestions;
  const EventPage({super.key, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppbar(title: 'Export PDF', subtitle: 'Sub Total: $totalQuestions Questions'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  DateSection(),
                  SizedBox(height: 16),
                  TimeSection(),
                  SizedBox(height: 16),
                  InstituteNameField(),
                  SizedBox(height: 16),
                  TestNameField(),
                  SizedBox(height: 16),
                  PageEndingTextField(),
                  SizedBox(height: 16),
                  WatermarkSection(),
                  SizedBox(height: 24),
                  SubmitButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Date Section
class DateSection extends StatelessWidget {
  const DateSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Date',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: provider.selectedDate ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (date != null) {
                provider.setDate(date);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    provider.selectedDate != null ? DateFormat('dd/MM/yyyy').format(provider.selectedDate!) : '20/04/2025',
                    style: const TextStyle(fontSize: 15),
                  ),
                  const Icon(Icons.calendar_today, size: 18, color: Colors.blue),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Time Section
class TimeSection extends StatelessWidget {
  const TimeSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter total houers',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: provider.setTime,
            decoration: InputDecoration(
              hintText: 'Enter total houers',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// Institute Name Field
class InstituteNameField extends StatelessWidget {
  const InstituteNameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter Institute Name',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: provider.setInstituteName,
            decoration: InputDecoration(
              hintText: 'Enter Institute Name',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// Test Name Field
class TestNameField extends StatelessWidget {
  const TestNameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter Test Name',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: provider.setTestName,
            decoration: InputDecoration(
              hintText: 'Enter Test Name',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class PageEndingTextField extends StatelessWidget {
  const PageEndingTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Wish you all the best',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: provider.setPageEndingText,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter ending message',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}

// Watermark Section
class WatermarkSection extends StatelessWidget {
  const WatermarkSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Water Mark',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (provider.watermarkImage != null)
                Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(6),
                    image: DecorationImage(image: FileImage(provider.watermarkImage!), fit: BoxFit.cover),
                  ),
                ),
              ElevatedButton(
                onPressed: () async {
                  final picker = ImagePicker();
                  final image = await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    provider.setWatermarkImage(File(image.path));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text('Upload'),
              ),
            ],
          ),
          if (provider.watermarkImage == null)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('Image', style: TextStyle(color: Colors.grey, fontSize: 13)),
            ),
        ],
      ),
    );
  }
}

// Submit Button
class SubmitButton extends StatelessWidget {
  const SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context, listen: false);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          // Access all form data
          int totalMarks = 0;
          for (Map<String, dynamic> q in provider.selectedQuestions) {
            totalMarks += q['marks'] as int;
          }
          log('error: ${provider.selectedQuestions}');
          final file = await QuestionPaperPDF.generatePDF(
            subject: provider.selectedSubject,
            standard: provider.standard,
            marks: totalMarks.toString(),
            examTime: '2 H',
            questions: provider.selectedQuestions.toList(),
            date: provider.selectedDate != null
                ? DateFormat('dd/MM/yyyy').format(provider.selectedDate!)
                : DateFormat('dd/MM/yyyy').format(DateTime.now()),
            instituteName: provider.instituteName,
            testName: provider.testName,
            pageEndingText: provider.pageEndingText,
            watermarkImage: provider.watermarkImage,
          );

          // Open PDF preview
          await Printing.layoutPdf(
            onLayout: (PdfPageFormat format) async {
              return await file.readAsBytes();
            },
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Genarete', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
