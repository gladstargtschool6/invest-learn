import 'package:flutter/foundation.dart';

class CoachingProfile {
  String name;
  String ageRange;
  String country;
  String education;
  String occupation;
  String experience;
  bool runningBusiness;
  String businessType;
  String businessStage;
  String employees;
  String revenue;
  String biggestChallenge;
  String mainGoal;
  String targetDate;
  Map<String, int> skills;

  CoachingProfile({
    this.name = '', this.ageRange = '', this.country = '', this.education = '',
    this.occupation = '', this.experience = '', this.runningBusiness = false,
    this.businessType = '', this.businessStage = 'Idea', this.employees = '0',
    this.revenue = '', this.biggestChallenge = '', this.mainGoal = '',
    this.targetDate = '', Map<String, int>? skills,
  }) : skills = skills ?? {for (final skill in coachingSkills) skill: 3};

  double get averageScore => skills.values.isEmpty
      ? 0
      : skills.values.reduce((a, b) => a + b) / skills.length;
}

const coachingSkills = [
  'Communication', 'Decision-making', 'Delegation', 'Team management',
  'Emotional intelligence', 'Problem-solving', 'Strategic thinking',
  'Negotiation', 'Conflict management', 'Time management', 'Accountability',
];

class CoachingGoal {
  String title;
  String why;
  String target;
  String deadline;
  double progress;
  String nextAction;
  CoachingGoal({required this.title, this.why = '', this.target = '', this.deadline = '', this.progress = 0, this.nextAction = ''});
}

class CoachingTask {
  final String title;
  final String detail;
  final String category;
  bool completed;
  CoachingTask({required this.title, required this.detail, required this.category, this.completed = false});
}

class CoachingStore extends ChangeNotifier {
  CoachingProfile profile = CoachingProfile();
  bool onboardingComplete = false;
  int selectedPlanDays = 30;
  int streak = 4;
  int points = 180;
  final goals = <CoachingGoal>[];
  final tasks = <CoachingTask>[
    CoachingTask(title: 'One short lesson', detail: 'Customer acquisition cost: know what you pay to win each customer.', category: 'Learn'),
    CoachingTask(title: 'Reflection question', detail: 'What currently limits your customer acquisition?', category: 'Reflect'),
    CoachingTask(title: 'Business action', detail: 'Calculate your customer acquisition cost for the last 30 days.', category: 'Business'),
    CoachingTask(title: 'Leadership action', detail: 'Delegate one marketing task with a clear outcome and deadline.', category: 'Leadership'),
  ];
  final challenges = <CoachingTask>[
    CoachingTask(title: 'Define your ideal customer', detail: 'Write their problem, context, budget, and buying trigger.', category: 'Week 1'),
    CoachingTask(title: 'Interview five potential customers', detail: 'Ask about their current workaround before pitching.', category: 'Week 2'),
    CoachingTask(title: 'Improve your value proposition', detail: 'Describe the customer, problem, outcome, and proof in one sentence.', category: 'Week 3'),
    CoachingTask(title: 'Delegate one responsibility', detail: 'Give ownership, success criteria, and a check-in time.', category: 'Week 4'),
  ];

  void complete(CoachingTask task) {
    if (!task.completed) { task.completed = true; points += 25; notifyListeners(); }
  }

  void addGoal(CoachingGoal goal) { goals.add(goal); notifyListeners(); }
  void updateProfile(CoachingProfile value) { profile = value; onboardingComplete = true; notifyListeners(); }
}
