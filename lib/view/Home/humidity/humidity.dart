import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_parking/Provider/humidity_provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'dart:math' as math;


class humidity extends StatefulWidget {
  const humidity({Key? key}) : super(key: key);

  @override
  State<humidity> createState() => _humidityState();
}

class _humidityState extends State<humidity> {

  @override
  void initState() {
    super.initState();
    Provider.of<HumidityProvider>(context, listen: false).connect();
  }
  @override
  void dispose() {
    Provider.of<HumidityProvider>(context, listen: false).disconnect();
    super.dispose();
  }


  String getHumidityDescription(double humidity) {
    if (humidity >= 0 && humidity < 20) {
      return 'Very Dry 🏜️';
    } else if (humidity >= 20 && humidity < 40) {
      return 'Dry 🏖️';
    } else if (humidity >= 40 && humidity < 60) {
      return 'Moist 🌦️';
    } else if (humidity >= 60 && humidity < 80) {
      return 'Damp 🌧️';
    } else if (humidity >= 80 && humidity <= 100) {
      return 'Very Moist 🌊';
    } else {
      return 'Invalid humidity data';
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HumidityProvider>(context);
    String humidityDescription = getHumidityDescription(model.currentHumidity);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Humidity", style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16
        ),),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_left), color: Colors.white,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Consumer<HumidityProvider>(
        builder: (context, humidityProvider, child){
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(model.isConnected)
                  Container(
                    child: Column(
                      children: [
                        Text(
                          'Humidity Gauge',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 20.0),
                        SfRadialGauge(
                          axes: <RadialAxis>[
                            RadialAxis(
                              minimum: 0,
                              maximum: 100,
                              ranges: <GaugeRange>[

                                GaugeRange(
                                  startValue: 0,
                                  endValue: 20,
                                  color: Colors.green,

                                ),
                                GaugeRange(
                                  startValue: 20,
                                  endValue: 40,
                                  color: Colors.yellow,
                                ),
                                GaugeRange(
                                  startValue: 40,
                                  endValue: 60,
                                  color: Colors.orange,
                                ),
                                GaugeRange(
                                  startValue: 60,
                                  endValue: 80,
                                  color: Colors.red,
                                ),
                                GaugeRange(
                                  startValue: 80,
                                  endValue: 100,
                                  color: Colors.purple,
                                ),
                              ],
                              pointers: <GaugePointer>[
                                NeedlePointer(
                                  value: model.currentHumidity,
                                  enableAnimation: true,
                                ),
                              ],
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                  widget: Text(
                                    '${model.currentHumidity}%',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  angle: 90,
                                  positionFactor: 0.5,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          humidityDescription,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                if(!model.isConnected)
                  CircularProgressIndicator()
              ],
            ),
          );
        },

      ),
    );
  }
}