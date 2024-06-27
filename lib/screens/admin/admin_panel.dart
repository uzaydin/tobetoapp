import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_event.dart';
import 'package:tobetoapp/bloc/admin/admin_state.dart';
import 'package:tobetoapp/bloc/auth/auth_drawer/auth_provider_drawer.dart';
import 'package:tobetoapp/screens/admin/class_management.dart';
import 'package:tobetoapp/screens/admin/lesson_and_catalog_management.dart';
import 'package:tobetoapp/screens/admin/user_management.dart';
import 'package:tobetoapp/screens/calendar/add_event.dart';

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
      drawer: const DrawerManager(),
      backgroundColor: Colors.grey[200], // Sayfanın arka plan rengi
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.verticalPaddingSmall,
        ),
        child: Column(
          children: [
            SizedBox(height: AppConstants.sizedBoxHeightSmall),
            SizedBox(
              //height: AppConstants.screenHeight * 0.4,
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
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 1.5
                          : 1.5,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return _buildDashboardCard(
                        context,
                        icon: Icons.person,
                        label: 'Kullanıcı Yönetimi',
                        color: Colors.blue[100]!,
                        page: const UserManagementPage(),
                      );
                    case 1:
                      return _buildDashboardCard(
                        context,
                        icon: Icons.class_,
                        label: 'Sınıf Yönetimi',
                        color: Colors.orange[100]!,
                        page: const ClassManagementPage(),
                      );
                    case 2:
                      return _buildDashboardCard(
                        context,
                        icon: Icons.book,
                        label: 'Ders/Katalog Yönetimi',
                        color: Colors.pink[100]!,
                        page: const LessonAndCatalogManagementPage(),
                      );
                    case 3:
                      return _buildDashboardCard(
                        context,
                        icon: Icons.calendar_today,
                        label: 'Takvim Yönetimi',
                        color: Colors.green[100]!,
                        page: const AddEventPage(),
                      );
                    default:
                      return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context,
      {required IconData icon,
      required String label,
      required Color color,
      required Widget page}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: context.read<AdminBloc>(),
                child: page,
              ),
            ))
            .then((_) => _refreshChartData());
      },
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: AppConstants.screenWidth * 0.1,
                color: Colors.black,
              ),
              SizedBox(height: AppConstants.screenHeight * 0.01),
              Text(
                label,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: AppConstants.screenWidth * 0.035,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
