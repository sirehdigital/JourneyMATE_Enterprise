import '../models/reasoning_context.dart';
import '../models/reasoning_decision.dart';
import '../models/reasoning_rule.dart';
import '../models/reasoning_trace.dart';

class ReasoningService {
  const ReasoningService();

  ReasoningDecision evaluate({
    required ReasoningContext context,
    required List<ReasoningRule> rules,
  }) {
    final appliedRules = applyRules(context: context, rules: rules);
    final confidence = calculateConfidence(
      context: context,
      appliedRules: appliedRules,
    );
    final recommendations = <String>[];

    if (context.destination.isNotEmpty) {
      recommendations.add('Prioritize destination suitability');
    }
    if (context.budget > 0) {
      recommendations.add('Maintain budget compatibility');
    }
    if (context.travellers > 1) {
      recommendations.add('Consider group-friendly activities');
    }

    return ReasoningDecision(
      id: 'decision-${DateTime.now().microsecondsSinceEpoch}',
      title: 'Reasoned travel recommendation',
      description: 'Decision derived from locally evaluated rules and context.',
      confidence: confidence,
      decisionType: 'recommendation',
      appliedRules: appliedRules
          .map((rule) => rule.name)
          .toList(growable: false),
      recommendations: recommendations,
    );
  }

  List<ReasoningRule> applyRules({
    required ReasoningContext context,
    required List<ReasoningRule> rules,
  }) {
    if (context.destination.isEmpty) {
      return const <ReasoningRule>[];
    }

    final selected = rules
        .where((rule) => rule.enabled)
        .toList(growable: false);
    selected.sort((left, right) => right.priority.compareTo(left.priority));
    return selected;
  }

  List<ReasoningDecision> rankDecisions(List<ReasoningDecision> decisions) {
    if (decisions.isEmpty) {
      return const <ReasoningDecision>[];
    }

    final ranked = List<ReasoningDecision>.from(decisions);
    ranked.sort((left, right) => right.confidence.compareTo(left.confidence));
    return ranked;
  }

  List<ReasoningDecision> resolveConflicts(List<ReasoningDecision> decisions) {
    if (decisions.isEmpty) {
      return const <ReasoningDecision>[];
    }

    final resolved = <ReasoningDecision>[];
    for (final decision in decisions) {
      if (!resolved.any((candidate) => candidate.id == decision.id)) {
        resolved.add(decision);
      }
    }
    return resolved;
  }

  double calculateConfidence({
    required ReasoningContext context,
    required List<ReasoningRule> appliedRules,
  }) {
    if (context.destination.isEmpty) {
      return 0.0;
    }

    final score = (appliedRules.length / 5).clamp(0.0, 1.0).toDouble();
    final preferenceBonus = context.preferences.isEmpty ? 0.0 : 0.1;
    return (score + preferenceBonus).clamp(0.0, 1.0).toDouble();
  }

  ReasoningTrace generateTrace({
    required List<ReasoningRule> executedRules,
    required List<ReasoningRule> skippedRules,
    required int decisionTime,
  }) {
    return ReasoningTrace(
      timestamp: DateTime.now(),
      executedRules: executedRules
          .map((rule) => rule.name)
          .toList(growable: false),
      skippedRules: skippedRules
          .map((rule) => rule.name)
          .toList(growable: false),
      decisionTime: decisionTime,
    );
  }
}
