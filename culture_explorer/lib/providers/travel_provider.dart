import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../models/travel_plan.dart';

class TravelProvider with ChangeNotifier {
  List<TravelPlan> _travelPlans = [];
  bool _isLoading = false;
  String _error = '';

  List<TravelPlan> get travelPlans => _travelPlans;
  bool get isLoading => _isLoading;
  String get error => _error;

  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Load all travel plans
  Future<void> loadTravelPlans() async {
    _isLoading = true;
    _error = '';
    // notifyListeners() dihapus di sini agar tidak terjadi double-build saat inisialisasi
    
    try {
      _travelPlans = await _dbHelper.getAllTravelPlans();
      print('📋 Loaded ${_travelPlans.length} travel plans');
    } catch (e) {
      _error = 'Failed to load travel plans: $e';
      print('❌ Error loading travel plans: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add new travel plan (CREATE)
  Future<bool> addTravelPlan(TravelPlan plan) async {
    try {
      final id = await _dbHelper.insertTravelPlan(plan);
      if (id > 0) {
        plan.id = id;
        // Masukkan ke posisi paling atas agar langsung terlihat
        _travelPlans.insert(0, plan); 
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('❌ Error adding travel plan: $e');
      return false;
    }
  }

  // Update travel plan (UPDATE) - PERBAIKAN BUG GAMBAR TERTUKAR
  Future<bool> updateTravelPlan(TravelPlan plan) async {
    try {
      final rows = await _dbHelper.updateTravelPlan(plan);
      if (rows > 0) {
        // Cari data berdasarkan ID unik, bukan urutan List
        final index = _travelPlans.indexWhere((p) => p.id == plan.id);
        if (index != -1) {
          // Pastikan semua field termasuk heritageImage terupdate di list lokal
          _travelPlans[index] = plan; 
          notifyListeners();
          print('✅ Updated: ${plan.heritageName} Status: ${plan.status}');
          return true;
        }
      }
      return false;
    } catch (e) {
      print('❌ Error updating: $e');
      return false;
    }
  }

  // Delete travel plan (DELETE)
  Future<bool> deleteTravelPlan(int id) async {
    try {
      final rows = await _dbHelper.deleteTravelPlan(id);
      if (rows > 0) {
        _travelPlans.removeWhere((plan) => plan.id == id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Get travel plans by status (Case Insensitive)
  List<TravelPlan> getPlansByStatus(String status) {
    return _travelPlans
        .where((plan) => plan.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  // --- LOGIKA STATISTIK (DIOPTIMALKAN) ---

  Map<String, dynamic> getDetailedStatistics() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final planned = getPlansByStatus('planned');
    final visited = getPlansByStatus('visited');
    
    // Rencana masa depan yang belum dikunjungi
    final upcoming = planned
        .where((plan) => plan.planDate.isAfter(today) || plan.planDate.isAtSameMomentAs(today))
        .length;
    
    final overdue = planned
        .where((plan) => plan.planDate.isBefore(today))
        .length;

    final countries = _travelPlans.map((p) => p.heritageCountry).toSet().toList();

    return {
      'total': _travelPlans.length,
      'planned': planned.length,
      'visited': visited.length,
      'cancelled': getPlansByStatus('cancelled').length,
      'upcoming': upcoming,
      'overdue': overdue,
      'uniqueCountries': countries.length,
      'countries': countries,
    };
  }

  Map<String, int> getMonthlyStatistics() {
    final now = DateTime.now();
    
    int thisMonthCount = _travelPlans.where((plan) => 
      plan.planDate.month == now.month && 
      plan.planDate.year == now.year &&
      plan.status != 'cancelled'
    ).length;

    int nextMonthCount = _travelPlans.where((plan) => 
      plan.planDate.month == (now.month % 12) + 1 && 
      plan.status != 'cancelled'
    ).length;

    return {
      'thisMonth': thisMonthCount,
      'nextMonth': nextMonthCount,
    };
  }

  Map<String, double> getBudgetStatistics() {
    double plannedBudget = 0;
    double spentBudget = 0;

    for (var plan in _travelPlans) {
      if (plan.status == 'planned') {
        plannedBudget += plan.budget;
      } else if (plan.status == 'visited') {
        spentBudget += plan.budget;
      }
    }

    return {
      'planned': plannedBudget,
      'spent': spentBudget,
      'remaining': plannedBudget, 
    };
  }

  // Metode shortcut untuk Dashboard Utama
  Map<String, int> getStatistics() {
    return {
      'total': _travelPlans.length,
      'planned': getPlansByStatus('planned').length,
      'visited': getPlansByStatus('visited').length,
      'cancelled': getPlansByStatus('cancelled').length,
    };
  }
}