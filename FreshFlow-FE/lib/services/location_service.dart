import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/location.dart';

class LocationService {
  final SupabaseClient _client = SupabaseConfig.client;

  // Get all locations
  Future<List<Location>> getAllLocations() async {
    try {
      final response = await _client
          .from('locations')
          .select()
          .order('name', ascending: true);
      
      return (response as List)
          .map((json) => Location.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching locations: $e');
      rethrow;
    }
  }

  // Get location by ID
  Future<Location?> getLocationById(String id) async {
    try {
      final response = await _client
          .from('locations')
          .select()
          .eq('id', id)
          .single();
      
      return Location.fromJson(response);
    } catch (e) {
      print('Error fetching location: $e');
      rethrow;
    }
  }

  // Get locations by type
  Future<List<Location>> getLocationsByType(String type) async {
    try {
      final response = await _client
          .from('locations')
          .select()
          .eq('type', type)
          .order('name', ascending: true);
      
      return (response as List)
          .map((json) => Location.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching locations by type: $e');
      rethrow;
    }
  }

  // Search locations by name
  Future<List<Location>> searchLocations(String query) async {
    try {
      final response = await _client
          .from('locations')
          .select()
          .ilike('name', '%$query%')
          .order('name', ascending: true);
      
      return (response as List)
          .map((json) => Location.fromJson(json))
          .toList();
    } catch (e) {
      print('Error searching locations: $e');
      rethrow;
    }
  }

  // Get nearby locations (requires latitude/longitude)
  Future<List<Location>> getNearbyLocations({
    required double latitude,
    required double longitude,
    double radiusKm = 5.0,
  }) async {
    try {
      // Get all locations and filter by distance
      final allLocations = await getAllLocations();
      
      return allLocations.where((location) {
        if (location.latitude == null || location.longitude == null) {
          return false;
        }
        
        final distance = _calculateDistance(
          latitude,
          longitude,
          location.latitude!,
          location.longitude!,
        );
        
        return distance <= radiusKm;
      }).toList();
    } catch (e) {
      print('Error fetching nearby locations: $e');
      rethrow;
    }
  }

  // Calculate distance between two coordinates (Haversine formula)
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // km
    
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);
    
    final a = 
        (dLat / 2).sin() * (dLat / 2).sin() +
        _degreesToRadians(lat1).cos() * 
        _degreesToRadians(lat2).cos() *
        (dLon / 2).sin() * (dLon / 2).sin();
    
    final c = 2 * (a.sqrt()).asin();
    
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (3.14159265359 / 180);
  }

  // Create location (admin function)
  Future<Location> createLocation({
    required String name,
    String? address,
    double? latitude,
    double? longitude,
    String? type,
    String? description,
  }) async {
    try {
      final response = await _client
          .from('locations')
          .insert({
            'name': name,
            'address': address,
            'latitude': latitude,
            'longitude': longitude,
            'type': type,
            'description': description,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();
      
      return Location.fromJson(response);
    } catch (e) {
      print('Error creating location: $e');
      rethrow;
    }
  }

  // Update location (admin function)
  Future<Location> updateLocation({
    required String id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    String? type,
    String? description,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      if (name != null) updates['name'] = name;
      if (address != null) updates['address'] = address;
      if (latitude != null) updates['latitude'] = latitude;
      if (longitude != null) updates['longitude'] = longitude;
      if (type != null) updates['type'] = type;
      if (description != null) updates['description'] = description;

      final response = await _client
          .from('locations')
          .update(updates)
          .eq('id', id)
          .select()
          .single();
      
      return Location.fromJson(response);
    } catch (e) {
      print('Error updating location: $e');
      rethrow;
    }
  }
}
