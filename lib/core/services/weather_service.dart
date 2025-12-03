import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const String _apiKey = '27af3b99f85d163020d3b42e7cab7740';
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> getWeather(String city) async {
    final url = Uri.parse(
      '$_baseUrl?q=$city&appid=$_apiKey&units=metric&lang=ru',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Weather.fromJson(data);
    } else {
      throw Exception('Не удалось получить данные о погоде');
    }
  }
}
