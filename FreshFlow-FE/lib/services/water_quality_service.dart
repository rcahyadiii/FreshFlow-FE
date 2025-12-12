import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/water_quality_reading.dart';

class WaterQualityService {
  final SupabaseClient _client = SupabaseConfig.client;

  // Get all water quality readings
  Future<List<WaterQualityReading>> getAllReadings() async {
    try {
      final response = await _client
          .from('water_quality_readings')
          .select()
          .order('timestamp', ascending: false);
      
      return (response as List)
          .map((json) => WaterQualityReading.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching water quality readings: $e');
      rethrow;
    }
  }

  // Get readings by location
  Future<List<WaterQualityReading>> getReadingsByLocation(String locationId) async {
    try {
      final response = await _client
          .from('water_quality_readings')
          .select()
          .eq('location_id', locationId)
          .order('timestamp', ascending: false);
      
      return (response as List)
          .map((json) => WaterQualityReading.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching readings by location: $e');
      rethrow;
    }
  }

  // Get readings by device
  Future<List<WaterQualityReading>> getReadingsByDevice(String deviceId) async {
    try {
      final response = await _client
          .from('water_quality_readings')
          .select()
          .eq('device_id', deviceId)
          .order('timestamp', ascending: false);
      
      return (response as List)
          .map((json) => WaterQualityReading.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching readings by device: $e');
      rethrow;
    }
  }

  // Get latest reading for a location
  Future<WaterQualityReading?> getLatestReadingForLocation(String locationId) async {
    try {
      final response = await _client
          .from('water_quality_readings')
          .select()
          .eq('location_id', locationId)
          .order('timestamp', ascending: false)
          .limit(1)
          .single();
      
      return WaterQualityReading.fromJson(response);
    } catch (e) {
      print('Error fetching latest reading: $e');
      return null;
    }
  }

  // Get readings within date range
  Future<List<WaterQualityReading>> getReadingsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    String? locationId,
  }) async {
    try {
      var query = _client
          .from('water_quality_readings')
          .select()
          .gte('timestamp', startDate.toIso8601String())
          .lte('timestamp', endDate.toIso8601String());

      if (locationId != null) {
        query = query.eq('location_id', locationId);
      }

      final response = await query.order('timestamp', ascending: false);
      
      return (response as List)
          .map((json) => WaterQualityReading.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching readings by date range: $e');
      rethrow;
    }
  }

  // Get readings by quality status
  Future<List<WaterQualityReading>> getReadingsByStatus(String status) async {
    try {
      final response = await _client
          .from('water_quality_readings')
          .select()
          .eq('quality_status', status)
          .order('timestamp', ascending: false);
      
      return (response as List)
          .map((json) => WaterQualityReading.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching readings by status: $e');
      rethrow;
    }
  }

  // Subscribe to real-time water quality updates
  RealtimeChannel subscribeToReadings(Function(WaterQualityReading) onInsert) {
    return _client
        .channel('public:water_quality_readings')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'water_quality_readings',
          callback: (payload) {
            final reading = WaterQualityReading.fromJson(payload.newRecord);
            onInsert(reading);
          },
        )
        .subscribe();
  }

  // Get average readings for a location
  Future<Map<String, double>> getAverageReadings(String locationId) async {
    try {
      final readings = await getReadingsByLocation(locationId);
      
      if (readings.isEmpty) {
        return {};
      }

      double avgPh = 0, avgTurbidity = 0, avgTds = 0, avgTemp = 0, avgDo = 0;
      int count = readings.length;

      for (var reading in readings) {
        avgPh += reading.ph ?? 0;
        avgTurbidity += reading.turbidity ?? 0;
        avgTds += reading.tds ?? 0;
        avgTemp += reading.temperature ?? 0;
        avgDo += reading.dissolvedOxygen ?? 0;
      }

      return {
        'ph': avgPh / count,
        'turbidity': avgTurbidity / count,
        'tds': avgTds / count,
        'temperature': avgTemp / count,
        'dissolved_oxygen': avgDo / count,
      };
    } catch (e) {
      print('Error calculating averages: $e');
      rethrow;
    }
  }
}
