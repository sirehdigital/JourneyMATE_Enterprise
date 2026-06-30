import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ai_message.dart';
import 'ai_provider.dart';

/// ===============================================================
/// JourneyMATE Enterprise
/// AI Chat Provider
/// ===============================================================

class AIChatController extends StateNotifier<List<AIMessage>> {
  AIChatController() : super(_initialMessages);

  static final List<AIMessage> _initialMessages = [
    AIMessage(
      message:
          'Hello Abang 👋\n\n'
          'I am JourneyMATE AI.\n'
          'How can I help you plan your next journey today?',
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ];

  //--------------------------------------------------------------
  // Send Message
  //--------------------------------------------------------------

  Future<void> sendMessage(String prompt, AIController controller) async {
    if (prompt.trim().isEmpty) return;

    //--------------------------------------------------
    // User Message
    //--------------------------------------------------

    state = [
      ...state,
      AIMessage(message: prompt, isUser: true, timestamp: DateTime.now()),
    ];

    //--------------------------------------------------
    // AI Thinking
    //--------------------------------------------------

    controller.setThinking();

    await controller.askAI(prompt);

    final response = controller.state.response;

    if (response != null) {
      state = [
        ...state,
        AIMessage(
          message: response.message,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      ];
    }

    controller.setReady();
  }

  //--------------------------------------------------------------
  // Clear Conversation
  //--------------------------------------------------------------

  void clear() {
    state = List.from(_initialMessages);
  }
}

final aiChatProvider = StateNotifierProvider<AIChatController, List<AIMessage>>(
  (ref) => AIChatController(),
);
