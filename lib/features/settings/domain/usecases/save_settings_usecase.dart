import 'package:drive_trust/features/settings/domain/entities/settings_entity.dart';
import 'package:drive_trust/features/settings/domain/repositories/settings_repository.dart';

class SaveSettingsUseCase {
  final SettingsRepository repository;

  SaveSettingsUseCase(this.repository);

  Future<void> call(SettingsEntity settings) async {
    await repository.saveSettings(settings);
  }
}
