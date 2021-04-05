import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/screens/city_screen.dart';
import 'package:weather_app/utilities/constants.dart';
import 'package:weather_app/services/weather.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather, this.locationAQI});
  final locationWeather;
  final locationAQI;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  int temperature;
  String weatherIcon;
  String cityName;
  String weatherMessage;
  int aqi;
  String aqiRemark;
  double latit;
  double longi;
  double humidity;

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather, widget.locationAQI);
  }

  void updateUI(dynamic weatherData, dynamic aqiData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherIcon = 'Error';
        weatherMessage = 'Unable to get the location';
        cityName = '';
        aqi = 0;
        aqiRemark = 'NULL';
        latit = 0.0;
        longi = 0.0;
        humidity = 0.0;
        return;
      }

      double temp = weatherData['main']['temp'].toDouble();
      temperature = temp.toInt();
      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);
      weatherMessage = weather.getMessage(temperature);
      cityName = weatherData['name'];
      aqi = aqiData['list'][0]['main']['aqi'];
      latit = weatherData['coord']['lat'];
      longi = weatherData['coord']['lon'];
      aqiRemark = weather.getAQIRemark(aqi);
      humidity = weatherData['main']['humidity'].toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () async {
                        var weatherData = await weather.getLocationWeather();
                        var aqiData = await weather.getCurrentAQI();
                        updateUI(weatherData, aqiData);
                      },
                      child: Icon(
                        CupertinoIcons.placemark,
                        size: 50.0,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        var typedName = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return CityScreen();
                          }),
                        );
                        if (typedName != null) {
                          var weatherData =
                              await weather.getCityWeather(typedName);

                          var aqiData = await weather.getCityAQI(latit, longi);

                          updateUI(weatherData, aqiData);
                        }
                      },
                      child: Icon(
                        CupertinoIcons.search_circle,
                        size: 50.0,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 55.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '$temperature°',
                        style: kTempTextStyle,
                      ),
                      Text(
                        weatherIcon,
                        style: kConditionTextStyle,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 13.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Air Quality Index: ',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            aqi.toString(),
                            style: TextStyle(
                              fontSize: 35,
                            ),
                          ),
                          Text(
                            ' ($aqiRemark)',
                            style: TextStyle(fontSize: 17),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 13.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Humidity %: ',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        humidity.toString(),
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: Text(
                    cityName == ''
                        ? 'Unable to find the location'
                        : '$weatherMessage\nin\n$cityName!',
                    textAlign: TextAlign.center,
                    style: kMessageTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
