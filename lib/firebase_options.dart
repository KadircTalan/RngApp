// Gerekli Flutter ve Firebase paketlerini import ediyoruz.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Firebase uygulamanın kullandığı platforma göre ayarları sağlayan sınıf.
/// Kullanım örneği:
///   await Firebase.initializeApp(
///     options: DefaultFirebaseOptions.currentPlatform,
///   );
class DefaultFirebaseOptions {
  // Platforma göre uygun olan FirebaseOptions nesnesini döndürür.
  static FirebaseOptions get currentPlatform {
    // Eğer web platformundaysan, web ayarlarını döndür.
    if (kIsWeb) {
      return web;
    }
    // Mobil ve masaüstü platformlarını anahtar-kilit ilişkisiyle ayarla.
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
      // Linux için ayar oluşturulmamış. Klasik hata fırlatma yöntemi.
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
      // Bilinmeyen platform için güvenli yol: yine hata fırlat.
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Web uygulaması için Firebase konfigürasyonu
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAhY9i-LeqRmTDU104myFwdqKI_VtA4uw8',         // Proje API anahtarı
    appId: '1:350012490066:web:aa10d6bab36d609a363a8b',        // Web uygulama ID
    messagingSenderId: '350012490066',                         // Mesaj gönderici ID
    projectId: 'rngapp-69188',                                 // Proje ID'si
    authDomain: 'rngapp-69188.firebaseapp.com',                // Kimlik doğrulama domain
    storageBucket: 'rngapp-69188.firebasestorage.app',         // Storage bucket adresi (dikkat: typo olmasın!)
  );

  // Android uygulaması için Firebase konfigürasyonu
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBiYsf-9kHBvNqGBRHCs7yS8OHrBJXuw34',
    appId: '1:350012490066:android:ede3c8cfbc140f1d363a8b',
    messagingSenderId: '350012490066',
    projectId: 'rngapp-69188',
    storageBucket: 'rngapp-69188.firebasestorage.app',
  );

  // iOS uygulaması için Firebase konfigürasyonu
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBOTj41ZqQZeRaI--_w_4AwMdBV8MCIWFA',
    appId: '1:350012490066:ios:775a92779e9c5e8c363a8b',
    messagingSenderId: '350012490066',
    projectId: 'rngapp-69188',
    storageBucket: 'rngapp-69188.firebasestorage.app',
    iosBundleId: 'com.example.rng', // iOS bundle ID
  );

  // MacOS uygulaması için Firebase konfigürasyonu (genellikle iOS ile aynı)
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBOTj41ZqQZeRaI--_w_4AwMdBV8MCIWFA',
    appId: '1:350012490066:ios:775a92779e9c5e8c363a8b',
    messagingSenderId: '350012490066',
    projectId: 'rngapp-69188',
    storageBucket: 'rngapp-69188.firebasestorage.app',
    iosBundleId: 'com.example.rng',
  );

  // Windows uygulaması için Firebase konfigürasyonu
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAhY9i-LeqRmTDU104myFwdqKI_VtA4uw8',
    appId: '1:350012490066:web:7c297a43ab7dcf86363a8b', // Evet, web appId'siyle
    messagingSenderId: '350012490066',
    projectId: 'rngapp-69188',
    authDomain: 'rngapp-69188.firebaseapp.com',
    storageBucket: 'rngapp-69188.firebasestorage.app',
  );
}
