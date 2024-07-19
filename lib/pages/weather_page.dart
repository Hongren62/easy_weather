import 'package:easy_weather/models/weather_model.dart';
import 'package:easy_weather/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService('#');
  Weather? _weather;

  _fetchWeather() async {
    // 當前城市
    String cityName = await _weatherService.getCurrentCity();

    // 發送request取得當前氣候狀況
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // 顯示動畫
  String getWeatherCondition(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/sunny.json';
    }

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'dirzzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thundersotm':
        return 'assets/thunder/json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  // init state
  @override
  void initState() {
    super.initState();

    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Icon(
                  Icons.location_pin,
                  color: Colors.grey,
                  size: 30,
                ),

                const SizedBox(height: 10),
                // city name
                Text(
                  _weather?.cityName ?? 'loading city...',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // animation
            Lottie.asset(getWeatherCondition(_weather?.mainCondition)),

            // temperature
            Text(
              '${_weather?.temperature.round()}°',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
