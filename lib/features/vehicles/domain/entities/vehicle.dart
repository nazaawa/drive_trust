import 'package:equatable/equatable.dart';

class Vehicle extends Equatable {
  final String id;
  final String ownerId;
  final String plateNumber;
  final String brand;
  final String model;

  const Vehicle({
    required this.id,
    required this.ownerId,
    required this.plateNumber,
    required this.brand,
    required this.model,
  });

  @override
  List<Object> get props => [id, ownerId, plateNumber, brand, model];
}
