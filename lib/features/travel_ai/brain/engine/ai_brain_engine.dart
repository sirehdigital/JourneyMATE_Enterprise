import '../models/ai_brain_request.dart';
import '../models/ai_brain_response.dart';
import '../models/ai_brain_status.dart';
import '../services/ai_brain_service.dart';

class AIBrainEngine {
  AIBrainEngine({AIBrainService? service})
    : _service = service ?? AIBrainService();

  final AIBrainService _service;

  AIBrainStatus initializeBrain() {
    return _runStatusOperation(
      operation: _AIBrainEngineOperation.initialize,
      action: _service.initialize,
    );
  }

  AIBrainResponse execute(AIBrainRequest request) {
    final validationError = _validateRequest(request);
    if (validationError != null) {
      return _buildFailureResponse(
        request: request,
        operation: _AIBrainEngineOperation.execute,
        error: validationError,
      );
    }

    try {
      _ensureReady();
      return _service.processRequest(request);
    } on Object catch (error, stackTrace) {
      return _buildFailureResponse(
        request: request,
        operation: _AIBrainEngineOperation.execute,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  AIBrainStatus getStatus() {
    return _runStatusOperation(
      operation: _AIBrainEngineOperation.status,
      action: _service.healthCheck,
    );
  }

  AIBrainStatus refresh() {
    return _runStatusOperation(
      operation: _AIBrainEngineOperation.refresh,
      action: _service.initialize,
    );
  }

  AIBrainStatus reset() {
    return _runStatusOperation(
      operation: _AIBrainEngineOperation.reset,
      action: _service.initialize,
    );
  }

  void _ensureReady() {
    final status = _service.healthCheck();
    if (!status.initialized) {
      _service.initialize();
    }
  }

  AIBrainStatus _runStatusOperation({
    required _AIBrainEngineOperation operation,
    required AIBrainStatus Function() action,
  }) {
    try {
      return action();
    } on Object catch (error, stackTrace) {
      return _buildFailureStatus(
        operation: operation,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  AIBrainEngineException? _validateRequest(AIBrainRequest request) {
    if (request.durationDays <= 0) {
      return const AIBrainEngineException(
        message: 'Duration days must be greater than zero.',
      );
    }
    if (request.travellers <= 0) {
      return const AIBrainEngineException(
        message: 'Travellers must be greater than zero.',
      );
    }
    if (request.budget < 0) {
      return const AIBrainEngineException(
        message: 'Budget cannot be negative.',
      );
    }
    return null;
  }

  AIBrainStatus _buildFailureStatus({
    required _AIBrainEngineOperation operation,
    required Object error,
    StackTrace? stackTrace,
  }) {
    return AIBrainStatus(
      initialized: false,
      knowledgeReady: false,
      memoryReady: false,
      plannerReady: false,
      reasoningReady: false,
      recommendationReady: false,
      personalizationReady: false,
      explainableReady: false,
      metadata: _buildErrorMetadata(
        operation: operation,
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }

  AIBrainResponse _buildFailureResponse({
    required AIBrainRequest request,
    required _AIBrainEngineOperation operation,
    required Object error,
    StackTrace? stackTrace,
  }) {
    return AIBrainResponse(
      recommendationSummary: 'AI Brain recommendation flow failed.',
      travelPlanSummary: 'AI Brain planner flow failed.',
      reasoningSummary: 'AI Brain reasoning flow failed.',
      explanationSummary: 'AI Brain explanation flow failed.',
      confidence: 0,
      generatedAt: DateTime.now(),
      metadata: <String, dynamic>{
        'destination': request.destination,
        ..._buildErrorMetadata(
          operation: operation,
          error: error,
          stackTrace: stackTrace,
        ),
      },
    );
  }

  Map<String, dynamic> _buildErrorMetadata({
    required _AIBrainEngineOperation operation,
    required Object error,
    StackTrace? stackTrace,
  }) {
    return <String, dynamic>{
      'operation': operation.name,
      'errorType': error.runtimeType.toString(),
      'error': _errorMessage(error),
      if (stackTrace != null) 'stackTrace': stackTrace.toString(),
    };
  }

  String _errorMessage(Object error) {
    if (error is AIBrainEngineException) {
      return error.message;
    }

    final message = error.toString().trim();
    return message.isEmpty ? error.runtimeType.toString() : message;
  }
}

enum _AIBrainEngineOperation { initialize, execute, status, refresh, reset }

class AIBrainEngineException implements Exception {
  const AIBrainEngineException({required this.message});

  final String message;

  @override
  String toString() => message;
}
