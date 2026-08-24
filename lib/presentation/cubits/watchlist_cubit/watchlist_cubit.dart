import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/watchlist_model.dart';
import '../../../data/repositories/watchlist_repository.dart';
import 'watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  final WatchlistRepository _repository;

  WatchlistCubit(this._repository) : super(const WatchlistState());

  Future<void> load() async {
    final lists = await _repository.getWatchlists();
    emit(state.copyWith(watchlists: lists, isLoading: false));
  }

  void setActive(int index) {
    if (index >= 0 && index < state.watchlists.length) {
      emit(state.copyWith(activeIndex: index));
    }
  }

  Future<void> createWatchlist(String name) async {
    final newList = WatchlistModel(
      id: const Uuid().v4(),
      name: name,
      stockSymbols: const [],
    );
    final updated = [...state.watchlists, newList];
    await _repository.saveWatchlists(updated);
    emit(state.copyWith(watchlists: updated, activeIndex: updated.length - 1));
  }

  Future<void> renameWatchlist(String id, String newName) async {
    final updated = state.watchlists.map((w) {
      return w.id == id ? w.copyWith(name: newName) : w;
    }).toList();
    await _repository.saveWatchlists(updated);
    emit(state.copyWith(watchlists: updated));
  }

  Future<void> deleteWatchlist(String id) async {
    final updated = state.watchlists.where((w) => w.id != id).toList();
    int newIndex = state.activeIndex;
    if (newIndex >= updated.length) newIndex = updated.length - 1;
    if (newIndex < 0) newIndex = 0;
    await _repository.saveWatchlists(updated);
    emit(state.copyWith(watchlists: updated, activeIndex: newIndex));
  }

  Future<void> addStock(String symbol) async {
    final active = state.activeWatchlist;
    if (active == null || active.stockSymbols.contains(symbol)) return;
    final updatedList = active.copyWith(
      stockSymbols: [...active.stockSymbols, symbol],
    );
    await _updateWatchlist(updatedList);
  }

  Future<void> removeStock(String symbol) async {
    final active = state.activeWatchlist;
    if (active == null) return;
    final updatedList = active.copyWith(
      stockSymbols: active.stockSymbols.where((s) => s != symbol).toList(),
    );
    await _updateWatchlist(updatedList);
  }

  Future<void> reorderStocks(int oldIndex, int newIndex) async {
    final active = state.activeWatchlist;
    if (active == null) return;
    final symbols = List<String>.from(active.stockSymbols);
    if (newIndex > oldIndex) newIndex--;
    final item = symbols.removeAt(oldIndex);
    symbols.insert(newIndex, item);
    final updatedList = active.copyWith(stockSymbols: symbols);
    await _updateWatchlist(updatedList);
  }

  Future<void> _updateWatchlist(WatchlistModel updated) async {
    final lists = state.watchlists
        .map((w) => w.id == updated.id ? updated : w)
        .toList();
    await _repository.saveWatchlists(lists);
    emit(state.copyWith(watchlists: lists));
  }
}
