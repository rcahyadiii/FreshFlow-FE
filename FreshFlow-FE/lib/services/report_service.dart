import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/report.dart';

class ReportService {
  final SupabaseClient _client = SupabaseConfig.client;

  // Create a new report
  Future<Report> createReport({
    required String title,
    required String description,
    String? locationId,
    String? category,
    String? priority,
    List<String>? imageUrls,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      
      final response = await _client
          .from('reports')
          .insert({
            'user_id': userId,
            'title': title,
            'description': description,
            'location_id': locationId,
            'category': category,
            'priority': priority ?? 'medium',
            'status': 'pending',
            'image_urls': imageUrls,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();
      
      return Report.fromJson(response);
    } catch (e) {
      print('Error creating report: $e');
      rethrow;
    }
  }

  // Get all reports
  Future<List<Report>> getAllReports() async {
    try {
      final response = await _client
          .from('reports')
          .select()
          .order('created_at', ascending: false);
      
      return (response as List)
          .map((json) => Report.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching reports: $e');
      rethrow;
    }
  }

  // Get reports by user
  Future<List<Report>> getMyReports() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await _client
          .from('reports')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      
      return (response as List)
          .map((json) => Report.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching user reports: $e');
      rethrow;
    }
  }

  // Get report by ID
  Future<Report?> getReportById(String id) async {
    try {
      final response = await _client
          .from('reports')
          .select()
          .eq('id', id)
          .single();
      
      return Report.fromJson(response);
    } catch (e) {
      print('Error fetching report: $e');
      rethrow;
    }
  }

  // Update report status
  Future<Report> updateReportStatus(String id, String status) async {
    try {
      final response = await _client
          .from('reports')
          .update({
            'status': status,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id)
          .select()
          .single();
      
      return Report.fromJson(response);
    } catch (e) {
      print('Error updating report status: $e');
      rethrow;
    }
  }

  // Get reports by status
  Future<List<Report>> getReportsByStatus(String status) async {
    try {
      final response = await _client
          .from('reports')
          .select()
          .eq('status', status)
          .order('created_at', ascending: false);
      
      return (response as List)
          .map((json) => Report.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching reports by status: $e');
      rethrow;
    }
  }

  // Delete report
  Future<void> deleteReport(String id) async {
    try {
      await _client
          .from('reports')
          .delete()
          .eq('id', id);
    } catch (e) {
      print('Error deleting report: $e');
      rethrow;
    }
  }

  // Subscribe to real-time report updates
  RealtimeChannel subscribeToReports(Function(Report) onInsert) {
    return _client
        .channel('public:reports')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'reports',
          callback: (payload) {
            final report = Report.fromJson(payload.newRecord);
            onInsert(report);
          },
        )
        .subscribe();
  }
}
