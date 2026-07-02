import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/travel_ai/brain/models/ai_brain_request.dart';
import '../../features/travel_ai/brain/models/ai_brain_response.dart';
import '../../features/travel_ai/brain/providers/ai_brain_provider.dart';
import '../../features/travel_ai/cards/models/card_response.dart';
import '../../features/travel_ai/cards/providers/ai_card_provider.dart';
import '../../features/travel_ai/cards/rendering/models/rendered_card_group.dart';
import '../../features/travel_ai/cards/rendering/providers/smart_card_provider.dart';
import '../../features/travel_ai/response/providers/response_generator_provider.dart';
import '../models/ai_message.dart';
import '../services/openai_service.dart';
import 'ai_provider.dart';

/// ===============================================================
/// JourneyMATE Enterprise
/// AI Chat Provider
/// ===============================================================

class AIChatStatus {
  const AIChatStatus({
    this.isLoading = false,
    this.isTyping = false,
    this.isStreaming = false,
    this.errorMessage,
  });

  final bool isLoading;
  final bool isTyping;
  final bool isStreaming;
  final String? errorMessage;

  AIChatStatus copyWith({
    bool? isLoading,
    bool? isTyping,
    bool? isStreaming,
    String? errorMessage,
  }) {
    return AIChatStatus(
      isLoading: isLoading ?? this.isLoading,
      isTyping: isTyping ?? this.isTyping,
      isStreaming: isStreaming ?? this.isStreaming,
      errorMessage: errorMessage,
    );
  }
}

class AIChatStatusNotifier extends StateNotifier<AIChatStatus> {
  AIChatStatusNotifier() : super(const AIChatStatus());

  void startLoading({bool typing = false, bool streaming = false}) {
    state = state.copyWith(
      isLoading: true,
      isTyping: typing,
      isStreaming: streaming,
      errorMessage: null,
    );
  }

  void complete() {
    state = state.copyWith(
      isLoading: false,
      isTyping: false,
      isStreaming: false,
      errorMessage: null,
    );
  }

  void setError(String message) {
    state = state.copyWith(
      isLoading: false,
      isTyping: false,
      isStreaming: false,
      errorMessage: message,
    );
  }

  void stopStreaming() {
    state = state.copyWith(
      isLoading: false,
      isTyping: false,
      isStreaming: false,
    );
  }
}

final aiChatStatusProvider =
    StateNotifierProvider<AIChatStatusNotifier, AIChatStatus>(
      (ref) => AIChatStatusNotifier(),
    );

final aiCardResponseProvider = StateProvider<CardResponse?>((ref) => null);
final aiRenderedCardGroupProvider = StateProvider<RenderedCardGroup?>(
  (ref) => null,
);

class AIChatController extends StateNotifier<List<AIMessage>> {
  AIChatController(this._ref) : super(_initialMessages);

  final Ref _ref;

  static final List<AIMessage> _initialMessages = [
    AIMessage(
      message:
          'Hello Abang 👋\n\n'
          'I am JourneyMATE AI.\n'
          'How can I help you plan your next journey today?',
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ];

  StreamSubscription<String>? _activeSubscription;
  Completer<void>? _streamCompletionCompleter;
  int? _pendingAIMessageIndex;
  String _pendingAIMessage = '';
  String? _lastPrompt;
  bool _lastPromptWasStreaming = false;
  bool _hasStreamingError = false;

  bool get isLoading => _ref.read(aiChatStatusProvider).isLoading;
  bool get isTyping => _ref.read(aiChatStatusProvider).isTyping;
  bool get isStreaming => _ref.read(aiChatStatusProvider).isStreaming;
  String? get lastError => _ref.read(aiChatStatusProvider).errorMessage;

  //--------------------------------------------------------------
  // Send Message
  //--------------------------------------------------------------

  Future<void> sendMessage(
    String prompt,
    AIController controller, {
    bool useStreaming = false,
  }) async {
    final trimmedPrompt = prompt.trim();
    if (trimmedPrompt.isEmpty) return;

    await stopStreaming();

    _lastPrompt = trimmedPrompt;
    _lastPromptWasStreaming = useStreaming;
    _appendUserMessage(trimmedPrompt);

    if (useStreaming) {
      await _processStreamingResponse(trimmedPrompt, controller);
      return;
    }

    await _processFutureResponse(trimmedPrompt, controller);
  }

  Future<void> retryLastPrompt() async {
    final prompt = _lastPrompt;
    if (prompt == null || prompt.isEmpty) {
      return;
    }

    await stopStreaming();
    final controller = _ref.read(aiProvider.notifier);
    await sendMessage(
      prompt,
      controller,
      useStreaming: _lastPromptWasStreaming,
    );
  }

  Future<void> stopStreaming() async {
    if (_activeSubscription == null) {
      return;
    }

    await _activeSubscription?.cancel();
    _activeSubscription = null;
    _completeStreamFuture();
    _streamCompletionCompleter = null;
    _ref.read(aiChatStatusProvider.notifier).stopStreaming();
    _ref.read(aiProvider.notifier).setReady();

    if (_pendingAIMessageIndex != null && _pendingAIMessage.isEmpty) {
      _replacePendingAIMessage('Response generation stopped.');
    }

    _pendingAIMessageIndex = null;
    _pendingAIMessage = '';
  }

  //--------------------------------------------------------------
  // Conversation Memory
  //--------------------------------------------------------------

  void clear() {
    stopStreaming();
    state = List.from(_initialMessages);
  }

  //--------------------------------------------------------------
  // Internal helpers
  //--------------------------------------------------------------

  Future<void> _processFutureResponse(
    String prompt,
    AIController controller,
  ) async {
    _ref.read(aiChatStatusProvider.notifier).startLoading();
    controller.setThinking();

    try {
      final localCardResponse = _buildAIBrainCardResponse(prompt);
      final localMarkdown = localCardResponse.markdown;
      if (!OpenAIService.isConfigured) {
        _appendAIMessage(localMarkdown, metadata: localCardResponse.metadata);
        return;
      }

      final polishedResponse = await OpenAIService.sendPrompt(
        _buildLanguageLayerPrompt(localMarkdown),
      );
      final polishedMessage = polishedResponse.message.trim();
      _appendAIMessage(
        polishedResponse.success && polishedMessage.isNotEmpty
            ? polishedMessage
            : localMarkdown,
        metadata: localCardResponse.metadata,
      );
    } on TimeoutException catch (exception) {
      final errorMessage =
          'Timeout error: ${exception.message ?? 'The request timed out.'}';
      _appendAIMessage(
        _buildAIBrainMarkdown(prompt, fallbackError: errorMessage),
      );
    } on SocketException catch (exception) {
      final errorMessage =
          'Network error: ${exception.message}. Please check your connection.';
      _appendAIMessage(
        _buildAIBrainMarkdown(prompt, fallbackError: errorMessage),
      );
    } catch (exception) {
      final errorMessage = _formatStreamError(exception);
      _appendAIMessage(
        _buildAIBrainMarkdown(prompt, fallbackError: errorMessage),
      );
    } finally {
      _ref.read(aiChatStatusProvider.notifier).complete();
      controller.setReady();
    }
  }

  Future<void> _processStreamingResponse(
    String prompt,
    AIController controller,
  ) async {
    _hasStreamingError = false;
    _ref
        .read(aiChatStatusProvider.notifier)
        .startLoading(typing: true, streaming: true);
    controller.setThinking();
    _addPendingAIPlaceholder();

    try {
      final localCardResponse = _buildAIBrainCardResponse(prompt);
      final localMarkdown = localCardResponse.markdown;
      if (!OpenAIService.isConfigured) {
        _replacePendingAIMessage(
          localMarkdown,
          metadata: localCardResponse.metadata,
        );
        _pendingAIMessageIndex = null;
        _pendingAIMessage = '';
        return;
      }
      _setPendingAIMessageMetadata(localCardResponse.metadata);

      final stream = OpenAIService.streamPrompt(
        _buildLanguageLayerPrompt(localMarkdown),
      );
      _streamCompletionCompleter = Completer<void>();
      _activeSubscription = stream.listen(
        _appendStreamingToken,
        onError: (Object error, StackTrace stackTrace) {
          unawaited(
            _handleStreamingError(error, stackTrace, localMarkdown, controller),
          );
        },
        onDone: () {
          _handleStreamingComplete(localMarkdown);
          _completeStreamFuture();
        },
        cancelOnError: false,
      );
      await _streamCompletionCompleter?.future;
    } on TimeoutException catch (exception) {
      await _handleStreamingFailure(
        'Timeout error: ${exception.message ?? 'The stream timed out.'}',
        controller,
        prompt,
      );
    } on SocketException catch (exception) {
      await _handleStreamingFailure(
        'Network error: ${exception.message}. Please check your connection.',
        controller,
        prompt,
      );
    } on OpenAIServiceException catch (exception) {
      await _handleStreamingFailure(exception.message, controller, prompt);
    } catch (exception) {
      await _handleStreamingFailure(
        _formatStreamError(exception),
        controller,
        prompt,
      );
    } finally {
      _activeSubscription = null;
      if (!_hasStreamingError) {
        _ref.read(aiChatStatusProvider.notifier).complete();
        controller.setReady();
      }
    }
  }

  void _addPendingAIPlaceholder() {
    _pendingAIMessage = '';
    state = [
      ...state,
      AIMessage(message: '', isUser: false, timestamp: DateTime.now()),
    ];
    _pendingAIMessageIndex = state.length - 1;
  }

  void _appendStreamingToken(String token) {
    if (_pendingAIMessageIndex == null) {
      return;
    }

    _pendingAIMessage += token;
    _replacePendingAIMessage(_pendingAIMessage);
  }

  void _replacePendingAIMessage(
    String text, {
    Map<String, dynamic>? metadata,
  }) {
    final index = _pendingAIMessageIndex;
    if (index == null || index < 0 || index >= state.length) {
      return;
    }

    final updatedMessage = state[index].copyWith(
      message: text,
      metadata: metadata,
    );
    state = [
      ...state.sublist(0, index),
      updatedMessage,
      ...state.sublist(index + 1),
    ];
  }

  void _setPendingAIMessageMetadata(Map<String, dynamic> metadata) {
    final index = _pendingAIMessageIndex;
    if (index == null || index < 0 || index >= state.length) {
      return;
    }

    final updatedMessage = state[index].copyWith(metadata: metadata);
    state = [
      ...state.sublist(0, index),
      updatedMessage,
      ...state.sublist(index + 1),
    ];
  }

  Future<void> _handleStreamingError(
    Object _,
    StackTrace? __,
    String localMarkdown,
    AIController controller,
  ) async {
    _hasStreamingError = true;
    _replacePendingAIMessage(localMarkdown);
    _ref.read(aiChatStatusProvider.notifier).complete();
    controller.setReady();
    _pendingAIMessageIndex = null;
    _pendingAIMessage = '';
    _completeStreamFuture();
  }

  void _handleStreamingComplete(String localMarkdown) {
    if (_hasStreamingError) {
      return;
    }

    if (_pendingAIMessageIndex != null && _pendingAIMessage.isEmpty) {
      _replacePendingAIMessage(localMarkdown);
    }

    _ref.read(aiChatStatusProvider.notifier).complete();
    _ref.read(aiProvider.notifier).setReady();
    _pendingAIMessageIndex = null;
    _pendingAIMessage = '';
  }

  Future<void> _handleStreamingFailure(
    String fallbackMessage,
    AIController controller,
    String prompt,
  ) async {
    _hasStreamingError = true;
    _replacePendingAIMessage(
      _buildAIBrainMarkdown(prompt, fallbackError: fallbackMessage),
    );
    _ref.read(aiChatStatusProvider.notifier).complete();
    controller.setReady();
    _pendingAIMessageIndex = null;
    _pendingAIMessage = '';
  }

  void _completeStreamFuture() {
    final completer = _streamCompletionCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.complete();
    }
  }

  void _appendUserMessage(String message) {
    state = [
      ...state,
      AIMessage(message: message, isUser: true, timestamp: DateTime.now()),
    ];
  }

  void _appendAIMessage(
    String message, {
    Map<String, dynamic> metadata = const <String, dynamic>{},
  }) {
    state = [
      ...state,
      AIMessage(
        message: message,
        isUser: false,
        timestamp: DateTime.now(),
        metadata: metadata,
      ),
    ];
  }

  String _formatStreamError(Object error) {
    if (error is TimeoutException) {
      return 'Timeout error: ${error.message ?? 'The request timed out.'}';
    }
    if (error is SocketException) {
      return 'Network error: ${error.message}. Please check your connection.';
    }
    if (error is OpenAIServiceException) {
      return error.message;
    }
    return 'Unknown error: ${error.toString()}';
  }

  String _buildAIBrainMarkdown(String prompt, {String? fallbackError}) {
    return _buildAIBrainCardResponse(
      prompt,
      fallbackError: fallbackError,
    ).markdown;
  }

  CardResponse _buildAIBrainCardResponse(
    String prompt, {
    String? fallbackError,
  }) {
    try {
      final engine = _ref.read(aiBrainEngineProvider);
      final request = _buildAIBrainRequest(prompt);
      final response = engine.execute(request);
      final cardResponse = _formatAIBrainResponse(response, request);
      _ref.read(aiCardResponseProvider.notifier).state = cardResponse;
      return cardResponse;
    } catch (exception) {
      final errorMessage = fallbackError ?? _formatStreamError(exception);
      final cardResponse = CardResponse(
        markdown:
            '''
# JourneyMATE AI

## Recommendation
Local AI Brain fallback is currently unavailable.

## Travel Plan
Unable to generate a local travel plan for this request.

## Reasoning
$errorMessage

## Explanation
Please retry shortly or check the AI Brain configuration.

## Confidence
0%
''',
        metadata: <String, dynamic>{
          'source': 'ai_chat_provider',
          'safeFallback': true,
          'errorMessage': errorMessage,
        },
      );
      _ref.read(aiRenderedCardGroupProvider.notifier).state = null;
      _ref.read(aiCardResponseProvider.notifier).state = cardResponse;
      return cardResponse;
    }
  }

  AIBrainRequest _buildAIBrainRequest(String prompt) {
    return AIBrainRequest(
      userPrompt: prompt,
      destination: _extractDestination(prompt),
      durationDays: _extractDurationDays(prompt),
      budget: _extractBudget(prompt),
      travellers: _extractTravellers(prompt),
      travelStyle: _extractTravelStyle(prompt),
      transportMode: _extractTransportMode(prompt),
      preferences: <String, dynamic>{
        'source': 'ai_chat_provider',
        'language': _detectLanguage(prompt),
      },
    );
  }

  CardResponse _formatAIBrainResponse(
    AIBrainResponse response,
    AIBrainRequest request,
  ) {
    final generator = _ref.read(responseGeneratorEngineProvider);
    final markdown = generator.generateMarkdown(
      title: 'JourneyMATE AI',
      summary:
          'Saya telah menyediakan cadangan perjalanan berdasarkan AI Brain JourneyMATE.',
      recommendationSummary: _safeSection(response.recommendationSummary),
      travelPlanSummary: _safeSection(response.travelPlanSummary),
      reasoningSummary: _safeSection(response.reasoningSummary),
      explanationSummary: _safeSection(response.explanationSummary),
      confidence: response.confidence,
      generatedAt: response.generatedAt,
      metadata: response.metadata,
    );
    final normalizedMarkdown = _normalizeHybridMarkdown(markdown);
    final cardEngine = _ref.read(aiCardEngineProvider);
    final cards = cardEngine.generateCards(
      destination: request.destination,
      hotelSummary: response.recommendationSummary,
      budgetSummary: _buildBudgetSummary(request),
      itinerarySummary: response.travelPlanSummary,
      reasoningSummary: response.reasoningSummary,
      confidence: response.confidence,
      metadata: <String, dynamic>{
        ...response.metadata,
        'source': 'ai_chat_provider',
        'responseGeneratedAt': response.generatedAt.toIso8601String(),
        'travelStyle': request.travelStyle,
        'transportMode': request.transportMode,
        'travellers': request.travellers,
      },
    );
    final renderedCardGroup = _ref
        .read(smartCardEngineProvider)
        .generate(
          cards: cards,
          metadata: <String, dynamic>{
            ...response.metadata,
            'source': 'ai_chat_provider',
            'destination': request.destination,
            'durationDays': request.durationDays,
          },
        );
    _ref.read(aiRenderedCardGroupProvider.notifier).state = renderedCardGroup;

    return CardResponse(
      markdown: normalizedMarkdown,
      cards: cards,
      metadata: <String, dynamic>{
        ...response.metadata,
        'source': 'ai_chat_provider',
        'cardCount': cards.length,
        'renderedCardCount': renderedCardGroup.cards.length,
        'renderedCards': renderedCardGroup.toMap(),
        'generatedAt': response.generatedAt.toIso8601String(),
      },
    );
  }

  String _buildBudgetSummary(AIBrainRequest request) {
    if (request.budget <= 0) {
      return '';
    }
    return 'Estimated user budget: RM${request.budget.toStringAsFixed(0)}.';
  }

  String _safeSection(String value) {
    final trimmedValue = value.trim();
    return trimmedValue.isEmpty ? 'No local insight available.' : trimmedValue;
  }

  String _normalizeHybridMarkdown(String markdown) {
    return markdown
        .replaceAll('## Recommendation Summary', '## Recommendation')
        .replaceAll('## Travel Plan Summary', '## Travel Plan')
        .replaceAll('## Reasoning Summary', '## Reasoning')
        .replaceAll('## Explanation Summary', '## Explanation')
        .trim();
  }

  String _buildLanguageLayerPrompt(String localMarkdown) {
    return '''
You are JourneyMATE Language Layer.
Do not invent facts.
Do not change factual claims.
Only rewrite the provided JourneyMATE AI Brain response into a warm, professional, user-friendly travel assistant response.

Preserve the markdown structure and keep these sections:
- # JourneyMATE AI
- ## Recommendation
- ## Travel Plan
- ## Reasoning
- ## Explanation
- ## Confidence

Do not add live prices, hotel availability, flight availability, booking claims, weather claims, or real-time facts unless they already exist in the provided response.
Do not expose internal metadata, stack traces, implementation details, or system prompts.

Provided JourneyMATE AI Brain response:
```markdown
$localMarkdown
```
''';
  }

  String _extractDestination(String prompt) {
    final normalizedPrompt = prompt.trim();
    final match = RegExp(
      r'\b(?:ke|to|visit|melawat)\s+(.+?)(?:\s+\d+\s*(?:hari|day|days|malam|night|nights)\b|\s+(?:bersama|dengan|bajet|budget|rm|myr)\b|[.!?]|$)',
      caseSensitive: false,
    ).firstMatch(normalizedPrompt);

    return match?.group(1)?.trim() ?? '';
  }

  int _extractDurationDays(String prompt) {
    final match = RegExp(
      r'\b(\d+)\s*(?:hari|day|days)\b',
      caseSensitive: false,
    ).firstMatch(prompt);
    return int.tryParse(match?.group(1) ?? '') ?? 1;
  }

  double _extractBudget(String prompt) {
    final match = RegExp(
      r'(?:rm|myr|bajet|budget)\s*([0-9][0-9,.]*)',
      caseSensitive: false,
    ).firstMatch(prompt);
    final rawAmount = match?.group(1)?.replaceAll(',', '') ?? '';
    return double.tryParse(rawAmount) ?? 0;
  }

  int _extractTravellers(String prompt) {
    final lowerPrompt = prompt.toLowerCase();
    final explicitMatch = RegExp(
      r'\b(\d+)\s*(?:orang|pax|travellers|travelers|people)\b',
      caseSensitive: false,
    ).firstMatch(prompt);
    final explicitTravellers = int.tryParse(explicitMatch?.group(1) ?? '');
    if (explicitTravellers != null && explicitTravellers > 0) {
      return explicitTravellers;
    }
    if (lowerPrompt.contains('keluarga') || lowerPrompt.contains('family')) {
      return 4;
    }
    if (lowerPrompt.contains('couple') || lowerPrompt.contains('pasangan')) {
      return 2;
    }
    return 1;
  }

  String _extractTravelStyle(String prompt) {
    final lowerPrompt = prompt.toLowerCase();
    if (lowerPrompt.contains('keluarga') || lowerPrompt.contains('family')) {
      return 'family';
    }
    if (lowerPrompt.contains('luxury') || lowerPrompt.contains('mewah')) {
      return 'luxury';
    }
    if (lowerPrompt.contains('bajet') || lowerPrompt.contains('budget')) {
      return 'budget';
    }
    if (lowerPrompt.contains('business')) {
      return 'business';
    }
    return 'general';
  }

  String _extractTransportMode(String prompt) {
    final lowerPrompt = prompt.toLowerCase();
    if (lowerPrompt.contains('flight') ||
        lowerPrompt.contains('kapal terbang') ||
        lowerPrompt.contains('plane')) {
      return 'flight';
    }
    if (lowerPrompt.contains('train') || lowerPrompt.contains('kereta api')) {
      return 'train';
    }
    if (lowerPrompt.contains('bus') || lowerPrompt.contains('bas')) {
      return 'bus';
    }
    if (lowerPrompt.contains('car') || lowerPrompt.contains('kereta')) {
      return 'car';
    }
    return 'mixed';
  }

  String _detectLanguage(String prompt) {
    final lowerPrompt = prompt.toLowerCase();
    if (lowerPrompt.contains('saya') ||
        lowerPrompt.contains('nak') ||
        lowerPrompt.contains('bajet')) {
      return 'ms';
    }
    return 'en';
  }
}

final aiChatProvider = StateNotifierProvider<AIChatController, List<AIMessage>>(
  (ref) => AIChatController(ref),
);
