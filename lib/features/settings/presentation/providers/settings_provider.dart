import 'package:drive_trust/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:drive_trust/features/settings/domain/entities/settings_entity.dart';
import 'package:drive_trust/features/settings/domain/repositories/settings_repository.dart';
import 'package:drive_trust/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:drive_trust/features/settings/domain/usecases/save_settings_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repository provider
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl();
});

// Use case providers
final getSettingsUseCaseProvider = Provider<GetSettingsUseCase>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return GetSettingsUseCase(repository);
});

final saveSettingsUseCaseProvider = Provider<SaveSettingsUseCase>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return SaveSettingsUseCase(repository);
});

// Settings state notifier
class SettingsNotifier extends StateNotifier<SettingsEntity> {
  final GetSettingsUseCase _getSettingsUseCase;
  final SaveSettingsUseCase _saveSettingsUseCase;

  SettingsNotifier(this._getSettingsUseCase, this._saveSettingsUseCase)
      : super(const SettingsEntity()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _getSettingsUseCase();
    state = settings;
  }

  Future<void> updateSettings(SettingsEntity settings) async {
    state = settings;
    await _saveSettingsUseCase(settings);
  }

  Future<void> toggleDarkMode() async {
    final updatedSettings = state.copyWith(isDarkMode: !state.isDarkMode);
    await updateSettings(updatedSettings);
  }

  Future<void> setLanguage(String language) async {
    final updatedSettings = state.copyWith(language: language);
    await updateSettings(updatedSettings);
  }

  Future<void> toggleNotifications() async {
    final updatedSettings = state.copyWith(
        notificationsEnabled: !state.notificationsEnabled);
    await updateSettings(updatedSettings);
  }

  Future<void> setCurrency(String currency) async {
    final updatedSettings = state.copyWith(currency: currency);
    await updateSettings(updatedSettings);
  }

  Future<void> setDistanceUnit(String unit) async {
    final updatedSettings = state.copyWith(distanceUnit: unit);
    await updateSettings(updatedSettings);
  }

  Future<void> setFuelUnit(String unit) async {
    final updatedSettings = state.copyWith(fuelUnit: unit);
    await updateSettings(updatedSettings);
  }

  Future<void> toggleAutoBackup() async {
    final updatedSettings =
        state.copyWith(autoBackupEnabled: !state.autoBackupEnabled);
    await updateSettings(updatedSettings);
  }
}

// Settings provider
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsEntity>((ref) {
  final getSettingsUseCase = ref.watch(getSettingsUseCaseProvider);
  final saveSettingsUseCase = ref.watch(saveSettingsUseCaseProvider);
  return SettingsNotifier(getSettingsUseCase, saveSettingsUseCase);
});
