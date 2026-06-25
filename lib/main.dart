import 'package:flutter/widgets.dart';

import 'app/taskify_app.dart';
import 'core/di/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(const TaskifyApp());
}
