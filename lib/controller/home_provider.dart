import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider extends ChangeNotifier {
  late Razorpay _razorpay;
  bool isPremium = false;

  HomeProvider() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _checkPremiumStatus();
  }

  Future<void> _checkPremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isPremium = prefs.getBool('isPremium') ?? false;
    notifyListeners();
  }

  void startPayment() {
    var options = {
      'key': 'rzp_test_placeholder', // REPLACE WITH YOUR KEY
      'amount': 100, // 100 paise = 1 INR
      'name': 'Paper Generator',
      'description': 'Premium Chapter Access',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    debugPrint("Payment Success: ${response.paymentId}");
    isPremium = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPremium', true);
    notifyListeners();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("Payment Error: ${response.code} - ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("External Wallet: ${response.walletName}");
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  List<String> categories = ['Teachers', 'Students', 'Others'];
  String category = 'Teachers';
  void setCategory(String value) {
    category = value;
    notifyListeners();
  }

  List<String> boards = ['Gujarat', 'Bihar', 'Maharashtra'];
  String board = 'Gujarat';
  void setBoard(String value) {
    board = value;
    notifyListeners();
  }

  List<String> mediums = ['english-medium', 'gujrati-medium'];
  String medium = 'english-medium';
  void setMedium(String value) {
    medium = value;
    notifyListeners();
  }

  // List<String> streams = ['Secondary', 'Science', 'Commerce', 'Arts'];
  // String stream = 'Secondary';
  // void setStream(String value) {
  //   stream = value;
  //   notifyListeners();
  // }

  List<String> standards = ['9', '10', '11-com', '11-sci', '12-com', '12-sci'];
  String standard = '10';
  void setStandard(String value) {
    standard = value;
    notifyListeners();
  }

  Map dataMap = {};

  Future<void> loadJosnData() async {
    try {
      final String response = await rootBundle.loadString('assets/std/db.json');
      Map data = jsonDecode(response);
      if (data.isNotEmpty) {
        dataMap = data;
      } else {
        dataMap = {};
      }
      notifyListeners();
    } catch (e, straceTrace) {
      print('Error loading JSON data: $e');
      print('Stack trace: $straceTrace');
    }
  }

  List<String> subNames = [];

  void getDataSubject() {
    subNames = [];
    if (dataMap.isNotEmpty) {
      subNames = dataMap[medium]['std-$standard'].keys.toList();
    }
    notifyListeners();
  }

  List chapterNames = [];

  String selectedSubject = '';

  void getChapterData(String subName) {
    selectedSubject = subName;
    chapterNames = [];
    _selectedQuestions.clear(); // Clear selections when subject changes
    if (dataMap.isNotEmpty) {
      chapterNames = dataMap[medium]['std-$standard'][subName].keys.toList();
    }
    notifyListeners();
  }

  List questionTypes = [];
  String selectedChapter = '';

  void getQuestionType(String chapter) {
    selectedChapter = chapter;
    questionTypes = [];
    if (dataMap.isNotEmpty) {
      questionTypes = dataMap[medium]['std-$standard'][selectedSubject][chapter].keys.toList();
      questionTypes.remove('name');
    }
    notifyListeners();
  }

  String selectedQuestionType = '';

  void getQuestions(String questionType) {
    selectedQuestionType = questionType;
    // questionList = [];
    // if (dataMap.isNotEmpty) {
    //   questionList = dataMap[medium]['std-$standard'][selectedSubject][selectedChapter][questionType];
    // }
    notifyListeners();
  }

  Map<String, String> _selectedAnswers = {};
  List<Map<String, dynamic>> _questionList = [];
  List<Map<String, dynamic>> get questionList => _questionList;
  Set<Map<String, dynamic>> _selectedQuestions = {};
  Set<Map<String, dynamic>> get selectedQuestions => _selectedQuestions;

  Map<String, String> get selectedAnswers => _selectedAnswers;

  // Getters

  int chapterTotalQuestions = 0;
  void chapterTotalQuestionCount() {
    chapterTotalQuestions = 0;

    if (dataMap.isNotEmpty) {
      var subjectData = dataMap[medium]['std-$standard'][selectedSubject];
      var chapterData = subjectData[selectedChapter];

      for (var key in chapterData.keys) {
        if (key != 'name' && chapterData[key] is List) {
          chapterTotalQuestions += (chapterData[key] as List).length;
        }
      }
    }

    notifyListeners();
  }

  void loadQuestions() {
    _questionList.clear();
    try {
      var chapterData = dataMap[medium]['std-$standard'][selectedSubject][selectedChapter];
      List<dynamic>? questions = chapterData[selectedQuestionType];

      if (questions != null) {
        for (int i = 0; i < questions.length; i++) {
          var q = Map<String, dynamic>.from(questions[i]);
          _questionList.add({
            'id': '${selectedQuestionType}_${i + 1}',
            'question': q['question'],
            'options': (selectedQuestionType == 'mcq')
                ? ['A', 'B', 'C', 'D'].where((opt) => q.containsKey(opt)).map((opt) => {"id": opt, "text": q[opt]}).toList()
                : [],
            'subject': selectedChapter,
            'type': selectedQuestionType,
            'marks': _getMarks(selectedQuestionType),
            'qus-image': q['qus-image'] ?? '',
            'op-image': q['op-image'] ?? false,
          });
        }
      }
      chapterTotalQuestionCount();
    } catch (e, stackTrace) {
      print("Error loading questions: $e $stackTrace");
    } finally {
      notifyListeners();
    }
  }

  int _getMarks(String type) {
    switch (type) {
      case '1-mark':
        return 1;
      case '2-mark':
        return 2;
      case '3-mark':
        return 3;
      case '4-mark':
        return 4;
      default:
        return 1;
    }
  }

  void toggleQuestionSelection(Map<String, dynamic> questionId) {
    if (_selectedQuestions.contains(questionId)) {
      _selectedQuestions.remove(questionId);
    } else {
      _selectedQuestions.add(questionId);
    }
    notifyListeners();
  }

  void selectAllQuestions() {
    for (var question in _questionList) {
      _selectedQuestions.add(question);
    }
    notifyListeners();
  }

  void clearAllSelections() {
    _selectedQuestions.clear();
    notifyListeners();
  }

  String getChapterName() {
    try {
      return dataMap[medium][standard][selectedSubject][selectedChapter]['name'];
    } catch (e) {
      return "Chapter";
    }
  }

  Map<String, int> getSelectionSummary() {
    int totalQuestions = chapterTotalQuestions;
    int selectedCount = _selectedQuestions.length;
    int unselectedCount = chapterTotalQuestions - selectedCount;

    return {'total': totalQuestions, 'selected': selectedCount, 'unselected': unselectedCount};
  }

  List<Map<String, dynamic>> getSelectedQuestionsList() {
    return _questionList.where((question) => _selectedQuestions.contains(question['id'])).toList();
  }

  DateTime? _selectedDate;
  String? _selectedTime;
  String _instituteName = '';
  String _testName = '';
  String _pageEndingText = '';
  File? _watermarkImage;

  // Getters
  DateTime? get selectedDate => _selectedDate;
  String? get selectedTime => _selectedTime;
  String get instituteName => _instituteName;
  String get testName => _testName;
  String get pageEndingText => _pageEndingText;
  File? get watermarkImage => _watermarkImage;

  // Setters
  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setTime(String time) {
    _selectedTime = time;
    notifyListeners();
  }

  void setInstituteName(String value) {
    _instituteName = value;
    notifyListeners();
  }

  void setTestName(String value) {
    _testName = value;
    notifyListeners();
  }

  void setPageEndingText(String value) {
    _pageEndingText = value;
    notifyListeners();
  }

  void setWatermarkImage(File image) {
    _watermarkImage = image;
    notifyListeners();
  }

  void clearForm() {
    _selectedDate = null;
    _selectedTime = null;
    _instituteName = '';
    _testName = '';
    _pageEndingText = '';
    _watermarkImage = null;
    notifyListeners();
  }
}
