import 'package:equatable/equatable.dart';

enum UserRole { public, member, leader, admin }

/// Official positions within the KVS party hierarchy.
/// Every new party member starts as [member].
/// They progress by recruiting members and earning nominations confirmed by the party.
/// Positions are geography-bound — a member holds their position only within
/// the district/taluk/ward they registered in.
enum PartyPosition {
  // ── Base ─────────────────────────────────────────────────────────────
  member,                   // All new party members start here

  // ── Grassroots ───────────────────────────────────────────────────────
  boothCommitteeMember,     // Booth Committee Member
  boothPresident,           // Booth President  (qualify: 20 recruits)
  mandalPresident,          // Mandal President (qualify: 50 recruits + party)

  // ── Assembly / Taluk ─────────────────────────────────────────────────
  blockTalukPresident,      // Block / Taluk President   (party assigns)
  constituencyIncharge,     // Constituency In-charge    (party assigns)

  // ── District ─────────────────────────────────────────────────────────
  districtMorchaHead,       // Morcha Head: Youth / Women / Farmers / SC-ST
  districtSecretary,        // District Secretary
  districtGeneralSecretary, // District General Secretary
  districtPresident,        // District President

  // ── State ─────────────────────────────────────────────────────────────
  stateSecretary,           // State Secretary
  stateTreasurer,           // State Treasurer
  stateGeneralSecretary,    // State General Secretary
  stateOrgGeneralSecretary, // General Secretary (Organisation)
  stateVicePresident,       // State Vice President
  statePresident,           // State President
}

/// Status of the member's current position.
/// [active]            = confirmed and live.
/// [pendingAssignment] = nomination submitted, awaiting party review.
/// [suspended]         = temporarily suspended by party.
enum PositionStatus { pendingAssignment, active, suspended }

class AppUser extends Equatable {
  final String uid;
  final String phone;
  final String name;
  final String? photoUrl;
  final UserRole role;
  final PartyPosition position;
  final PositionStatus positionStatus;
  final String district;
  final String taluk;
  final String ward;
  final String constituencyId;
  final String referralCode;
  final String? referredBy;
  final int referralCount;
  final int activityScore;
  final int issuesReported;
  final int issuesResolved;
  final int eventsAttended;
  final List<String> badges;
  final bool isVerified;
  final bool isActive;
  final String language;
  final DateTime createdAt;
  final DateTime lastActiveAt;

  const AppUser({
    required this.uid,
    required this.phone,
    required this.name,
    this.photoUrl,
    required this.role,
    required this.position,
    this.positionStatus = PositionStatus.pendingAssignment,
    required this.district,
    required this.taluk,
    required this.ward,
    required this.constituencyId,
    required this.referralCode,
    this.referredBy,
    required this.referralCount,
    required this.activityScore,
    required this.issuesReported,
    required this.issuesResolved,
    required this.eventsAttended,
    required this.badges,
    required this.isVerified,
    required this.isActive,
    required this.language,
    required this.createdAt,
    required this.lastActiveAt,
  });

  @override
  List<Object?> get props => [uid, phone, role, position, positionStatus];

  AppUser copyWith({
    String? name,
    String? photoUrl,
    UserRole? role,
    PartyPosition? position,
    PositionStatus? positionStatus,
    String? district,
    String? taluk,
    String? ward,
    String? constituencyId,
    int? referralCount,
    int? activityScore,
    int? issuesReported,
    int? issuesResolved,
    int? eventsAttended,
    List<String>? badges,
    bool? isVerified,
    bool? isActive,
    String? language,
    DateTime? lastActiveAt,
  }) {
    return AppUser(
      uid: uid,
      phone: phone,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      position: position ?? this.position,
      positionStatus: positionStatus ?? this.positionStatus,
      district: district ?? this.district,
      taluk: taluk ?? this.taluk,
      ward: ward ?? this.ward,
      constituencyId: constituencyId ?? this.constituencyId,
      referralCode: referralCode,
      referredBy: referredBy,
      referralCount: referralCount ?? this.referralCount,
      activityScore: activityScore ?? this.activityScore,
      issuesReported: issuesReported ?? this.issuesReported,
      issuesResolved: issuesResolved ?? this.issuesResolved,
      eventsAttended: eventsAttended ?? this.eventsAttended,
      badges: badges ?? this.badges,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      language: language ?? this.language,
      createdAt: createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }
}
