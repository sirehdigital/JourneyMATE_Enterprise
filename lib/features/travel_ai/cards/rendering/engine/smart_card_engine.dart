import '../../models/ai_card.dart';
import '../models/rendered_card.dart';
import '../models/rendered_card_group.dart';
import '../services/smart_card_renderer.dart';

class SmartCardEngine {
  SmartCardEngine({SmartCardRenderer? renderer})
    : _renderer = renderer ?? const SmartCardRenderer();

  final SmartCardRenderer _renderer;

  RenderedCardGroup generate({
    required List<AICard> cards,
    Map<String, dynamic>? metadata,
    String title = 'JourneyMATE Smart Cards',
    String subtitle = '',
  }) {
    return _renderer.renderGroup(
      cards: cards,
      metadata: metadata,
      title: title,
      subtitle: subtitle,
    );
  }

  RenderedCard renderCard(AICard card, {Map<String, dynamic>? metadata}) {
    return _renderer.renderCard(card, metadata: metadata);
  }
}
