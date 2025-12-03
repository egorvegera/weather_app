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
      city: json['name'],
      country: json['sys']['country'],
      temperature: (json['main']['temp'] as num).toDouble(),
      condition: json['weather'][0]['description'],
    );
  }
}
