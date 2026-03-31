import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../providers/settings_provider.dart';
import '../providers/auth_provider.dart';
import '../../data/models/user_settings.dart';
import '../../data/models/balance.dart';

/// Экран настроек с вкладками
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    Future.microtask(() {
      context.read<SettingsProvider>().loadSettings();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.person_rounded), text: 'Профиль'),
            Tab(icon: Icon(Icons.palette_rounded), text: 'Внешний вид'),
            Tab(icon: Icon(Icons.notifications_rounded), text: 'Уведомления'),
            Tab(icon: Icon(Icons.info_rounded), text: 'О приложении'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _ProfileTab(),
          _AppearanceTab(),
          _NotificationsTab(),
          _AboutTab(),
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Аватар
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: theme.primaryColor.withOpacity(0.1),
                backgroundImage: settings?.avatarUrl != null
                    ? NetworkImage(settings!.avatarUrl!)
                    : null,
                child: settings?.avatarUrl == null
                    ? Icon(Icons.person_rounded, size: 50)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: IconButton(
                  onPressed: () => _showAvatarOptions(context, provider),
                  icon: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.camera_alt_rounded, size: 20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Базовая валюта
          _SettingsCard(
            title: 'Базовая валюта',
            child: DropdownButtonFormField<SupportedCurrency>(
              value: settings?.baseCurrency ?? SupportedCurrency.usd,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: SupportedCurrencyX.fiatValues.take(10).map((currency) {
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
            title: 'Месячный бюджет',
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
              onChanged: (value) {
                final budget = double.tryParse(value);
                if (budget != null) {
                  provider.updateSettings(monthlyBudget: budget);
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
                context.read<AuthProvider>().signOut();
              },
              icon: const Icon(Icons.logout_rounded),
              label: const Padding(
                padding: EdgeInsets.all(12),
                child: Text('Выйти'),
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
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: const Text('Сделать фото'),
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
              title: const Text('Выбрать из галереи'),
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
                leading: const Icon(Icons.delete_outline_rounded),
                title: const Text('Удалить аватар'),
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
    final provider = context.watch<SettingsProvider>();
    final settings = provider.settings;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _SettingsCard(
            title: 'Тема',
            child: Column(
              children: AppTheme.values.map((appTheme) {
                return RadioListTile<AppTheme>(
                  value: appTheme,
                  groupValue: AppThemeX.fromString(settings?.theme ?? 'system'),
                  title: Text(appTheme.displayName),
                  secondary: Icon(appTheme.icon),
                  onChanged: (value) {
                    provider.changeTheme(value!);
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          _SettingsCard(
            title: 'Язык',
            child: Column(
              children: AppLanguage.values.map((language) {
                return RadioListTile<AppLanguage>(
                  value: language,
                  groupValue: AppLanguageX.fromCode(settings?.language ?? 'ru').code,
                  title: Text(language.displayName),
                  secondary: Icon(language.icon),
                  onChanged: (value) {
                    provider.changeLanguage(AppLanguageX.fromCode(value ?? 'ru'));
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
    final provider = context.watch<SettingsProvider>();
    final settings = provider.settings;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _SettingsCard(
        title: 'Уведомления',
        child: Column(
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Включить уведомления'),
              value: settings?.notificationsEnabled ?? true,
              onChanged: (value) {
                // TODO: Реализовать обновление настроек
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Email уведомления'),
              value: settings?.emailNotifications ?? false,
              onChanged: (value) {
                // TODO: Реализовать обновление настроек
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Push уведомления'),
              value: settings?.pushNotifications ?? true,
              onChanged: (value) {
                // TODO: Реализовать обновление настроек
              },
            ),
          ],
        ),
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
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
            'Версия 0.1.0',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 32),
          _SettingsCard(
            title: 'О приложении',
            child: Column(
              children: [
                const Text(
                  'Goida AI - это приложение для управления личными финансами с интеграцией искусственного интеллекта.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Функции:\n'
                  '• Учет активов и транзакций\n'
                  '• Анализ расходов\n'
                  '• ИИ-ассистент\n'
                  '• Распознавание чеков\n'
                  '• Уведомления и напоминания\n'
                  '• Мультивалютность',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SettingsCard(
            title: 'Контакты',
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
