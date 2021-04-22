import 'package:weather_app/services/location.dart';
import 'package:weather_app/services/networking.dart';

const apiKey = '<Enter Your ApiKey>';
const openWeatherUrl = 'https://api.openweathermap.org/data/2.5/weather';
const airQualityUrl = 'https://api.openweathermap.org/data/2.5/air_pollution';

//?lat=50&lon=50&appid=19fba74d5e07bf0095e6f6b26f58ed94

class WeatherModel {
  Future<dynamic> getCityWeather(String cityName) async {
    NetworkHelper networkHelper =
        NetworkHelper('$openWeatherUrl?q=$cityName&appid=$apiKey&units=metric');
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getCurrentAQI() async {
    Location location = Location();
    await location.getCurrentLocation();

    NetworkHelper networkHelper = NetworkHelper(
        '$airQualityUrl?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey');

    var aqiData = await networkHelper.getData();
    return (aqiData);
  }

  Future<dynamic> getCityAQI(double latit, double longi) async {
    Location location = Location();
    await location.getCurrentLocation();

    NetworkHelper networkHelper =
        NetworkHelper('$airQualityUrl?lat=${latit}&lon=${longi}&appid=$apiKey');

    var aqiData = await networkHelper.getData();
    return (aqiData);
  }

  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();

    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherUrl?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');

    var weatherData = await networkHelper.getData();
    return (weatherData);
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }

  String getAQIRemark(int index) {
    if (index == 1) {
      return 'Good';
    } else if (index == 2) {
      return 'Fair';
    } else if (index == 3) {
      return 'Moderate';
    } else if (index == 4) {
      return 'Poor';
    } else {
      return 'Very Poor';
    }
  }
}

//1 = Good, 2 = Fair, 3 = Moderate, 4 = Poor, 5 = Very Poor.
