// Тимчасова заглушка. Файл буде перезаписано командою `flutterfire configure`,
// яка згенерує реальні ключі Firebase-проєкту для кожної платформи.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    throw UnsupportedError(
      'Firebase is not configured yet. Run `flutterfire configure` '
      'in the project root to generate lib/firebase_options.dart.',
    );
  }
}
