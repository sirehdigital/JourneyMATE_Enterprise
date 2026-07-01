import '../../domain/entities/prompt_context.dart';
import '../../domain/entities/travel_context.dart';
import '../../domain/entities/travel_intent.dart';
import '../../domain/enums/travel_intent_type.dart';
import '../../domain/enums/travel_style.dart';
import '../../domain/enums/transport_mode.dart';

class PromptBuilderService {
  PromptBuilderService._();

  static PromptContext buildPrompt(
    TravelIntent intent,
    TravelContext context,
    String userPrompt,
  ) {
    final systemRole = 'You are an enterprise travel planning assistant.';
    final travelIntent = intent;
    final travelContext = context;
    final generatedPrompt = _buildMarkdownPrompt(
      systemRole: systemRole,
      intent: intent,
      context: context,
      userPrompt: userPrompt,
    );

    return PromptContext(
      systemRole: systemRole,
      travelIntent: travelIntent,
      travelContext: travelContext,
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
    buffer.writeln('# Travel AI Prompt');
    buffer.writeln();
    buffer.writeln('**System Role:** $systemRole');
    buffer.writeln();
    buffer.writeln('**Travel Intent:** ${_formatIntentType(intent.type)}');
    buffer.writeln();
    buffer.writeln('## Travel Context');
    buffer.writeln();
    buffer.writeln('- **Destination:** ${context.destination ?? 'Not specified'}');
    buffer.writeln('- **Origin:** ${context.origin ?? 'Not specified'}');
    buffer.writeln('- **Duration:** ${_formatDuration(context.durationDays)}');
    buffer.writeln('- **Travellers:** ${context.travellers?.toString() ?? 'Not specified'}');
    buffer.writeln('- **Budget:** ${_formatBudget(context.budget)}');
    buffer.writeln('- **Travel Style:** ${_formatTravelStyle(context.travelStyle)}');
    buffer.writeln('- **Transport Mode:** ${_formatTransportMode(context.transportMode)}');
    buffer.writeln('- **Language:** ${context.language ?? 'Not specified'}');
    buffer.writeln();
    buffer.writeln('### Additional Requirements');
    buffer.writeln();
    buffer.writeln('- **Muslim friendly:** ${context.muslimFriendly ? 'Yes' : 'No'}');
    buffer.writeln('- **Wheelchair access:** ${context.wheelchairAccess ? 'Yes' : 'No'}');
    buffer.writeln('- **Family friendly:** ${context.familyFriendly ? 'Yes' : 'No'}');
    buffer.writeln('- **Kids friendly:** ${context.kidsFriendly ? 'Yes' : 'No'}');
    buffer.writeln();
    buffer.writeln('## User Request');
    buffer.writeln();
    buffer.writeln(userPrompt.trim().isEmpty ? 'No user prompt provided.' : userPrompt.trim());
    buffer.writeln();
    buffer.writeln('---');
    buffer.writeln('Please answer the user request using the travel context and intent above.');

    return buffer.toString();
  }

  static String _formatIntentType(TravelIntentType type) {
    final label = type.name.replaceAll(RegExp(r'([A-Z])'), ' \\$1').trim();
    return label.isEmpty ? 'Unknown' : label;
  }

  static String _formatDuration(int? durationDays) {
    if (durationDays == null) {
      return 'Not specified';
    }
    return '$durationDays day${durationDays == 1 ? '' : 's'}';
  }

  static String _formatBudget(double? budget) {
    if (budget == null) {
      return 'Not specified';
    }
    return 'RM ${budget.toStringAsFixed(2)}';
  }

  static String _formatTravelStyle(TravelStyle style) {
    if (style == TravelStyle.unknown) {
      return 'Not specified';
    }
    return style.name.replaceAll(RegExp(r'([A-Z])'), ' \\$1').trim();
  }

  static String _formatTransportMode(TransportMode mode) {
    if (mode == TransportMode.unknown) {
      return 'Not specified';
    }
    return mode.name.replaceAll(RegExp(r'([A-Z])'), ' \\$1').trim();
  }
}
