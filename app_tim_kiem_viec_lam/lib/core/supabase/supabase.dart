import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseBase {
  static const String APIKEY =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF5ZHRscnppZG56dnlmanp0bXpwIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzMzNDcwMzgsImV4cCI6MTk4ODkyMzAzOH0.aTXPLdyA_lbEOnYKi2GfyKOJ08dySSZGlvjhZcJRNRw";

  static const String APIURL = "https://aydtlrzidnzvyfjztmzp.supabase.co";

  static SupabaseClient supabaseClient = SupabaseClient(APIURL, APIKEY);
}
