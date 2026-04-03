import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/ios_design_system.dart';
import '../../l10n/app_localizations.dart';
import '../providers/app_settings_provider.dart';
import '../providers/auth_provider.dart';
import '../../data/models/user_settings.dart';

/// Экран Настройки в едином стиле iOS Settings.app
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appSettings = context.watch<AppSettingsProvider>();
    final authProvider = context.watch<AuthProvider>();
    final l10n = AppLocalizations.of(context)!;

    final settings = appSettings.settings;
    final profile = appSettings.profile;
    final fullName = settings?.fullName ?? profile?.displayName ?? authProvider.displayName;
    final email = settings?.email ?? profile?.email ?? authProvider.email;
    final avatarUrl = settings?.avatarUrl ?? profile?.avatarUrl ?? authProvider.avatarUrl;

    return Scaffold(
      backgroundColor: IosDesignSystem.getSystemGroupedBackground(context),
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: IosDesignSystem.getSystemBackground(context).withValues(alpha: 0.95),
        elevation: 0,
        foregroundColor: IosDesignSystem.getLabelPrimary(context),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverPadding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
            ),

            // Профиль карточка
            SliverToBoxAdapter(
              child: _buildProfileCard(context, fullName, email, avatarUrl, appSettings, l10n),
            ),

            const SliverPadding(
              padding: EdgeInsets.only(bottom: IosDesignSystem.sectionSpacing),
            ),

            // USAGE & BILLING секция
            _buildSection(
              context: context,
              header: l10n.usageAndBilling,
              children: [
                _buildListTile(
                  context: context,
                  icon: CupertinoIcons.creditcard,
                  title: l10n.monthlyBudget,
                  value: '\$${(settings?.monthlyBudget ?? 0).toStringAsFixed(2)}',
                  onTap: () => _showBudgetDialog(context, appSettings, l10n),
                ),
                _buildListTile(
                  context: context,
                  icon: CupertinoIcons.doc_text,
                  title: l10n.billingHistory,
                  onTap: () {},
                ),
              ],
            ),

            const SliverPadding(
              padding: EdgeInsets.only(bottom: IosDesignSystem.sectionSpacing),
            ),

            // APPEARANCE секция
            _buildSection(
              context: context,
              header: l10n.appearanceSection,
              children: [
                _buildListTile(
                  context: context,
                  icon: CupertinoIcons.paintbrush,
                  title: l10n.theme,
                  value: _getThemeName(appSettings.appTheme, l10n),
                  onTap: () => _showThemeDialog(context, appSettings, l10n),
                ),
                _buildListTile(
                  context: context,
                  icon: CupertinoIcons.globe,
                  title: l10n.language,
                  value: _getLanguageName(appSettings.appLanguage, l10n),
                  onTap: () => _showLanguageDialog(context, appSettings, l10n),
                ),
              ],
            ),

            const SliverPadding(
              padding: EdgeInsets.only(bottom: IosDesignSystem.sectionSpacing),
            ),

            // NOTIFICATIONS секция
            _buildSection(
              context: context,
              header: l10n.notificationsSection,
              children: [
                _buildSwitchTile(
                  context: context,
                  icon: CupertinoIcons.mail,
                  title: l10n.emailNotifications,
                  value: settings?.emailNotifications ?? false,
                  onChanged: (value) {
                    appSettings.updateSettings(emailNotifications: value);
                  },
                ),
                _buildSwitchTile(
                  context: context,
                  icon: CupertinoIcons.bell,
                  title: l10n.pushNotifications,
                  value: settings?.pushNotifications ?? true,
                  onChanged: (value) {
                    appSettings.updateSettings(pushNotifications: value);
                  },
                ),
              ],
            ),

            const SliverPadding(
              padding: EdgeInsets.only(bottom: IosDesignSystem.sectionSpacing),
            ),

            // SYSTEM секция
            _buildSection(
              context: context,
              header: l10n.systemSection,
              children: [
                _buildListTile(
                  context: context,
                  icon: CupertinoIcons.info,
                  title: l10n.about,
                  value: l10n.appVersion,
                  onTap: () => _showAboutDialog(context, l10n),
                ),
                _buildListTile(
                  context: context,
                  icon: CupertinoIcons.lock_shield,
                  title: l10n.privacyPolicy,
                  onTap: () {},
                ),
              ],
            ),

            const SliverPadding(
              padding: EdgeInsets.only(bottom: 40),
            ),

            // Sign Out кнопка
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: IosDesignSystem.paddingMedium),
                child: CupertinoButton(
                  color: IosDesignSystem.errorRed,
                  onPressed: () => _showSignOutDialog(context, authProvider, l10n),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      l10n.signOut,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: IosDesignSystem.fontSizeBody,
                        fontWeight: IosDesignSystem.weightSemibold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SliverPadding(
              padding: EdgeInsets.only(bottom: 40),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    String fullName,
    String email,
    String? avatarUrl,
    AppSettingsProvider appSettings,
    AppLocalizations l10n,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: IosDesignSystem.paddingMedium),
      padding: const EdgeInsets.all(IosDesignSystem.paddingXLarge),
      decoration: BoxDecoration(
        color: IosDesignSystem.getSecondarySystemBackground(context),
        borderRadius: BorderRadius.circular(IosDesignSystem.radiusXLarge),
        border: Border.all(
          color: IosDesignSystem.getSeparator(context).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _showAvatarOptions(context, appSettings, l10n),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    IosDesignSystem.primaryAccent,
                    IosDesignSystem.successGreen,
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: IosDesignSystem.getLabelPrimary(context),
                  width: 3,
                ),
              ),
              child: const Icon(CupertinoIcons.person, color: Colors.white, size: 50),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            fullName,
            style: TextStyle(
              color: IosDesignSystem.getLabelPrimary(context),
              fontSize: IosDesignSystem.fontSizeTitle3,
              fontWeight: IosDesignSystem.weightBold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: TextStyle(
              color: IosDesignSystem.getLabelSecondary(context),
              fontSize: IosDesignSystem.fontSizeSubheadline,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => _showEditProfileDialog(context, appSettings, l10n),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: IosDesignSystem.primaryAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(IosDesignSystem.radiusMedium),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    CupertinoIcons.pencil,
                    color: IosDesignSystem.primaryAccent,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.editProfile,
                    style: const TextStyle(
                      color: IosDesignSystem.primaryAccent,
                      fontSize: IosDesignSystem.fontSizeFootnote,
                      fontWeight: IosDesignSystem.weightSemibold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String header,
    required List<Widget> children,
  }) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.only(
            left: IosDesignSystem.paddingMedium,
            bottom: IosDesignSystem.paddingSmall,
          ),
          child: Text(
            header,
            style: TextStyle(
              color: IosDesignSystem.getLabelSecondary(context),
              fontSize: IosDesignSystem.fontSizeFootnote,
              fontWeight: IosDesignSystem.weightSemibold,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: IosDesignSystem.paddingMedium),
          decoration: BoxDecoration(
            color: IosDesignSystem.getSecondarySystemBackground(context),
            borderRadius: BorderRadius.circular(IosDesignSystem.radiusMedium),
            border: Border.all(
              color: IosDesignSystem.getSeparator(context).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: children,
          ),
        ),
      ]),
    );
  }

  Widget _buildListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? value,
    VoidCallback? onTap,
  }) {
    return CupertinoButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(IosDesignSystem.paddingMedium),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: IosDesignSystem.getSeparator(context),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: IosDesignSystem.primaryAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(IosDesignSystem.radiusSmall),
              ),
              child: Icon(
                icon,
                color: IosDesignSystem.primaryAccent,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: IosDesignSystem.getLabelPrimary(context),
                  fontSize: IosDesignSystem.fontSizeBody,
                ),
              ),
            ),
            if (value != null) ...[
              Text(
                value,
                style: TextStyle(
                  color: IosDesignSystem.getLabelSecondary(context),
                  fontSize: IosDesignSystem.fontSizeSubheadline,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Icon(
              CupertinoIcons.chevron_right,
              color: IosDesignSystem.getLabelTertiary(context),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(IosDesignSystem.paddingMedium),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: IosDesignSystem.getSeparator(context),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: IosDesignSystem.primaryAccent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(IosDesignSystem.radiusSmall),
            ),
            child: Icon(
              icon,
              color: IosDesignSystem.primaryAccent,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: IosDesignSystem.getLabelPrimary(context),
                fontSize: IosDesignSystem.fontSizeBody,
              ),
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: IosDesignSystem.primaryAccent,
          ),
        ],
      ),
    );
  }

  String _getThemeName(AppTheme theme, AppLocalizations l10n) {
    switch (theme) {
      case AppTheme.light:
        return l10n.lightMode;
      case AppTheme.dark:
        return l10n.darkMode;
      case AppTheme.system:
        return l10n.systemMode;
    }
  }

  String _getLanguageName(AppLanguage language, AppLocalizations l10n) {
    switch (language) {
      case AppLanguage.russian:
        return l10n.russian;
      case AppLanguage.english:
        return l10n.english;
    }
  }

  void _showAvatarOptions(BuildContext context, AppSettingsProvider appSettings, AppLocalizations l10n) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(l10n.changeAvatar, style: const TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          CupertinoActionSheetAction(
            child: Text(l10n.chooseFromGallery),
            onPressed: () {
              Navigator.pop(context);
              appSettings.pickAndUploadAvatar();
            },
          ),
          CupertinoActionSheetAction(
            child: Text(l10n.deleteAvatar, style: const TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.pop(context);
              appSettings.deleteAvatar();
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(l10n.cancel),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, AppSettingsProvider appSettings, AppLocalizations l10n) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(l10n.themeDialogTitle, style: const TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          CupertinoActionSheetAction(
            child: Row(
              children: [
                Icon(
                  Icons.light_mode_rounded,
                  color: appSettings.appTheme == AppTheme.light 
                    ? IosDesignSystem.primaryAccent 
                    : IosDesignSystem.getLabelSecondary(context),
                ),
                const SizedBox(width: 12),
                Text(l10n.lightMode),
                if (appSettings.appTheme == AppTheme.light) ...[
                  const Spacer(),
                  Icon(
                    CupertinoIcons.check_mark,
                    color: IosDesignSystem.primaryAccent,
                  ),
                ],
              ],
            ),
            onPressed: () {
              Navigator.pop(context);
              appSettings.changeTheme(AppTheme.light);
            },
          ),
          CupertinoActionSheetAction(
            child: Row(
              children: [
                Icon(
                  Icons.dark_mode_rounded,
                  color: appSettings.appTheme == AppTheme.dark 
                    ? IosDesignSystem.primaryAccent 
                    : IosDesignSystem.getLabelSecondary(context),
                ),
                const SizedBox(width: 12),
                Text(l10n.darkMode),
                if (appSettings.appTheme == AppTheme.dark) ...[
                  const Spacer(),
                  Icon(
                    CupertinoIcons.check_mark,
                    color: IosDesignSystem.primaryAccent,
                  ),
                ],
              ],
            ),
            onPressed: () {
              Navigator.pop(context);
              appSettings.changeTheme(AppTheme.dark);
            },
          ),
          CupertinoActionSheetAction(
            child: Row(
              children: [
                Icon(
                  Icons.phone_android_rounded,
                  color: appSettings.appTheme == AppTheme.system 
                    ? IosDesignSystem.primaryAccent 
                    : IosDesignSystem.getLabelSecondary(context),
                ),
                const SizedBox(width: 12),
                Text(l10n.systemMode),
                if (appSettings.appTheme == AppTheme.system) ...[
                  const Spacer(),
                  Icon(
                    CupertinoIcons.check_mark,
                    color: IosDesignSystem.primaryAccent,
                  ),
                ],
              ],
            ),
            onPressed: () {
              Navigator.pop(context);
              appSettings.changeTheme(AppTheme.system);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(l10n.cancel),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, AppSettingsProvider appSettings, AppLocalizations l10n) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(l10n.languageDialogTitle, style: const TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          CupertinoActionSheetAction(
            child: Row(
              children: [
                Icon(
                  Icons.language_rounded,
                  color: appSettings.appLanguage == AppLanguage.russian 
                    ? IosDesignSystem.primaryAccent 
                    : IosDesignSystem.getLabelSecondary(context),
                ),
                const SizedBox(width: 12),
                Text(l10n.russian),
                if (appSettings.appLanguage == AppLanguage.russian) ...[
                  const Spacer(),
                  Icon(
                    CupertinoIcons.check_mark,
                    color: IosDesignSystem.primaryAccent,
                  ),
                ],
              ],
            ),
            onPressed: () {
              Navigator.pop(context);
              appSettings.changeLanguage(AppLanguage.russian);
            },
          ),
          CupertinoActionSheetAction(
            child: Row(
              children: [
                Icon(
                  Icons.translate_rounded,
                  color: appSettings.appLanguage == AppLanguage.english 
                    ? IosDesignSystem.primaryAccent 
                    : IosDesignSystem.getLabelSecondary(context),
                ),
                const SizedBox(width: 12),
                Text(l10n.english),
                if (appSettings.appLanguage == AppLanguage.english) ...[
                  const Spacer(),
                  Icon(
                    CupertinoIcons.check_mark,
                    color: IosDesignSystem.primaryAccent,
                  ),
                ],
              ],
            ),
            onPressed: () {
              Navigator.pop(context);
              appSettings.changeLanguage(AppLanguage.english);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(l10n.cancel),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showBudgetDialog(BuildContext context, AppSettingsProvider appSettings, AppLocalizations l10n) {
    final controller = TextEditingController(
      text: (appSettings.settings?.monthlyBudget ?? 0).toString(),
    );

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(l10n.budgetDialogTitle),
        content: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: CupertinoTextField(
            controller: controller,
            placeholder: l10n.enterBudget,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: IosDesignSystem.getSystemBackground(context),
              borderRadius: BorderRadius.circular(IosDesignSystem.radiusSmall),
              border: Border.all(
                color: IosDesignSystem.getSeparator(context),
              ),
            ),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(l10n.cancel),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(l10n.save),
            onPressed: () {
              final budget = double.tryParse(controller.text) ?? 0.0;
              appSettings.updateSettings(monthlyBudget: budget);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, AppSettingsProvider appSettings, AppLocalizations l10n) {
    final controller = TextEditingController(
      text: appSettings.settings?.fullName ?? appSettings.displayName,
    );

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(l10n.editProfile),
        content: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: CupertinoTextField(
            controller: controller,
            placeholder: l10n.enterFullName,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: IosDesignSystem.getSystemBackground(context),
              borderRadius: BorderRadius.circular(IosDesignSystem.radiusSmall),
              border: Border.all(
                color: IosDesignSystem.getSeparator(context),
              ),
            ),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(l10n.cancel),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(l10n.save),
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                appSettings.updateSettings(fullName: name);
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context, AppLocalizations l10n) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(l10n.aboutDialogTitle),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${l10n.version} ${l10n.appVersion}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: IosDesignSystem.getLabelPrimary(context),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.appDescriptionFull,
                style: TextStyle(
                  color: IosDesignSystem.getLabelSecondary(context),
                ),
              ),
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(l10n.done),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, AuthProvider authProvider, AppLocalizations l10n) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(l10n.signOut),
        content: Text(l10n.signOutConfirm),
        actions: [
          CupertinoDialogAction(
            child: Text(l10n.cancel),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text(l10n.signOut),
            onPressed: () {
              Navigator.pop(context);
              authProvider.signOut();
            },
          ),
        ],
      ),
    );
  }
}
