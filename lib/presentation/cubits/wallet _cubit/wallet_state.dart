import 'package:equatable/equatable.dart';

class WalletState extends Equatable {
  final int balancePaise;
  final bool isLoading;

  const WalletState({this.balancePaise = 0, this.isLoading = true});

  WalletState copyWith({int? balancePaise, bool? isLoading}) {
    return WalletState(
      balancePaise: balancePaise ?? this.balancePaise,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [balancePaise, isLoading];
}
