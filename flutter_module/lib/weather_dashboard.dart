import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherDashboard extends StatefulWidget {
  const WeatherDashboard({Key? key}) : super(key: key);

  @override
  _WeatherDashboardState createState() => _WeatherDashboardState();
}

class _WeatherDashboardState extends State<WeatherDashboard> {
  String query = '';
  bool loading = false;
  String? error;
  Map<String, dynamic>? current;
  List<dynamic>? hourly;

  Future<void> searchCity(String name) async {
    setState(() {
      loading = true;
      error = null;
      current = null;
      hourly = null;
    });

    try {
      final gResp = await http.get(Uri.parse('https://geocoding-api.open-meteo.com/v1/search?name=${Uri.encodeComponent(name)}&count=1'));
      if (gResp.statusCode != 200) throw Exception('Geocoding failed');
      final gJson = jsonDecode(gResp.body) as Map<String, dynamic>;
      final results = gJson['results'] as List<dynamic>?;
      if (results == null || results.isEmpty) throw Exception('Location not found');
      final r = results.first as Map<String, dynamic>;
      final lat = r['latitude'];
      final lon = r['longitude'];

      final url = 'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true&hourly=temperature_2m,relativehumidity_2m&timezone=auto';
      final wResp = await http.get(Uri.parse(url));
      if (wResp.statusCode != 200) throw Exception('Weather fetch failed');
      final wJson = jsonDecode(wResp.body) as Map<String, dynamic>;
      setState(() {
        current = wJson['current_weather'] as Map<String, dynamic>?;
        hourly = wJson['hourly'] != null ? (wJson['hourly'] as Map<String, dynamic>)['temperature_2m'] as List<dynamic>? : null;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Search city'),
                  onChanged: (v) => query = v,
                  onSubmitted: (v) => searchCity(v),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => searchCity(query),
                child: const Text('Search'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (loading) const CircularProgressIndicator(),
          if (error != null) Text('Error: $error', style: const TextStyle(color: Colors.red)),
          if (current != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Temperature: ${current!['temperature']}°C', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text('Wind speed: ${current!['windspeed']} m/s'),
                    const SizedBox(height: 6),
                    Text('Wind direction: ${current!['winddirection']}°'),
                    const SizedBox(height: 6),
                    Text('Time: ${current!['time']}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (hourly != null) Expanded(
              child: ListView.builder(
                itemCount: (hourly ?? []).length > 24 ? 24 : (hourly ?? []).length,
                itemBuilder: (context, idx) {
                  final temp = hourly![idx];
                  return ListTile(
                    title: Text('Hour ${idx + 1}'),
                    trailing: Text('$temp °C'),
                  );
                },
              ),
            ),
          ]
        ],
      ),
    );
  }
}
