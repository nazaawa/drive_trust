import 'package:drive_trust/features/settings/domain/entities/settings_entity.dart';
import 'package:drive_trust/features/settings/presentation/providers/settings_provider.dart';
import 'package:drive_trust/features/settings/presentation/widgets/profile_header.dart';
import 'package:drive_trust/features/settings/presentation/widgets/settings_section.dart';
import 'package:drive_trust/features/settings/presentation/widgets/settings_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
    });
  }

  Future<void> _signOut() async {
    final navigator = Navigator.of(context);
    await FirebaseAuth.instance.signOut();
    // Navigate to login screen
    navigator.pushNamedAndRemoveUntil('/login', (route) => false);
  }

  Future<void> _launchPrivacyPolicy() async {
    const url = 'https://drivetrust.com/privacy-policy';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d\'ouvrir la page')),
        );
      }
    }
  }

  Future<void> _showLanguageDialog() async {
    final settings = ref.read(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    
    final languages = {
      'fr': 'Français',
      'en': 'English',
    };
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir la langue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.entries.map((entry) {
            return RadioListTile<String>(
              title: Text(entry.value),
              value: entry.key,
              groupValue: settings.language,
              onChanged: (value) {
                if (value != null) {
                  settingsNotifier.setLanguage(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  Future<void> _showCurrencyDialog() async {
    final settings = ref.read(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    
    final currencies = {
      '€': 'Euro (€)',
      '\$': 'Dollar (\$)',
      '£': 'Livre Sterling (£)',
      'FCFA': 'Franc CFA (FCFA)',
    };
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir la devise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: currencies.entries.map((entry) {
            return RadioListTile<String>(
              title: Text(entry.value),
              value: entry.key,
              groupValue: settings.currency,
              onChanged: (value) {
                if (value != null) {
                  settingsNotifier.setCurrency(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  Future<void> _showUnitDialog(String type) async {
    final settings = ref.read(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    
    Map<String, String> units;
    String title;
    String currentValue;
    Function(String) updateFunction;
    
    if (type == 'distance') {
      units = {
        'km': 'Kilomètres (km)',
        'miles': 'Miles',
      };
      title = 'Unité de distance';
      currentValue = settings.distanceUnit;
      updateFunction = settingsNotifier.setDistanceUnit;
    } else {
      units = {
        'liter': 'Litres (L)',
        'gallon': 'Gallons (gal)',
      };
      title = 'Unité de carburant';
      currentValue = settings.fuelUnit;
      updateFunction = settingsNotifier.setFuelUnit;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: units.entries.map((entry) {
            return RadioListTile<String>(
              title: Text(entry.value),
              value: entry.key,
              groupValue: currentValue,
              onChanged: (value) {
                if (value != null) {
                  updateFunction(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const ProfileHeader(),
              const SizedBox(height: 16),
              SettingsSection(
                title: 'PRÉFÉRENCES D\'AFFICHAGE',
                children: [
                  SettingsTile(
                    icon: Icons.dark_mode,
                    title: 'Mode sombre',
                    subtitle: settings.isDarkMode ? 'Activé' : 'Désactivé',
                    trailing: Switch(
                      value: settings.isDarkMode,
                      onChanged: (_) => settingsNotifier.toggleDarkMode(),
                    ),
                    onTap: () => settingsNotifier.toggleDarkMode(),
                  ),
                  SettingsTile(
                    icon: Icons.language,
                    title: 'Langue',
                    subtitle: settings.language == 'fr' ? 'Français' : 'English',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: _showLanguageDialog,
                  ),
                  SettingsTile(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    subtitle: settings.notificationsEnabled
                        ? 'Activées'
                        : 'Désactivées',
                    trailing: Switch(
                      value: settings.notificationsEnabled,
                      onChanged: (_) => settingsNotifier.toggleNotifications(),
                    ),
                    onTap: () => settingsNotifier.toggleNotifications(),
                    showDivider: false,
                  ),
                ],
              ),
              SettingsSection(
                title: 'UNITÉS ET MESURES',
                children: [
                  SettingsTile(
                    icon: Icons.euro,
                    title: 'Devise',
                    subtitle: settings.currency,
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: _showCurrencyDialog,
                  ),
                  SettingsTile(
                    icon: Icons.speed,
                    title: 'Unité de distance',
                    subtitle: settings.distanceUnit == 'km'
                        ? 'Kilomètres (km)'
                        : 'Miles',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showUnitDialog('distance'),
                  ),
                  SettingsTile(
                    icon: Icons.local_gas_station,
                    title: 'Unité de carburant',
                    subtitle: settings.fuelUnit == 'liter'
                        ? 'Litres (L)'
                        : 'Gallons (gal)',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showUnitDialog('fuel'),
                    showDivider: false,
                  ),
                ],
              ),
              SettingsSection(
                title: 'DONNÉES ET SAUVEGARDE',
                children: [
                  SettingsTile(
                    icon: Icons.backup,
                    title: 'Sauvegarde automatique',
                    subtitle: settings.autoBackupEnabled
                        ? 'Activée'
                        : 'Désactivée',
                    trailing: Switch(
                      value: settings.autoBackupEnabled,
                      onChanged: (_) => settingsNotifier.toggleAutoBackup(),
                    ),
                    onTap: () => settingsNotifier.toggleAutoBackup(),
                  ),
                  SettingsTile(
                    icon: Icons.cloud_download,
                    title: 'Exporter les données',
                    subtitle: 'Exporter toutes vos données au format CSV',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fonctionnalité à venir'),
                        ),
                      );
                    },
                    showDivider: false,
                  ),
                ],
              ),
              SettingsSection(
                title: 'COMPTE ET SÉCURITÉ',
                children: [
                  SettingsTile(
                    icon: Icons.person,
                    iconColor: Colors.blue,
                    title: 'Modifier le profil',
                    subtitle: 'Changer votre nom, photo et informations',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fonctionnalité à venir'),
                        ),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.lock,
                    iconColor: Colors.orange,
                    title: 'Changer le mot de passe',
                    subtitle: 'Mettre à jour votre mot de passe',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fonctionnalité à venir'),
                        ),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.logout,
                    iconColor: Colors.red,
                    title: 'Déconnexion',
                    subtitle: 'Se déconnecter de l\'application',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Déconnexion'),
                          content: const Text(
                              'Êtes-vous sûr de vouloir vous déconnecter ?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Annuler'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _signOut();
                              },
                              child: const Text('Déconnexion'),
                            ),
                          ],
                        ),
                      );
                    },
                    showDivider: false,
                  ),
                ],
              ),
              SettingsSection(
                title: 'À PROPOS',
                children: [
                  SettingsTile(
                    icon: Icons.info,
                    title: 'Version de l\'application',
                    subtitle: _appVersion,
                    onTap: null,
                  ),
                  SettingsTile(
                    icon: Icons.privacy_tip,
                    title: 'Politique de confidentialité',
                    onTap: _launchPrivacyPolicy,
                  ),
                  SettingsTile(
                    icon: Icons.help,
                    title: 'Aide et support',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fonctionnalité à venir'),
                        ),
                      );
                    },
                    showDivider: false,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                '  ${DateTime.now().year} DriveTrust',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
