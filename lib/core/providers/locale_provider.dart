import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Active locale for the app.
/// Defaults to Kannada ('kn') — the primary language of Karnataka Vijaya Sena.
/// Profile language toggle writes to this via [localeProvider.notifier].state.
final localeProvider = StateProvider<Locale>((ref) => const Locale('kn'));
