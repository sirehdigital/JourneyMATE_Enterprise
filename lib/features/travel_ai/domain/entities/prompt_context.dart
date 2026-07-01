import 'travel_context.dart';
import 'travel_intent.dart';

class PromptContext {
  PromptContext({
    required this.systemRole,
    required this.travelIntent,
    required this.travelContext,
    required this.userPrompt,
    required this.generatedPrompt,
  });

  final String systemRole;
  final TravelIntent travelIntent;
  final TravelContext travelContext;
  final String userPrompt;
  final String generatedPrompt;
}
