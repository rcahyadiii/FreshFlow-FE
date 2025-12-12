import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/profile.dart';

class ProfileService {
  final SupabaseClient _client = SupabaseConfig.client;

  // Get current user's profile
  Future<Profile?> getCurrentProfile() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return null;

      final response = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      
      return Profile.fromJson(response);
    } catch (e) {
      print('Error fetching current profile: $e');
      rethrow;
    }
  }

  // Get profile by ID
  Future<Profile?> getProfileById(String id) async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', id)
          .single();
      
      return Profile.fromJson(response);
    } catch (e) {
      print('Error fetching profile: $e');
      rethrow;
    }
  }

  // Update profile
  Future<Profile> updateProfile({
    required String id,
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      if (fullName != null) updates['full_name'] = fullName;
      if (phone != null) updates['phone'] = phone;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      final response = await _client
          .from('profiles')
          .update(updates)
          .eq('id', id)
          .select()
          .single();
      
      return Profile.fromJson(response);
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  // Get all profiles (admin function)
  Future<List<Profile>> getAllProfiles() async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .order('created_at', ascending: false);
      
      return (response as List)
          .map((json) => Profile.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching profiles: $e');
      rethrow;
    }
  }

  // Search profiles by name or email
  Future<List<Profile>> searchProfiles(String query) async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .or('full_name.ilike.%$query%,email.ilike.%$query%');
      
      return (response as List)
          .map((json) => Profile.fromJson(json))
          .toList();
    } catch (e) {
      print('Error searching profiles: $e');
      rethrow;
    }
  }
}
