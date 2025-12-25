class QuestionModel {
  final String id;
  final String question;
  final List<OptionModel> options;
  final String subject;
  final String type;
  final int marks;
  final String qusImage;
  final dynamic opImage; // Can be boolean or image path/url, kept dynamic to match original usage if needed, or better specify

  QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.subject,
    required this.type,
    required this.marks,
    this.qusImage = '',
    this.opImage = false,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map, String id, int marks, String type, String subject) {
    return QuestionModel(
      id: id,
      question: map['question'] ?? '',
      options: (type == 'mcq')
          ? ['A', 'B', 'C', 'D'].where((opt) => map.containsKey(opt)).map((opt) => OptionModel(id: opt, text: map[opt])).toList()
          : [],
      subject: subject,
      type: type,
      marks: marks,
      qusImage: map['qus-image'] ?? '',
      opImage: map['op-image'] ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestionModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class OptionModel {
  final String id;
  final String text;

  OptionModel({required this.id, required this.text});
}
