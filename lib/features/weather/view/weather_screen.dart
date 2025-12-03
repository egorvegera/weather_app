import 'package:flutter/material.dart';
import '../../../core/services/weather_service.dart';
import '../../../core/models/weather_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _service = WeatherService();
  Weather? _weather;
  final TextEditingController _controller = TextEditingController();

  Future<void> _getWeather(String city) async {
    try {
      final weather = await _service.getWeather(city);
      if (!mounted) return; // защита от использования BuildContext после async
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Погода')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Введите город',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _getWeather(value);
                }
              },
            ),
            const SizedBox(height: 20),
            if (_weather != null) ...[
              Text(
                '${_weather!.city}, ${_weather!.country}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${_weather!.temperature} °C, ${_weather!.condition}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
