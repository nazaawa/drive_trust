import 'package:drive_trust/features/auth/presentation/providers/auth_provider.dart';
import 'package:drive_trust/features/vehicles/domain/entities/vehicle.dart';
import 'package:drive_trust/features/vehicles/domain/usecases/add_vehicle_usecase.dart';
import 'package:drive_trust/features/vehicles/domain/usecases/get_vehicles_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import these at the top of the file
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_trust/features/vehicles/data/datasources/vehicle_remote_datasource.dart';
import 'package:drive_trust/features/vehicles/data/repositories/vehicle_repository_impl.dart';

final vehicleProvider =
    StateNotifierProvider<VehicleNotifier, AsyncValue<List<Vehicle>>>((ref) {
  final currentUser = ref.watch(userNotifierProvider).value;
  final getVehiclesUseCase = ref.watch(getVehiclesUseCaseProvider);
  final addVehicleUseCase = ref.watch(addVehicleUseCaseProvider);

  return VehicleNotifier(
    getVehiclesUseCase: getVehiclesUseCase,
    addVehicleUseCase: addVehicleUseCase,
    userId: currentUser?.uid ?? '',
  );
});

// Stream provider to get a single vehicle by ID
final vehicleStreamProvider = StreamProvider.family<Vehicle, String>((ref, vehicleId) {
  final firestore = ref.watch(firestoreProvider);
  
  return firestore
      .collection('vehicles')
      .doc(vehicleId)
      .snapshots()
      .map((snapshot) {
    if (!snapshot.exists) {
      throw Exception('Vehicle not found');
    }
    
    final data = snapshot.data()!;
    return Vehicle(
      id: snapshot.id,
      ownerId: data['ownerId'] ?? '',
      plateNumber: data['plateNumber'] ?? '',
      brand: data['brand'] ?? '',
      model: data['model'] ?? '',
    );
  });
});

class VehicleNotifier extends StateNotifier<AsyncValue<List<Vehicle>>> {
  final GetVehiclesUseCase getVehiclesUseCase;
  final AddVehicleUseCase addVehicleUseCase;
  final String userId;

  VehicleNotifier({
    required this.getVehiclesUseCase,
    required this.addVehicleUseCase,
    required this.userId,
  }) : super(const AsyncValue.loading()) {
    if (userId.isNotEmpty) {
      getVehicles();
    }
  }

  Future<void> getVehicles() async {
    if (userId.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    final result = await getVehiclesUseCase(userId);

    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (vehicles) => state = AsyncValue.data(vehicles),
    );
  }

  Future<void> addVehicle({
    required String plateNumber,
    required String brand,
    required String model,
  }) async {
    if (userId.isEmpty) {
      state = AsyncValue.error('Utilisateur non connecté', StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();

    final params = AddVehicleParams(
      ownerId: userId,
      plateNumber: plateNumber,
      brand: brand,
      model: model,
    );

    final result = await addVehicleUseCase(params);

    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (vehicle) {
        final currentVehicles = state.value ?? [];
        state = AsyncValue.data([...currentVehicles, vehicle]);
      },
    );
  }
}

// Providers for use cases
final getVehiclesUseCaseProvider = Provider<GetVehiclesUseCase>((ref) {
  final repository = ref.watch(vehicleRepositoryProvider);
  return GetVehiclesUseCase(repository);
});

final addVehicleUseCaseProvider = Provider<AddVehicleUseCase>((ref) {
  final repository = ref.watch(vehicleRepositoryProvider);
  return AddVehicleUseCase(repository);
});

// Repository provider
final vehicleRepositoryProvider = Provider((ref) {
  final dataSource = ref.watch(vehicleRemoteDataSourceProvider);
  return VehicleRepositoryImpl(remoteDataSource: dataSource);
});

// Data source provider
final vehicleRemoteDataSourceProvider = Provider((ref) {
  final firestore = ref.watch(firestoreProvider);
  return VehicleRemoteDataSourceImpl(firestore: firestore);
});

// Firebase providers
final firestoreProvider = Provider((ref) {
  return FirebaseFirestore.instance;
});
