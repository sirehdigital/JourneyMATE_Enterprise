import '../models/explanation_item.dart';
import '../models/explanation_summary.dart';

class ExplainabilityService {
  const ExplainabilityService();

  ExplanationSummary explain(String title, List<ExplanationItem> items) {
    final safeItems = items.isEmpty ? const <ExplanationItem>[] : items;
    final summary = safeItems.isEmpty
        ? 'No explanation available.'
        : 'Generated ${safeItems.length} explainability points for $title.';

    return ExplanationSummary(
      title: title,
      summary: summary,
      items: safeItems,
      generatedAt: DateTime.now(),
      metadata: <String, dynamic>{'source': 'local-explainability-engine'},
    );
  }

  List<ExplanationItem> buildReasoningItems({
    required String target,
    required double score,
    required String category,
  }) {
    if (target.trim().isEmpty) {
      return const <ExplanationItem>[];
    }

    return <ExplanationItem>[
      ExplanationItem(
        id: 'reason-1',
        title: 'Knowledge match',
        detail: 'The target matched the available local knowledge graph context.',
        score: score,
        category: category,
      ),
      ExplanationItem(
        id: 'reason-2',
        title: 'Preference alignment',
        detail: 'The recommendation aligns with the local personalization profile.',
        score: score,
        category: category,
      ),
    ];
  }
}
