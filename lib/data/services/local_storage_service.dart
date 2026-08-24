import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> saveWatchlists(List<Map<String, dynamic>> data) async {
    await _prefs?.setString(AppConstants.prefWatchlists, jsonEncode(data));
  }

  // Synchronous getter (No Future needed)
  List<Map<String, dynamic>>? getWatchlists() {
    final raw = _prefs?.getString(AppConstants.prefWatchlists);
    if (raw == null) return null;
    final list = jsonDecode(raw) as List;
    return list.cast<Map<String, dynamic>>();
  }

  Future<void> saveHoldings(List<Map<String, dynamic>> data) async {
    await _prefs?.setString(AppConstants.prefHoldings, jsonEncode(data));
  }

  List<Map<String, dynamic>>? getHoldings() {
    final raw = _prefs?.getString(AppConstants.prefHoldings);
    if (raw == null) return null;
    final list = jsonDecode(raw) as List;
    return list.cast<Map<String, dynamic>>();
  }

  Future<void> saveOrders(List<Map<String, dynamic>> data) async {
    await _prefs?.setString(AppConstants.prefOrders, jsonEncode(data));
  }

  List<Map<String, dynamic>>? getOrders() {
    final raw = _prefs?.getString(AppConstants.prefOrders);
    if (raw == null) return null;
    final list = jsonDecode(raw) as List;
    return list.cast<Map<String, dynamic>>();
  }

  Future<void> saveWallet(int balancePaise) async {
    await _prefs?.setInt(AppConstants.prefWallet, balancePaise);
  }

  int? getWallet() => _prefs?.getInt(AppConstants.prefWallet);

  Future<void> clear() async => await _prefs?.clear();
}
