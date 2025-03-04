import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_trust/features/auth/presentation/providers/auth_provider.dart';
import 'package:drive_trust/features/drivers/data/datasources/driver_remote_datasource.dart';
import 'package:drive_trust/features/drivers/data/repositories/driver_repository_impl.dart';
import 'package:drive_trust/features/drivers/domain/entities/driver.dart';
import 'package:drive_trust/features/drivers/domain/usecases/add_driver_usecase.dart';
import 'package:drive_trust/features/drivers/domain/usecases/assign_driver_to_vehicle_usecase.dart';
import 'package:drive_trust/features/drivers/domain/usecases/delete_driver_usecase.dart';
import 'package:drive_trust/features/drivers/domain/usecases/get_drivers_usecase.dart';
import 'package:drive_trust/features/drivers/domain/usecases/unassign_driver_from_vehicle_usecase.dart';
import 'package:drive_trust/features/drivers/domain/usecases/update_driver_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'driver_provider.g.dart';

@Riverpod(keepAlive: true)
DriverRemoteDataSource driverRemoteDataSource(Ref ref) {
  return DriverRemoteDataSourceImpl(firestore: FirebaseFirestore.instance);
}

@Riverpod(keepAlive: true)
DriverRepositoryImpl driverRepository(Ref ref) {
  return DriverRepositoryImpl(
    remoteDataSource: ref.watch(driverRemoteDataSourceProvider),
    firebaseAuth: ref.watch(firebaseAuthProvider),
  );
}

@Riverpod(keepAlive: true)
GetDriversUseCase getDriversUseCase(Ref ref) {
  return GetDriversUseCase(ref.watch(driverRepositoryProvider));
}

@Riverpod(keepAlive: true)
AddDriverUseCase addDriverUseCase(Ref ref) {
  return AddDriverUseCase(ref.watch(driverRepositoryProvider));
}

@Riverpod(keepAlive: true)
UpdateDriverUseCase updateDriverUseCase(Ref ref) {
  return UpdateDriverUseCase(ref.watch(driverRepositoryProvider));
}

@Riverpod(keepAlive: true)
DeleteDriverUseCase deleteDriverUseCase(Ref ref) {
  return DeleteDriverUseCase(ref.watch(driverRepositoryProvider));
}

@Riverpod(keepAlive: true)
AssignDriverToVehicleUseCase assignDriverToVehicleUseCase(Ref ref) {
  return AssignDriverToVehicleUseCase(ref.watch(driverRepositoryProvider));
}

@Riverpod(keepAlive: true)
UnassignDriverFromVehicleUseCase unassignDriverFromVehicleUseCase(Ref ref) {
  return UnassignDriverFromVehicleUseCase(ref.watch(driverRepositoryProvider));
}

@riverpod
class DriverNotifier extends _$DriverNotifier {
  @override
  FutureOr<List<Driver>> build() {
    _fetchDrivers();
    return [];
  }

  Future<void> _fetchDrivers() async {
    state = const AsyncLoading();

    final user = ref.read(userNotifierProvider).value;
    if (user == null) {
      state = const AsyncData([]);
      return;
    }

    final result = await ref.read(getDriversUseCaseProvider).call(
          GetDriversParams(ownerId: user.uid),
        );

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (drivers) => AsyncData(drivers),
    );
  }

  Future<void> addDriver(String name, String email, {String? vehicleId}) async {
    state = const AsyncLoading();

    final result = await ref.read(addDriverUseCaseProvider).call(
          AddDriverParams(
            name: name,
            email: email,
            vehicleId: vehicleId,
          ),
        );

    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (driver) {
        final currentDrivers = state.value ?? [];
        state = AsyncData([...currentDrivers, driver]);
      },
    );
  }

  Future<void> updateDriver(Driver driver) async {
    state = const AsyncLoading();

    final result = await ref.read(updateDriverUseCaseProvider).call(
          UpdateDriverParams(driver: driver),
        );

    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (updatedDriver) {
        final currentDrivers = state.value ?? [];
        final index =
            currentDrivers.indexWhere((d) => d.id == updatedDriver.id);
        if (index != -1) {
          final updatedDrivers = List<Driver>.from(currentDrivers);
          updatedDrivers[index] = updatedDriver;
          state = AsyncData(updatedDrivers);
        } else {
          state = AsyncData(currentDrivers);
        }
      },
    );
  }

  Future<void> deleteDriver(String driverId) async {
    state = const AsyncLoading();

    final result = await ref.read(deleteDriverUseCaseProvider).call(
          DeleteDriverParams(driverId: driverId),
        );

    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (_) {
        final currentDrivers = state.value ?? [];
        final updatedDrivers =
            currentDrivers.where((d) => d.id != driverId).toList();
        state = AsyncData(updatedDrivers);
      },
    );
  }

  Future<void> assignDriverToVehicle(String driverId, String vehicleId) async {
    state = const AsyncLoading();

    final result = await ref.read(assignDriverToVehicleUseCaseProvider).call(
          AssignDriverToVehicleParams(
            driverId: driverId,
            vehicleId: vehicleId,
          ),
        );

    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (updatedDriver) {
        final currentDrivers = state.value ?? [];
        final index =
            currentDrivers.indexWhere((d) => d.id == updatedDriver.id);
        if (index != -1) {
          final updatedDrivers = List<Driver>.from(currentDrivers);
          updatedDrivers[index] = updatedDriver;
          state = AsyncData(updatedDrivers);
        } else {
          state = AsyncData(currentDrivers);
        }
      },
    );
  }

  Future<void> unassignDriverFromVehicle(String driverId) async {
    state = const AsyncLoading();

    final result =
        await ref.read(unassignDriverFromVehicleUseCaseProvider).call(
              UnassignDriverFromVehicleParams(driverId: driverId),
            );

    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (updatedDriver) {
        final currentDrivers = state.value ?? [];
        final index =
            currentDrivers.indexWhere((d) => d.id == updatedDriver.id);
        if (index != -1) {
          final updatedDrivers = List<Driver>.from(currentDrivers);
          updatedDrivers[index] = updatedDriver;
          state = AsyncData(updatedDrivers);
        } else {
          state = AsyncData(currentDrivers);
        }
      },
    );
  }

  Future<void> refreshDrivers() async {
    await _fetchDrivers();
  }
}
