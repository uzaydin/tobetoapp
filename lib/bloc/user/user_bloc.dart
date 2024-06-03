import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/user/user_event.dart';
import 'package:tobetoapp/bloc/user/user_state.dart';
import 'package:tobetoapp/repository/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  UserBloc(this._userRepository) : super(UserInitial()) {
    on<FetchUser>(_onFetchUser);
  }

  Future<void> _onFetchUser(FetchUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      print("Fetching user data for ID: ${event.userId}");
      final user = await _userRepository.getUserDetails(event.userId);
      print("User data fetched successfully: $user");
      emit(UserLoaded(user));
    } catch (e) {
      print("Error fetching user data: $e");
      emit(UserError(e.toString()));
    }
  }
}