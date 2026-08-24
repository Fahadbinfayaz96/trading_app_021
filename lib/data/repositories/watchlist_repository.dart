import '../models/watchlist_model.dart';
import '../services/local_storage_service.dart';

abstract class WatchlistRepository {
  Future<List<WatchlistModel>> getWatchlists();
  Future<void> saveWatchlists(List<WatchlistModel> watchlists);
  Future<WatchlistModel> createDefault();
}

class WatchlistRepositoryImpl implements WatchlistRepository {
  final LocalStorageService _storage;

  WatchlistRepositoryImpl(this._storage);

  @override
  Future<List<WatchlistModel>> getWatchlists() async {
    final data = _storage.getWatchlists();
    if (data == null || data.isEmpty) {
      final defaultList = [await createDefault()];
      await saveWatchlists(defaultList);
      return defaultList;
    }
    return data.map((e) => WatchlistModel.fromJson(e)).toList();
  }

  @override
  Future<void> saveWatchlists(List<WatchlistModel> watchlists) async {
    await _storage.saveWatchlists(watchlists.map((e) => e.toJson()).toList());
  }

  @override
  Future<WatchlistModel> createDefault() async {
    return const WatchlistModel(
      id: 'default',
      name: 'My Watchlist',
      stockSymbols: ['RELIANCE', 'TCS', 'INFY'],
    );
  }
}
