import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/settings_provider.dart';
import '../../services/auth_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  String _getThemeName(BuildContext context, ThemeMode mode) {
    final l10n = AppLocalizations.of(context)!;
    switch (mode) {
      case ThemeMode.system:
        return l10n.settingsThemeSystem;
      case ThemeMode.light:
        return l10n.settingsThemeLight;
      case ThemeMode.dark:
        return l10n.settingsThemeDark;
    }
  }

  String _getLanguageName(BuildContext context, String code) {
    final l10n = AppLocalizations.of(context)!;
    switch (code) {
      case 'en':
        return l10n.settingsLanguageEnglish;
      case 'zh':
        return l10n.settingsLanguageChinese;
      default:
        return l10n.settingsLanguageSystem;
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final authService = AuthService();
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final currentUser = authService.currentUser;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: ListView(
        children: [
          _buildSectionHeader(l10n.settingsAppearance, colorScheme),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text(l10n.settingsTheme),
            subtitle: Text(_getThemeName(context, settingsProvider.themeMode)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemePicker(context, settingsProvider),
          ),
          const Divider(height: 1),
          _buildSectionHeader(l10n.settingsPreferences, colorScheme),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: Text(l10n.settingsLanguage),
            subtitle: Text(_getLanguageName(context, settingsProvider.languageCode)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguagePicker(context, settingsProvider),
          ),
          const Divider(height: 1),
          _buildSectionHeader(l10n.settingsDataManagement, colorScheme),
          ListTile(
            leading: const Icon(Icons.fingerprint),
            title: Text(l10n.settingsYourUserId),
            subtitle: Text(currentUser?.uid ?? 'N/A', overflow: TextOverflow.ellipsis),
            trailing: IconButton(
              icon: const Icon(Icons.copy),
              tooltip: l10n.settingsCopyId,
              onPressed: currentUser != null ? () {
                Clipboard.setData(ClipboardData(text: currentUser.uid));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User ID copied to clipboard!')), // TODO: Localize
                );
              } : null,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.restore_page_outlined),
            title: Text(l10n.settingsRestoreData),
            onTap: () => _showRestoreDialog(context),
          ),
          ListTile(
            leading: Icon(Icons.delete_forever_outlined, color: colorScheme.error),
            title: Text(l10n.settingsDeleteAccount, style: TextStyle(color: colorScheme.error)),
            onTap: () => _showDeleteAccountDialog(context, authService),
          ),
          const Divider(height: 1),
          _buildSectionHeader(l10n.settingsAbout, colorScheme),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.settingsVersion),
            trailing: Text(settingsProvider.version, style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  void _showRestoreDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final idController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsRestoreDataTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.settingsRestoreDataWarning),
            const SizedBox(height: 16),
            TextField(
              controller: idController,
              decoration: InputDecoration(
                labelText: l10n.settingsRestoreDataHint,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final oldId = idController.text.trim();
              if (oldId.isNotEmpty) {
                print("Initiating data restore from old UID: $oldId");
                // TODO: Implement Cloud Function call here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.settingsRestoreDataSuccess)),
                );
                Navigator.pop(context);
              }
            },
            child: Text(l10n.settingsRestoreDataConfirm),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, AuthService authService) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsDeleteAccount),
        content: Text(l10n.settingsDeleteAccountWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () async {
              final success = await authService.deleteCurrentUserAccount();
              Navigator.pop(context);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.settingsDeleteAccountSuccess)),
                );
                // In a real app, you might want to force a restart or navigate to a splash screen
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.settingsDeleteAccountError)),
                );
              }
            },
            child: Text(l10n.settingsDeleteAccountConfirm),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: colorScheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  void _showThemePicker(BuildContext context, SettingsProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(l10n.settingsTheme, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              _buildThemeOption(context, provider, l10n.settingsThemeSystem, ThemeMode.system, Icons.brightness_auto),
              _buildThemeOption(context, provider, l10n.settingsThemeLight, ThemeMode.light, Icons.light_mode),
              _buildThemeOption(context, provider, l10n.settingsThemeDark, ThemeMode.dark, Icons.dark_mode),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(BuildContext context, SettingsProvider provider, String title, ThemeMode mode, IconData icon) {
    final isSelected = provider.themeMode == mode;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Theme.of(context).colorScheme.primary : null),
      title: Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      trailing: isSelected ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
      onTap: () {
        provider.setThemeMode(mode);
        Navigator.pop(context);
      },
    );
  }

  void _showLanguagePicker(BuildContext context, SettingsProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    final supportedLanguages = {
      'system': l10n.settingsLanguageSystem,
      'en': l10n.settingsLanguageEnglish,
      'zh': l10n.settingsLanguageChinese,
    };

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(l10n.settingsLanguage, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ...supportedLanguages.entries.map((entry) {
                final isSelected = provider.languageCode == entry.key;
                return ListTile(
                  title: Text(entry.value, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                  trailing: isSelected ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
                  onTap: () {
                    provider.setLanguage(entry.key);
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
