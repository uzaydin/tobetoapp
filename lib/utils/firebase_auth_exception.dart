import 'package:firebase_auth/firebase_auth.dart';

class AuthExceptionHandler {
  static String handleException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Geçersiz email adresi.';
      case 'user-disabled':
        return 'Kullanıcı devre dışı bırakıldı.';
      case 'user-not-found':
        return 'Kullanıcı bulunamadı.';
      case 'wrong-password':
        return 'Yanlış şifre.';
      case 'email-already-in-use':
        return 'Bu email adresi zaten kullanılıyor.';
      case 'operation-not-allowed':
        return 'Bu işlem şu anda yapılamıyor.';
      case 'weak-password':
        return 'Şifre çok zayıf.';
      case 'network-request-failed':
        return 'Ağ bağlantısı başarısız oldu. Lütfen internet bağlantınızı kontrol edin.';
      case 'too-many-requests':
        return 'Çok fazla istek gönderildi. Lütfen daha sonra tekrar deneyin.';
      case 'invalid-credential':
        return 'Geçersiz kimlik bilgisi.';
      case 'account-exists-with-different-credential':
        return 'Bu email adresiyle daha önce başka bir giriş yöntemi kullanıldı.';
      case 'invalid-verification-code':
        return 'Geçersiz doğrulama kodu.';
      case 'invalid-verification-id':
        return 'Geçersiz doğrulama kimliği.';
      default:
        return 'Bilinmeyen bir hata oluştu. Lütfen tekrar deneyin.';
    }
  }
}
