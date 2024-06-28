import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:tobetoapp/screens/calendar/calendar_page.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:tobetoapp/utils/theme/light/light_theme.dart';
import '../calendar/event_provider.dart';

class AddEventPage extends StatelessWidget {
  const AddEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return ChangeNotifierProvider(
      create: (_) => EventProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Etkinlik Ekle"),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CalendarPage()),
                );
              },
              icon: const Icon(Icons.calendar_month),
            ),
          ],
        ),
        body: Consumer<EventProvider>(
          builder: (context, provider, _) {
            return Padding(
              padding: EdgeInsets.all(AppConstants.paddingMedium),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        OutlineGradientButton(
                          padding: EdgeInsets.all(AppConstants.paddingLarge),
                          strokeWidth: 3,
                          radius: Radius.circular(AppConstants.br16),
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.tobetoMoru,
                              Colors.white30,
                              AppColors.tobetoMoru,
                              Colors.white30
                            ],
                            stops: [0.0, 0.5, 0.5, 1.0],
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                  height: AppConstants.sizedBoxHeightMedium),
                              TextFormField(
                                controller: provider.educationController,
                                focusNode: provider.educationFocusNode,
                                decoration: const InputDecoration(
                                    labelText: "Eğitim Adı"),
                                onChanged: (value) {
                                  provider.education = value;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Eğitim adı gerekli';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                  height: AppConstants.sizedBoxHeightSmall),
                              TextFormField(
                                controller: provider.educatorController,
                                focusNode: provider.educatorFocusNode,
                                decoration: const InputDecoration(
                                    labelText: "Eğitmen Adı"),
                                onChanged: (value) {
                                  provider.educator = value;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Eğitmen adı gerekli";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                  height: AppConstants.sizedBoxHeightSmall),
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: "Ücret (isteğe bağlı)"),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  provider.price = value;
                                },
                              ),
                              SizedBox(
                                  height: AppConstants.sizedBoxHeightSmall),
                              ElevatedButton(
                                onPressed: () => provider.selectDate(context),
                                child: Text(provider.date == null
                                    ? "Tarih Seç"
                                    : provider.date!
                                        .toLocal()
                                        .toString()
                                        .split(' ')[0]),
                              ),
                              SizedBox(
                                  height: AppConstants.sizedBoxHeightSmall),
                              ElevatedButton(
                                onPressed: () =>
                                    provider.selectStartTime(context),
                                child: Text(provider.startTime == null
                                    ? 'Başlangıç Saati Seç'
                                    : provider.startTime!.format(context)),
                              ),
                              SizedBox(
                                  height: AppConstants.sizedBoxHeightSmall),
                              ElevatedButton(
                                onPressed: () =>
                                    provider.selectEndTime(context),
                                child: Text(provider.endTime == null
                                    ? 'Bitiş Saati Seç'
                                    : provider.endTime!.format(context)),
                              ),
                              SizedBox(
                                  height: AppConstants.sizedBoxHeightSmall),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  fixedSize: const Size(double.infinity, 50),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    provider.addEvent(context);
                                  }
                                },
                                child: provider.isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : const Text(
                                        "Etkinlik Ekle",
                                        style: TextStyle(color: Colors.white),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
