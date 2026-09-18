import 'package:flutter/material.dart';
import 'coaching_models.dart';

class CoachingShell extends StatefulWidget {
  const CoachingShell({super.key});
  @override State<CoachingShell> createState() => _CoachingShellState();
}

class _CoachingShellState extends State<CoachingShell> {
  final store = CoachingStore();
  int index = 0;

  @override
  void initState() { super.initState(); store.addListener(_refresh); }
  @override
  void dispose() { store.removeListener(_refresh); store.dispose(); super.dispose(); }
  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(store: store, onOpen: (i) => setState(() => index = i)),
      LearnPage(store: store),
      CoachPage(store: store),
      ChallengesPage(store: store),
      ProgressPage(store: store),
    ];
    return Scaffold(
      body: SafeArea(child: pages[index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Learn'),
          NavigationDestination(icon: Icon(Icons.forum_outlined), selectedIcon: Icon(Icons.forum), label: 'Coaching'),
          NavigationDestination(icon: Icon(Icons.flag_outlined), selectedIcon: Icon(Icons.flag), label: 'Challenges'),
          NavigationDestination(icon: Icon(Icons.insights_outlined), selectedIcon: Icon(Icons.insights), label: 'Progress'),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  final CoachingStore store; final ValueChanged<int> onOpen;
  const DashboardPage({super.key, required this.store, required this.onOpen});
  @override Widget build(BuildContext context) {
    final name = store.profile.name.isEmpty ? 'Founder' : store.profile.name;
    return _Page(title: 'Good morning, $name', subtitle: 'Your coaching today', actions: [
      if (!store.onboardingComplete) _ActionCard(icon: Icons.assignment, title: 'Build your scorecard', body: 'Tell us where you are and where you want to go.', button: 'Start assessment', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AssessmentPage(store: store)))),
      _FocusCard(store: store),
      _ActionCard(icon: Icons.chat_bubble_outline, title: 'AI Coach', body: 'Work through the question that is limiting your progress.', button: 'Open coach', onTap: () => onOpen(2)),
      _ActionCard(icon: Icons.flag_outlined, title: 'Weekly challenge', body: store.challenges.first.title, button: 'View challenges', onTap: () => onOpen(3)),
    ]);
  }
}

class _FocusCard extends StatelessWidget {
  final CoachingStore store; const _FocusCard({required this.store});
  @override Widget build(BuildContext context) => Card(color: Theme.of(context).colorScheme.primary, child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text('TODAY\'S FOCUS', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, letterSpacing: 1)),
    const SizedBox(height: 8), Text(store.profile.mainGoal.isEmpty ? 'Build a business that creates real customer value.' : store.profile.mainGoal, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
    const SizedBox(height: 12), Text(store.tasks.first.detail, style: const TextStyle(color: Colors.white)),
  ]));
}

class LearnPage extends StatelessWidget { final CoachingStore store; const LearnPage({super.key, required this.store});
  @override Widget build(BuildContext context) => _Page(title: 'Learn', subtitle: 'Short, practical lessons for your next level', actions: const [
    _CourseCard(title: 'Entrepreneurial mindset', detail: 'Turn assumptions into testable opportunities.', progress: .3),
    _CourseCard(title: 'Customer validation', detail: 'Learn before you build.', progress: 0),
    _CourseCard(title: 'Communication & delegation', detail: 'Create clarity, ownership, and trust.', progress: .15),
    _CourseCard(title: 'Financial management', detail: 'Understand cash flow and sustainable growth.', progress: 0),
  ]);
}
class _CourseCard extends StatelessWidget { final String title, detail; final double progress; const _CourseCard({required this.title, required this.detail, required this.progress});
  @override Widget build(BuildContext context) => Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.play_arrow)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(detail), trailing: SizedBox(width: 70, child: LinearProgressIndicator(value: progress))));
}

class CoachPage extends StatefulWidget { final CoachingStore store; const CoachPage({super.key, required this.store}); @override State<CoachPage> createState() => _CoachPageState(); }
class _CoachPageState extends State<CoachPage> { final input = TextEditingController(); final messages = <String>['Before we continue, tell me what is currently limiting your customer acquisition.'];
  @override Widget build(BuildContext context) => _Page(title: 'AI Coach', subtitle: 'Practical questions, thoughtful challenges, real accountability', actions: [Expanded(child: ListView.builder(itemCount: messages.length, itemBuilder: (_, i) => Align(alignment: i.isEven ? Alignment.centerLeft : Alignment.centerRight, child: Card(color: i.isEven ? null : Theme.of(context).colorScheme.primaryContainer, child: Padding(padding: const EdgeInsets.all(14), child: Text(messages[i])))))), Row(children: [Expanded(child: TextField(controller: input, decoration: const InputDecoration(hintText: 'Share your situation...', border: OutlineInputBorder()))), IconButton(icon: const Icon(Icons.send), onPressed: () { if (input.text.trim().isEmpty) return; setState(() { messages.add(input.text.trim()); messages.add('Good start. What evidence do you have, and what is the smallest action you can take in the next 48 hours?'); input.clear(); }); })])]); }
}

class ChallengesPage extends StatelessWidget { final CoachingStore store; const ChallengesPage({super.key, required this.store});
  @override Widget build(BuildContext context) => _Page(title: 'Challenges', subtitle: 'Action beats intention. Complete one meaningful step.', actions: store.challenges.map((task) => _TaskTile(task: task, onDone: () => store.complete(task))).toList());
}
class ProgressPage extends StatelessWidget { final CoachingStore store; const ProgressPage({super.key, required this.store});
  @override Widget build(BuildContext context) { final done = store.tasks.where((t) => t.completed).length; return _Page(title: 'Progress', subtitle: 'Reward consistent action, not screen time.', actions: [Card(child: ListTile(leading: const Icon(Icons.local_fire_department), title: Text('${store.streak}-day streak'), subtitle: Text('${store.points} points earned'))), _Metric(title: 'Overall coaching progress', value: done / store.tasks.length), _Metric(title: 'Leadership development', value: store.profile.averageScore / 5), _Metric(title: 'Business development', value: store.challenges.where((t) => t.completed).length / store.challenges.length), const SizedBox(height: 8), const Text('Weekly review', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const Text('What did you accomplish? What did you learn? What will you do differently next week?')]); }
}
class _Metric extends StatelessWidget { final String title; final double value; const _Metric({required this.title, required this.value}); @override Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title), const SizedBox(height: 8), LinearProgressIndicator(value: value.clamp(0, 1)), const SizedBox(height: 4), Text('${(value.clamp(0, 1) * 100).round()}%')] ))); }
class _TaskTile extends StatelessWidget { final CoachingTask task; final VoidCallback onDone; const _TaskTile({required this.task, required this.onDone}); @override Widget build(BuildContext context) => Card(child: CheckboxListTile(value: task.completed, onChanged: (_) => onDone(), title: Text(task.title), subtitle: Text('${task.category} · ${task.detail}'))); }

class AssessmentPage extends StatefulWidget { final CoachingStore store; const AssessmentPage({super.key, required this.store}); @override State<AssessmentPage> createState() => _AssessmentPageState(); }
class _AssessmentPageState extends State<AssessmentPage> { final form = GlobalKey<FormState>(); final name = TextEditingController(); final goal = TextEditingController(); final challenge = TextEditingController(); String stage = 'Idea'; int days = 30;
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Your coaching assessment')), body: Form(key: form, child: ListView(padding: const EdgeInsets.all(20), children: [const Text('We use this to recommend training—not to judge your worth.', style: TextStyle(fontSize: 16)), const SizedBox(height: 20), TextFormField(controller: name, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()), validator: (v) => v == null || v.isEmpty ? 'Required' : null), const SizedBox(height: 12), TextFormField(controller: goal, decoration: const InputDecoration(labelText: 'Main business goal', border: OutlineInputBorder()), validator: (v) => v == null || v.isEmpty ? 'Required' : null), const SizedBox(height: 12), TextFormField(controller: challenge, decoration: const InputDecoration(labelText: 'Biggest business challenge', border: OutlineInputBorder())), const SizedBox(height: 12), DropdownButtonFormField(value: stage, decoration: const InputDecoration(labelText: 'Business stage', border: OutlineInputBorder()), items: ['Idea', 'Startup', 'Growing', 'Established'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(), onChanged: (v) => setState(() => stage = v!)), const SizedBox(height: 18), const Text('Choose your coaching horizon'), SegmentedButton<int>(segments: const [ButtonSegment(value: 30, label: Text('30 days')), ButtonSegment(value: 60, label: Text('60 days')), ButtonSegment(value: 90, label: Text('90 days'))], selected: {days}, onSelectionChanged: (v) => setState(() => days = v.first)), const SizedBox(height: 24), FilledButton(onPressed: () { if (!form.currentState!.validate()) return; final p = widget.store.profile..name = name.text..mainGoal = goal.text..biggestChallenge = challenge.text..businessStage = stage; widget.store.selectedPlanDays = days; widget.store.updateProfile(p); Navigator.pop(context); }, child: const Text('Create my coaching plan'))]))); }
}

class _Page extends StatelessWidget { final String title, subtitle; final List<Widget> actions; const _Page({required this.title, required this.subtitle, required this.actions}); @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.fromLTRB(16, 24, 16, 8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(subtitle), const SizedBox(height: 18), Expanded(child: ListView.separated(itemCount: actions.length, separatorBuilder: (_, __) => const SizedBox(height: 10), itemBuilder: (_, i) => actions[i]))])); }
class _ActionCard extends StatelessWidget { final IconData icon; final String title, body, button; final VoidCallback onTap; const _ActionCard({required this.icon, required this.title, required this.body, required this.button, required this.onTap}); @override Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [Icon(icon, size: 32), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text(body), TextButton(onPressed: onTap, child: Text(button))]))])); }
