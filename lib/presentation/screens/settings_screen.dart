import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../providers/settings_provider.dart';
import '../providers/auth_provider.dart';
import '../../data/models/user_settings.dart';
import '../../data/models/balance.dart';

/// Экран настроек с вертикальными вкладками
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedTab = 0;

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
      body: Row(
        children: [
          // Вертикальное меню вкладок
          NavigationRail(
            extended: MediaQuery.of(context).size.width > 600,
            selectedIndex: _selectedTab,
            onDestinationSelected: (index) {
              setState(() {
                _selectedTab = index;
              });
            },
            leading: Column(
              children: [
                const SizedBox(height: 16),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
              ],
            ),
            destinations: [
              NavigationRailDestination(
                icon: const Icon(Icons.person_rounded),
                label: Text(l10n.profile),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.palette_rounded),
                label: Text(l10n.appearance),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.notifications_rounded),
                label: Text(l10n.notifications),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.info_rounded),
                label: Text(l10n.about),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Контент вкладок
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: const [
                _ProfileTab(),
                _AppearanceTab(),
                _NotificationsTab(),
                _AboutTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Вкладка профиля
class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<SettingsProvider>();
    final settings = provider.settings;
    final authProvider = context.watch<AuthProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profile,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Аватар
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: theme.primaryColor.withOpacity(0.1),
                  backgroundImage: settings?.avatarUrl != null
                      ? NetworkImage(settings!.avatarUrl!)
                      : null,
                  child: settings?.avatarUrl == null
                      ? Icon(Icons.person_rounded, size: 60)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.colorScheme.surface, width: 3),
                    ),
                    child: IconButton(
                      onPressed: () => _showAvatarOptions(context, provider),
                      icon: const Icon(Icons.camera_alt_rounded, size: 20),
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Имя
          _SettingsTextField(
            label: l10n.fullName,
            initialValue: settings?.fullName ?? authProvider.profile?.displayName ?? authProvider.user?.displayName ?? '',
            onChanged: (value) {
              provider.updateSettings(fullName: value);
            },
          ),
          const SizedBox(height: 16),

          // Email (только для чтения)
          _SettingsTextField(
            label: l10n.email,
            initialValue: settings?.email ?? authProvider.profile?.email ?? authProvider.user?.email ?? '',
            enabled: false,
          ),
          const SizedBox(height: 24),

          // Базовая валюта
          _SettingsCard(
            title: l10n.baseCurrency,
            child: DropdownButtonFormField<SupportedCurrency>(
              value: settings?.baseCurrency ?? SupportedCurrency.usd,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: SupportedCurrencyX.fiatValues.map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Text('${currency.code} - ${currency.symbol}'),
                );
              }).toList(),
              onChanged: (currency) {
                if (currency != null) {
                  provider.changeBaseCurrency(currency);
                }
              },
            ),
          ),
          const SizedBox(height: 16),

          // Месячный бюджет
          _SettingsCard(
            title: l10n.monthlyBudget,
            child: TextField(
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                prefixText: '${settings?.baseCurrency.symbol ?? '\$'} ',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              controller: TextEditingController(
                text: settings?.monthlyBudget.toString() ?? '0',
              ),
              onChanged: (value) {
                final budget = double.tryParse(value);
                if (budget != null) {
                  provider.updateSettings(monthlyBudget: budget);
                }
              },
            ),
          ),
          const SizedBox(height: 32),

          // Часовой пояс
          _SettingsCard(
            title: l10n.timezone,
            child: DropdownButtonFormField<String>(
              value: settings?.timezone ?? 'UTC',
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: [
                'UTC',
                'Europe/Moscow',
                'Europe/London',
                'America/New_York',
                'America/Los_Angeles',
                'Asia/Tokyo',
                'Asia/Shanghai',
              ].map((timezone) {
                return DropdownMenuItem(
                  value: timezone,
                  child: Text(timezone),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  provider.updateSettings(timezone: value);
                }
              },
            ),
          ),
          const SizedBox(height: 32),

          // Выход
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                authProvider.signOut();
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
        ],
      ),
    );
  }

  void _showAvatarOptions(BuildContext context, SettingsProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: Text(l10n.takePhoto),
              onTap: () async {
                Navigator.pop(context);
                final file = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                );
                if (file != null) {
                  provider.uploadAvatar(File(file.path));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: Text(l10n.chooseFromGallery),
              onTap: () async {
                Navigator.pop(context);
                final file = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                if (file != null) {
                  provider.uploadAvatar(File(file.path));
                }
              },
            ),
            if (provider.settings?.avatarUrl != null)
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                title: Text(l10n.deleteAvatar),
                onTap: () {
                  Navigator.pop(context);
                  provider.deleteAvatar();
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// Вкладка внешнего вида
class _AppearanceTab extends StatelessWidget {
  const _AppearanceTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<SettingsProvider>();
    final settings = provider.settings;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.appearance,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          _SettingsCard(
            title: l10n.theme,
            child: Column(
              children: AppTheme.values.map((appTheme) {
                return RadioListTile<AppTheme>(
                  value: appTheme,
                  groupValue: AppThemeX.fromString(settings?.theme ?? 'system'),
                  title: Text(appTheme.displayName),
                  secondary: Icon(appTheme.icon),
                  onChanged: (value) {
                    if (value != null) {
                      provider.changeTheme(value);
                    }
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          _SettingsCard(
            title: l10n.language,
            child: Column(
              children: AppLanguage.values.map((language) {
                return RadioListTile<AppLanguage>(
                  value: language,
                  groupValue: AppLanguageX.fromCode(settings?.language ?? 'ru'),
                  title: Text(language.displayName),
                  secondary: Icon(language.icon),
                  onChanged: (value) {
                    if (value != null) {
                      provider.changeLanguage(value);
                    }
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Вкладка уведомлений
class _NotificationsTab extends StatelessWidget {
  const _NotificationsTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<SettingsProvider>();
    final settings = provider.settings;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.notifications,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          _SettingsCard(
            title: l10n.notificationSettings,
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.enableNotifications),
                  value: settings?.notificationsEnabled ?? true,
                  onChanged: (value) {
                    provider.updateSettings(notificationsEnabled: value);
                  },
                ),
                const Divider(),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.emailNotifications),
                  value: settings?.emailNotifications ?? false,
                  onChanged: (value) {
                    provider.updateSettings(emailNotifications: value);
                  },
                ),
                const Divider(),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.pushNotifications),
                  value: settings?.pushNotifications ?? true,
                  onChanged: (value) {
                    provider.updateSettings(pushNotifications: value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Вкладка о приложении
class _AboutTab extends StatelessWidget {
  const _AboutTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet_rounded,
            size: 80,
            color: theme.primaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Goida AI',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.appVersion,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 32),
          _SettingsCard(
            title: l10n.about,
            child: Column(
              children: [
                Text(
                  l10n.appDescription,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.appFeatures,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SettingsCard(
            title: l10n.contact,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.email_rounded),
                  title: const Text('support@goida.ai'),
                  onTap: () {
                    // TODO: Открыть email клиент
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.telegram_rounded),
                  title: const Text('@goida_support'),
                  onTap: () {
                    // TODO: Открыть Telegram
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Карточка настроек
class _SettingsCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SettingsCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

/// Поле ввода настроек
class _SettingsTextField extends StatelessWidget {
  final String label;
  final String initialValue;
  final bool enabled;
  final Function(String)? onChanged;

  const _SettingsTextField({
    required this.label,
    required this.initialValue,
    this.enabled = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _SettingsCard(
      title: label,
      child: TextField(
        enabled: enabled,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        controller: TextEditingController(text: initialValue),
        onChanged: onChanged,
      ),
    );
  }
}
