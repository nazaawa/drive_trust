import 'package:drive_trust/features/settings/data/models/settings_model.dart';
import 'package:drive_trust/features/settings/domain/entities/settings_entity.dart';
import 'package:drive_trust/features/settings/domain/repositories/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SettingsRepositoryImpl implements SettingsRepository {
  final String _settingsKey = 'app_settings';

  @override
  Future<SettingsEntity> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_settingsKey);
    
    if (settingsJson == null) {
      // Return default settings if none are saved
      return const SettingsEntity();
    }
    
    try {
      final Map<String, dynamic> decodedJson = json.decode(settingsJson);
      return SettingsModel.fromJson(decodedJson);
    } catch (e) {
      // Return default settings if there's an error parsing
      return const SettingsEntity();
    }
  }

  @override
  Future<void> saveSettings(SettingsEntity settings) async {
    final prefs = await SharedPreferences.getInstance();
    final settingsModel = settings is SettingsModel 
        ? settings as SettingsModel 
        : SettingsModel.fromEntity(settings);
    
    final encodedJson = json.encode(settingsModel.toJson());
    await prefs.setString(_settingsKey, encodedJson);
  }
}
