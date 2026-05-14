import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

enum PostType { announcement, video, article, event }

class FeedPost {
  final String id;
  final String title;
  final String body;
  final String authorName;
  final PostType type;
  final String? imageUrl;
  final String? videoUrl;
  final int likes;
  final int comments;
  final DateTime createdAt;

  const FeedPost({
    required this.id,
    required this.title,
    required this.body,
    required this.authorName,
    required this.type,
    this.imageUrl,
    this.videoUrl,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });
}

final _stubFeed = [
  FeedPost(
    id: '1',
    title: 'KVS Special Drive – Report Road Issues This Week',
    body: 'ಈ ವಾರ ರಸ್ತೆ ದುರಸ್ತಿ ಅಭಿಯಾನ ನಡೆಯಲಿದೆ. Join the campaign to report road damage across Karnataka before 15 May.',
    authorName: 'KVS Central',
    type: PostType.announcement,
    likes: 428,
    comments: 64,
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  FeedPost(
    id: '2',
    title: 'Volunteer Training – Bengaluru Urban',
    body: 'All volunteers in Bengaluru Urban district are invited for leadership training on 18 May at KVS Office, Rajajinagar.',
    authorName: 'District Lead – Ravi Kumar',
    type: PostType.event,
    likes: 211,
    comments: 38,
    createdAt: DateTime.now().subtract(const Duration(hours: 8)),
  ),
  FeedPost(
    id: '3',
    title: 'How We Got 12 Water Problems Fixed in Mysuru',
    body: 'Read how our Mysuru ward lead coordinated with BBMP to restore water supply to over 400 households in just 10 days.',
    authorName: 'Savitha Naik',
    type: PostType.article,
    likes: 897,
    comments: 120,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
];

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({super.key});

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Updates & News'),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Movement'),
            Tab(text: 'Events'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _FeedList(posts: _stubFeed),
          _FeedList(posts: _stubFeed
              .where((p) => p.type == PostType.announcement ||
                  p.type == PostType.article)
              .toList()),
          _FeedList(posts: _stubFeed
              .where((p) => p.type == PostType.event)
              .toList()),
        ],
      ),
    );
  }
}

class _FeedList extends StatelessWidget {
  final List<FeedPost> posts;
  const _FeedList({required this.posts});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return const Center(
        child: Text('No posts yet', style: TextStyle(color: AppColors.textSecondary)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(AppSizes.md),
      itemCount: posts.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.md),
      itemBuilder: (_, i) => _FeedCard(post: posts[i]),
    );
  }
}

class _FeedCard extends StatefulWidget {
  final FeedPost post;
  const _FeedCard({required this.post});

  @override
  State<_FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<_FeedCard> {
  bool _liked = false;

  Color _typeColor(PostType t) => switch (t) {
        PostType.announcement => AppColors.primary,
        PostType.event        => AppColors.secondary,
        PostType.article      => AppColors.info,
        PostType.video        => Colors.red,
      };

  IconData _typeIcon(PostType t) => switch (t) {
        PostType.announcement => Icons.campaign_outlined,
        PostType.event        => Icons.event_outlined,
        PostType.article      => Icons.article_outlined,
        PostType.video        => Icons.play_circle_outlined,
      };

  String _typeLabel(PostType t) => switch (t) {
        PostType.announcement => 'Announcement',
        PostType.event        => 'Event',
        PostType.article      => 'Story',
        PostType.video        => 'Video',
      };

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(widget.post.type);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_typeIcon(widget.post.type),
                          size: 12, color: color),
                      const SizedBox(width: 4),
                      Text(
                        _typeLabel(widget.post.type),
                        style: TextStyle(
                            color: color,
                            fontSize: 11,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  _timeAgo(widget.post.createdAt),
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
            child: Text(
              widget.post.title,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
            child: Text(
              widget.post.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.4),
            ),
          ),
          const SizedBox(height: AppSizes.md),
          // Footer
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSizes.md, 0, AppSizes.md, AppSizes.md),
            child: Row(
              children: [
                const Icon(Icons.person_outline,
                    size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(widget.post.authorName,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
                const Spacer(),
                // Like button
                GestureDetector(
                  onTap: () => setState(() => _liked = !_liked),
                  child: Row(
                    children: [
                      Icon(
                        _liked ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color: _liked ? Colors.red : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.post.likes + (_liked ? 1 : 0)}',
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text('${widget.post.comments}',
                        style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
