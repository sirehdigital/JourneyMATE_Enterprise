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
import '../widgets/ai_chat_input.dart';
import '../widgets/typing_indicator.dart';

class AIConversationScreen extends ConsumerStatefulWidget {
  const AIConversationScreen({super.key});

  @override
  ConsumerState<AIConversationScreen> createState() =>
      _AIConversationScreenState();
}

class _AIConversationScreenState extends ConsumerState<AIConversationScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final prompt = _controller.text.trim();
    if (prompt.isEmpty) return;

    await ref
        .read(aiChatProvider.notifier)
        .sendMessage(prompt, ref.read(aiProvider.notifier), useStreaming: true);

    _controller.clear();
  }

  Future<void> _stopStreaming() async {
    await ref.read(aiChatProvider.notifier).stopStreaming();
  }

  Future<void> _retryLastPrompt() async {
    await ref.read(aiChatProvider.notifier).retryLastPrompt();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<List<AIMessage>>(aiChatProvider, (_, __) {
      _scrollToBottom();
    });

    ref.listen<AIChatStatus>(aiChatStatusProvider, (_, next) {
      if (next.isTyping || next.isStreaming) {
        _scrollToBottom();
      }
    });

    final messages = ref.watch(aiChatProvider);
    final chatStatus = ref.watch(aiChatStatusProvider);
    final displayState = ref.watch(aiProvider);

    return Scaffold(
      backgroundColor: JMColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: JMColors.surface,
        surfaceTintColor: Colors.transparent,
        title: const Text('JourneyMATE AI', style: JMTypography.titleLarge),
        actions: [
          if (chatStatus.isStreaming)
            TextButton.icon(
              onPressed: _stopStreaming,
              icon: const Icon(Icons.stop_circle, size: 18),
              label: const Text('STOP'),
              style: TextButton.styleFrom(foregroundColor: JMColors.error),
            ),
          if (!chatStatus.isStreaming && chatStatus.errorMessage != null)
            TextButton.icon(
              onPressed: _retryLastPrompt,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('RETRY'),
              style: TextButton.styleFrom(foregroundColor: JMColors.primary),
            ),
          const SizedBox(width: JMSpacing.sm),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: JMSpacing.screenHorizontal,
            vertical: JMSpacing.screenVertical,
          ),
          child: Column(
            children: [
              _buildStatusCard(displayState, chatStatus),
              const SizedBox(height: JMSpacing.lg),
              Expanded(child: _buildConversationView(messages, chatStatus)),
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
    ); // Tutup Scaffold
  } // Tutu

  Widget _buildStatusCard(AIState aiState, AIChatStatus chatStatus) {
    final statusText = chatStatus.isStreaming
        ? 'Streaming response...'
        : (chatStatus.isTyping
              ? 'Typing...'
              : aiState.loading
              ? 'Thinking...'
              : 'Online');

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
                Text(statusText, style: JMTypography.bodySmall),
              ],
            ),
          ),
          _buildStatusChip(chatStatus),
        ],
      ),
    );
  }

  Widget _buildStatusChip(AIChatStatus chatStatus) {
    final label = chatStatus.isStreaming
        ? 'STREAMING'
        : chatStatus.isTyping
        ? 'TYPING'
        : 'READY';

    final color = chatStatus.isStreaming
        ? JMColors.primary
        : chatStatus.isTyping
        ? JMColors.warning
        : JMColors.success;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: JMSpacing.sm,
        vertical: JMSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(JMRadius.pill),
      ),
      child: Text(
        label,
        style: JMTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildConversationView(
    List<AIMessage> messages,
    AIChatStatus chatStatus,
  ) {
    return Container(
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
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                padding: const EdgeInsets.only(bottom: JMSpacing.xxl),
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return AnimatedSize(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    child: _ChatBubble(
                      message: message.message,
                      timestamp:
                          '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                      isUser: message.isUser,
                      onCopy: () => _copyMessage(message.message),
                    ),
                  );
                },
              ),
            ),
            if (chatStatus.isTyping) ...[
              const Divider(height: 1),
              const SizedBox(height: JMSpacing.md),
              Row(
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
                      child: const TypingIndicator(),
                    ),
                  ),
                ],
              ),
            ],
            if (chatStatus.errorMessage != null) ...[
              const SizedBox(height: JMSpacing.md),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(JMSpacing.lg),
                decoration: BoxDecoration(
                  color: JMColors.error.withOpacity(.08),
                  borderRadius: BorderRadius.circular(JMRadius.lg),
                  border: Border.all(color: JMColors.error.withOpacity(.25)),
                ),
                child: Text(
                  chatStatus.errorMessage!,
                  style: JMTypography.bodySmall.copyWith(color: JMColors.error),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _copyMessage(String message) async {
    await Clipboard.setData(ClipboardData(text: message));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message copied to clipboard.')),
      );
    }
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    required this.message,
    required this.timestamp,
    required this.isUser,
    required this.onCopy,
  });

  final String message;
  final String timestamp;
  final bool isUser;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isUser ? JMColors.primary : JMColors.background;
    final contentColor = isUser ? JMColors.textInverse : JMColors.textPrimary;
    final border = isUser ? null : Border.all(color: JMColors.border);
    final radius = isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(JMRadius.lg),
            topRight: Radius.circular(JMRadius.lg),
            bottomLeft: Radius.circular(JMRadius.lg),
            bottomRight: Radius.circular(JMRadius.sm),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(JMRadius.sm),
            topRight: Radius.circular(JMRadius.lg),
            bottomLeft: Radius.circular(JMRadius.lg),
            bottomRight: Radius.circular(JMRadius.lg),
          );

    return Padding(
      padding: const EdgeInsets.only(bottom: JMSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            const _BubbleAvatar(
              backgroundColor: JMColors.ai,
              icon: Icons.smart_toy_rounded,
            ),
            const SizedBox(width: JMSpacing.md),
          ],
          Flexible(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: Container(
                key: ValueKey(message),
                padding: const EdgeInsets.all(JMSpacing.lg),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: radius,
                  border: border,
                ),
                child: Column(
                  crossAxisAlignment: isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _MarkdownText(
                            text: message,
                            textColor: contentColor,
                          ),
                        ),
                        const SizedBox(width: JMSpacing.sm),
                        GestureDetector(
                          onTap: onCopy,
                          child: Icon(
                            Icons.copy,
                            size: 18,
                            color: contentColor.withOpacity(.65),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: JMSpacing.sm),
                    Text(
                      timestamp,
                      style: JMTypography.labelSmall.copyWith(
                        color: contentColor.withOpacity(.60),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: JMSpacing.md),
            const _BubbleAvatar(
              backgroundColor: JMColors.primary,
              icon: Icons.person_rounded,
            ),
          ],
        ],
      ),
    );
  }
}

class _BubbleAvatar extends StatelessWidget {
  const _BubbleAvatar({required this.backgroundColor, required this.icon});

  final Color backgroundColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Icon(icon, color: JMColors.textInverse, size: 22),
    );
  }
}

class _MarkdownText extends StatelessWidget {
  const _MarkdownText({required this.text, required this.textColor});

  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final spans = _parseMarkdown(text, textColor);
    return RichText(
      text: TextSpan(children: spans),
      textAlign: TextAlign.left,
    );
  }

  static List<TextSpan> _parseMarkdown(String input, Color color) {
    final lines = input.split('\n');
    final spans = <TextSpan>[];
    var inCodeBlock = false;

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.trim().startsWith('```')) {
        inCodeBlock = !inCodeBlock;
        continue;
      }

      if (inCodeBlock) {
        spans.add(
          TextSpan(
            text: '${line.replaceAll('\t', '  ')}\n',
            style: TextStyle(
              color: JMColors.textSecondary,
              fontFamily: 'monospace',
            ),
          ),
        );
        continue;
      }

      if (line.startsWith('# ')) {
        spans.add(
          TextSpan(
            text: '${line.substring(2)}\n',
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        continue;
      }

      if (line.startsWith('- ') || line.startsWith('* ')) {
        spans.add(
          TextSpan(
            text: '• ${line.substring(2)}\n',
            style: TextStyle(color: color),
          ),
        );
        continue;
      }

      final parsedInline = _parseInlineMarkdown(line, color);
      spans.addAll(parsedInline);
      spans.add(const TextSpan(text: '\n'));
    }

    return spans;
  }

  static List<TextSpan> _parseInlineMarkdown(String line, Color color) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'(`[^`]+`|\*\*[^*]+\*\*|\*[^*]+\*)');
    var start = 0;
    final matches = regex.allMatches(line);

    for (final match in matches) {
      if (match.start > start) {
        spans.add(
          TextSpan(
            text: line.substring(start, match.start),
            style: TextStyle(color: color),
          ),
        );
      }
      final matchText = match.group(0)!;
      if (matchText.startsWith('**') && matchText.endsWith('**')) {
        spans.add(
          TextSpan(
            text: matchText.substring(2, matchText.length - 2),
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        );
      } else if (matchText.startsWith('*') && matchText.endsWith('*')) {
        spans.add(
          TextSpan(
            text: matchText.substring(1, matchText.length - 1),
            style: TextStyle(color: color, fontStyle: FontStyle.italic),
          ),
        );
      } else if (matchText.startsWith('`') && matchText.endsWith('`')) {
        spans.add(
          TextSpan(
            text: matchText.substring(1, matchText.length - 1),
            style: TextStyle(
              color: JMColors.textSecondary,
              fontFamily: 'monospace',
            ),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: matchText,
            style: TextStyle(color: color),
          ),
        );
      }
      start = match.end;
    }

    if (start < line.length) {
      spans.add(
        TextSpan(
          text: line.substring(start),
          style: TextStyle(color: color),
        ),
      );
    }

    return spans;
  }
}
