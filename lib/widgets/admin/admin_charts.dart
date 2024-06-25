import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';

class AdminCharts extends StatefulWidget {
  final Map<String, int> classDistribution;
  final List<int> monthlyRegistrations;

  const AdminCharts({
    super.key,
    required this.classDistribution,
    required this.monthlyRegistrations,
  });

  @override
  _AdminChartsState createState() => _AdminChartsState();
}

class _AdminChartsState extends State<AdminCharts> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: AppConstants.screenHeight * 0.26,
          child: PageView.builder(
            controller: _pageController,
            itemCount: 2,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              if (index == 0) {
                return PieChart(
                  PieChartData(
                    sections: widget.classDistribution.entries.map((entry) {
                      return PieChartSectionData(
                        value: entry.value.toDouble(),
                        title: '${entry.key}\n${entry.value}',
                        color: getColor(entry.key),
                        radius: 20,
                      );
                    }).toList(),
                  ),
                );
              } else {
                return BarChart(
                  BarChartData(
                    barTouchData: barTouchData,
                    titlesData: titlesData,
                    borderData: borderData,
                    barGroups: barGroups(widget.monthlyRegistrations),
                    gridData: const FlGridData(show: false),
                    alignment: BarChartAlignment.spaceAround,
                    maxY: (widget.monthlyRegistrations.reduce((a, b) => a > b ? a : b)).toDouble() * 1.5,
                  ),
                );
              }
            },
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(2, (index) {
            return GestureDetector(
              onTap: () {
                _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.black : Colors.grey,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      getTooltipColor: (group) => Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 8,
      getTooltipItem: (
        BarChartGroupData group,
        int groupIndex,
        BarChartRodData rod,
        int rodIndex,
      ) {
        return BarTooltipItem(
          rod.toY.round().toString(),
          const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Oca';
        break;
      case 1:
        text = 'Şub';
        break;
      case 2:
        text = 'Mar';
        break;
      case 3:
        text = 'Nis';
        break;
      case 4:
        text = 'May';
        break;
      case 5:
        text = 'Haz';
        break;
      case 6:
        text = 'Tem';
        break;
      case 7:
        text = 'Ağu';
        break;
      case 8:
        text = 'Eyl';
        break;
      case 9:
        text = 'Eki';
        break;
      case 10:
        text = 'Kas';
        break;
      case 11:
        text = 'Ara';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );

  FlBorderData get borderData => FlBorderData(
    show: false,
  );

  LinearGradient get _barsGradient => LinearGradient(
    colors: [
      Colors.blue.shade800,
      Colors.cyanAccent.shade400,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  List<BarChartGroupData> barGroups(List<int> monthlyData) {
    if (monthlyData.length != 12) {
      return [];
    }
    return List.generate(12, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: monthlyData[index].toDouble(),
            gradient: _barsGradient,
          )
        ],
        showingTooltipIndicators: [0],
      );
    });
  }

  Color getColor(String key) {
    const colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.yellow,
      Colors.cyan,
      Colors.pink,
      Colors.brown,
      Colors.teal,
      Colors.indigo,
      Colors.lime,
    ];
    int index = key.hashCode % colors.length;
    return colors[index];
  }
}