import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_bh/widgets/text/custom_text.dart';
import 'package:pie_chart/pie_chart.dart';

class Reportview extends StatefulWidget {
  const Reportview({Key? key}) : super(key: key);

  @override
  State<Reportview> createState() => _ReportviewState();
}

class _ReportviewState extends State<Reportview> {
  Map<String, double> dataMap = {
    "Flutter": 5,
    "React": 5,
    "Xamarin": 5,
    "Ionic": 2,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Gap(50),
          Row(
            children: [
              CustomText(
                txt: 'Expenses Report',
                color: Colors.black,
                size: 15,
                fontweight: FontWeight.bold,
                spacing: 1,
                fontfamily: 'Cairo',
              ),
              Spacer(),
              DropdownButton(
                hint: const Text("cette mois"),
                items: const [
                  DropdownMenuItem(
                    child: Text("Janvier"),
                    value: 1,
                  ),
                  DropdownMenuItem(
                    child: Text("fevrier"),
                    value: 2,
                  ),
                  DropdownMenuItem(
                    child: Text("Mars"),
                    value: 3,
                  ),
                  DropdownMenuItem(
                    child: Text("Avril"),
                    value: 4,
                  ),
                  DropdownMenuItem(
                    child: Text("Mai"),
                    value: 5,
                  ),
                  DropdownMenuItem(
                    child: Text("Juin"),
                    value: 6,
                  ),
                ],
                onChanged: (value) {
                  print(value);

                  setState(() {
                    if (value == 1) {
                      dataMap = {
                        "Flutter": 5,
                        "React": 5,
                        "Xamarin": 5,
                        "Ionic": 2,
                      };
                    } else if (value == 2) {
                      dataMap = {
                        "Flutter": 10,
                        "React": 10,
                        "Xamarin": 10,
                        "Ionic": 5,
                      };
                    } else if (value == 3) {
                      dataMap = {
                        "Flutter": 15,
                        "React": 15,
                        "Xamarin": 15,
                        "Ionic": 10,
                      };
                    } else if (value == 4) {
                      dataMap = {
                        "Flutter": 20,
                        "React": 20,
                        "Xamarin": 20,
                        "Ionic": 15,
                      };
                    } else if (value == 5) {
                      dataMap = {
                        "Flutter": 25,
                        "React": 25,
                        "Xamarin": 25,
                        "Ionic": 20,
                      };
                    } else if (value == 6) {
                      dataMap = {
                        "Flutter": 30,
                        "React": 30,
                        "Xamarin": 30,
                        "Ionic": 25,
                      };
                    }
                  });
                },
              ),
            ],
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.03,
              right: MediaQuery.of(context).size.width * 0.03,
            ),
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: PieChart(
              dataMap: dataMap,
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: 40,
              chartRadius: MediaQuery.of(context).size.width / 2.2,
              colorList: [
                Colors.blue,
                Colors.red,
                Colors.green,
                Colors.yellow,
              ],
              initialAngleInDegree: 0,
              chartType: ChartType.disc,
              ringStrokeWidth: 32,
              // centerText: "HYBRID",
              legendOptions: LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.left,
                showLegends: true,
                legendShape: BoxShape.rectangle,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              chartValuesOptions: ChartValuesOptions(
                showChartValueBackground: true,
                showChartValues: true,
                showChartValuesInPercentage: false,
                showChartValuesOutside: false,
                decimalPlaces: 0,
              ),
              // gradientList: ---To add gradient colors---
              // emptyColorGradient: ---Empty Color gradient---
            ),
          ),
          Gap(30),
          Column(
            children: [
              ListTile(
                leading: Icon(
                  FeatherIcons.circle,
                  color: Colors.blue,
                  shadows: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                subtitle: CustomText(
                  txt: 'Ionic',
                  color: Colors.black,
                  size: 15,
                  fontweight: FontWeight.w100,
                  spacing: 1,
                  fontfamily: 'Cairo',
                ),
                title: CustomText(
                  txt: 'Flutter',
                  color: Colors.black,
                  size: 15,
                  fontweight: FontWeight.bold,
                  spacing: 1,
                  fontfamily: 'Cairo',
                ),
                trailing: CustomText(
                  txt: '5',
                  color: Colors.black,
                  size: 15,
                  fontweight: FontWeight.bold,
                  spacing: 1,
                  fontfamily: 'Cairo',
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
