import '../../core/services/api_service.dart';
import '../models/truck.dart';

abstract class TruckRepository {
  Future<Truck> getTruckDetails(String id);
}

class TruckRepositoryImpl implements TruckRepository {
  final ApiService apiService;

  TruckRepositoryImpl(this.apiService);

  @override
  Future<Truck> getTruckDetails(String id) async {
    // Fetch truck data as a map
    final data = await apiService.fetchTruckData(id);
    
    // Create and return a Truck object from the data
    return Truck(
      id: data['id'],          // Assuming the data has 'id' field
      name: data['name'],      // Assuming the data has 'name' field
      driverName: data['driver_name'], // Assuming the data has 'driver_name' field
    );
  }
}
