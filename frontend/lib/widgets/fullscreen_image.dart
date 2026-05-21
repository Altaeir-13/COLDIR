import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/post_model.dart';
import '../providers/feed_provider.dart';
import '../screens/core/comments/comments_screen.dart';

class FullScreenImage extends StatefulWidget {
  final PostModel post;
  final String heroTag;
  final String? heroBase;
  final int initialIndex;

  const FullScreenImage({
    super.key,
    required this.post,
    required this.heroTag,
    this.heroBase,
    this.initialIndex = 0,
  });

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  bool _showChrome = false;
  late final PageController _pageController;
  late int _currentIndex;

  void _toggleChrome() {
    setState(() => _showChrome = !_showChrome);
  }

  void _like() {
    context.read<FeedProvider>().likePost(widget.post);
  }

  @override
  void initState() {
    super.initState();
    final int maxIndex =
        widget.post.imageUrls.isEmpty ? 0 : widget.post.imageUrls.length - 1;
    _currentIndex = widget.initialIndex.clamp(0, maxIndex).toInt();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    final Color accent = colors.primary;
    final List<String> images = widget.post.imageUrls;

    if (images.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'Imagem indisponível',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _toggleChrome,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final String heroTag = _heroForIndex(index);
                  return Center(
                    child: Hero(
                      tag: heroTag,
                      child: InteractiveViewer(
                        child: Image.network(
                          images[index],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Top bar (back)
              AnimatedOpacity(
                opacity: _showChrome ? 1 : 0,
                duration: const Duration(milliseconds: 180),
                child: Container(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.82),
                        Colors.black.withValues(alpha: 0.35),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      _roundButton(
                        icon: Icons.arrow_back,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Spacer(),
                      _roundButton(
                        icon: Icons.more_vert,
                        onPressed: () => _showInfo('Mais ações em breve'),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom actions
              AnimatedOpacity(
                opacity: _showChrome ? 1 : 0,
                duration: const Duration(milliseconds: 180),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.9),
                          Colors.black.withValues(alpha: 0.55),
                          Colors.black.withValues(alpha: 0.25),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        child: Row(
                          children: [
                            _actionIcon(
                              icon: widget.post.curtiu
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: widget.post.curtiu ? Colors.redAccent : accent,
                              onTap: _like,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${widget.post.totalLikes}',
                              style: const TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            const SizedBox(width: 22),
                            _actionIcon(
                              icon: Icons.chat_bubble_outline,
                              color: accent,
                              onTap: _openComments,
                            ),
                            const Spacer(),
                            if (images.length > 1)
                              Text(
                                '${_currentIndex + 1}/${images.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            const SizedBox(width: 12),
                            _actionIcon(
                              icon: Icons.bookmark_border,
                              color: accent,
                              onTap: () => _showInfo('Salvar em breve'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roundButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.65),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Theme.of(context).colorScheme.primary),
        onPressed: onPressed,
      ),
    );
  }

  Widget _actionIcon({required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkResponse(
      onTap: onTap,
      radius: 28,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }

  void _openComments() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CommentsScreen(post: widget.post),
      ),
    );
  }

  String _heroForIndex(int index) {
    if (widget.heroBase != null && widget.heroBase!.isNotEmpty) {
      return '${widget.heroBase}-$index';
    }
    if (widget.post.imageUrls.length == 1) return widget.heroTag;
    return '${widget.heroTag}-$index';
  }

  void _showInfo(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
