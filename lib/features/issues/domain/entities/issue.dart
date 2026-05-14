enum IssueType { bribery, road, water, hospital, school, electricity, farmer, other }

extension IssueTypeX on IssueType {
  String get label {
    const m = {
      IssueType.bribery:     'Bribery / Corruption',
      IssueType.road:        'Road / Infrastructure',
      IssueType.water:       'Water Supply',
      IssueType.hospital:    'Hospital / Health',
      IssueType.school:      'School / Education',
      IssueType.electricity: 'Electricity',
      IssueType.farmer:      'Farmer / Agriculture',
      IssueType.other:       'Other',
    };
    return m[this] ?? name;
  }

  String get kannadaLabel {
    const m = {
      IssueType.bribery:     'ಲಂಚ / ಭ್ರಷ್ಟಾಚಾರ',
      IssueType.road:        'ರಸ್ತೆ / ಮೂಲಸೌಕರ್ಯ',
      IssueType.water:       'ನೀರು ಪೂರೈಕೆ',
      IssueType.hospital:    'ಆಸ್ಪತ್ರೆ / ಆರೋಗ್ಯ',
      IssueType.school:      'ಶಾಲೆ / ಶಿಕ್ಷಣ',
      IssueType.electricity: 'ವಿದ್ಯುತ್',
      IssueType.farmer:      'ರೈತ / ಕೃಷಿ',
      IssueType.other:       'ಇತರ',
    };
    return m[this] ?? name;
  }

  String get dbValue => name;
  static IssueType fromDb(String s) =>
      IssueType.values.firstWhere((e) => e.name == s, orElse: () => IssueType.other);
}

enum IssueStatus { open, inProgress, resolved, closed }

extension IssueStatusX on IssueStatus {
  static IssueStatus fromDb(String s) {
    switch (s) {
      case 'in_progress': return IssueStatus.inProgress;
      case 'resolved':    return IssueStatus.resolved;
      case 'closed':      return IssueStatus.closed;
      default:            return IssueStatus.open;
    }
  }
}

class Issue {
  final String id;
  final String reporterId;
  final IssueType type;
  final String title;
  final String description;
  final String district;
  final String taluk;
  final String ward;
  final double? latitude;
  final double? longitude;
  final List<String> mediaUrls;
  final String? voiceNoteUrl;
  final IssueStatus status;
  final int upvotes;
  final DateTime createdAt;

  const Issue({
    required this.id,
    required this.reporterId,
    required this.type,
    required this.title,
    required this.description,
    required this.district,
    required this.taluk,
    required this.ward,
    this.latitude,
    this.longitude,
    required this.mediaUrls,
    this.voiceNoteUrl,
    required this.status,
    required this.upvotes,
    required this.createdAt,
  });
}
