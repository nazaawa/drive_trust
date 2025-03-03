import 'package:drive_trust/features/vehicles/domain/entities/vehicle.dart';

class VehicleModel extends Vehicle {
  const VehicleModel({
    required String id,
    required String ownerId,
    required String plateNumber,
    required String brand,
    required String model,
  }) : super(
          id: id,
          ownerId: ownerId,
          plateNumber: plateNumber,
          brand: brand,
          model: model,
        );

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'],
      ownerId: json['ownerId'],
      plateNumber: json['plateNumber'],
      brand: json['brand'],
      model: json['model'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'plateNumber': plateNumber,
      'brand': brand,
      'model': model,
    };
  }
}
