import 'package:drive_trust/features/settings/domain/entities/settings_entity.dart';

class SettingsModel extends SettingsEntity {
  const SettingsModel({
    super.isDarkMode,
    super.language,
    super.notificationsEnabled,
    super.currency,
    super.distanceUnit,
    super.fuelUnit,
    super.autoBackupEnabled,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      isDarkMode: json['isDarkMode'] ?? false,
      language: json['language'] ?? 'fr',
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      currency: json['currency'] ?? '€',
      distanceUnit: json['distanceUnit'] ?? 'km',
      fuelUnit: json['fuelUnit'] ?? 'liter',
      autoBackupEnabled: json['autoBackupEnabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'language': language,
      'notificationsEnabled': notificationsEnabled,
      'currency': currency,
      'distanceUnit': distanceUnit,
      'fuelUnit': fuelUnit,
      'autoBackupEnabled': autoBackupEnabled,
    };
  }

  factory SettingsModel.fromEntity(SettingsEntity entity) {
    return SettingsModel(
      isDarkMode: entity.isDarkMode,
      language: entity.language,
      notificationsEnabled: entity.notificationsEnabled,
      currency: entity.currency,
      distanceUnit: entity.distanceUnit,
      fuelUnit: entity.fuelUnit,
      autoBackupEnabled: entity.autoBackupEnabled,
    );
  }
}
