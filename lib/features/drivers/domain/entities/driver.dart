import 'package:equatable/equatable.dart';

enum ContractStatus { active, inactive }

class Driver extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? vehicleId;
  final ContractStatus contractStatus;

  const Driver({
    required this.id,
    required this.name,
    required this.email,
    this.vehicleId,
    this.contractStatus = ContractStatus.inactive,
  });

  @override
  List<Object?> get props => [id, name, email, vehicleId, contractStatus];
}
