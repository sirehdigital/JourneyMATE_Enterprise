import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';
import '../../../../core/models/ai_message.dart';
import '../../../../core/providers/ai_chat_provider.dart';
import '../../../../core/providers/ai_provider.dart';
import 'ai_message_bubble.dart';
import 'typing_indicator.dart';

class AIConversation extends ConsumerStatefulWidget {
  const AIConversation({super.key});

  @override
  ConsumerState<AIConversation> createState() => _AIConversationState();
}

class _AIConversationState extends ConsumerState<AIConversation> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToBottom = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    ref.listen<List<AIMessage>>(
      aiChatProvider,
      (_, __) => _scrollToBottomIfNeeded(),
    );
    ref.listen<AIChatStatus>(aiChatStatusProvider, (_, next) {
      if (next.isTyping || next.isStreaming) {
        _scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxExtent = _scrollController.position.maxScrollExtent;
    final current = _scrollController.offset;
    final shouldShow = current < maxExtent - 120;

    if (shouldShow != _showScrollToBottom) {
      setState(() {
        _showScrollToBottom = shouldShow;
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
      );
    });
  }

  void _scrollToBottomIfNeeded() {
    if (!_scrollController.hasClients) return;
    final maxExtent = _scrollController.position.maxScrollExtent;
    final current = _scrollController.offset;
    if (current >= maxExtent - 120) {
      _scrollToBottom();
    }
  }

  Future<void> _copyMessage(String message) async {
    await Clipboard.setData(ClipboardData(text: message));
    if (!mounted) return;

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message copied to clipboard.')),
    );
  }

  Future<void> _stopStreaming() async {
    await ref.read(aiChatProvider.notifier).stopStreaming();
  }

  Future<void> _retryLastPrompt() async {
    await ref.read(aiChatProvider.notifier).retryLastPrompt();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(aiChatProvider);
    final chatStatus = ref.watch(aiChatStatusProvider);
    final aiState = ref.watch(aiProvider);

    return Stack(
      children: [
        Column(
          children: [
            _buildHeader(chatStatus),
            const SizedBox(height: JMSpacing.lg),
            Expanded(
              child: _buildConversationPanel(messages, chatStatus, aiState),
            ),
          ],
        ),
        Positioned(
          right: JMSpacing.md,
          bottom: 148,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _showScrollToBottom ? 1 : 0,
            child: IgnorePointer(
              ignoring: !_showScrollToBottom,
              child: FloatingActionButton.small(
                onPressed: _scrollToBottom,
                backgroundColor: JMColors.primary,
                child: const Icon(Icons.arrow_downward),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(AIChatStatus chatStatus) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(JMSpacing.lg),
      decoration: BoxDecoration(
        color: JMColors.card,
        borderRadius: BorderRadius.circular(JMRadius.lg),
        border: Border.all(color: JMColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: JMColors.ai,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: JMColors.textInverse,
            ),
          ),
          const SizedBox(width: JMSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('JourneyMATE AI', style: JMTypography.titleMedium),
                const SizedBox(height: JMSpacing.xs),
                Text(
                  'JourneyMATE AI • GPT-5.5',
                  style: JMTypography.bodySmall.copyWith(
                    color: JMColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (chatStatus.isStreaming) ...[
            TextButton.icon(
              onPressed: _stopStreaming,
              icon: const Icon(Icons.stop_circle, size: 18),
              label: const Text('STOP'),
              style: TextButton.styleFrom(foregroundColor: JMColors.error),
            ),
          ] else if (chatStatus.errorMessage != null) ...[
            TextButton.icon(
              onPressed: _retryLastPrompt,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('RETRY'),
              style: TextButton.styleFrom(foregroundColor: JMColors.primary),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildConversationPanel(
    List<AIMessage> messages,
    AIChatStatus chatStatus,
    AIState aiState,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: JMColors.card,
        borderRadius: BorderRadius.circular(JMRadius.lg),
        border: Border.all(color: JMColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(JMSpacing.cardPadding),
        child: Column(
          children: [
            Expanded(
              child: messages.isEmpty
                  ? _buildEmptyState()
                  : _buildMessageList(messages, chatStatus),
            ),
            if (aiState.loading &&
                !chatStatus.isTyping &&
                !chatStatus.isStreaming) ...[
              const SizedBox(height: JMSpacing.lg),
              _buildThinkingIndicator(),
            ],
            if (chatStatus.errorMessage != null) ...[
              const SizedBox(height: JMSpacing.lg),
              _buildErrorPanel(chatStatus.errorMessage!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.chat_bubble_outline,
            size: 48,
            color: JMColors.textSecondary,
          ),
          const SizedBox(height: JMSpacing.md),
          Text(
            'Start a conversation with JourneyMATE AI',
            style: JMTypography.bodyLarge.copyWith(
              color: JMColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: JMSpacing.sm),
          Text(
            'Ask your travel questions and receive instant guidance.',
            style: JMTypography.bodySmall.copyWith(
              color: JMColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(List<AIMessage> messages, AIChatStatus chatStatus) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: messages.length,
      padding: const EdgeInsets.only(bottom: JMSpacing.xxl),
      itemBuilder: (context, index) {
        final message = messages[index];
        final isLast = index == messages.length - 1;
        final showCursor = isLast && !message.isUser && chatStatus.isTyping;

        return AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          child: Padding(
            padding: const EdgeInsets.only(bottom: JMSpacing.md),
            child: AIMessageBubble(
              message: message.message,
              timestamp:
                  '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
              isUser: message.isUser,
              showCursor: showCursor,
              metadata: message.metadata,
              onCopy: () => _copyMessage(message.message),
            ),
          ),
        );
      },
    );
  }

  Widget _buildThinkingIndicator() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: JMColors.ai,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.smart_toy_rounded,
            color: JMColors.textInverse,
            size: 20,
          ),
        ),
        const SizedBox(width: JMSpacing.md),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: JMSpacing.lg,
              vertical: JMSpacing.md,
            ),
            decoration: BoxDecoration(
              color: JMColors.background,
              borderRadius: BorderRadius.circular(JMRadius.lg),
              border: Border.all(color: JMColors.border),
            ),
            child: Row(
              children: [
                const TypingIndicator(),
                const SizedBox(width: JMSpacing.md),
                Expanded(
                  child: Text('Thinking...', style: JMTypography.bodyLarge),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorPanel(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(JMSpacing.lg),
      decoration: BoxDecoration(
        color: JMColors.error.withOpacity(.08),
        borderRadius: BorderRadius.circular(JMRadius.lg),
        border: Border.all(color: JMColors.error.withOpacity(.24)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: JMColors.error),
          const SizedBox(width: JMSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: JMTypography.bodySmall.copyWith(color: JMColors.error),
            ),
          ),
          TextButton(onPressed: _retryLastPrompt, child: const Text('Retry')),
        ],
      ),
    );
  }
}
