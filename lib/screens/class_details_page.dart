import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:tobetoapp/bloc/lessons/lesson_bloc.dart';
import 'package:tobetoapp/bloc/lessons/lesson_event.dart';
import 'package:tobetoapp/bloc/lessons/lesson_state.dart';
import 'package:tobetoapp/screens/lesson_details_and_video/lesson_details_page.dart';

class ClassDetailPage extends StatefulWidget {
  final List<String>? classIds;

  const ClassDetailPage({
    super.key,
    this.classIds,
  });

  @override
  _ClassDetailPageState createState() => _ClassDetailPageState();
}

class _ClassDetailPageState extends State<ClassDetailPage> {
  bool isListView = true;

  @override
  void initState() {
    super.initState();
    // Derslerin, sınıf id'lerine göre yüklenmesi!
    context.read<LessonBloc>().add(LoadLessons(widget.classIds));
    initializeDateFormatting();
     // yerel tarih ve saate dönüştürülmesi.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Derslerim"),
        actions: [
          IconButton(
            icon: Icon(isListView ? Icons.grid_view : Icons.list),
            onPressed: () {
              setState(() {
                isListView = !isListView;
              });
            },
          ),
        ],
      ),
      body: widget.classIds == null || widget.classIds!.isEmpty
          ? Center(
              child: Text("Henüz ders tanımlanmamıştır."),
            )
          : BlocBuilder<LessonBloc, LessonState>(
              builder: (context, state) {
                if (state is LessonsLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is LessonsLoaded) {
                  if (state.lessons.isEmpty) {
                    return Center(
                      child: Text("Henüz ders tanımlanmamıştır"),
                    );
                  } else {
                    return isListView
                        ? ListView.builder(
                            itemCount: state.lessons.length,
                            itemBuilder: (context, index) {
                              final lesson = state.lessons[index];
                              return ListTile(
                                leading: lesson.image != null
                                    ? Image.network(lesson.image!)
                                    : null,
                                title: Text(lesson.title ?? "No title"),
                                subtitle: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(lesson.description ??
                                        "No description"),
                                    Text(
                                      "${lesson.startDate != null ? DateFormat('dd MMM yyyy, hh:mm', 'tr').format(lesson.startDate!) : 'Tarih yok'}",
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  if (lesson.isLive ?? false) {
                                    // Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //     builder: (context) =>
                                    //         LiveLessonPage(lesson: lesson,),  // canli dersler icin yonlendirme.
                                    //   ),
                                    // );
                                  } else {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            LessonDetailsPage(lesson: lesson,),
                                      ),
                                    );
                                  }
                                },
                                
                              );
                            },
                          )
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemCount: state.lessons.length,
                            itemBuilder: (context, index) {
                              final lesson = state.lessons[index];
                              return GestureDetector(
                                onTap: () {
                                  if (lesson.isLive ?? false) {
                                    // Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //     builder: (context) =>                     // canli ders icin yonlendirme
                                    //         LiveLessonPage(lesson: lesson)
                                    //   ),
                                    // );
                                  } else {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            LessonDetailsPage(lesson: lesson),
                                      ),
                                    );
                                  }
                                },
                                child: Card(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      lesson.image != null
                                          ? Image.network(lesson.image!)
                                          : Container(
                                              height: 100,
                                              color: Colors.grey,
                                            ),
                                      SizedBox(height: 10,),
                                      Text(lesson.title ?? "No title"),
                                      SizedBox(height: 10,),
                                      Text(
                                        " ${lesson.startDate != null ? DateFormat('dd MMM yyyy, hh:mm', 'tr').format(lesson.startDate!) : 'Tarih yok'}",
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                  }
                } else if (state is LessonOperationFailure) {
                  return Center(
                    child: Text("Ders yükleme başarısız oldu! ${state.error}"),
                  );
                } else {
                  return const Center(
                    child: Text("Bilinmeyen bir hata oluştu."),
                  );
                }
              },
            ),
    );
  }
}