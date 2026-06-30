import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/app_initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //--------------------------------------------------------------
  // Initialize JourneyMATE Enterprise
  //--------------------------------------------------------------
  await AppInitializer.initialize();

  //--------------------------------------------------------------
  // Launch App
  //--------------------------------------------------------------
  runApp(const ProviderScope(child: JourneyMATEApp()));
}
