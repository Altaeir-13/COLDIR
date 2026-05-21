import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/comment_model.dart';
import '../../../models/post_model.dart';
import '../../../providers/feed_provider.dart';
import '../../../providers/language_provider.dart';
import '../../../widgets/user_avatar.dart';

class CommentsScreen extends StatefulWidget {
  final PostModel post;

  const CommentsScreen({super.key, required this.post});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late Future<List<CommentModel>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    _commentsFuture = _loadComments();
  }

  Future<List<CommentModel>> _loadComments() {
    return context.read<FeedProvider>().fetchComments(widget.post.id);
  }

  Future<void> _refresh() async {
    setState(() {
      _commentsFuture = _loadComments();
    });
    await _commentsFuture;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    final t = context.t;

    return Scaffold(
      appBar: AppBar(
        title: Text(t('commentsTitle')),
      ),
      body: Column(
        children: [
          _PostHeader(post: widget.post),
          const Divider(height: 1),
          Expanded(
            child: FutureBuilder<List<CommentModel>>(
              future: _commentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return _ErrorState(
                    message: t('commentsListError'),
                    retryLabel: t('commentsRetry'),
                    onRetry: _refresh,
                  );
                }

                final comments = snapshot.data ?? [];

                if (comments.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 52,
                          color: colors.outline,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          t('commentsEmptyTitle'),
                          style: textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          t('commentsEmptySubtitle'),
                          style: textTheme.bodyMedium
                              ?.copyWith(color: colors.outline),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return _CommentTile(comment: comment);
                    },
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemCount: comments.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  final PostModel post;

  const _PostHeader({required this.post});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatar(imageUrl: post.userAvatar, size: 44),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.userName,
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                if (post.text.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    post.text,
                    style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final CommentModel comment;

  const _CommentTile({required this.comment});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatar(imageUrl: comment.userAvatar, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        comment.userName,
                        style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      _formatTime(context, comment.createdAt),
                      style: textTheme.bodySmall?.copyWith(color: colors.outline),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.text,
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(BuildContext context, DateTime date) {
    final Duration diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return AppStrings.of(context, 'justNow');
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}${AppStrings.of(context, 'minutesAgo')}';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}${AppStrings.of(context, 'hoursAgo')}';
    }
    return '${diff.inDays}${AppStrings.of(context, 'daysAgo')}';
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.retryLabel, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: colors.error),
            const SizedBox(height: 12),
            Text(message, style: textTheme.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(retryLabel),
            ),
          ],
        ),
      ),
    );
  }
}
