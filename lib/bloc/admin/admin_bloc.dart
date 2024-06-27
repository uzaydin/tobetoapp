import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_event.dart';
import 'package:tobetoapp/bloc/admin/admin_state.dart';
import 'package:tobetoapp/repository/catalog/catalog_repository.dart';
import 'package:tobetoapp/repository/class_repository.dart';
import 'package:tobetoapp/repository/lessons/lesson_repository.dart';
import 'package:tobetoapp/repository/user_repository.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final UserRepository _userRepository;
  final ClassRepository _classRepository;
  final LessonRepository _lessonRepository;
  final CatalogRepository _catalogRepository;

  AdminBloc(
    this._userRepository,
    this._classRepository,
    this._lessonRepository,
    this._catalogRepository,
  ) : super(AdminInitial()) {
    on<LoadChartData>(_onLoadChartData);
    on<LoadUserData>(_onLoadUserData);
    on<UpdateUser>(_onUpdateUser);
    on<DeleteUser>(_onDeleteUser);
    on<LoadClassNamesForUser>(_onLoadClassNamesForUser);
    on<LoadClasses>(_onLoadClasses);
    on<AddClass>(_onAddClass);
    on<UpdateClass>(_onUpdateClass);
    on<DeleteClass>(_onDeleteClass);
    on<LoadClassDetails>(_onLoadClassDetails);
    on<LoadLessons>(_onLoadLessons);
    on<AddLesson>(_onAddLesson);
    on<UpdateLesson>(_onUpdateLesson);
    on<DeleteLesson>(_onDeleteLesson);
    on<LoadLessonDetails>(_onLoadLessonDetails);
    on<AssignClassToLesson>(_onAssignClassToLesson);
    on<UploadLessonImage>(_onUploadLessonImage);
    on<LoadCatalogs>(_onLoadCatalogs);
    on<AddCatalog>(_onAddCatalog);
    on<UpdateCatalog>(_onUpdateCatalog);
    on<DeleteCatalog>(_onDeleteCatalog);
    on<LoadCatalogDetails>(_onLoadCatalogDetails);
    on<UploadCatalogImage>(_onUploadCatalogImage);
  }

  void _onLoadChartData(LoadChartData event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      final classDistribution = await _userRepository.getClassDistribution();
      final monthlyRegistrations =
          await _userRepository.getMonthlyRegistrations();
      emit(ChartDataLoaded(
          classDistribution: classDistribution,
          monthlyRegistrations: monthlyRegistrations));
    } catch (e) {
      emit(AdminError(message: e.toString()));
    }
  }

  void _onLoadUserData(LoadUserData event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      final users = await _userRepository.fetchUsers();
      final classNames = await _classRepository.getClassNames();
      emit(UsersDataLoaded(users: users, classNames: classNames));
    } catch (e) {
      emit(AdminError(message: e.toString()));
    }
  }

  void _onUpdateUser(UpdateUser event, Emitter<AdminState> emit) async {
    try {
      await _userRepository.updateUser(event.user);
      final currentState = state;
      if (currentState is UsersDataLoaded) {
        final updatedUsers = currentState.users.map((u) {
          return u.id == event.user.id ? event.user : u;
        }).toList();
        emit(UsersDataLoaded(
            users: updatedUsers, classNames: currentState.classNames));
      }
    } catch (e) {
      emit(AdminError(message: e.toString()));
    }
  }

  void _onDeleteUser(DeleteUser event, Emitter<AdminState> emit) async {
    try {
      await _userRepository.deleteUser(event.userId);
      final currentState = state;
      if (currentState is UsersDataLoaded) {
        final updatedUsers =
            currentState.users.where((u) => u.id != event.userId).toList();
        emit(UsersDataLoaded(
            users: updatedUsers, classNames: currentState.classNames));
      }
    } catch (e) {
      emit(AdminError(message: e.toString()));
    }
  }

  void _onLoadClassNamesForUser(
      LoadClassNamesForUser event, Emitter<AdminState> emit) async {
    try {
      final classNames = await _classRepository.getClassNames();

      emit(ClassNamesForUserLoaded(user: event.user, classNames: classNames));
    } catch (e) {
      emit(AdminError(message: e.toString()));
    }
  }

  // Sınıflar için
  void _onLoadClasses(LoadClasses event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      final classes = await _classRepository.getClasses();

      emit(ClassesLoaded(
        classes: classes,
      ));
    } catch (e) {
      emit(AdminError(message: e.toString()));
    }
  }

  void _onAddClass(AddClass event, Emitter<AdminState> emit) async {
    try {
      await _classRepository.addClass(event.newClass);
      add(LoadClasses());
    } catch (e) {
      emit(AdminError(message: e.toString()));
    }
  }

  void _onUpdateClass(UpdateClass event, Emitter<AdminState> emit) async {
    try {
      await _classRepository.updateClass(event.updatedClass);
      add(LoadClasses()); // Refresh class list
    } catch (e) {
      emit(AdminError(message: e.toString()));
    }
  }

  void _onDeleteClass(DeleteClass event, Emitter<AdminState> emit) async {
    try {
      await _classRepository.deleteClass(event.classId);
      add(LoadClasses()); // Refresh class list
    } catch (e) {
      emit(AdminError(message: e.toString()));
    }
  }

  void _onLoadClassDetails(
      LoadClassDetails event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      final classDetails =
          await _classRepository.getClassDetails(event.classId);
      final users = await _userRepository.getUsersByClass(event.classId);
      final lessons = await _lessonRepository.getLessonsForClass(event.classId);
      emit(ClassDetailsLoaded(
          classDetails: classDetails, users: users, lessons: lessons));
    } catch (e) {
      emit(AdminError(message: e.toString()));
    }
  }

  // Ders işlemleri için handler'lar
  void _onLoadLessons(LoadLessons event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      final lessons = await _lessonRepository.getLesson();
      emit(LessonsLoaded(lessons: lessons));
    } catch (e) {
      emit(AdminError(message: e.toString()));
    }
  }

  void _onAddLesson(AddLesson event, Emitter<AdminState> emit) async {
    try {
      await _lessonRepository.addLesson(event.newLesson);
      add(LoadLessons());
    } catch (e) {
      emit(AdminError(message: e.toString()));
    }
  }

  void _onUpdateLesson(UpdateLesson event, Emitter<AdminState> emit) async {
    try {
      await _lessonRepository.updateLesson(event.updatedLesson);
      add(LoadLessons());
    } catch (e) {
      emit(AdminError(message: e.toString()));
    }
  }

  void _onDeleteLesson(DeleteLesson event, Emitter<AdminState> emit) async {
    try {
      await _lessonRepository.deleteLesson(event.lessonId);
      add(LoadLessons());
    } catch (e) {
      emit(AdminError(message: e.toString()));
    }
  }

  void _onUploadLessonImage(
      UploadLessonImage event, Emitter<AdminState> emit) async {
    try {
      emit(AdminLoading());
      final imageUrl = await _lessonRepository.uploadLessonImage(
          event.lessonId, event.imageFile);

      // Güncellenen image URL'yi ders modeline ekleyin
      final lesson = await _lessonRepository.getLessonById(event.lessonId);
      final updatedLesson = lesson.copyWith(image: imageUrl);
      await _lessonRepository.updateLesson(updatedLesson);

      // Ders detaylarını yeniden yüklemek yerine image URL'yi güncelleyin
      emit(LessonImageUploaded(imageUrl: imageUrl));
    } catch (e) {
      emit(AdminError(message: e.toString()));
    }
  }

  void _onLoadLessonDetails(
      LoadLessonDetails event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      final lesson = await _lessonRepository.getLessonById(event.lessonId);
      final teachers = await _userRepository.getTeachers();
      final classes = await _classRepository.getClasses();
      emit(LessonDetailsLoaded(
          lesson: lesson, classes: classes, teachers: teachers));
    } catch (e) {
      emit(AdminError(message: e.toString()));
    }
  }

  void _onAssignClassToLesson(
      AssignClassToLesson event, Emitter<AdminState> emit) async {
    try {
      final lesson = await _lessonRepository.getLessonById(event.lessonId);
      final updatedClassIds = List<String>.from(lesson.classIds ?? []);
      if (!updatedClassIds.contains(event.classId)) {
        updatedClassIds.add(event.classId);
      }
      final updatedLesson = lesson.copyWith(classIds: updatedClassIds);
      await _lessonRepository.updateLesson(updatedLesson);
      add(LoadLessonDetails(event.lessonId));
    } catch (e) {
      emit(AdminError(message: e.toString()));
    }
  }

void _onLoadCatalogs(LoadCatalogs event, Emitter<AdminState> emit) async {
  emit(AdminLoading());
  try {
    final catalogs = await _catalogRepository.getCatalog('');
    emit(CatalogsLoaded(catalogs: catalogs));
  } catch (e) {
    emit(AdminError(message: e.toString()));
  }
}

void _onAddCatalog(AddCatalog event, Emitter<AdminState> emit) async {
  try {
    await _catalogRepository.addCatalog(event.newCatalog);
    add(LoadCatalogs());
  } catch (e) {
    emit(AdminError(message: e.toString()));
  }
}

void _onUpdateCatalog(UpdateCatalog event, Emitter<AdminState> emit) async {
  try {
    await _catalogRepository.updateCatalog(event.updatedCatalog);
    add(LoadCatalogs());
  } catch (e) {
    emit(AdminError(message: e.toString()));
  }
}

void _onDeleteCatalog(DeleteCatalog event, Emitter<AdminState> emit) async {
  try {
    await _catalogRepository.deleteCatalog(event.catalogId);
    add(LoadCatalogs());
  } catch (e) {
    emit(AdminError(message: e.toString()));
  }
}

void _onUploadCatalogImage(UploadCatalogImage event, Emitter<AdminState> emit) async {
  try {
    emit(AdminLoading());
    final imageUrl = await _catalogRepository.uploadCatalogImage(event.catalogId, event.imageFile);

    final catalog = await _catalogRepository.getCatalogById(event.catalogId);
    final updatedCatalog = catalog.copyWith(imageUrl: imageUrl);
    await _catalogRepository.updateCatalog(updatedCatalog);

    emit(CatalogImageUploaded(imageUrl: imageUrl));
  } catch (e) {
    emit(AdminError(message: e.toString()));
  }
}

void _onLoadCatalogDetails(LoadCatalogDetails event, Emitter<AdminState> emit) async {
  emit(AdminLoading());
  try {
    final catalog = await _catalogRepository.getCatalogById(event.catalogId);
    emit(CatalogDetailsLoaded(catalog: catalog));
  } catch (e) {
    emit(AdminError(message: e.toString()));
  }
}
}
