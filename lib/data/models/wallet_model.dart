import 'package:equatable/equatable.dart';

class WalletModel extends Equatable {
  final int balancePaise;

  const WalletModel({required this.balancePaise});

  WalletModel copyWith({int? balancePaise}) {
    return WalletModel(balancePaise: balancePaise ?? this.balancePaise);
  }

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(balancePaise: json['balancePaise'] as int);
  }

  Map<String, dynamic> toJson() => {'balancePaise': balancePaise};

  @override
  List<Object?> get props => [balancePaise];
}
