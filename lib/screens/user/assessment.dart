import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/competency_test/competency_test_bloc.dart';
import 'package:tobetoapp/bloc/competency_test/competency_test_event.dart';
import 'package:tobetoapp/bloc/competency_test/competency_test_state.dart';
import 'package:tobetoapp/bloc/exam/exam_bloc.dart';
import 'package:tobetoapp/bloc/exam/exam_event.dart';
import 'package:tobetoapp/bloc/exam/exam_state.dart';
import 'package:tobetoapp/repository/exam_repository.dart';
import 'package:tobetoapp/screens/user/competency_test_result_page.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:tobetoapp/widgets/user/competency_test_info_dialog.dart';
import 'package:tobetoapp/widgets/user/exam_dialog.dart';
import 'package:tobetoapp/widgets/user/result_dialog.dart';

class Assessment extends StatefulWidget {
  const Assessment({super.key});

  @override
  State<Assessment> createState() => _AssessmentState();
}

class _AssessmentState extends State<Assessment> {
  @override
  void initState() {
    super.initState();

    context.read<CompetencyTestBloc>().add(FetchCompetencyTestResult());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Değerlendirmeler'),
        backgroundColor: Colors.purple[50],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: AppConstants.sizedBoxHeightLarge),
            _buildIntroText(),
            _buildHeader(context),
            _buildSoftwareTestSection(),
            _buildSubjectList(),
            SizedBox(height: AppConstants.sizedBoxHeightLarge),
            _buildSubscriptionSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroText() {
    return RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'Yetkinlik',
            style: TextStyle(color: Colors.purple, fontSize: 18),
          ),
          TextSpan(
            text: 'lerini ücretsiz ölç, ',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          TextSpan(
            text: 'bilgi',
            style: TextStyle(color: Colors.purple, fontSize: 18),
          ),
          TextSpan(
            text: 'lerini test et.',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppConstants.paddingMedium),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(AppConstants.br20),
            bottomRight: Radius.circular(AppConstants.br20),
            bottomLeft: Radius.circular(AppConstants.br20),
          ),
          gradient: const LinearGradient(
            colors: [Color(0xFFdda1fa), Color(0xFF3c0b8c)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        padding: EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          children: [
            const Text(
              'Tobeto İşte Başarı Modeli',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppConstants.sizedBoxHeightLarge),
            const Text(
              '80 soru ile yetkinliklerini ölç, önerilen eğitimleri tamamla, rozetini kazan.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppConstants.sizedBoxHeightMedium),
            BlocBuilder<CompetencyTestBloc, CompetencyTestState>(
              builder: (context, state) {
                if (state is CompetencyTestLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CompetencyTestResultFetched) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9933ff),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppConstants.br20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const CompetencyTestResultPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Raporu Görüntüle',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9933ff),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppConstants.br20),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const CompetencyTestInfoDialog(),
                      );
                    },
                    child: const Text(
                      'Başla',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoftwareTestSection() {
    return Padding(
      padding: EdgeInsets.all(AppConstants.paddingMedium),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(AppConstants.br20),
            bottomRight: Radius.circular(AppConstants.br20),
            bottomLeft: Radius.circular(AppConstants.br20),
          ),
          gradient: const LinearGradient(
            colors: [Color(0xFFb59ef9), Color(0xFF1d0b8c)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        padding: EdgeInsets.all(AppConstants.paddingMedium),
        child: const Column(
          children: [
            Text(
              'Yazılımda Başarı Testi',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            Text(
              'Çoktan seçmeli sorular ile teknik bilgini test et.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            Text(
              ">>>",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<String> subjects = [
    "Front End",
    "Full Stack",
    "Back End",
    "Microsoft SQL Server",
    "Masaüstü Programlama"
  ];

  Widget _buildSubjectList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        return BlocProvider(
          create: (context) => ExamBloc(examRepository: ExamRepository())
            ..add(CheckExamCompletionStatus(subjects[index])),
          child: BlocBuilder<ExamBloc, ExamState>(
            builder: (context, state) {
              if (state is ExamCompletionStatus &&
                  state.subject == subjects[index]) {
                bool completed = state.isCompleted;
                return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: AppConstants.verticalPaddingSmall / 3,
                      horizontal: AppConstants.paddingMedium),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppConstants.br30),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8A2387), Color(0xFF1d0b8c)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.subject, color: Colors.white),
                      title: Text(
                        subjects[index],
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xFF8A2387),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppConstants.br30),
                          ),
                        ),
                        onPressed: () {
                          showGeneralDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierLabel: MaterialLocalizations.of(context)
                                .modalBarrierDismissLabel,
                            barrierColor: Colors.black54,
                            transitionDuration:
                                const Duration(milliseconds: 200),
                            pageBuilder: (BuildContext buildContext,
                                Animation animation,
                                Animation secondaryAnimation) {
                              return completed
                                  ? ResultDialog(subject: subjects[index])
                                  : ExamDialog(
                                      subject: subjects[index],
                                      onQuizCompleted: () {
                                        context.read<ExamBloc>().add(
                                              CheckExamCompletionStatus(
                                                  subjects[index]),
                                            );
                                      },
                                    );
                            },
                            transitionBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return SlideTransition(
                                position: CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOut,
                                ).drive(Tween<Offset>(
                                  begin: const Offset(0, 1),
                                  end: Offset.zero,
                                )),
                                child: child,
                              );
                            },
                          );
                        },
                        child: Text(completed ? 'Raporu Görüntüle' : 'Başla'),
                      ),
                    ),
                  ),
                );
              } else if (state is ExamLoading) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: AppConstants.verticalPaddingSmall,
                      horizontal: AppConstants.paddingMedium),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppConstants.br30),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8A2387), Color(0xFFE94057)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const ListTile(
                      leading: Icon(Icons.subject, color: Colors.white),
                      title: Text(
                        'Yükleniyor...',
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: CircularProgressIndicator(),
                    ),
                  ),
                );
              } else {
                return Container(); // Handle other states if needed
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildSubscriptionSection() {
    return Padding(
      padding: EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        children: [
          Container(
            height: AppConstants.screenHeight * 0.1,
            width: 2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SizedBox(height: AppConstants.sizedBoxHeightLarge),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Aboneliğe özel ',
                  style: TextStyle(color: Colors.purple, fontSize: 18),
                ),
                TextSpan(
                  text: 'değerlendirme araçları ',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                TextSpan(
                  text: 'için',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ],
            ),
          ),
          SizedBox(height: AppConstants.sizedBoxHeightXLarge),
          Container(
            padding: EdgeInsets.all(AppConstants.paddingLarge),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(AppConstants.br20),
                  bottomRight: Radius.circular(AppConstants.br20),
                  bottomLeft: Radius.circular(AppConstants.br20)),
              gradient: const LinearGradient(
                colors: [Color(0xFFac1eeb), Color(0xFF6e6cf5)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kazanım Odaklı Testler',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Dijital gelişim kategorisindeki eğitimlere başlamadan önce konuyla ilgili bilgin ölçülür ve seviyene göre yönlendirilirsin.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
          SizedBox(height: AppConstants.sizedBoxHeightXLarge),
          Container(
            padding: EdgeInsets.all(AppConstants.paddingMedium),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(AppConstants.br20),
                  bottomRight: Radius.circular(AppConstants.br20),
                  bottomLeft: Radius.circular(AppConstants.br20)),
              gradient: const LinearGradient(
                colors: [Color(0xFFac1eeb), Color(0xFF6e6cf5)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Huawei Talent Interview Teknik Bilgi Sınavı*',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Sertifika alabilmen için, eğitim yolculuğunun sonunda teknik yetkinliklerin ve kod bilgin ölçülür.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '4400+ soru | 30+ programlama dili 4 zorluk seviyesi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '*Türkiye Ar-Ge Merkezi tarafından tasarlanmıştır.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
