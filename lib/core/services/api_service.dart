class ApiService {
  // Simulating an API request for truck data
  Future<Map<String, dynamic>> fetchTruckData(String id) async {
    // Simulating a network delay
    await Future.delayed(const Duration(seconds: 2));

    // Returning mock data (replace this with actual API logic later)
    return {
      'id': id,
      'name': 'Truck $id',
      'driver_name': 'John Doe',
    };
  }
}
