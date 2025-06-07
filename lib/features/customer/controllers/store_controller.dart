import 'package:get/get.dart';
import 'package:del_pick/core/errors/failures.dart';
import 'package:del_pick/core/errors/error_handler.dart';
import 'package:del_pick/data/models/store/store_model.dart';
import 'package:del_pick/data/repositories/store_repository.dart';
import 'package:del_pick/core/services/external/location_service.dart';

class StoreController extends GetxController {
  final StoreRepository _storeRepository;
  final LocationService _locationService;

  StoreController({
    required StoreRepository storeRepository,
    required LocationService locationService,
  })  : _storeRepository = storeRepository,
        _locationService = locationService;

  // Observable state
  final RxBool _isLoading = false.obs;
  final RxList<StoreModel> _stores = <StoreModel>[].obs;
  final RxString _errorMessage = ''.obs;
  final RxBool _hasError = false.obs;
  final RxBool _hasLocation = false.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  List<StoreModel> get stores => _stores;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _hasError.value;
  bool get hasLocation => _hasLocation.value;
  bool get hasStores => _stores.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    fetchNearbyStores();
  }

  Future<void> fetchNearbyStores() async {
    _isLoading.value = true;
    _hasError.value = false;
    _errorMessage.value = '';

    try {
      // Get current location
      final position = await _locationService.getCurrentLocation();

      if (position != null) {
        _hasLocation.value = true;

        // Fetch stores from repository
        final result = await _storeRepository.getNearbyStores(
          latitude: position.latitude,
          longitude: position.longitude,
        );

        if (result.isSuccess && result.data != null) {
          _stores.value = result.data!;
        } else {
          _hasError.value = true;
          _errorMessage.value = result.message ?? 'Failed to fetch stores';
        }
      } else {
        _hasLocation.value = false;
        // Fallback to get all stores without location
        final result = await _storeRepository.getAllStores();

        if (result.isSuccess && result.data != null) {
          _stores.value = result.data!;
        } else {
          _hasError.value = true;
          _errorMessage.value = result.message ?? 'Failed to fetch stores';
        }
      }
    } catch (e) {
      _hasError.value = true;
      if (e is Exception) {
        final failure = ErrorHandler.handleException(e);
        _errorMessage.value = ErrorHandler.getErrorMessage(failure);
      } else {
        _errorMessage.value = 'An unexpected error occurred';
      }
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> refreshStores() async {
    await fetchNearbyStores();
  }

  void sortStoresByDistance() {
    _stores.sort((a, b) {
      final distanceA = a.distance ?? double.infinity;
      final distanceB = b.distance ?? double.infinity;
      return distanceA.compareTo(distanceB);
    });
  }

  void sortStoresByRating() {
    _stores.sort((a, b) {
      final ratingA = a.rating ?? 0.0;
      final ratingB = b.rating ?? 0.0;
      return ratingB.compareTo(ratingA); // Descending order
    });
  }

  void filterStores(String query) {
    if (query.isEmpty) {
      refreshStores();
      return;
    }

    // Filter stores by name or category
    final filteredStores = _stores.where((store) {
      final name = store.name.toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();

    _stores.value = filteredStores;
  }
}
