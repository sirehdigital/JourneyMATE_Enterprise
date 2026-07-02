import '../models/reasoning_context.dart';
import '../models/reasoning_decision.dart';
import '../models/reasoning_rule.dart';
import '../models/reasoning_trace.dart';
import '../services/reasoning_service.dart';

class ReasoningEngine {
  ReasoningEngine({ReasoningService? service})
    : _service = service ?? const ReasoningService();

  final ReasoningService _service;

  ReasoningDecision reasonTravelPlan({
    required ReasoningContext context,
    required List<ReasoningRule> rules,
  }) {
    return _service.evaluate(context: context, rules: rules);
  }

  ReasoningDecision reasonRecommendation({
    required ReasoningContext context,
    required List<ReasoningRule> rules,
  }) {
    return _service.evaluate(context: context, rules: rules);
  }

  ReasoningDecision reasonDestination({
    required ReasoningContext context,
    required List<ReasoningRule> rules,
  }) {
    return _service.evaluate(context: context, rules: rules);
  }

  ReasoningDecision evaluateScenario({
    required ReasoningContext context,
    required List<ReasoningRule> rules,
  }) {
    return _service.evaluate(context: context, rules: rules);
  }

  ReasoningTrace explainDecision({
    required List<ReasoningRule> executedRules,
    required List<ReasoningRule> skippedRules,
    required int decisionTime,
  }) {
    return _service.generateTrace(
      executedRules: executedRules,
      skippedRules: skippedRules,
      decisionTime: decisionTime,
    );
  }
}
