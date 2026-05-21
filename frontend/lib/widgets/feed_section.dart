import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/feed_provider.dart';
import '../widgets/feed_item.dart';

class FeedSection extends StatelessWidget {
  const FeedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(
      builder: (context, feed, _) {
        if (feed.isLoading && feed.posts.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(40),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (feed.posts.isEmpty) {
          return const Center(child: Text('No posts yet'));
        }

        return Column(
          children: [
            ...feed.posts.map((post) {
              return FeedItem(post: post, time: _tempoAtras(post.createdAt));
            }),

            // Indicador de carregamento do scroll infinito
            if (feed.isFetchingMore)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: CircularProgressIndicator(),
              ),
          ],
        );
      },
    );
  }

  // Converte data em "Agora", "5 min", "2 h", etc
  String _tempoAtras(DateTime data) {
    final diff = DateTime.now().difference(data);

    if (diff.inMinutes < 1) return 'Agora';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min';
    if (diff.inHours < 24) return '${diff.inHours} h';
    return '${diff.inDays} d';
  }
}
