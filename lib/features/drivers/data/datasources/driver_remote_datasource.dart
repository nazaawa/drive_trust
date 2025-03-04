import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_trust/features/drivers/data/models/driver_model.dart';
import 'package:drive_trust/features/drivers/domain/entities/driver.dart';

abstract class DriverRemoteDataSource {
  Future<List<DriverModel>> getDriversByOwnerId(String ownerId);
  Future<List<DriverModel>> getDriversByVehicleId(String vehicleId);
  Future<DriverModel> getDriverById(String id);
  Future<DriverModel> addDriver(
    String ownerId,
    String name,
    String email,
    String? vehicleId,
    ContractStatus contractStatus,
  );
  Future<DriverModel> updateDriver(DriverModel driver);
  Future<void> deleteDriver(String id);
  Future<DriverModel> assignDriverToVehicle(
    String driverId,
    String vehicleId,
    ContractStatus contractStatus,
  );
  Future<DriverModel> unassignDriverFromVehicle(String driverId);
}

class DriverRemoteDataSourceImpl implements DriverRemoteDataSource {
  final FirebaseFirestore firestore;

  DriverRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<DriverModel>> getDriversByOwnerId(String ownerId) async {
    final driversCollection = await firestore
        .collection('drivers')
        .where('ownerId', isEqualTo: ownerId)
        .get();

    return driversCollection.docs
        .map((doc) => DriverModel.fromJson({
              'id': doc.id,
              ...doc.data(),
            }))
        .toList();
  }

  @override
  Future<List<DriverModel>> getDriversByVehicleId(String vehicleId) async {
    final driversCollection = await firestore
        .collection('drivers')
        .where('vehicleId', isEqualTo: vehicleId)
        .get();

    return driversCollection.docs
        .map((doc) => DriverModel.fromJson({
              'id': doc.id,
              ...doc.data(),
            }))
        .toList();
  }

  @override
  Future<DriverModel> getDriverById(String id) async {
    final driverDoc = await firestore.collection('drivers').doc(id).get();

    if (!driverDoc.exists) {
      throw Exception('Driver not found');
    }

    return DriverModel.fromJson({
      'id': driverDoc.id,
      ...driverDoc.data()!,
    });
  }

  @override
  Future<DriverModel> addDriver(
    String ownerId,
    String name,
    String email,
    String? vehicleId,
    ContractStatus contractStatus,
  ) async {
    final driverData = {
      'ownerId': ownerId,
      'name': name,
      'email': email,
      'vehicleId': vehicleId,
      'contractStatus': contractStatus.toString().split('.').last,
      'createdAt': FieldValue.serverTimestamp(),
    };

    final docRef = await firestore.collection('drivers').add(driverData);
    
    return DriverModel(
      id: docRef.id,
      name: name,
      email: email,
      vehicleId: vehicleId,
      contractStatus: contractStatus,
    );
  }

  @override
  Future<DriverModel> updateDriver(DriverModel driver) async {
    await firestore.collection('drivers').doc(driver.id).update({
      'name': driver.name,
      'email': driver.email,
      'vehicleId': driver.vehicleId,
      'contractStatus': driver.contractStatus.toString().split('.').last,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return driver;
  }

  @override
  Future<void> deleteDriver(String id) async {
    await firestore.collection('drivers').doc(id).delete();
  }

  @override
  Future<DriverModel> assignDriverToVehicle(
    String driverId,
    String vehicleId,
    ContractStatus contractStatus,
  ) async {
    // Get the driver first
    final driverDoc = await firestore.collection('drivers').doc(driverId).get();
    
    if (!driverDoc.exists) {
      throw Exception('Driver not found');
    }
    
    // Update the driver with the vehicle ID and contract status
    await firestore.collection('drivers').doc(driverId).update({
      'vehicleId': vehicleId,
      'contractStatus': contractStatus.toString().split('.').last,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    
    // Return the updated driver
    final updatedDriverDoc = await firestore.collection('drivers').doc(driverId).get();
    
    return DriverModel.fromJson({
      'id': updatedDriverDoc.id,
      ...updatedDriverDoc.data()!,
    });
  }

  @override
  Future<DriverModel> unassignDriverFromVehicle(String driverId) async {
    // Get the driver first
    final driverDoc = await firestore.collection('drivers').doc(driverId).get();
    
    if (!driverDoc.exists) {
      throw Exception('Driver not found');
    }
    
    // Update the driver to remove the vehicle ID and set contract status to inactive
    await firestore.collection('drivers').doc(driverId).update({
      'vehicleId': null,
      'contractStatus': ContractStatus.inactive.toString().split('.').last,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    
    // Return the updated driver
    final updatedDriverDoc = await firestore.collection('drivers').doc(driverId).get();
    
    return DriverModel.fromJson({
      'id': updatedDriverDoc.id,
      ...updatedDriverDoc.data()!,
    });
  }
}
