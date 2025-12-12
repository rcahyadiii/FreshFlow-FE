import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

/// Example service class demonstrating CRUD operations with Supabase
/// Replace 'your_table_name' with your actual table name
class DatabaseService {
  final SupabaseClient _client = SupabaseConfig.client;

  // CREATE - Insert data
  Future<Map<String, dynamic>?> insertData({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _client
          .from(table)
          .insert(data)
          .select()
          .single();
      return response;
    } catch (e) {
      print('Error inserting data: $e');
      rethrow;
    }
  }

  // READ - Fetch all records
  Future<List<Map<String, dynamic>>> fetchAll(String table) async {
    try {
      final response = await _client
          .from(table)
          .select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching data: $e');
      rethrow;
    }
  }

  // READ - Fetch single record by ID
  Future<Map<String, dynamic>?> fetchById({
    required String table,
    required String id,
  }) async {
    try {
      final response = await _client
          .from(table)
          .select()
          .eq('id', id)
          .single();
      return response;
    } catch (e) {
      print('Error fetching record: $e');
      rethrow;
    }
  }

  // UPDATE - Update record
  Future<Map<String, dynamic>?> updateData({
    required String table,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _client
          .from(table)
          .update(data)
          .eq('id', id)
          .select()
          .single();
      return response;
    } catch (e) {
      print('Error updating data: $e');
      rethrow;
    }
  }

  // DELETE - Delete record
  Future<void> deleteData({
    required String table,
    required String id,
  }) async {
    try {
      await _client
          .from(table)
          .delete()
          .eq('id', id);
    } catch (e) {
      print('Error deleting data: $e');
      rethrow;
    }
  }

  // SEARCH - Filter records
  Future<List<Map<String, dynamic>>> searchData({
    required String table,
    required String column,
    required String searchTerm,
  }) async {
    try {
      final response = await _client
          .from(table)
          .select()
          .ilike(column, '%$searchTerm%');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error searching data: $e');
      rethrow;
    }
  }

  // REAL-TIME - Subscribe to changes
  RealtimeChannel subscribeToTable({
    required String table,
    required void Function(PostgresChangePayload) onData,
  }) {
    return _client
        .channel('public:$table')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: table,
          callback: onData,
        )
        .subscribe();
  }
}
