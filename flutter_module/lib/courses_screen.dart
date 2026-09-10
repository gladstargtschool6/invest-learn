import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({Key? key}) : super(key: key);

  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  List<dynamic> courses = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    try {
      final s = await rootBundle.loadString('assets/courses.json');
      final j = jsonDecode(s) as List<dynamic>;
      setState(() {
        courses = j;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (courses.isEmpty) return const Center(child: Text('No courses available'));

    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final c = courses[index] as Map<String, dynamic>;
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(c['title'] ?? 'Untitled'),
            subtitle: Text(c['description'] ?? ''),
            trailing: IconButton(
              icon: const Icon(Icons.open_in_new),
              onPressed: () {
                final url = c['link'] ?? '';
                if (url.isNotEmpty) {
                  // open url using url_launcher could be added; for now show dialog
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('External link'),
                      content: Text('Open $url in browser'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
