import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// PROVIDERS
import 'package:fadir/providers/user_provider.dart';
import 'package:fadir/providers/reuniao_provider.dart';
import 'package:fadir/providers/feed_provider.dart';
import 'package:fadir/providers/language_provider.dart';

// PAGES
import 'package:fadir/screens/core/publicacao/criar_publicacao_page.dart';
import 'package:fadir/screens/core/recentEvents/history_page.dart';
import 'package:fadir/screens/core/profilePage/profile_page.dart';

// WIDGETS
import 'package:fadir/widgets/bottom_bar.dart';
import 'package:fadir/widgets/home_events_card.dart';
import 'package:fadir/widgets/feed_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/*
  HOME PAGE
  Responsável apenas por:
  - Navegação (BottomNavigationBar)
  - Manter as páginas vivas (IndexedStack)
*/
class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late final AnimationController _fabController;
  bool _isDialOpen = false;

  /*
    IndexedStack mantém o estado das páginas.
    O feed NÃO é recriado ao trocar de aba.
  */
  final List<Widget> _pages = const [
    HomeContent(),
    HistoryPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  Future<void> _handleCreatePost(BuildContext context) async {
    _toggleFabMenu(closeOnly: true);

    final postCriado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreatePostPage()),
    );

    if (!context.mounted) return;

    if (postCriado == true) {
      final user = context.read<UserProvider>();
      context.read<FeedProvider>().fetchInitialPosts(
            emailUsuario: user.email,
          );
    }
  }

  void _handleMeetingAction({required ReuniaoProvider reuniaoProvider}) {
    _toggleFabMenu(closeOnly: true);

    final rota =
        reuniaoProvider.proximaReuniao == null ? '/create_meeting' : '/edit_meeting';
    Navigator.pushNamed(context, rota);
  }

  void _toggleFabMenu({bool closeOnly = false}) {
    final shouldOpen = closeOnly ? false : !_isDialOpen;
    setState(() {
      _isDialOpen = shouldOpen;
      if (_isDialOpen) {
        _fabController.forward();
      } else {
        _fabController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final reuniaoProvider = context.watch<ReuniaoProvider>();

    final colors = Theme.of(context).colorScheme;
    final onSurface = colors.onSurface;

    final bool showAppBar = _selectedIndex == 0;
    final bool showFab = _selectedIndex == 0;

    return Scaffold(
      backgroundColor: colors.surface,

      appBar:
          showAppBar
              ? AppBar(
                backgroundColor: colors.surface,
                elevation: 0,
                automaticallyImplyLeading: false,
                title: Text(
                  "FADIR",
                  style: TextStyle(
                    color: onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 28,
                    letterSpacing: -1.0,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.notifications_none,
                      color: colors.onSurface,
                      size: 28,
                    ),
                    onPressed:
                        () => Navigator.pushNamed(context, '/notification'),
                  ),
                  const SizedBox(width: 10),
                ],
              )
              : null,

      /*
        IndexedStack mantém as telas vivas
        e evita rebuild desnecessário
      */
      body: IndexedStack(index: _selectedIndex, children: _pages),

      floatingActionButton:
          showFab
              ? _FabSpeedDial(
                  controller: _fabController,
                  isOpen: _isDialOpen,
                  toggle: _toggleFabMenu,
                  primaryColor: colors.primary,
                  onCreatePost: () => _handleCreatePost(context),
                  showMeetingAction:
                      !reuniaoProvider.isLoading &&
                      (userProvider.cargo == "ADMIN" ||
                          userProvider.cargo == "PROPRIETARIO"),
                  meetingLabel:
                      reuniaoProvider.proximaReuniao == null
                          ? "Nova reunião"
                          : "Editar reunião",
                  onMeetingTap: () =>
                      _handleMeetingAction(reuniaoProvider: reuniaoProvider),
                )
              : null,

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

/*
  HOME CONTENT
  Responsável por:
  - Carregar o feed
  - Scroll infinito
  - Pull-to-refresh
*/
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<UserProvider>();

      // Carrega o card do evento
      context.read<ReuniaoProvider>().carregarHome();

      // Carrega o feed
      context.read<FeedProvider>().fetchInitialPosts(emailUsuario: user.email);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        final user = context.read<UserProvider>();
        context.read<FeedProvider>().fetchMorePosts(emailUsuario: user.email);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final user = context.read<UserProvider>();
        await context.read<FeedProvider>().fetchInitialPosts(
          emailUsuario: user.email,
        );
      },
      child: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 10),

          // ===============================
          // CARD DO EVENTO (TOPO)
          // ===============================
          Consumer<ReuniaoProvider>(
            builder: (context, reuniaoProvider, _) {
              if (reuniaoProvider.isLoading) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (reuniaoProvider.proximaReuniao == null) {
                return const SizedBox.shrink();
              }

              return HomeEventCard(reuniao: reuniaoProvider.proximaReuniao!);
            },
          ),

          const SizedBox(height: 20),

          // ===============================
          // FEED
          // ===============================
          const FeedSection(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _FabSpeedDial extends StatelessWidget {
  const _FabSpeedDial({
    required this.controller,
    required this.isOpen,
    required this.toggle,
    required this.primaryColor,
    required this.onCreatePost,
    required this.showMeetingAction,
    required this.meetingLabel,
    required this.onMeetingTap,
  });

  final AnimationController controller;
  final bool isOpen;
  final void Function({bool closeOnly}) toggle;
  final Color primaryColor;
  final VoidCallback onCreatePost;
  final bool showMeetingAction;
  final String meetingLabel;
  final VoidCallback onMeetingTap;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final baseBottom = 16.0 + bottomInset;
    String t(String key) => context.t(key);

    final actions = <_DialAction>[
      _DialAction(
        label: t('fabPost'),
        icon: Icons.post_add_rounded,
        color: primaryColor,
        onTap: onCreatePost,
      ),
      if (showMeetingAction)
        _DialAction(
          label: t('fabEdit'),
          icon: Icons.edit,
          color: const Color(0xFFFFA726),
          onTap: onMeetingTap,
        ),
    ];

    // Spread actions in an arc above the FAB (equidistant, closer to main)
    const double radius = 85;
    final startAngle = -math.pi / 2; // straight up
    final endAngle = startAngle - (math.pi / 2.2); // sweep ~82° para evitar sobreposição
    final angleStep = actions.length <= 1
        ? 0
        : (startAngle - endAngle) / (actions.length - 1);

    final distance = Tween<double>(begin: 0, end: radius).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.9, curve: Curves.easeOutCubic),
        reverseCurve: Curves.easeInCubic,
      ),
    );

    final rotation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    );

    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          // Tap-to-close area (transparent, no dimming)
          if (isOpen)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => toggle(closeOnly: true),
              ),
            ),

          Padding(
            padding: EdgeInsets.only(bottom: baseBottom, right: 16),
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                return SizedBox(
                  width: radius + 120,
                  height: radius + 120,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    clipBehavior: Clip.none,
                    children: [
                      for (int i = 0; i < actions.length; i++)
                        _RadialAction(
                          controller: controller,
                          distance: distance,
                          angle: startAngle - angleStep * i,
                          index: i,
                          child: _DialActionButton(action: actions[i]),
                        ),

                      // Main FAB
                      FloatingActionButton(
                        backgroundColor: primaryColor,
                        elevation: 4,
                        shape: const CircleBorder(),
                        onPressed: () => toggle(closeOnly: false),
                        child: AnimatedBuilder(
                          animation: rotation,
                          builder: (_, __) {
                            return Transform.rotate(
                              angle: rotation.value * (math.pi / 4), // 45° vira X
                              child: const Icon(Icons.add, color: Colors.white, size: 30),
                            );
                          },
                        ),
                      ),
                    ],
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

class _RadialAction extends StatelessWidget {
  const _RadialAction({
    required this.controller,
    required this.distance,
    required this.angle,
    required this.index,
    required this.child,
  });

  final AnimationController controller;
  final Animation<double> distance;
  final double angle;
  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final fade = CurvedAnimation(
      parent: controller,
      curve: Interval(0.05 * index, 0.7, curve: Curves.easeOut),
      reverseCurve: Curves.easeIn,
    );

    final scale = CurvedAnimation(
      parent: controller,
      curve: Interval(0.05 * index, 0.85, curve: Curves.easeOutBack),
      reverseCurve: Curves.easeInBack,
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final offset = Offset.fromDirection(angle, distance.value);
        return Transform.translate(
          offset: offset,
          child: Opacity(
            opacity: fade.value,
            child: Transform.scale(scale: scale.value, child: child),
          ),
        );
      },
    );
  }
}

class _DialAction {
  const _DialAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}

class _DialActionButton extends StatelessWidget {
  const _DialActionButton({required this.action});

  final _DialAction action;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: action.label,
      preferBelow: false,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              action.label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          FloatingActionButton(
            heroTag: '${action.label}-${action.icon}-${action.color.toARGB32()}',
            backgroundColor: action.color,
            elevation: 4,
            shape: const CircleBorder(),
            onPressed: action.onTap,
            child: Icon(action.icon, color: Colors.white, size: 26),
          ),
        ],
      ),
    );
  }
}