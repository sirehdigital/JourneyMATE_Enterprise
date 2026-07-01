import '../models/ai_response.dart';
import '../services/openai_service.dart';

/// ===============================================================
/// JourneyMATE Enterprise
/// AI Repository
/// ===============================================================
///
/// Repository Layer
///
/// Responsibilities:
/// • Bridge UI ↔ OpenAI Service
/// • Future Cache Layer
/// • AI Provider Selection
/// • Business Logic
/// ===============================================================

class AIRepository {
  AIRepository();

  //--------------------------------------------------------------
  // General AI Prompt
  //--------------------------------------------------------------

  Future<AIResponse> askAI(String prompt) async {
    return OpenAIService.sendPrompt(prompt);
  }

  //--------------------------------------------------------------
  // Trip Planner
  //--------------------------------------------------------------

  Future<AIResponse> generateTrip(String destination) async {
    return OpenAIService.generateTrip(destination);
  }

  //--------------------------------------------------------------
  // Hotel Recommendation
  //--------------------------------------------------------------

  Future<AIResponse> recommendHotel(String city) async {
    return OpenAIService.recommendHotel(city);
  }

  //--------------------------------------------------------------
  // Flight Recommendation
  //--------------------------------------------------------------

  Future<AIResponse> recommendFlight(String route) async {
    return OpenAIService.recommendFlight(route);
  }

  //--------------------------------------------------------------
  // Budget Planner
  //--------------------------------------------------------------

  Future<AIResponse> generateBudget(String destination) async {
    return OpenAIService.generateBudget(destination);
  }

  //--------------------------------------------------------------
  // Health Check
  //--------------------------------------------------------------

  Future<bool> ping() async {
    return OpenAIService.ping();
  }
}
