// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$driverRemoteDataSourceHash() =>
    r'2043612ee159de503f23214fcc92a3ea2d85018e';

/// See also [driverRemoteDataSource].
@ProviderFor(driverRemoteDataSource)
final driverRemoteDataSourceProvider =
    Provider<DriverRemoteDataSource>.internal(
  driverRemoteDataSource,
  name: r'driverRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$driverRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DriverRemoteDataSourceRef = ProviderRef<DriverRemoteDataSource>;
String _$driverRepositoryHash() => r'4314974c9ad9066dacfbc623e34b5eb52ddf1fb1';

/// See also [driverRepository].
@ProviderFor(driverRepository)
final driverRepositoryProvider = Provider<DriverRepositoryImpl>.internal(
  driverRepository,
  name: r'driverRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$driverRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DriverRepositoryRef = ProviderRef<DriverRepositoryImpl>;
String _$getDriversUseCaseHash() => r'5b4c6fcddf023eb1c82a1ace4111ede86672a0be';

/// See also [getDriversUseCase].
@ProviderFor(getDriversUseCase)
final getDriversUseCaseProvider = Provider<GetDriversUseCase>.internal(
  getDriversUseCase,
  name: r'getDriversUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getDriversUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetDriversUseCaseRef = ProviderRef<GetDriversUseCase>;
String _$addDriverUseCaseHash() => r'24e24627e7c1c6ec53e16e459ac5d63bb4a34821';

/// See also [addDriverUseCase].
@ProviderFor(addDriverUseCase)
final addDriverUseCaseProvider = Provider<AddDriverUseCase>.internal(
  addDriverUseCase,
  name: r'addDriverUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$addDriverUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AddDriverUseCaseRef = ProviderRef<AddDriverUseCase>;
String _$updateDriverUseCaseHash() =>
    r'0a5cca06fd907b47124ae7cfee7b51de817a2ad2';

/// See also [updateDriverUseCase].
@ProviderFor(updateDriverUseCase)
final updateDriverUseCaseProvider = Provider<UpdateDriverUseCase>.internal(
  updateDriverUseCase,
  name: r'updateDriverUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateDriverUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpdateDriverUseCaseRef = ProviderRef<UpdateDriverUseCase>;
String _$deleteDriverUseCaseHash() =>
    r'090c6972588de6cc9cc683bd9380246bd66b7616';

/// See also [deleteDriverUseCase].
@ProviderFor(deleteDriverUseCase)
final deleteDriverUseCaseProvider = Provider<DeleteDriverUseCase>.internal(
  deleteDriverUseCase,
  name: r'deleteDriverUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$deleteDriverUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DeleteDriverUseCaseRef = ProviderRef<DeleteDriverUseCase>;
String _$assignDriverToVehicleUseCaseHash() =>
    r'9d71189ae4606e7170cd4cfe031870de98da625a';

/// See also [assignDriverToVehicleUseCase].
@ProviderFor(assignDriverToVehicleUseCase)
final assignDriverToVehicleUseCaseProvider =
    Provider<AssignDriverToVehicleUseCase>.internal(
  assignDriverToVehicleUseCase,
  name: r'assignDriverToVehicleUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$assignDriverToVehicleUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AssignDriverToVehicleUseCaseRef
    = ProviderRef<AssignDriverToVehicleUseCase>;
String _$unassignDriverFromVehicleUseCaseHash() =>
    r'8040a5d34a845e3235518d9080be22ead49121ec';

/// See also [unassignDriverFromVehicleUseCase].
@ProviderFor(unassignDriverFromVehicleUseCase)
final unassignDriverFromVehicleUseCaseProvider =
    Provider<UnassignDriverFromVehicleUseCase>.internal(
  unassignDriverFromVehicleUseCase,
  name: r'unassignDriverFromVehicleUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unassignDriverFromVehicleUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UnassignDriverFromVehicleUseCaseRef
    = ProviderRef<UnassignDriverFromVehicleUseCase>;
String _$driverNotifierHash() => r'b61ecb01c1e01f6cc98637eabb481f34bbb91d66';

/// See also [DriverNotifier].
@ProviderFor(DriverNotifier)
final driverNotifierProvider =
    AutoDisposeAsyncNotifierProvider<DriverNotifier, List<Driver>>.internal(
  DriverNotifier.new,
  name: r'driverNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$driverNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DriverNotifier = AutoDisposeAsyncNotifier<List<Driver>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
