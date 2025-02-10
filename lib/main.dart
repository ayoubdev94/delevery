 import 'package:delevery/data/repositories/search_sort_repo.dart';
 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/models/product.dart';
import 'data/repositories/truck_repository.dart';
import 'core/services/api_service.dart'; // Import ApiService
import 'logic/view_model/sales_cubit/sales_cubit.dart';
import 'logic/view_model/search_sort_bloc/search_sort_bloc.dart';
import 'ui/screens/pos_screen.dart';

void main() {
  // Initialize API and Repositories
  final apiService = ApiService();
  final truckRepository = TruckRepositoryImpl(apiService);

  runApp(MyApp(truckRepository: truckRepository));
}

class MyApp extends StatelessWidget {
  final TruckRepository truckRepository;

  const MyApp({super.key, required this.truckRepository});

  @override
  Widget build(BuildContext context) {
    List<Product> sampleItems = SearchSortRepo.getProducts();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SearchSortBloc(sampleItems),
        ),
        BlocProvider(
          create: (context) => SalesCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Delivery POS',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => /*  LoginScreen() */ const POSScreen(),
          '/pos': (context) => const POSScreen(),
        },
      ),
    );
  }
}
