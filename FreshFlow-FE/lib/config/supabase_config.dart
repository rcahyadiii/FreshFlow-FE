import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static SupabaseClient get client => Supabase.instance.client;
  
  // Helper method to check if user is authenticated
  static bool get isAuthenticated => client.auth.currentUser != null;
  
  // Get current user
  static User? get currentUser => client.auth.currentUser;
  
  // Auth stream for listening to auth state changes
  static Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;
}
