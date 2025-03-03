import 'package:drive_trust/features/drivers/domain/entities/driver.dart';

class DriverModel extends Driver {
  const DriverModel({
    required super.id,
    required super.name,
    required super.email,
    super.vehicleId,
    super.contractStatus,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      vehicleId: json['vehicleId'],
      contractStatus: _mapStringToContractStatus(json['contractStatus']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'vehicleId': vehicleId,
      'contractStatus': contractStatus.toString().split('.').last,
    };
  }

  static ContractStatus _mapStringToContractStatus(String status) {
    switch (status) {
      case 'active':
        return ContractStatus.active;
      case 'inactive':
        return ContractStatus.inactive;
      default:
        return ContractStatus.inactive;
    }
  }
}
