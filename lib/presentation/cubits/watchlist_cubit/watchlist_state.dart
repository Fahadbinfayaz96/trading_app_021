import 'package:equatable/equatable.dart';
import '../../../data/models/watchlist_model.dart';

class WatchlistState extends Equatable {
  final List<WatchlistModel> watchlists;
  final int activeIndex;
  final bool isLoading;

  const WatchlistState({
    this.watchlists = const [],
    this.activeIndex = 0,
    this.isLoading = true,
  });

  WatchlistModel? get activeWatchlist =>
      watchlists.isEmpty ? null : watchlists[activeIndex];

  WatchlistState copyWith({
    List<WatchlistModel>? watchlists,
    int? activeIndex,
    bool? isLoading,
  }) {
    return WatchlistState(
      watchlists: watchlists ?? this.watchlists,
      activeIndex: activeIndex ?? this.activeIndex,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [watchlists, activeIndex, isLoading];
}
