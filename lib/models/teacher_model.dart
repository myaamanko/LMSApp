enum TeacherType { All, Teaching, NonTeaching }

class Teacher {
  final String name;
  final String subject;
  final String imageUrl;
  final TeacherType type;

  Teacher({
    required this.name,
    required this.subject,
    required this.imageUrl,
    required this.type,
  });
}
