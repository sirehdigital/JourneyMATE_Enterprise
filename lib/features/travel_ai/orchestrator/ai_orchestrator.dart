import 'dart:async';

import '../agents/base/agent_registry.dart';
import '../agents/base/agent_result.dart';
import '../router/routing_result.dart';
import 'orchestration_result.dart';

/// Coordinates execution of AI agents based on routing decisions.
class AIOrchestrator {
  /// Creates a new [AIOrchestrator] with the provided [registry].
  AIOrchestrator({required AgentRegistry registry}) : _registry = registry;

  final AgentRegistry _registry;

  /// Executes selected agents sequentially based on the routing result.
  ///
  /// The orchestrator resolves agent ids from [routing], retrieves each agent
  /// from the registry, sorts them by priority, and executes them one by one.
  /// Missing agents are skipped safely, and failures from one agent do not
  /// stop remaining agent execution.
  Future<OrchestrationResult> execute({
    required RoutingResult routing,
    required String prompt,
    required Map<String, dynamic> context,
  }) async {
    final stopwatch = Stopwatch()..start();
    final executedAgentIds = <String>[];
    final agentResults = <AgentResult>[];
    final metadata = <String, dynamic>{
      'prompt': prompt,
      'requestedAgentIds': List<String>.from(routing.selectedAgents),
    };

    final availableAgents =
        routing.selectedAgents
            .map(_registry.getAgent)
            .where((agent) => agent != null)
            .cast<dynamic>()
            .toList()
          ..sort(
            (first, second) => (first.priority).compareTo(second.priority),
          );

    for (final dynamic agent in availableAgents) {
      final agentId = agent.id as String;
      executedAgentIds.add(agentId);

      try {
        final result = await agent.execute(prompt: prompt, context: context);
        agentResults.add(result);
      } catch (error, stackTrace) {
        agentResults.add(
          AgentResult(
            agentId: agentId,
            success: false,
            message: 'Agent execution failed: ${error.toString()}',
            metadata: {
              'error': error.toString(),
              'stackTrace': stackTrace.toString(),
            },
          ),
        );
      }
    }

    stopwatch.stop();
    final success = agentResults.every((result) => result.success);
    metadata['executedCount'] = executedAgentIds.length;
    metadata['failedCount'] = agentResults
        .where((result) => !result.success)
        .length;

    return OrchestrationResult(
      success: success,
      executedAgents: executedAgentIds,
      agentResults: agentResults,
      executionTime: stopwatch.elapsed,
      metadata: metadata,
    );
  }
}
