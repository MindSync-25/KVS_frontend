import 'package:supabase_flutter/supabase_flutter.dart';

/// Call Supabase.client anywhere: `supabase.from('users')...`
SupabaseClient get supabase => Supabase.instance.client;
