import 'package:firebase_auth/firebase_auth.dart';

class AuthException {
  static String handleException(Exception e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'Bu email adresi zaten kullanımda.';
        case 'invalid-email':
          return 'Geçersiz email adresi.';
        case 'operation-not-allowed':
          return 'İşlem izni yok. Email/password hesapları etkinleştirilmeli.';
        case 'weak-password':
          return 'Zayıf şifre. Daha güçlü bir şifre seçin.';
        case 'user-disabled':
          return 'Kullanıcı devre dışı bırakıldı.';
        case 'user-not-found':
          return 'Kullanıcı bulunamadı.';
        case 'wrong-password':
          return 'Yanlış şifre. Tekrar dene.';
        default:
          return 'Beklenmeyen bir hata oluştu.';
      }
    } else {
      return 'Beklenmeyen bir hata oluştu.';
    }
  }
}
