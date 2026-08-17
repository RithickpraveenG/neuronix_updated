import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_config.dart';

/// Production API client connecting Flutter UI screens to the FastAPI backend micro-services.
class ApiService {
  String get _baseUrl => ApiConfig.backendBaseUrl;

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode != 200) {
      throw Exception('Login failed: ${response.body}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> register(String email, String password, String role) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password, 'role': role}),
    );

    if (response.statusCode != 200) {
      throw Exception('Registration failed: ${response.body}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Send medical report text for OCR normalization, spaCy NLP entity extraction, and ML analysis.
  Future<Map<String, dynamic>> analyzeReport(String reportText) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/ai/analyze-report'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'report_text': reportText}),
    );

    if (response.statusCode != 200) {
      throw Exception('Analysis failed: ${response.body}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Run Scikit-learn disease prediction classifier with confidence scores and department referral.
  Future<Map<String, dynamic>> symptomCheck(List<String> symptoms) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/ai/symptom-check'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'symptoms': symptoms}),
    );

    if (response.statusCode != 200) {
      throw Exception('Symptom evaluation failed: ${response.body}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Request comprehensive Clinical Decision Support (CDS) assessment.
  Future<Map<String, dynamic>> getClinicalDecisionSupport({
    required String reportText,
    required List<String> symptoms,
    Map<String, dynamic>? patientHistory,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/ai/cds'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'report_text': reportText,
        'symptoms': symptoms,
        'patient_history': patientHistory ?? {},
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Clinical Decision Support evaluation failed: ${response.body}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<List<dynamic>> getPatients() async {
    final response = await http.get(Uri.parse('$_baseUrl/patients/'));
    if (response.statusCode != 200) {
      throw Exception('Unable to fetch patients');
    }
    return jsonDecode(response.body) as List<dynamic>;
  }

  Future<List<dynamic>> getDoctors() async {
    final response = await http.get(Uri.parse('$_baseUrl/doctors/'));
    if (response.statusCode != 200) {
      throw Exception('Unable to fetch doctors');
    }
    return jsonDecode(response.body) as List<dynamic>;
  }

  Future<List<dynamic>> getAppointments() async {
    final response = await http.get(Uri.parse('$_baseUrl/appointments/'));
    if (response.statusCode != 200) {
      throw Exception('Unable to fetch appointments');
    }
    return jsonDecode(response.body) as List<dynamic>;
  }

  Future<List<dynamic>> getNotifications() async {
    final response = await http.get(Uri.parse('$_baseUrl/notifications/'));
    if (response.statusCode != 200) {
      throw Exception('Unable to fetch notifications');
    }
    return jsonDecode(response.body) as List<dynamic>;
  }

  Future<Map<String, dynamic>> createAppointment(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/appointments/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create appointment');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
