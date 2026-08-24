import '../models/order_model.dart';
import '../services/local_storage_service.dart';

abstract class OrdersRepository {
  Future<List<OrderModel>> getOrders();
  Future<void> addOrder(OrderModel order);
}

class OrdersRepositoryImpl implements OrdersRepository {
  final LocalStorageService _storage;

  OrdersRepositoryImpl(this._storage);

  @override
  Future<List<OrderModel>> getOrders() async {
    final data = _storage.getOrders();
    if (data == null) return [];
    return data.map((e) => OrderModel.fromJson(e)).toList();
  }

  @override
  Future<void> addOrder(OrderModel order) async {
    final orders = await getOrders();
    orders.insert(0, order);
    await _storage.saveOrders(orders.map((e) => e.toJson()).toList());
  }
}
