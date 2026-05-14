import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/supabase_client.dart';
import '../../../../core/utils/logger.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../../domain/entities/issue.dart';

class IssuesDatasource {
  final _supa = supabase;

  Future<Issue> submitIssue({
    required String reporterId,
    required IssueType type,
    required String title,
    required String description,
    required String district,
    required String taluk,
    required String ward,
    double? latitude,
    double? longitude,
    List<File> mediaFiles = const [],
    File? voiceNote,
  }) async {
    // Upload media files
    final List<String> mediaUrls = [];
    for (final file in mediaFiles) {
      final path = 'issues/$reporterId/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      await _supa.storage.from('media').upload(path, file);
      final url = _supa.storage.from('media').getPublicUrl(path);
      mediaUrls.add(url);
    }

    // Upload voice note
    String? voiceUrl;
    if (voiceNote != null) {
      final path = 'issues/$reporterId/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _supa.storage.from('media').upload(path, voiceNote);
      voiceUrl = _supa.storage.from('media').getPublicUrl(path);
    }

    final row = {
      'reporter_id':  reporterId,
      'issue_type':   type.dbValue,
      'title':        title,
      'description':  description,
      'district':     district,
      'taluk':        taluk,
      'ward':         ward,
      if (latitude  != null) 'latitude':  latitude,
      if (longitude != null) 'longitude': longitude,
      'media_urls':   mediaUrls,
      if (voiceUrl  != null) 'voice_note_url': voiceUrl,
      'status': 'open',
    };

    final res = await _supa.from('issues').insert(row).select().single();
    // ignore: avoid_print
    print('Issue submitted: ${res['id']}');
    return _fromMap(res);
  }

  Future<List<Issue>> fetchIssuesByDistrict(String district) async {
    final res = await _supa
        .from('issues')
        .select()
        .eq('district', district)
        .order('created_at', ascending: false)
        .limit(50);
    return (res as List).map((m) => _fromMap(m)).toList();
  }

  Future<List<Issue>> fetchMyIssues(String reporterId) async {
    final res = await _supa
        .from('issues')
        .select()
        .eq('reporter_id', reporterId)
        .order('created_at', ascending: false);
    return (res as List).map((m) => _fromMap(m)).toList();
  }

  Issue _fromMap(Map<String, dynamic> m) => Issue(
        id:           m['id'] as String,
        reporterId:   m['reporter_id'] as String,
        type:         IssueTypeX.fromDb(m['issue_type'] as String),
        title:        m['title'] as String,
        description:  m['description'] as String? ?? '',
        district:     m['district'] as String? ?? '',
        taluk:        m['taluk'] as String? ?? '',
        ward:         m['ward'] as String? ?? '',
        latitude:     (m['latitude'] as num?)?.toDouble(),
        longitude:    (m['longitude'] as num?)?.toDouble(),
        mediaUrls:    List<String>.from(m['media_urls'] ?? []),
        voiceNoteUrl: m['voice_note_url'] as String?,
        status:       IssueStatusX.fromDb(m['status'] as String? ?? 'open'),
        upvotes:      m['upvotes'] as int? ?? 0,
        createdAt:    DateTime.parse(m['created_at'] as String),
      );
}
