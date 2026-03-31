import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle(l10n.profile),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: authProvider.avatarImageProvider,
                    child: authProvider.avatarImageProvider == null
                        ? const Icon(Icons.person, size: 30)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authProvider.displayName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          authProvider.email,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(l10n.appearance),
          Card(
            child: Column(
              children: [
                _buildListTile(
                  context,
                  l10n.system,
                  authProvider.themeMode == ThemeMode.system,
                  () => authProvider.setThemeMode(ThemeMode.system),
                ),
                _buildListTile(
                  context,
                  l10n.light,
                  authProvider.themeMode == ThemeMode.light,
                  () => authProvider.setThemeMode(ThemeMode.light),
                ),
                _buildListTile(
                  context,
                  l10n.dark,
                  authProvider.themeMode == ThemeMode.dark,
                  () => authProvider.setThemeMode(ThemeMode.dark),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(l10n.language),
          Card(
            child: Column(
              children: [
                _buildListTile(
                  context,
                  l10n.system,
                  authProvider.locale == null,
                  () => authProvider.setLocale(null),
                ),
                _buildListTile(
                  context,
                  "English",
                  authProvider.locale?.languageCode == 'en',
                  () => authProvider.setLocale(const Locale('en')),
                ),
                _buildListTile(
                  context,
                  "Русский",
                  authProvider.locale?.languageCode == 'ru',
                  () => authProvider.setLocale(const Locale('ru')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(l10n.account),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: Text(l10n.changeAvatar ?? "Изменить аватарку"),
                  subtitle: authProvider.isUploadingAvatar
                      ? Text(l10n.avatarUploading ?? "Загрузка...")
                      : Text(l10n.chooseAvatarFromGallery ?? "Выбрать из галереи"),
                  trailing: authProvider.isUploadingAvatar
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : null,
                  onTap: authProvider.isUploadingAvatar
                      ? null
                      : () async {
                          final success = await authProvider.pickAndUploadAvatar();
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? (l10n.avatarUpdated ?? "Аватарка обновлена")
                                    : (l10n.avatarUpdateFailed ?? "Ошибка обновления"),
                              ),
                            ),
                          );
                        },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    l10n.logout,
                    style: const TextStyle(color: Colors.red),
                  ),
                  onTap: () async {
                    await authProvider.signOut();
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return ListTile(
      title: Text(label),
      trailing: isSelected
          ? const Icon(Icons.check, color: Color(0xFF00D09E))
          : null,
      onTap: onTap,
    );
  }
}
