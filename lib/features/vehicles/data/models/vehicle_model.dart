import 'package:drive_trust/features/vehicles/domain/entities/vehicle.dart';

class VehicleModel extends Vehicle {
  const VehicleModel({
    required super.id,
    required super.ownerId,
    required super.plateNumber,
    required super.brand,
    required super.model,
  });

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
