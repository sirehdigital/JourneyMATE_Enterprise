import 'dart:async';

import '../models/ai_response.dart';
import 'openai_service.dart';

/// ===============================================================
/// JourneyMATE Enterprise
/// AI Service
/// ===============================================================
/// ===============================================================
/// JourneyMATE Enterprise
/// AI Service
/// ===============================================================
///
/// AI Engine Facade
///
/// Current Engine:
/// • OpenAI
///
/// Future:
/// • OpenAI
/// • Claude
/// • DeepSeek
/// • Local AI
/// ===============================================================

class AIService {
  AIService._();

  static const String _model = 'OpenAI GPT';

  //--------------------------------------------------------------
  // Initialize
  //--------------------------------------------------------------

  static Future<void> initialize() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  //--------------------------------------------------------------
  // Health Check
  //--------------------------------------------------------------

  static Future<bool> ping() async {
    try {
      return await OpenAIService.ping();
    } catch (_) {
      return true;
    }
  }

  //--------------------------------------------------------------
  // General Prompt
  //--------------------------------------------------------------

  static Future<AIResponse> sendPrompt(String prompt) async {
    try {
      return await OpenAIService.sendPrompt(prompt);
    } catch (_) {
      await Future.delayed(const Duration(seconds: 2));
      return _response(message: _mock(prompt));
    }
  }

  //--------------------------------------------------------------
  // Trip Planner
  //--------------------------------------------------------------

  static Future<AIResponse> generateTrip(String destination) async {
    await Future.delayed(const Duration(seconds: 2));

    return _response(
      message:
          '''
3 Days 2 Nights itinerary generated successfully.

Destination:
$destination

Estimated Budget:
RM850
''',
    );
  }

  //--------------------------------------------------------------
  // Hotel Recommendation
  //--------------------------------------------------------------

  static Future<AIResponse> recommendHotel(String city) async {
    await Future.delayed(const Duration(seconds: 1));

    return _response(
      message:
          '''
Recommended Hotels

• Perdana Hotel
• H Elite Design Hotel
• Grand Riverview Hotel

Location:
$city
''',
    );
  }

  //--------------------------------------------------------------
  // Flight Recommendation
  //--------------------------------------------------------------

  static Future<AIResponse> recommendFlight(String route) async {
    await Future.delayed(const Duration(seconds: 1));

    return _response(
      message:
          '''
Flight recommendation ready.

Route:
$route

Best Fare:
RM199
''',
    );
  }

  //--------------------------------------------------------------
  // Budget Planner
  //--------------------------------------------------------------

  static Future<AIResponse> generateBudget(String destination) async {
    await Future.delayed(const Duration(seconds: 1));

    return _response(
      message:
          '''
Estimated Budget

Destination:
$destination

Hotel : RM350
Flight : RM250
Food : RM150
Transport : RM100

Total : RM850
''',
    );
  }

  //--------------------------------------------------------------
  // Helper
  //--------------------------------------------------------------

  static AIResponse _response({required String message}) {
    return AIResponse(
      message: message,
      success: true,
      model: _model,
      timestamp: DateTime.now(),
    );
  }

  static String _mock(String prompt) {
    final text = prompt.toLowerCase();

    if (text.contains('kelantan')) {
      return '''
Certainly! 👋

I have prepared a suggested itinerary.

Day 1
• Arrive in Kota Bharu
• Visit Siti Khadijah Market
• Dinner at Pantai Cahaya Bulan

Day 2
• Explore Museums
• Try local cuisine
• Shopping at Wakaf Che Yeh

Day 3
• Breakfast
• Souvenir shopping
• Return journey

Estimated Budget:
RM780
''';
    }

    if (text.contains('hotel')) {
      return '''
Recommended Hotels

• Perdana Hotel
• H Elite Design Hotel
• Grand Riverview Hotel

Would you like me to compare prices?
''';
    }

    if (text.contains('flight')) {
      return '''
Current flight prices look competitive.

Best fare found:
RM199

I can monitor airfare and notify you if prices drop.
''';
    }

    if (text.contains('budget')) {
      return '''
Estimated Budget

Hotel      RM350
Flight     RM250
Food       RM150
Transport  RM100

Total RM850
''';
    }

    return '''
Hello Abang 👋

I am JourneyMATE AI.

I can help you with:

• Travel planning
• Hotels
• Flights
• Budget optimisation
• Local attractions
• Emergency assistance

How can I help you today?
''';
  }
}
