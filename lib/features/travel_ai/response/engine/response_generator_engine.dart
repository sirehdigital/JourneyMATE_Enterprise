import '../models/response_document.dart';
import '../models/response_theme.dart';
import '../services/response_generator_service.dart';

class ResponseGeneratorEngine {
  ResponseGeneratorEngine({ResponseGeneratorService? service})
    : _service = service ?? ResponseGeneratorService();

  final ResponseGeneratorService _service;

  ResponseDocument generate({
    String title = 'JourneyMATE AI Brain',
    String summary = '',
    String recommendationSummary = '',
    String travelPlanSummary = '',
    String reasoningSummary = '',
    String explanationSummary = '',
    double confidence = 0,
    ResponseTheme? theme,
    DateTime? generatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return _service.generateDocument(
      title: title,
      summary: summary,
      recommendationSummary: recommendationSummary,
      travelPlanSummary: travelPlanSummary,
      reasoningSummary: reasoningSummary,
      explanationSummary: explanationSummary,
      confidence: confidence,
      theme: theme,
      generatedAt: generatedAt,
      metadata: metadata,
    );
  }

  String generateMarkdown({
    String title = 'JourneyMATE AI Brain',
    String summary = '',
    String recommendationSummary = '',
    String travelPlanSummary = '',
    String reasoningSummary = '',
    String explanationSummary = '',
    double confidence = 0,
    ResponseTheme? theme,
    DateTime? generatedAt,
    Map<String, dynamic>? metadata,
  }) {
    final document = generate(
      title: title,
      summary: summary,
      recommendationSummary: recommendationSummary,
      travelPlanSummary: travelPlanSummary,
      reasoningSummary: reasoningSummary,
      explanationSummary: explanationSummary,
      confidence: confidence,
      theme: theme,
      generatedAt: generatedAt,
      metadata: metadata,
    );
    return _service.exportMarkdown(document);
  }

  String generatePlainText({
    String title = 'JourneyMATE AI Brain',
    String summary = '',
    String recommendationSummary = '',
    String travelPlanSummary = '',
    String reasoningSummary = '',
    String explanationSummary = '',
    double confidence = 0,
    ResponseTheme? theme,
    DateTime? generatedAt,
    Map<String, dynamic>? metadata,
  }) {
    final document = generate(
      title: title,
      summary: summary,
      recommendationSummary: recommendationSummary,
      travelPlanSummary: travelPlanSummary,
      reasoningSummary: reasoningSummary,
      explanationSummary: explanationSummary,
      confidence: confidence,
      theme: theme,
      generatedAt: generatedAt,
      metadata: metadata,
    );
    return _service.exportPlainText(document);
  }

  String generateSummary({
    String summary = '',
    String recommendationSummary = '',
    String travelPlanSummary = '',
    double confidence = 0,
  }) {
    return _service.generateTravelSummary(
      summary: summary,
      recommendationSummary: recommendationSummary,
      travelPlanSummary: travelPlanSummary,
      confidence: confidence,
    );
  }
}
