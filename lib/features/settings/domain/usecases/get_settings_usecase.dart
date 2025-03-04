import 'package:drive_trust/features/settings/domain/entities/settings_entity.dart';
import 'package:drive_trust/features/settings/domain/repositories/settings_repository.dart';

class GetSettingsUseCase {
  final SettingsRepository repository;

  GetSettingsUseCase(this.repository);

  Future<SettingsEntity> call() async {
    return await repository.getSettings();
  }
}
