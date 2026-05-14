import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/issues_datasource.dart';
import '../../domain/entities/issue.dart';

// ─── State ───────────────────────────────────────────────────────────────────

class IssuesState {
  final bool isSubmitting;
  final String? error;
  final Issue? lastSubmitted;
  final List<Issue> myIssues;

  const IssuesState({
    this.isSubmitting = false,
    this.error,
    this.lastSubmitted,
    this.myIssues = const [],
  });

  IssuesState copyWith({
    bool? isSubmitting,
    String? error,
    Issue? lastSubmitted,
    List<Issue>? myIssues,
  }) =>
      IssuesState(
        isSubmitting:  isSubmitting  ?? this.isSubmitting,
        error:         error,
        lastSubmitted: lastSubmitted ?? this.lastSubmitted,
        myIssues:      myIssues     ?? this.myIssues,
      );
}

// ─── Notifier ────────────────────────────────────────────────────────────────

class IssuesNotifier extends Notifier<IssuesState> {
  late final IssuesDatasource _ds;

  @override
  IssuesState build() {
    _ds = IssuesDatasource();
    return const IssuesState();
  }

  Future<bool> submitIssue({
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
    state = state.copyWith(isSubmitting: true);
    try {
      final issue = await _ds.submitIssue(
        reporterId:  reporterId,
        type:        type,
        title:       title,
        description: description,
        district:    district,
        taluk:       taluk,
        ward:        ward,
        latitude:    latitude,
        longitude:   longitude,
        mediaFiles:  mediaFiles,
        voiceNote:   voiceNote,
      );
      state = state.copyWith(
        isSubmitting:  false,
        lastSubmitted: issue,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<void> loadMyIssues(String reporterId) async {
    try {
      final issues = await _ds.fetchMyIssues(reporterId);
      state = state.copyWith(myIssues: issues);
    } catch (_) {}
  }
}

// ─── Provider ────────────────────────────────────────────────────────────────

final issuesProvider =
    NotifierProvider<IssuesNotifier, IssuesState>(IssuesNotifier.new);
