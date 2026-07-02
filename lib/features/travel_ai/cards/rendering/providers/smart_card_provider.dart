import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../engine/smart_card_engine.dart';
import '../services/smart_card_renderer.dart';

final Provider<SmartCardRenderer> smartCardRendererProvider =
    Provider<SmartCardRenderer>((ref) {
      return const SmartCardRenderer();
    });

final Provider<SmartCardEngine> smartCardEngineProvider =
    Provider<SmartCardEngine>((ref) {
      final renderer = ref.watch(smartCardRendererProvider);
      return SmartCardEngine(renderer: renderer);
    });
