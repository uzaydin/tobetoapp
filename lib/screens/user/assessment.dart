import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/competency_test/competency_test_bloc.dart';
import 'package:tobetoapp/bloc/competency_test/competency_test_event.dart';
import 'package:tobetoapp/bloc/competency_test/competency_test_state.dart';
import 'package:tobetoapp/bloc/exam/exam_bloc.dart';
import 'package:tobetoapp/bloc/exam/exam_event.dart';
import 'package:tobetoapp/bloc/exam/exam_state.dart';
import 'package:tobetoapp/repository/exam_repository.dart';
import 'package:tobetoapp/screens/competency_test_result_page.dart';
import 'package:tobetoapp/widgets/user/competency_test_dialog.dart';
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
            const SizedBox(height: 20),
            _buildIntroText(),
            _buildHeader(context),
            _buildSoftwareTestSection(),
            _buildSubjectList(),
            const SizedBox(height: 20),
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
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          gradient: LinearGradient(
            colors: [Color(0xFFdda1fa), Color(0xFF3c0b8c)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 30),
            const Text(
              '80 soru ile yetkinliklerini ölç, önerilen eğitimleri tamamla, rozetini kazan.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            BlocBuilder<CompetencyTestBloc, CompetencyTestState>(
              builder: (context, state) {
                if (state is CompetencyTestLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CompetencyTestResultFetched) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9933ff),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CompetencyTestResultPage(),
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
                        borderRadius: BorderRadius.circular(18.0),
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
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          gradient: LinearGradient(
            colors: [Color(0xFFb59ef9), Color(0xFF1d0b8c)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
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
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
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
                            borderRadius: BorderRadius.circular(30),
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
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
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
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            height: 100,
            width: 2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          const SizedBox(height: 20),
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
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
              gradient: LinearGradient(
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
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
              gradient: LinearGradient(
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
