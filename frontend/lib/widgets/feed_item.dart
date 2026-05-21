import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/post_model.dart';
import '../providers/feed_provider.dart';
import '../screens/core/comments/comments_screen.dart';
import 'fullscreen_image.dart';
import 'user_avatar.dart';

Color _colorWithOpacity(Color color, double opacity) {
  final double safeOpacity = opacity.clamp(0.0, 1.0).toDouble();
  return color.withValues(alpha: safeOpacity);
}

class FeedItem extends StatelessWidget {
  final PostModel post;
  final String time;

  const FeedItem({super.key, required this.post, required this.time});

  @override
  Widget build(BuildContext context) {
    final bool temImagem = post.imageUrls.isNotEmpty;
    final bool temTexto = post.text.trim().isNotEmpty;
    final String heroBase = 'post-image-${post.id}';

    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final bool isDark = theme.brightness == Brightness.dark;

    // Cores ajustadas para Flutter estável
    final Color cardColor =
        isDark
            ? Color.alphaBlend(
              _colorWithOpacity(colors.primary, 0.08),
              colors.surface,
            )
            : colors.surface;

    final Color subtleShadow =
        _colorWithOpacity(colors.shadow, isDark ? 0.35 : 0.08);

    final Color outline = _colorWithOpacity(
      colors.outline,
      isDark ? 0.25 : 0.22,
    );

    final Color onSurface = colors.onSurface;
    final Color mutedText = _colorWithOpacity(onSurface, 0.65);

    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: outline),
        boxShadow: [
          BoxShadow(
            color: subtleShadow,
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- HEADER ----------
          Row(
            children: [
              UserAvatar(imageUrl: post.userAvatar, size: 45),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  post.userName,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: onSurface,
                  ),
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  color: mutedText,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ---------- CONTEÚDO ----------
          if (temTexto)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Text(
                post.text,
                style: TextStyle(
                  color: _colorWithOpacity(onSurface, 0.82),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ),

          if (temTexto && temImagem) const SizedBox(height: 12),

          if (temImagem) _buildImages(context, heroBase),

          const SizedBox(height: 16),
          Divider(
            color: _colorWithOpacity(colors.outline, isDark ? 0.30 : 0.12),
          ),
          const SizedBox(height: 8),

          // ---------- AÇÕES ----------
          Row(
            children: [
              IconButton(
                icon: Icon(
                  post.curtiu ? Icons.favorite : Icons.favorite_border,
                  size: 26,
                  color: post.curtiu
                      ? Colors.red
                      : _colorWithOpacity(onSurface, 0.7),
                ),
                onPressed: () {
                  context.read<FeedProvider>().likePost(post);
                },
              ),
              Text(
                '${post.totalLikes}',
                style: TextStyle(
                  color: _colorWithOpacity(onSurface, 0.75),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: Icon(
                  Icons.chat_bubble_outline,
                  size: 24,
                  color: _colorWithOpacity(onSurface, 0.7),
                ),
                onPressed: () => _openComments(context),
              ),
              const Spacer(),
              Icon(
                Icons.bookmark_border,
                size: 26,
                color: _colorWithOpacity(onSurface, 0.7),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImages(BuildContext context, String heroBase) {
    if (post.imageUrls.length == 1) {
      return _buildSingleImage(context, heroBase, post.imageUrls.first, 0);
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: post.imageUrls.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final imageUrl = post.imageUrls[index];
        return _buildSingleImage(context, heroBase, imageUrl, index);
      },
    );
  }

  Widget _buildSingleImage(
    BuildContext context,
    String heroBase,
    String imageUrl,
    int index,
  ) {
    final String heroTag = _heroTag(heroBase, index);

    return GestureDetector(
      onTap: () => _openImage(context, heroBase, index),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Hero(
          tag: heroTag,
          child: Image.network(
            imageUrl,
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _openImage(BuildContext context, String heroBase, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FullScreenImage(
          post: post,
          heroTag: _heroTag(heroBase, initialIndex),
          heroBase: heroBase,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  String _heroTag(String heroBase, int index) => '$heroBase-$index';

  void _openComments(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CommentsScreen(post: post),
      ),
    );
  }
}