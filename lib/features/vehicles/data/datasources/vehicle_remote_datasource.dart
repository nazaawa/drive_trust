import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_trust/features/vehicles/data/models/vehicle_model.dart';

abstract class VehicleRemoteDataSource {
  Future<List<VehicleModel>> getVehiclesByOwnerId(String ownerId);
  Future<VehicleModel> getVehicleById(String id);
  Future<VehicleModel> addVehicle(
    String ownerId,
    String plateNumber,
    String brand,
    String model,
  );
  Future<VehicleModel> updateVehicle(VehicleModel vehicle);
  Future<void> deleteVehicle(String id);
}

class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  final FirebaseFirestore firestore;

  VehicleRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<VehicleModel>> getVehiclesByOwnerId(String ownerId) async {
    final vehiclesCollection = await firestore
        .collection('vehicles')
        .where('ownerId', isEqualTo: ownerId)
        .get();

    return vehiclesCollection.docs
        .map((doc) => VehicleModel.fromJson({
              'id': doc.id,
              ...doc.data(),
            }))
        .toList();
  }

  @override
  Future<VehicleModel> getVehicleById(String id) async {
    final vehicleDoc = await firestore.collection('vehicles').doc(id).get();

    if (!vehicleDoc.exists) {
      throw Exception('Vehicle not found');
    }

    return VehicleModel.fromJson({
      'id': vehicleDoc.id,
      ...vehicleDoc.data()!,
    });
  }

  @override
  Future<VehicleModel> addVehicle(
    String ownerId,
    String plateNumber,
    String brand,
    String model,
  ) async {
    final vehicleData = {
      'ownerId': ownerId,
      'plateNumber': plateNumber,
      'brand': brand,
      'model': model,
      'createdAt': FieldValue.serverTimestamp(),
    };

    final docRef = await firestore.collection('vehicles').add(vehicleData);
    
    return VehicleModel(
      id: docRef.id,
      ownerId: ownerId,
      plateNumber: plateNumber,
      brand: brand,
      model: model,
    );
  }

  @override
  Future<VehicleModel> updateVehicle(VehicleModel vehicle) async {
    await firestore.collection('vehicles').doc(vehicle.id).update({
      'plateNumber': vehicle.plateNumber,
      'brand': vehicle.brand,
      'model': vehicle.model,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return vehicle;
  }

  @override
  Future<void> deleteVehicle(String id) async {
    await firestore.collection('vehicles').doc(id).delete();
  }
}
