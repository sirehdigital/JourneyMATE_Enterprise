import '../models/ai_response.dart';
import '../services/ai_service.dart';

/// ===============================================================
/// JourneyMATE Enterprise
/// AI Repository
/// ---------------------------------------------------------------
/// Repository layer between UI and AI Service.
///
/// Responsibilities:
/// • Business Logic
/// • AI Orchestration
/// • Future Cache Layer
/// • Multiple AI Providers
/// ===============================================================

class AIRepository {
  AIRepository();

  //--------------------------------------------------------------
  // General Prompt
  //--------------------------------------------------------------

  Future<AIResponse> askAI(String prompt) async {
    return AIService.sendPrompt(prompt);
  }

  //--------------------------------------------------------------
  // Trip Planner
  //--------------------------------------------------------------

  Future<AIResponse> generateTrip(String destination) async {
    return AIService.generateTrip(destination);
  }

  //--------------------------------------------------------------
  // Hotel Recommendation
  //--------------------------------------------------------------

  Future<AIResponse> recommendHotel(String city) async {
    return AIService.recommendHotel(city);
  }

  //--------------------------------------------------------------
  // Flight Recommendation
  //--------------------------------------------------------------

  Future<AIResponse> recommendFlight(String route) async {
    return AIService.recommendFlight(route);
  }

  //--------------------------------------------------------------
  // Budget Planner
  //--------------------------------------------------------------

  Future<AIResponse> generateBudget(String destination) async {
    return AIService.generateBudget(destination);
  }

  //--------------------------------------------------------------
  // AI Health Check
  //--------------------------------------------------------------

  Future<bool> ping() async {
    return AIService.ping();
  }
}
