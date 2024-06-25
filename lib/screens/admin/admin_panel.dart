import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_event.dart';
import 'package:tobetoapp/bloc/admin/admin_state.dart';
import 'package:tobetoapp/screens/admin/class_management.dart';
import 'package:tobetoapp/screens/admin/lesson_management.dart';
import 'package:tobetoapp/screens/admin/user_management.dart';
import 'package:tobetoapp/screens/calendar/calendar_page.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:tobetoapp/utils/theme/light/light_theme.dart';
import 'package:tobetoapp/widgets/admin/admin_charts.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(LoadChartData());
  }

  void _refreshChartData() {
    context.read<AdminBloc>().add(LoadChartData());
  }

  @override
  Widget build(BuildContext context) {
    AppConstants.init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: AppColors.tobetoMoru,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.verticalPaddingSmall,
        ),
        child: Column(
          children: [
            SizedBox(height: AppConstants.sizedBoxHeightSmall),
            SizedBox(
              height: AppConstants.screenHeight * 0.3,
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
            SizedBox(height: AppConstants.screenHeight * 0.02),
            Flexible(
              child: Column(
                children: [
                  _buildButton(
                    context,
                    "Kullanıcı Yönetimi",
                    const UserManagementPage(),
                  ),
                  SizedBox(height: AppConstants.sizedBoxHeightSmall),
                  _buildButton(
                    context,
                    "Sınıf Yönetimi",
                    const ClassManagementPage(),
                  ),
                  SizedBox(height: AppConstants.sizedBoxHeightSmall),
                  _buildButton(
                    context,
                    "Ders Yönetimi",
                    const LessonManagementPage(),
                  ),
                  SizedBox(height: AppConstants.sizedBoxHeightSmall),
                  _buildButton(
                    context,
                    "Takvim Yönetimi",
                    const CalendarPage(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, Widget page) {
    return Container(
      width: double.infinity, // Butonun genişliğini tam ekran yapar
      height: 50, // Butonun yüksekliğini ayarlar
      margin: const EdgeInsets.symmetric(
          vertical: 2), // Butonlar arasında boşluk ekler
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: context.read<AdminBloc>(),
                  child: page,
                ),
              ))
              .then((_) => _refreshChartData());
        },
        style: ElevatedButton.styleFrom(
          textStyle: Theme.of(context).textTheme.titleMedium,
        ),
        child: Text(title),
      ),
    );
  }
}
