import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

enum LearningAccess { free, premium }

enum CourseLevel { beginner, intermediate, advanced }

class LmsCategory {
  final String id;
  final String name;
  const LmsCategory(this.id, this.name);
}

const lmsCategories = <LmsCategory>[
  LmsCategory('entrepreneurship', 'Entrepreneurship'),
  LmsCategory('leadership', 'Leadership'),
  LmsCategory('business_management', 'Business Management'),
  LmsCategory('marketing_sales', 'Marketing & Sales'),
  LmsCategory('finance', 'Finance'),
  LmsCategory('personal_development', 'Personal Development'),
  LmsCategory('innovation_technology', 'Innovation & Technology'),
  LmsCategory('small_business', 'Small Business'),
  LmsCategory('startup_development', 'Startup Development'),
  LmsCategory('career_professional', 'Career & Professional Development'),
];

class LmsCourse {
  final String id, title, shortDescription, detailedDescription, category, level, instructor;
  final List<String> objectives;
  final int durationMinutes;
  final bool premium, published;
  final List<LmsModule> modules;
  const LmsCourse({required this.id, required this.title, this.shortDescription = '', this.detailedDescription = '', this.category = '', this.level = 'beginner', this.instructor = 'AI Coach', this.objectives = const [], this.durationMinutes = 0, this.premium = false, this.published = true, this.modules = const []});
  factory LmsCourse.fromJson(Map<String, dynamic> j) => LmsCourse(id: j['id'] ?? '', title: j['title'] ?? '', shortDescription: j['shortDescription'] ?? '', detailedDescription: j['detailedDescription'] ?? '', category: j['category'] ?? '', level: j['level'] ?? 'beginner', instructor: j['instructor'] ?? 'AI Coach', objectives: List<String>.from(j['objectives'] ?? const []), durationMinutes: j['durationMinutes'] ?? 0, premium: j['premium'] ?? false, published: j['published'] ?? true, modules: (j['modules'] as List? ?? const []).map((e) => LmsModule.fromJson(e)).toList());
}

class LmsModule { final String id, title; final int order; final List<LmsLesson> lessons; const LmsModule({required this.id, required this.title, this.order = 0, this.lessons = const []}); factory LmsModule.fromJson(Map<String, dynamic> j) => LmsModule(id: j['id'] ?? '', title: j['title'] ?? '', order: j['order'] ?? 0, lessons: (j['lessons'] as List? ?? const []).map((e) => LmsLesson.fromJson(e)).toList()); }
class LmsLesson { final String id, title, summary, content; final bool premium; const LmsLesson({required this.id, required this.title, this.summary = '', this.content = '', this.premium = false}); factory LmsLesson.fromJson(Map<String, dynamic> j) => LmsLesson(id: j['id'] ?? '', title: j['title'] ?? '', summary: j['summary'] ?? '', content: j['content'] ?? '', premium: j['premium'] ?? false); }

class LmsProgress { final String courseId; final Set<String> completedLessons; final int quizAttempts, totalLearningMinutes; final double averageScore; const LmsProgress({required this.courseId, this.completedLessons = const {}, this.quizAttempts = 0, this.totalLearningMinutes = 0, this.averageScore = 0}); }

class LmsRepository {
  final String baseUrl;
  final Future<String?> Function()? authToken;
  LmsRepository({this.baseUrl = '', this.authToken});
  Future<List<LmsCourse>> listCourses({int page = 1, int pageSize = 20, String? category}) async {
    if (baseUrl.isEmpty) return const [];
    final query = {'page': '$page', 'pageSize': '$pageSize', if (category != null) 'category': category};
    final response = await http.get(Uri.parse('$baseUrl/courses').replace(queryParameters: query), headers: await _headers());
    if (response.statusCode != 200) throw Exception('Unable to load courses');
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return (body['items'] as List).map((e) => LmsCourse.fromJson(e)).toList();
  }
  Future<Map<String, String>> _headers() async => {'accept': 'application/json', if (authToken != null && await authToken() != null) 'authorization': 'Bearer ${await authToken()}' };
}

class LmsStore extends ChangeNotifier {
  final LmsRepository repository;
  List<LmsCourse> courses = const [];
  bool loading = false;
  String? error;
  LearningAccess access;
  LmsStore({LmsRepository? repository, this.access = LearningAccess.free}) : repository = repository ?? LmsRepository();
  Future<void> loadCourses({String? category}) async { loading = true; error = null; notifyListeners(); try { courses = await repository.listCourses(category: category); } catch (e) { error = e.toString(); } loading = false; notifyListeners(); }
  bool canOpen(LmsCourse course) => !course.premium || access == LearningAccess.premium;
}
