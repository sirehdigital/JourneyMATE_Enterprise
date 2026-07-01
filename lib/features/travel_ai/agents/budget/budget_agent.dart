import '../../agents/base/ai_agent.dart';
import '../../agents/base/agent_result.dart';
import 'budget_request.dart';
import 'budget_summary.dart';

/// Budget AI agent responsible for analyzing travel affordability.
class BudgetAgent extends AIAgent {
  /// Creates a new [BudgetAgent].
  const BudgetAgent({
    required super.id,
    required super.name,
    required super.description,
    required super.priority,
  });

  /// Agent capabilities exposed for budget analysis.
  static const capabilities = <String>[
    'budget_analysis',
    'budget_optimization',
    'cost_estimation',
    'travel_budget',
    'expense_summary',
  ];

  @override
  Future<AgentResult> execute({
    required String prompt,
    required Map<String, dynamic> context,
  }) async {
    final request = _buildBudgetRequest(context);
    final summary = _analyzeBudget(request);
    final message = _buildMessage(summary);

    return AgentResult(
      agentId: id,
      success: true,
      message: message,
      metadata: {
        'destination': request.destination,
        'tripDays': request.tripDays,
        'travellers': request.travellers,
        'utilizationPercentage':
            summary.estimatedTotalCost / request.totalBudget * 100,
        'budgetStatus': summary.budgetStatus,
        'summary': summary.toMap(),
      },
    );
  }

  BudgetRequest _buildBudgetRequest(Map<String, dynamic> context) {
    final totalBudget = context['totalBudget'] is int
        ? (context['totalBudget'] as int).toDouble()
        : context['totalBudget'] as double?;
    final currency = context['currency'] as String?;
    final travellers = context['travellers'] as int?;
    final tripDays = context['tripDays'] as int?;
    final destination = context['destination'] as String?;
    final estimatedFlightCost = context['estimatedFlightCost'] is int
        ? (context['estimatedFlightCost'] as int).toDouble()
        : context['estimatedFlightCost'] as double?;
    final estimatedHotelCost = context['estimatedHotelCost'] is int
        ? (context['estimatedHotelCost'] as int).toDouble()
        : context['estimatedHotelCost'] as double?;
    final estimatedTransportCost = context['estimatedTransportCost'] is int
        ? (context['estimatedTransportCost'] as int).toDouble()
        : context['estimatedTransportCost'] as double?;
    final estimatedFoodCost = context['estimatedFoodCost'] is int
        ? (context['estimatedFoodCost'] as int).toDouble()
        : context['estimatedFoodCost'] as double?;
    final estimatedActivityCost = context['estimatedActivityCost'] is int
        ? (context['estimatedActivityCost'] as int).toDouble()
        : context['estimatedActivityCost'] as double?;

    if (totalBudget == null || totalBudget <= 0) {
      throw ArgumentError.value(
        totalBudget,
        'totalBudget',
        'Budget must be greater than zero.',
      );
    }
    if (currency == null || currency.isEmpty) {
      throw ArgumentError.value(
        currency,
        'currency',
        'Currency cannot be empty.',
      );
    }
    if (travellers == null || travellers <= 0) {
      throw ArgumentError.value(
        travellers,
        'travellers',
        'Travellers must be greater than zero.',
      );
    }
    if (tripDays == null || tripDays <= 0) {
      throw ArgumentError.value(
        tripDays,
        'tripDays',
        'Trip days must be greater than zero.',
      );
    }
    if (destination == null || destination.isEmpty) {
      throw ArgumentError.value(
        destination,
        'destination',
        'Destination is required.',
      );
    }
    if (estimatedFlightCost == null || estimatedFlightCost < 0) {
      throw ArgumentError.value(
        estimatedFlightCost,
        'estimatedFlightCost',
        'Estimated flight cost must be zero or positive.',
      );
    }
    if (estimatedHotelCost == null || estimatedHotelCost < 0) {
      throw ArgumentError.value(
        estimatedHotelCost,
        'estimatedHotelCost',
        'Estimated hotel cost must be zero or positive.',
      );
    }
    if (estimatedTransportCost == null || estimatedTransportCost < 0) {
      throw ArgumentError.value(
        estimatedTransportCost,
        'estimatedTransportCost',
        'Estimated transport cost must be zero or positive.',
      );
    }
    if (estimatedFoodCost == null || estimatedFoodCost < 0) {
      throw ArgumentError.value(
        estimatedFoodCost,
        'estimatedFoodCost',
        'Estimated food cost must be zero or positive.',
      );
    }
    if (estimatedActivityCost == null || estimatedActivityCost < 0) {
      throw ArgumentError.value(
        estimatedActivityCost,
        'estimatedActivityCost',
        'Estimated activity cost must be zero or positive.',
      );
    }

    return BudgetRequest(
      totalBudget: totalBudget,
      currency: currency,
      travellers: travellers,
      tripDays: tripDays,
      destination: destination,
      estimatedFlightCost: estimatedFlightCost,
      estimatedHotelCost: estimatedHotelCost,
      estimatedTransportCost: estimatedTransportCost,
      estimatedFoodCost: estimatedFoodCost,
      estimatedActivityCost: estimatedActivityCost,
    );
  }

  BudgetSummary _analyzeBudget(BudgetRequest request) {
    final estimatedTotalCost =
        request.estimatedFlightCost +
        request.estimatedHotelCost +
        request.estimatedTransportCost +
        request.estimatedFoodCost +
        request.estimatedActivityCost;
    final remainingBudget = request.totalBudget - estimatedTotalCost;
    final utilization = estimatedTotalCost / request.totalBudget;
    final budgetStatus = _resolveBudgetStatus(utilization);
    final recommendations = _buildRecommendations(
      request,
      remainingBudget,
      utilization,
    );

    return BudgetSummary(
      totalBudget: request.totalBudget,
      estimatedTotalCost: estimatedTotalCost,
      remainingBudget: remainingBudget,
      budgetStatus: budgetStatus,
      recommendations: recommendations,
      currency: request.currency,
    );
  }

  String _resolveBudgetStatus(double utilization) {
    if (utilization <= 0.55) {
      return 'Excellent';
    }
    if (utilization <= 0.80) {
      return 'Comfortable';
    }
    if (utilization <= 1.00) {
      return 'Tight';
    }
    return 'Over Budget';
  }

  List<String> _buildRecommendations(
    BudgetRequest request,
    double remainingBudget,
    double utilization,
  ) {
    final recommendations = <String>[];

    if (request.estimatedHotelCost > request.totalBudget * 0.4) {
      recommendations.add(
        'Consider alternative hotel options or shorter stays to reduce accommodation expenses.',
      );
    }

    if (request.estimatedFlightCost > request.totalBudget * 0.3) {
      recommendations.add(
        'Review flight options for lower fares or flexible dates.',
      );
    }

    if (request.estimatedFoodCost > request.totalBudget * 0.15) {
      recommendations.add(
        'Plan meals with a mix of local dining and self-catering to control food costs.',
      );
    }

    if (utilization > 1.0) {
      recommendations.add(
        'Your trip is currently over budget; adjust travel dates, accommodation, or activities to reduce cost.',
      );
    } else if (remainingBudget > request.totalBudget * 0.2) {
      recommendations.add(
        'Your budget looks healthy; you may consider upgrading one service or adding a premium experience.',
      );
    } else {
      recommendations.add(
        'Your budget is tight; monitor expenses closely and prioritize essential items.',
      );
    }

    return recommendations;
  }

  String _buildMessage(BudgetSummary summary) {
    return '''Budget analysis completed.
Total Budget: ${summary.totalBudget.toStringAsFixed(2)} ${summary.currency}
Estimated Cost: ${summary.estimatedTotalCost.toStringAsFixed(2)} ${summary.currency}
Remaining Budget: ${summary.remainingBudget.toStringAsFixed(2)} ${summary.currency}
Budget Status: ${summary.budgetStatus}
Recommendations:
- ${summary.recommendations.join('\n- ')}
''';
  }
}
