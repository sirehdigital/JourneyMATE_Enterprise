import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';
import '../../../../core/providers/ai_chat_provider.dart';
import '../../../../core/providers/ai_provider.dart';

import '../widgets/ai_chat_input.dart';
import '../widgets/ai_conversation.dart';

class AIConversationScreen extends ConsumerStatefulWidget {
  const AIConversationScreen({super.key});

  @override
  ConsumerState<AIConversationScreen> createState() =>
      _AIConversationScreenState();
}

class _AIConversationScreenState extends ConsumerState<AIConversationScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final prompt = _controller.text.trim();

    if (prompt.isEmpty) return;

    await ref
        .read(aiChatProvider.notifier)
        .sendMessage(prompt, ref.read(aiProvider.notifier));

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JMColors.background,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: JMColors.surface,
        surfaceTintColor: Colors.transparent,
        title: const Text('JourneyMATE AI', style: JMTypography.titleLarge),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: JMSpacing.screenHorizontal,
            vertical: JMSpacing.screenVertical,
          ),
          child: Column(
            children: [
              const Expanded(
                child: SingleChildScrollView(child: AIConversation()),
              ),

              const SizedBox(height: JMSpacing.lg),

              AIChatInput(
                controller: _controller,
                onSubmitted: (_) => _sendMessage(),
                onSend: _sendMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
