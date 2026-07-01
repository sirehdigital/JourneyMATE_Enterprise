import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeymate_enterprise/core/models/ai_response.dart';
import 'package:journeymate_enterprise/core/providers/ai_chat_provider.dart';
import 'package:journeymate_enterprise/core/providers/ai_provider.dart';
import 'package:journeymate_enterprise/core/repositories/ai_repository.dart';
import 'package:journeymate_enterprise/core/services/openai_service.dart';

class FakeAIRepository extends AIRepository {
  FakeAIRepository(this.response);

  final AIResponse response;

  @override
  Future<AIResponse> askAI(String prompt) async {
    return response;
  }
}

void main() {
  late ProviderContainer container;
  late AIController aiController;
  late AIChatController chatController;

  setUp(() {
    OpenAIService.streamPromptOverride = null;
    container = ProviderContainer(
      overrides: [
        aiRepositoryProvider.overrideWithValue(
          FakeAIRepository(const AIResponse(message: 'ready', success: true)),
        ),
      ],
    );
    addTearDown(container.dispose);
    aiController = container.read(aiProvider.notifier);
    chatController = container.read(aiChatProvider.notifier);
  });

  tearDown(() {
    OpenAIService.streamPromptOverride = null;
  });

  test('streaming starts and completes', () async {
    OpenAIService.streamPromptOverride = (_) => Stream.value('token');

    final future = chatController.sendMessage(
      'Hello',
      aiController,
      useStreaming: true,
    );

    expect(chatController.isStreaming, isTrue);
    expect(chatController.isTyping, isTrue);

    await future;

    expect(chatController.isStreaming, isFalse);
    expect(chatController.isTyping, isFalse);
    expect(container.read(aiChatProvider).last.message, 'token');
  });

  test('streaming appends tokens to assistant message', () async {
    OpenAIService.streamPromptOverride = (_) =>
        Stream.fromIterable(['first ', 'second']);

    await chatController.sendMessage('Hello', aiController, useStreaming: true);

    final messages = container.read(aiChatProvider);
    expect(messages.last.message, 'first second');
    expect(messages.last.isUser, isFalse);
  });

  test(
    'stopStreaming cancels active stream and replaces placeholder',
    () async {
      final controller = StreamController<String>();
      OpenAIService.streamPromptOverride = (_) => controller.stream;

      final sendFuture = chatController.sendMessage(
        'Hello',
        aiController,
        useStreaming: true,
      );
      await Future<void>.delayed(Duration.zero);

      expect(chatController.isStreaming, isTrue);

      await chatController.stopStreaming();

      expect(chatController.isStreaming, isFalse);
      expect(
        container.read(aiChatProvider).last.message,
        'Response generation stopped.',
      );

      controller.close();
      await sendFuture;
    },
  );

  test('retryLastPrompt reuses last prompt and stream mode', () async {
    var callCount = 0;
    OpenAIService.streamPromptOverride = (_) {
      callCount += 1;
      return Stream.value(callCount == 1 ? 'first' : 'retry');
    };

    await chatController.sendMessage('hello', aiController, useStreaming: true);
    await chatController.retryLastPrompt();

    final messages = container.read(aiChatProvider);
    expect(messages.length, greaterThanOrEqualTo(4));
    expect(messages.last.message, 'retry');
  });

  test('final assistant message is not empty after streaming', () async {
    OpenAIService.streamPromptOverride = (_) => Stream.fromIterable(['final']);

    await chatController.sendMessage('Hello', aiController, useStreaming: true);

    expect(container.read(aiChatProvider).last.message, 'final');
  });

  test('typing state toggles during streaming', () async {
    final controller = StreamController<String>();
    OpenAIService.streamPromptOverride = (_) => controller.stream;

    final sendFuture = chatController.sendMessage(
      'Hello',
      aiController,
      useStreaming: true,
    );
    await Future<void>.delayed(Duration.zero);

    expect(chatController.isTyping, isTrue);

    controller.add('x');
    controller.close();
    await sendFuture;

    expect(chatController.isTyping, isFalse);
  });
}
