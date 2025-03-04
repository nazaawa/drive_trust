import 'package:equatable/equatable.dart';

class SettingsEntity extends Equatable {
  final bool isDarkMode;
  final String language;
  final bool notificationsEnabled;
  final String currency;
  final String distanceUnit; // km or miles
  final String fuelUnit; // liter or gallon
  final bool autoBackupEnabled;

  const SettingsEntity({
    this.isDarkMode = false,
    this.language = 'fr',
    this.notificationsEnabled = true,
    this.currency = '€',
    this.distanceUnit = 'km',
    this.fuelUnit = 'liter',
    this.autoBackupEnabled = false,
  });

  SettingsEntity copyWith({
    bool? isDarkMode,
    String? language,
    bool? notificationsEnabled,
    String? currency,
    String? distanceUnit,
    String? fuelUnit,
    bool? autoBackupEnabled,
  }) {
    return SettingsEntity(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      currency: currency ?? this.currency,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      fuelUnit: fuelUnit ?? this.fuelUnit,
      autoBackupEnabled: autoBackupEnabled ?? this.autoBackupEnabled,
    );
  }

  @override
  List<Object?> get props => [
        isDarkMode,
        language,
        notificationsEnabled,
        currency,
        distanceUnit,
        fuelUnit,
        autoBackupEnabled,
      ];
}
