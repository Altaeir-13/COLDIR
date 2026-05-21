import 'package:flutter/material.dart';
import 'package:fadir/providers/language_provider.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Estado local para as configurações de notificação
  bool _allNotifications = true;
  bool _newEvents = true;
  bool _scheduleChanges = true;
  bool _documents = false;
  bool _announcements = true;
  bool _push = true;
  bool _email = false;

  @override
  Widget build(BuildContext context) {
    String t(String key) => context.t(key);
      final colors = Theme.of(context).colorScheme;
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final onSurface = colors.onSurface;
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text(t('notifications')),
        centerTitle: true,
        backgroundColor: colors.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: colors.onSurface),
        titleTextStyle: TextStyle(
          color: colors.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Seção Geral
          _buildSectionHeader(t('general'), onSurface),
          _buildNotificationCard(
            colors: colors,
            isDark: isDark,
            children: [
              _buildSwitchTile(
                title: t('receiveNotifications'),
                subtitle: t('receiveNotificationsSub'),
                value: _allNotifications,
                onChanged: (val) {
                  setState(() {
                    _allNotifications = val;
                    if (!val) {
                      // Se desativar geral, desativa os específicos visualmente (opcional)
                      // Aqui mantemos o estado individual mas o switch principal controla o "master"
                    }
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Seção Categorias
          _buildSectionHeader(t('categories'), onSurface),
          _buildNotificationCard(
            colors: colors,
            isDark: isDark,
            children: [
              _buildSwitchTile(
                title: t('newEvents'),
                subtitle: t('newEventsSub'),
                value: _newEvents,
                enabled: _allNotifications,
                onChanged: (val) => setState(() => _newEvents = val),
              ),
              _buildDivider(colors, isDark),
              _buildSwitchTile(
                title: t('scheduleChanges'),
                subtitle: t('scheduleChangesSub'),
                value: _scheduleChanges,
                enabled: _allNotifications,
                onChanged: (val) => setState(() => _scheduleChanges = val),
              ),
              _buildDivider(colors, isDark),
              _buildSwitchTile(
                title: t('documents'),
                subtitle: t('documentsSub'),
                value: _documents,
                enabled: _allNotifications,
                onChanged: (val) => setState(() => _documents = val),
              ),
              _buildDivider(colors, isDark),
              _buildSwitchTile(
                title: t('announcements'),
                subtitle: t('announcementsSub'),
                value: _announcements,
                enabled: _allNotifications,
                onChanged: (val) => setState(() => _announcements = val),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Seção Canais
          _buildSectionHeader(t('channels'), onSurface),
          _buildNotificationCard(
            colors: colors,
            isDark: isDark,
            children: [
              _buildSwitchTile(
                title: t('pushNotifications'),
                subtitle: t('pushNotificationsSub'),
                value: _push,
                enabled: _allNotifications,
                onChanged: (val) => setState(() => _push = val),
              ),
              _buildDivider(colors, isDark),
              _buildSwitchTile(
                title: t('email'),
                subtitle: t('emailSub'),
                value: _email,
                enabled: _allNotifications,
                onChanged: (val) => setState(() => _email = val),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color onSurface) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 5),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: onSurface.withValues(alpha: 0.75),
        ),
      ),
    );
  }

  Widget _buildNotificationCard({required ColorScheme colors, required bool isDark, required List<Widget> children}) {
    final cardColor = isDark ? colors.surfaceContainerHighest : colors.surface;
    final borderColor = colors.outline.withValues(alpha: isDark ? 0.4 : 0.2);
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: isDark ? 0.35 : 0.08),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool enabled = true,
  }) {
    final colors = Theme.of(context).colorScheme;
    final onSurface = colors.onSurface;
    final disabledColor = onSurface.withValues(alpha: 0.35);
        return SwitchListTile(
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: enabled ? onSurface : disabledColor,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: enabled ? onSurface.withValues(alpha: 0.7) : disabledColor.withValues(alpha: 0.6),
            ),
          ),
          value: value,
          onChanged: enabled ? onChanged : null,
          activeTrackColor: colors.primary,
          activeThumbColor: colors.onPrimary,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    );
  }

  Widget _buildDivider(ColorScheme colors, bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      color: colors.outline.withValues(alpha: isDark ? 0.3 : 0.15),
      indent: 20,
      endIndent: 20,
    );
  }
}
