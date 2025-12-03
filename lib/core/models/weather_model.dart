class Weather {
  final String city;
  final String country;
  final double temperature;
  final String condition;

  Weather({
    required this.city,
    required this.country,
    required this.temperature,
    required this.condition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'] ?? 'Неизвестно', // fallback
      country: json['sys'] != null ? json['sys']['country'] ?? '??' : '??',
      temperature: (json['main'] != null && json['main']['temp'] != null)
          ? (json['main']['temp'] as num).toDouble()
          : 0.0,
      condition: (json['weather'] != null && json['weather'].isNotEmpty)
          ? json['weather'][0]['description'] ?? 'Неизвестно'
          : 'Неизвестно',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': city,
      'sys': {'country': country},
      'main': {'temp': temperature},
      'weather': [
        {'description': condition},
      ],
    };
  }
}
