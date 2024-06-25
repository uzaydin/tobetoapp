import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_event.dart';
import 'package:tobetoapp/bloc/admin/admin_state.dart';
import 'package:tobetoapp/screens/admin/class_management.dart';
import 'package:tobetoapp/screens/admin/lesson_management.dart';
import 'package:tobetoapp/screens/admin/user_management.dart';
import 'package:tobetoapp/screens/calendar/calendar_page.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  void initState() {
    super.initState();
    context
        .read<AdminBloc>()
        .add(LoadChartData()); // Yalnızca Chart için gerekli verileri yükle
  }

  void _refreshChartData() {
    context.read<AdminBloc>().add(LoadChartData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: SizedBox(
        height: 400,
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<AdminBloc, AdminState>(
                builder: (context, state) {
                  if (state is AdminLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ChartDataLoaded) {
                    return AdminCharts(
                      classDistribution: state.classDistribution,
                      monthlyRegistrations: state.monthlyRegistrations,
                    );
                  } else if (state is AdminError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else {
                    return const Center(child: Text('Yükleniyor...'));
                  }
                },
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: context.read<AdminBloc>(),
                            child: const UserManagementPage(),
                          ),
                        ))
                        .then((_) => _refreshChartData());
                  },
                  child: const Text("Kullanıcı Yönetimi"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: context.read<AdminBloc>(),
                            child: const ClassManagementPage(),
                          ),
                        ))
                        .then((_) => _refreshChartData());
                  },
                  child: const Text("Sınıf Yönetimi"),
                ),
                // Diğer butonlar için yer tutucu
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: context.read<AdminBloc>(),
                            child: const LessonManagementPage(),
                          ),
                        ))
                        .then((_) => _refreshChartData());
                  },
                  child: const Text("Ders Yönetimi"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: context.read<AdminBloc>(),
                            child: const CalendarPage(),
                          ),
                        ))
                        .then((_) => _refreshChartData());
                  },
                  child: const Text("Takvim Yönetimi"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AdminCharts extends StatelessWidget {
  final Map<String, int> classDistribution;
  final List<int> monthlyRegistrations;

  AdminCharts(
      {super.key,
      required this.classDistribution,
      required this.monthlyRegistrations});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView(
        children: [
          // Pie Chart
          PieChart(
            PieChartData(
              sections: classDistribution.entries.map((entry) {
                return PieChartSectionData(
                  value: entry.value.toDouble(),
                  title: '${entry.key}\n${entry.value}',
                  color: getColor(entry.key),
                );
              }).toList(),
            ),
          ),
          // Bar Chart
          BarChart(
            BarChartData(
              barTouchData: barTouchData,
              titlesData: titlesData,
              borderData: borderData,
              barGroups: barGroups(monthlyRegistrations),
              gridData: const FlGridData(show: false),
              alignment: BarChartAlignment.spaceAround,
              maxY: (monthlyRegistrations.reduce((a, b) => a > b ? a : b))
                      .toDouble() +
                  1,
            ),
          ),
        ],
      ),
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
    const style = TextStyle(
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

  List<BarChartGroupData> barGroups(List<int> monthlyData) =>
      List.generate(12, (index) {
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
