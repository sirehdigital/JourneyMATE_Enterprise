import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';

class AIMessageBubble extends StatefulWidget {
  const AIMessageBubble({
    super.key,
    required this.message,
    required this.timestamp,
    this.isUser = false,
    this.showCursor = false,
    required this.onCopy,
  });

  final String message;
  final String timestamp;
  final bool isUser;
  final bool showCursor;
  final VoidCallback onCopy;

  @override
  State<AIMessageBubble> createState() => _AIMessageBubbleState();
}

class _AIMessageBubbleState extends State<AIMessageBubble>
    with SingleTickerProviderStateMixin {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _visible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messageText = widget.showCursor
        ? '${widget.message.isEmpty ? '' : widget.message}▌'
        : widget.message;
    final bubbleColor = widget.isUser ? JMColors.primary : JMColors.background;
    final textColor = widget.isUser
        ? JMColors.textInverse
        : JMColors.textPrimary;
    final border = widget.isUser ? null : Border.all(color: JMColors.border);
    final radius = widget.isUser
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

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 240),
      opacity: _visible ? 1 : 0,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
        child: Padding(
          padding: const EdgeInsets.only(bottom: JMSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: widget.isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (!widget.isUser) ...[
                const _Avatar(
                  backgroundColor: JMColors.ai,
                  icon: Icons.smart_toy_rounded,
                ),
                const SizedBox(width: JMSpacing.md),
              ],
              Flexible(
                child: GestureDetector(
                  onLongPress: widget.onCopy,
                  child: Container(
                    decoration: BoxDecoration(
                      color: bubbleColor,
                      borderRadius: radius,
                      border: border,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.05),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(JMSpacing.lg),
                      child: Column(
                        crossAxisAlignment: widget.isUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          _MarkdownContent(
                            text: messageText,
                            textColor: textColor,
                          ),
                          const SizedBox(height: JMSpacing.sm),
                          Text(
                            widget.timestamp,
                            style: JMTypography.labelSmall.copyWith(
                              color: textColor.withOpacity(.65),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.isUser) ...[
                const SizedBox(width: JMSpacing.md),
                const _Avatar(
                  backgroundColor: JMColors.primary,
                  icon: Icons.person_rounded,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.backgroundColor, required this.icon});

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

class _MarkdownContent extends StatelessWidget {
  const _MarkdownContent({required this.text, required this.textColor});

  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final blocks = _MarkdownParser(text, textColor).buildWidgets();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks,
    );
  }
}

class _MarkdownParser {
  _MarkdownParser(this.content, this.textColor);

  final String content;
  final Color textColor;

  List<Widget> buildWidgets() {
    final lines = content.replaceAll('\r\n', '\n').split('\n');
    final widgets = <Widget>[];
    final tableBuffer = <List<String>>[];
    var inCodeBlock = false;
    final codeLines = <String>[];

    void flushTable() {
      if (tableBuffer.isEmpty) return;
      widgets.add(_buildTable(tableBuffer));
      tableBuffer.clear();
    }

    void flushCodeBlock() {
      if (codeLines.isEmpty) return;
      widgets.add(_buildCodeBlock(codeLines));
      codeLines.clear();
    }

    for (final rawLine in lines) {
      final line = rawLine.trimRight();

      if (line.startsWith('```')) {
        if (inCodeBlock) {
          flushCodeBlock();
        }
        inCodeBlock = !inCodeBlock;
        continue;
      }

      if (inCodeBlock) {
        codeLines.add(rawLine);
        continue;
      }

      if (_isTableLine(line)) {
        flushCodeBlock();
        tableBuffer.add(_splitTableRow(line));
        continue;
      }

      if (tableBuffer.isNotEmpty) {
        flushTable();
      }

      if (line.isEmpty) {
        widgets.add(const SizedBox(height: JMSpacing.sm));
        continue;
      }

      if (line.startsWith('# ')) {
        widgets.add(_buildHeading(line.substring(2), 1));
        continue;
      }
      if (line.startsWith('## ')) {
        widgets.add(_buildHeading(line.substring(3), 2));
        continue;
      }
      if (line.startsWith('### ')) {
        widgets.add(_buildHeading(line.substring(4), 3));
        continue;
      }
      if (line.startsWith('> ')) {
        widgets.add(_buildQuote(line.substring(2)));
        continue;
      }
      if (RegExp(r'^[-*+]\s+').hasMatch(line)) {
        widgets.add(_buildBullet(line.substring(2)));
        continue;
      }
      if (RegExp(r'^\d+\.\s+').hasMatch(line)) {
        widgets.add(
          _buildBullet(
            line.replaceFirst(RegExp(r'^\d+\.\s+'), ''),
            ordered: true,
          ),
        );
        continue;
      }

      widgets.add(_buildParagraph(line));
    }

    flushTable();
    flushCodeBlock();

    return widgets;
  }

  bool _isTableLine(String line) {
    final pipes = line.split('|').length;
    return pipes > 2;
  }

  List<String> _splitTableRow(String line) {
    final trimmed = line.trim();
    final normalized = trimmed.startsWith('|') ? trimmed.substring(1) : trimmed;
    final row = normalized.endsWith('|')
        ? normalized.substring(0, normalized.length - 1)
        : normalized;
    return row.split('|').map((cell) => cell.trim()).toList();
  }

  Widget _buildHeading(String text, int level) {
    final sizes = [18.0, 16.0, 14.0];
    return Padding(
      padding: const EdgeInsets.only(bottom: JMSpacing.xs),
      child: Text(
        text,
        style: JMTypography.bodyLarge.copyWith(
          fontSize: sizes[level - 1],
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildQuote(String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: JMSpacing.xs),
      padding: const EdgeInsets.all(JMSpacing.sm),
      decoration: BoxDecoration(
        color: JMColors.background,
        borderRadius: BorderRadius.circular(JMRadius.lg),
        border: Border.all(color: JMColors.border),
      ),
      child: Text(
        text,
        style: JMTypography.bodyLarge.copyWith(
          color: textColor.withOpacity(.80),
        ),
      ),
    );
  }

  Widget _buildBullet(String text, {bool ordered = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: JMSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ordered ? '•' : '•',
            style: JMTypography.bodyLarge.copyWith(color: textColor),
          ),
          const SizedBox(width: JMSpacing.sm),
          Expanded(child: _buildParagraphWidget(text)),
        ],
      ),
    );
  }

  Widget _buildParagraph(String line) {
    return Padding(
      padding: const EdgeInsets.only(bottom: JMSpacing.xs),
      child: _buildParagraphWidget(line),
    );
  }

  Widget _buildParagraphWidget(String line) {
    return RichText(
      text: TextSpan(
        style: JMTypography.bodyLarge.copyWith(color: textColor),
        children: _parseInlineSpans(line),
      ),
    );
  }

  Widget _buildCodeBlock(List<String> lines) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: JMSpacing.xs),
      padding: const EdgeInsets.all(JMSpacing.md),
      decoration: BoxDecoration(
        color: JMColors.surface,
        borderRadius: BorderRadius.circular(JMRadius.lg),
      ),
      child: Text(
        lines.join('\n'),
        style: JMTypography.bodySmall.copyWith(
          fontFamily: 'monospace',
          color: JMColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildTable(List<List<String>> rows) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: JMSpacing.sm),
      decoration: BoxDecoration(
        color: JMColors.surface,
        borderRadius: BorderRadius.circular(JMRadius.lg),
      ),
      child: Table(
        border: TableBorder.all(color: JMColors.border),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: rows.map((row) {
          return TableRow(
            children: row.map((cell) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: JMSpacing.sm,
                  horizontal: JMSpacing.md,
                ),
                child: Text(
                  cell,
                  style: JMTypography.bodySmall.copyWith(color: textColor),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  List<TextSpan> _parseInlineSpans(String text) {
    final spans = <TextSpan>[];
    final regex = RegExp(
      r'(`[^`]+`|\*\*[^*]+\*\*|\*[^*]+\*|\[[^\]]+\]\([^\)]+\))',
    );
    var currentIndex = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > currentIndex) {
        spans.add(TextSpan(text: text.substring(currentIndex, match.start)));
      }

      final matchText = match.group(0)!;
      if (matchText.startsWith('**') && matchText.endsWith('**')) {
        spans.add(
          TextSpan(
            text: matchText.substring(2, matchText.length - 2),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      } else if (matchText.startsWith('*') && matchText.endsWith('*')) {
        spans.add(
          TextSpan(
            text: matchText.substring(1, matchText.length - 1),
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        );
      } else if (matchText.startsWith('`') && matchText.endsWith('`')) {
        spans.add(
          TextSpan(
            text: matchText.substring(1, matchText.length - 1),
            style: TextStyle(
              fontFamily: 'monospace',
              color: JMColors.textSecondary,
            ),
          ),
        );
      } else if (matchText.startsWith('[') && matchText.contains('](')) {
        final splitIndex = matchText.indexOf('](');
        final label = matchText.substring(1, splitIndex);
        final url = matchText.substring(splitIndex + 2, matchText.length - 1);
        spans.add(
          TextSpan(
            text: label,
            style: TextStyle(
              color: JMColors.primary,
              decoration: TextDecoration.underline,
            ),
          ),
        );
        spans.add(
          TextSpan(
            text: ' ($url)',
            style: TextStyle(color: JMColors.textSecondary, fontSize: 12),
          ),
        );
      } else {
        spans.add(TextSpan(text: matchText));
      }

      currentIndex = match.end;
    }

    if (currentIndex < text.length) {
      spans.add(TextSpan(text: text.substring(currentIndex)));
    }

    return spans;
  }
}
