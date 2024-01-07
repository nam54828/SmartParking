import 'package:flutter/material.dart';
import 'package:smart_parking/Provider/temperature_provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class temperature extends StatefulWidget {
  const temperature({Key? key}) : super(key: key);

  @override
  State<temperature> createState() => _temperatureState();
}

class _temperatureState extends State<temperature> {
  @override
  void initState() {
    super.initState();
    Provider.of<TemperatureProvider>(context, listen: false).connect();
  }
  @override
  void dispose() {
    Provider.of<TemperatureProvider>(context, listen: false).disconnect();
    super.dispose();
  }

  String getTemperatureDescription(double temperature) {
    if (temperature >= 0 && temperature < 10) {
      return 'It\'s very cold ❄️';
    } else if (temperature >= 10 && temperature < 20) {
      return 'It\'s cold ☃️';
    } else if (temperature >= 20 && temperature < 30) {
      return 'It\'s moderate 🌡️';
    } else if (temperature >= 30 && temperature < 40) {
      return 'It\'s warm ☀️';
    } else if (temperature >= 40 && temperature <= 60) {
      return 'It\'s hot 🔥';
    } else {
      return 'Temperature out of range';
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TemperatureProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Temperature", style: TextStyle(
          color: Colors.white,
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
      body: Consumer<TemperatureProvider>(
        builder: (context, mqttProvider, child){
          String temperatureDescription = getTemperatureDescription(mqttProvider.currentTemperature);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(model.isConnected)
                  Container(
                    child: Column(
                      children: [
                        Text(
                          'Temperature Gauge',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 20.0),
                        SfRadialGauge(
                          axes: <RadialAxis>[
                            RadialAxis(
                              minimum: 0,
                              maximum: 60,
                              ranges: <GaugeRange>[

                                GaugeRange(
                                  startValue: 0,
                                  endValue: 15,
                                  color: Colors.green,

                                ),
                                GaugeRange(
                                  startValue: 15,
                                  endValue: 30,
                                  color: Colors.yellow,
                                ),
                                GaugeRange(
                                  startValue: 30,
                                  endValue: 45,
                                  color: Colors.orange,
                                ),
                                GaugeRange(
                                  startValue: 45,
                                  endValue: 60,
                                  color: Colors.red,
                                ),

                              ],
                              pointers: <GaugePointer>[
                                NeedlePointer(
                                  value: model.currentTemperature,
                                  enableAnimation: true,
                                ),
                              ],
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                  widget: Text(
                                    '${model.currentTemperature} C',
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
                          temperatureDescription,
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