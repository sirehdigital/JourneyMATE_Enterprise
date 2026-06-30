import '../../../../core/models/ai_response.dart';

/// ===============================================================
/// JourneyMATE Enterprise
/// AI Service (Mock)
/// Sprint JM-07.03.04
/// ===============================================================
///
/// Mock AI Engine
/// Future Upgrade:
/// • Gemini Live API
/// • OpenAI
/// • Claude
/// • DeepSeek
/// • JourneyMATE AI Router
/// ===============================================================

class AIService {
  AIService._();

  //--------------------------------------------------------------
  // General AI Prompt
  //--------------------------------------------------------------

  static Future<AIResponse> sendPrompt(String prompt) async {
    await Future.delayed(const Duration(seconds: 2));

    return AIResponse(
      message: _generateResponse(prompt),
      timestamp: DateTime.now(),
    );
  }

  //--------------------------------------------------------------
  // Generate Trip
  //--------------------------------------------------------------

  static Future<AIResponse> generateTrip(String destination) async {
    await Future.delayed(const Duration(seconds: 2));

    return AIResponse(
      message:
          'Here is your suggested itinerary for $destination.\n\n'
          '📍 Day 1 - Arrival & City Tour\n'
          '📍 Day 2 - Food & Culture Exploration\n'
          '📍 Day 3 - Shopping & Departure',
      timestamp: DateTime.now(),
    );
  }

  //--------------------------------------------------------------
  // Recommend Hotel
  //--------------------------------------------------------------

  static Future<AIResponse> recommendHotel(String city) async {
    await Future.delayed(const Duration(seconds: 2));

    return AIResponse(
      message:
          'Recommended hotels in $city:\n\n'
          '🏨 Journey Hotel Premium\n'
          '🏨 Grand Riverside Hotel\n'
          '🏨 Smart Budget Inn',
      timestamp: DateTime.now(),
    );
  }

  //--------------------------------------------------------------
  // Recommend Flight
  //--------------------------------------------------------------

  static Future<AIResponse> recommendFlight(String route) async {
    await Future.delayed(const Duration(seconds: 2));

    return AIResponse(
      message:
          'Best available flight for:\n$route\n\n'
          '✈ Estimated Fare: RM129',
      timestamp: DateTime.now(),
    );
  }

  //--------------------------------------------------------------
  // Budget Planner
  //--------------------------------------------------------------

  static Future<AIResponse> generateBudget(String destination) async {
    await Future.delayed(const Duration(seconds: 2));

    return AIResponse(
      message:
          'Estimated travel budget for $destination\n\n'
          '✈ Flight : RM129\n'
          '🏨 Hotel : RM180\n'
          '🍽 Food : RM90\n'
          '🚗 Transport : RM60\n'
          '💰 Total : RM459',
      timestamp: DateTime.now(),
    );
  }

  //--------------------------------------------------------------
  // Health Check
  //--------------------------------------------------------------

  static Future<bool> ping() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  //--------------------------------------------------------------
  // Mock AI Brain
  //--------------------------------------------------------------

  static String _generateResponse(String prompt) {
    final text = prompt.toLowerCase();

    if (text.contains('kelantan')) {
      return 'Kelantan is famous for its rich culture, delicious local cuisine, beautiful beaches and warm hospitality. I can also prepare a complete travel itinerary for you.';
    }

    if (text.contains('hotel')) {
      return 'I found several hotel recommendations based on your preferred location and budget.';
    }

    if (text.contains('flight')) {
      return 'I can compare flight prices and recommend the most suitable option for your trip.';
    }

    if (text.contains('budget')) {
      return 'I can estimate your travel budget including flights, accommodation, food and transportation.';
    }

    if (text.contains('trip') || text.contains('itinerary')) {
      return 'I can generate a personalised travel itinerary based on your destination, travel dates and interests.';
    }

    return 'Hello Abang 👋\n\n'
        'I received your message:\n'
        '"$prompt"\n\n'
        'How else can I assist with your JourneyMATE travel planning today?';
  }
}
