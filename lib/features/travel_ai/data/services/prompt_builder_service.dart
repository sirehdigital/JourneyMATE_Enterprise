import '../../domain/entities/prompt_context.dart';
import '../../domain/entities/travel_context.dart';
import '../../domain/entities/travel_intent.dart';

class PromptBuilderService {
  PromptBuilderService._();

  static PromptContext buildPrompt(
    TravelIntent intent,
    TravelContext context,
    String userPrompt,
  ) {
    const systemRole = 'You are an enterprise travel planning assistant.';

    final generatedPrompt = _buildMarkdownPrompt(
      systemRole: systemRole,
      intent: intent,
      context: context,
      userPrompt: userPrompt,
    );

    return PromptContext(
      systemRole: systemRole,
      travelIntent: intent,
      travelContext: context,
      userPrompt: userPrompt,
      generatedPrompt: generatedPrompt,
    );
  }

  static String _buildMarkdownPrompt({
    required String systemRole,
    required TravelIntent intent,
    required TravelContext context,
    required String userPrompt,
  }) {
    final buffer = StringBuffer();

    buffer.writeln('# JourneyMATE Enterprise Prompt');
    buffer.writeln();

    buffer.writeln('## System Role');
    buffer.writeln(systemRole);
    buffer.writeln();

    buffer.writeln('## Travel Intent');
    buffer.writeln(_formatIntent(intent));
    buffer.writeln();

    buffer.writeln('## Travel Context');
    buffer.writeln();

    buffer.writeln('- Destination: ${context.destination ?? "Not specified"}');

    buffer.writeln('- Origin: ${context.origin ?? "Not specified"}');

    buffer.writeln('- Duration: ${_formatDuration(context.durationDays)}');

    buffer.writeln('- Travellers: ${context.travellers ?? "Not specified"}');

    buffer.writeln('- Budget: ${_formatBudget(context.budget)}');

    buffer.writeln(
      '- Travel Style: ${_formatTravelStyle(context.travelStyle)}',
    );

    buffer.writeln(
      '- Transport Mode: ${_formatTransportMode(context.transportMode)}',
    );

    buffer.writeln('- Language: ${context.language ?? "Not specified"}');

    buffer.writeln();

    buffer.writeln('## Preferences');

    buffer.writeln(
      '- Muslim Friendly: ${context.muslimFriendly ? "Yes" : "No"}',
    );

    buffer.writeln(
      '- Family Friendly: ${context.familyFriendly ? "Yes" : "No"}',
    );

    buffer.writeln('- Kids Friendly: ${context.kidsFriendly ? "Yes" : "No"}');

    buffer.writeln(
      '- Wheelchair Access: ${context.wheelchairAccess ? "Yes" : "No"}',
    );

    buffer.writeln();

    buffer.writeln('## User Request');
    buffer.writeln();

    if (userPrompt.trim().isEmpty) {
      buffer.writeln('No user request provided.');
    } else {
      buffer.writeln(userPrompt.trim());
    }

    buffer.writeln();

    buffer.writeln('## Instructions');
    buffer.writeln();

    buffer.writeln(
      'Generate a comprehensive travel response based on the travel intent, '
      'travel context, and user request above.',
    );

    buffer.writeln(
      'Provide practical recommendations and keep the response clear, '
      'friendly, and well structured.',
    );

    return buffer.toString();
  }

  static String _formatIntent(TravelIntent intent) {
    final value = intent.type.name;

    return value
        .replaceAllMapped(RegExp(r'[A-Z]'), (match) => ' ${match.group(0)}')
        .trim();
  }

  static String _formatDuration(int? durationDays) {
    if (durationDays == null) {
      return 'Not specified';
    }

    if (durationDays == 1) {
      return '1 day';
    }

    return '$durationDays days';
  }

  static String _formatBudget(double? budget) {
    if (budget == null) {
      return 'Not specified';
    }

    return 'RM ${budget.toStringAsFixed(2)}';
  }

  static String _humanize(String value) {
    return value
        .replaceAllMapped(RegExp(r'[A-Z]'), (match) => ' ${match.group(0)}')
        .trim();
  }

  static String _formatTravelStyle(dynamic style) {
    if (style == null) {
      return 'Not specified';
    }

    final value = style.name.toString();

    if (value.toLowerCase() == 'unknown') {
      return 'Not specified';
    }

    return _humanize(value);
  }

  static String _formatTransportMode(dynamic mode) {
    if (mode == null) {
      return 'Not specified';
    }

    final value = mode.name.toString();

    if (value.toLowerCase() == 'unknown') {
      return 'Not specified';
    }

    return _humanize(value);
  }
}
