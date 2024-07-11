import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/auth/auth_event.dart';
import 'package:tobetoapp/bloc/auth/auth_state.dart';
import 'package:tobetoapp/models/user_model.dart';
import 'package:tobetoapp/repository/auth_repo.dart';
import 'package:tobetoapp/repository/user_repository.dart';
import 'package:tobetoapp/utils/firebase_auth_exception.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  UserModel? _currentUser; // Bellekte kullanıcı bilgilerini saklayan değişken

  AuthBloc(this._authRepository, this._userRepository)
      : super(AuthAppStarted()) {
    on<AuthLogin>(_loginUser);
    on<AuthSignUp>(_signUp);
    on<AuthGoogleSignIn>(_onGoogleSignIn);
    on<AuthStateChanged>(_authStateChanged);
    on<AuthLogOut>(_logoutUser);
    on<AuthCheckStatus>(_checkAuthStatus);
    on<AuthPasswordReset>(_onPasswordReset);

    // AuthBloc oluşturulduğunda oturum durumunu kontrol et
    _initializeAuthState();
  }
  // Bellekte saklanan kullanıcı bilgilerine erişim sağlıyoruz
  UserModel? get currentUser => _currentUser;

  Future<void> _initializeAuthState() async {
    final user = _authRepository.getCurrentUser();
    if (user != null) {
      final role = await _authRepository.getUserRole(user.uid);
      final userModel = await _userRepository.getUserDetails(user.uid);
      _currentUser = userModel; // Kullanıcı bilgilerini bellekte saklama
      add(AuthStateChanged(user: user, role: role));
    } else {
      add(AuthStateChanged(user: null, role: null));
    }
  }

  void _authStateChanged(AuthStateChanged event, Emitter<AuthState> emit) {
    if (event.user != null) {
      emit(AuthSuccess(id: event.user!.uid, role: event.role));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _loginUser(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user =
          await _authRepository.loggedInUser(event.email, event.password);
      if (user != null) {
        final role = await _authRepository.getUserRole(user.uid);
        final userModel = await _userRepository.getUserDetails(user.uid);
        _currentUser = userModel; // Kullanıcı bilgilerini bellekte saklama
        emit(AuthSuccess(id: user.uid, role: role));
      }
    } on FirebaseAuthException catch (e) {
      final errorMessage = AuthExceptionHandler.handleException(e);
      emit(AuthFailure(message: errorMessage));
    } catch (e) {
      emit(AuthFailure(message: 'Bilinmeyen bir hata oluştu.'));
    }
  }

  Future<void> _signUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signUp(
        event.name,
        event.lastName,
        event.email,
        event.password,
      );
      if (user != null) {
        final role = await _authRepository.getUserRole(user.uid);
        final userModel = await _userRepository.getUserDetails(user.uid);
        _currentUser = userModel; // Kullanıcı bilgilerini bellekte saklama
        emit(AuthSuccess(id: user.uid, role: role));
      }
    } on FirebaseAuthException catch (e) {
      final errorMessage = AuthExceptionHandler.handleException(e);
      emit(AuthFailure(message: errorMessage));
    } catch (e) {
      emit(AuthFailure(message: 'Bilinmeyen bir hata oluştu.'));
    }
  }

  void _onGoogleSignIn(AuthGoogleSignIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      User? user = await _authRepository.signInWithGoogle();
      if (user != null) {
        final role = await _authRepository.getUserRole(user.uid);
        emit(AuthSuccess(id: user.uid, role: role));
      }
    } on FirebaseAuthException catch (e) {
      final errorMessage = AuthExceptionHandler.handleException(e);
      emit(AuthFailure(message: errorMessage));
    } catch (e) {
      emit(AuthFailure(message: 'Bilinmeyen bir hata oluştu.'));
    }
  }

  Future<void> _logoutUser(AuthLogOut event, Emitter<AuthState> emit) async {
    try {
      await _authRepository.logout();
      _currentUser = null; // Kullanıcı çıkış yaptığında bilgileri temizleme
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _checkAuthStatus(
      AuthCheckStatus event, Emitter<AuthState> emit) async {
    await _initializeAuthState();
  }

  void _onPasswordReset(
      AuthPasswordReset event, Emitter<AuthState> emit) async {
    try {
      await _authRepository.resetPassword(event.email);
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }
}
