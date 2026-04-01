import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../providers/settings_provider.dart';
import '../providers/auth_provider.dart';
import '../../data/models/user_settings.dart';
import '../../data/models/balance.dart';

/// Экран настроек в виде списка с модальными окнами
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<SettingsProvider>().loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Профиль
          _SettingsSection(
            title: l10n.profile,
            children: [
              _SettingsTile(
                icon: Icons.person_outline_rounded,
                title: l10n.fullName,
                subtitle: context.watch<SettingsProvider>().settings?.fullName ??
                    context.watch<AuthProvider>().profile?.displayName ??
                    '',
                onTap: () => _showProfileDialog(context),
              ),
              _SettingsTile(
                icon: Icons.email_outlined,
                title: l10n.email,
                subtitle: context.watch<SettingsProvider>().settings?.email ??
                    context.watch<AuthProvider>().profile?.email ??
                    '',
                enabled: false,
              ),
              _SettingsTile(
                icon: Icons.account_balance_wallet_outlined,
                title: l10n.baseCurrency,
                subtitle: context.watch<SettingsProvider>().settings?.baseCurrency.code ??
                    'USD',
                onTap: () => _showCurrencyPicker(context),
              ),
              _SettingsTile(
                icon: Icons.attach_money,
                title: l10n.monthlyBudget,
                subtitle: context.watch<SettingsProvider>().settings?.monthlyBudget.toString() ??
                    '0',
                onTap: () => _showBudgetDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Внешний вид
          _SettingsSection(
            title: l10n.appearance,
            children: [
              _SettingsTile(
                icon: Icons.palette_outlined,
                title: l10n.theme,
                subtitle: _getThemeName(
                  context.watch<SettingsProvider>().settings?.theme ?? 'system',
                  l10n,
                ),
                onTap: () => _showThemeDialog(context),
              ),
              _SettingsTile(
                icon: Icons.language_rounded,
                title: l10n.language,
                subtitle: _getLanguageName(
                  context.watch<SettingsProvider>().settings?.language ?? 'ru',
                  l10n,
                ),
                onTap: () => _showLanguageDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Уведомления
          _SettingsSection(
            title: l10n.notifications,
            children: [
              _SettingsSwitchTile(
                icon: Icons.notifications_outlined,
                title: l10n.enableNotifications,
                value: context.watch<SettingsProvider>().settings?.notificationsEnabled ?? true,
                onChanged: (value) {
                  context.read<SettingsProvider>().updateSettings(notificationsEnabled: value);
                },
              ),
              _SettingsSwitchTile(
                icon: Icons.email_outlined,
                title: l10n.emailNotifications,
                value: context.watch<SettingsProvider>().settings?.emailNotifications ?? false,
                onChanged: (value) {
                  context.read<SettingsProvider>().updateSettings(emailNotifications: value);
                },
              ),
              _SettingsSwitchTile(
                icon: Icons.phone_android_rounded,
                title: l10n.pushNotifications,
                value: context.watch<SettingsProvider>().settings?.pushNotifications ?? true,
                onChanged: (value) {
                  context.read<SettingsProvider>().updateSettings(pushNotifications: value);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // О приложении
          _SettingsSection(
            title: l10n.about,
            children: [
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                title: l10n.about,
                subtitle: l10n.appVersion,
                onTap: () => _showAboutDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Выход
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                context.read<AuthProvider>().signOut();
              },
              icon: const Icon(Icons.logout_rounded),
              label: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(l10n.logout),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String _getThemeName(String theme, AppLocalizations l10n) {
    switch (theme.toLowerCase()) {
      case 'light':
        return l10n.light;
      case 'dark':
        return l10n.dark;
      default:
        return l10n.system;
    }
  }

  String _getLanguageName(String language, AppLocalizations l10n) {
    switch (language.toLowerCase()) {
      case 'en':
        return 'English';
      case 'ru':
        return 'Русский';
      default:
        return 'Русский';
    }
  }

  void _showProfileDialog(BuildContext context) {
    final provider = context.read<SettingsProvider>();
    final settings = provider.settings;
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: settings?.fullName ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.fullName),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.fullName,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              provider.updateSettings(fullName: controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context) {
    final provider = context.read<SettingsProvider>();
    final settings = provider.settings;
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.baseCurrency,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: SupportedCurrencyX.fiatValues.length,
                itemBuilder: (context, index) {
                  final currency = SupportedCurrencyX.fiatValues[index];
                  final isSelected = settings?.baseCurrency.code == currency.code;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade300,
                      child: Text(
                        currency.code,
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    title: Text('${currency.code} - ${currency.symbol}'),
                    trailing: isSelected
                        ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                        : null,
                    onTap: () {
                      provider.changeBaseCurrency(currency);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBudgetDialog(BuildContext context) {
    final provider = context.read<SettingsProvider>();
    final settings = provider.settings;
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(
      text: settings?.monthlyBudget.toString() ?? '0',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.monthlyBudget),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: l10n.monthlyBudget,
            prefixText: '${settings?.baseCurrency.symbol ?? '\$'} ',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final budget = double.tryParse(controller.text.replaceAll(',', '.'));
              if (budget != null) {
                provider.updateSettings(monthlyBudget: budget);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    final provider = context.read<SettingsProvider>();
    final settings = provider.settings;
    final l10n = AppLocalizations.of(context)!;
    final currentTheme = AppThemeX.fromString(settings?.theme ?? 'system');

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.theme,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ...AppTheme.values.map((theme) => RadioListTile<AppTheme>(
              value: theme,
              groupValue: currentTheme,
              title: Text(theme.displayName),
              secondary: Icon(theme.icon),
              onChanged: (value) {
                if (value != null) {
                  provider.changeTheme(value);
                  Navigator.pop(context);
                }
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final provider = context.read<SettingsProvider>();
    final settings = provider.settings;
    final l10n = AppLocalizations.of(context)!;
    final currentLanguage = AppLanguageX.fromCode(settings?.language ?? 'ru');

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.language,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ...AppLanguage.values.map((language) => RadioListTile<AppLanguage>(
              value: language,
              groupValue: currentLanguage,
              title: Text(language.displayName),
              secondary: Icon(language.icon),
              onChanged: (value) {
                if (value != null) {
                  provider.changeLanguage(value);
                  Navigator.pop(context);
                }
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.about),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.appDescription),
            const SizedBox(height: 16),
            Text(l10n.appFeatures),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// Секция настроек
class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }
}

/// Элемент списка настроек
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool enabled;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: enabled
          ? Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurface.withOpacity(0.3))
          : null,
      enabled: enabled,
      onTap: onTap,
    );
  }
}

/// Переключатель настроек
class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitchTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SwitchListTile(
      secondary: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title),
      value: value,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
