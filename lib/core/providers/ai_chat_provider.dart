import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    _streamCompletionCompleter?.complete();
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
      await controller.askAI(prompt);
      final response = controller.state.response;
      final message = response?.message ?? controller.state.message;
      _appendAIMessage(message.isEmpty ? 'Unable to contact AI.' : message);
      if (response == null || response.success == false) {
        controller.setError();
        _ref
            .read(aiChatStatusProvider.notifier)
            .setError(controller.state.message);
      }
    } on TimeoutException catch (exception) {
      final errorMessage =
          'Timeout error: ${exception.message ?? 'The request timed out.'}';
      _appendAIMessage(errorMessage);
      controller.setError();
      _ref.read(aiChatStatusProvider.notifier).setError(errorMessage);
    } on SocketException catch (exception) {
      final errorMessage =
          'Network error: ${exception.message}. Please check your connection.';
      _appendAIMessage(errorMessage);
      controller.setError();
      _ref.read(aiChatStatusProvider.notifier).setError(errorMessage);
    } catch (exception) {
      final errorMessage = _formatStreamError(exception);
      _appendAIMessage(errorMessage);
      controller.setError();
      _ref.read(aiChatStatusProvider.notifier).setError(errorMessage);
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
      final stream = OpenAIService.streamPrompt(prompt);
      _streamCompletionCompleter = Completer<void>();
      _activeSubscription = stream.listen(
        _appendStreamingToken,
        onError: _handleStreamingError,
        onDone: () {
          _handleStreamingComplete();
          _streamCompletionCompleter?.complete();
        },
        cancelOnError: false,
      );
      await _streamCompletionCompleter?.future;
    } on TimeoutException catch (exception) {
      _handleStreamingFailure(
        'Timeout error: ${exception.message ?? 'The stream timed out.'}',
        controller,
      );
    } on SocketException catch (exception) {
      _handleStreamingFailure(
        'Network error: ${exception.message}. Please check your connection.',
        controller,
      );
    } on OpenAIServiceException catch (exception) {
      _handleStreamingFailure(exception.message, controller);
    } catch (exception) {
      _handleStreamingFailure(_formatStreamError(exception), controller);
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

  void _replacePendingAIMessage(String text) {
    final index = _pendingAIMessageIndex;
    if (index == null || index < 0 || index >= state.length) {
      return;
    }

    final updatedMessage = state[index].copyWith(message: text);
    state = [
      ...state.sublist(0, index),
      updatedMessage,
      ...state.sublist(index + 1),
    ];
  }

  void _handleStreamingError(Object error, StackTrace? stackTrace) {
    _hasStreamingError = true;
    final errorMessage = _formatStreamError(error);
    _replacePendingAIMessage(errorMessage);
    _ref.read(aiChatStatusProvider.notifier).setError(errorMessage);
    _ref.read(aiProvider.notifier).setError();
    _pendingAIMessageIndex = null;
    _pendingAIMessage = '';
  }

  void _handleStreamingComplete() {
    if (_hasStreamingError) {
      return;
    }

    if (_pendingAIMessageIndex != null && _pendingAIMessage.isEmpty) {
      _replacePendingAIMessage('No response received from AI.');
    }

    _ref.read(aiChatStatusProvider.notifier).complete();
    _ref.read(aiProvider.notifier).setReady();
    _pendingAIMessageIndex = null;
    _pendingAIMessage = '';
  }

  void _handleStreamingFailure(String message, AIController controller) {
    _hasStreamingError = true;
    _replacePendingAIMessage(message);
    _ref.read(aiChatStatusProvider.notifier).setError(message);
    controller.setError();
    _pendingAIMessageIndex = null;
    _pendingAIMessage = '';
  }

  void _appendUserMessage(String message) {
    state = [
      ...state,
      AIMessage(message: message, isUser: true, timestamp: DateTime.now()),
    ];
  }

  void _appendAIMessage(String message) {
    state = [
      ...state,
      AIMessage(message: message, isUser: false, timestamp: DateTime.now()),
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
}

final aiChatProvider = StateNotifierProvider<AIChatController, List<AIMessage>>(
  (ref) => AIChatController(ref),
);
