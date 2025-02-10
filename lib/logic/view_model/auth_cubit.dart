import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/truck_repository.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}

class AuthCubit extends Cubit<AuthState> {
  final TruckRepository truckRepository;

  AuthCubit(this.truckRepository) : super(AuthInitial());

  // Simulate login
  Future<void> login(String username, String password) async {
    try {
      emit(AuthLoading());
      
      // Simulate API call or use real API for authentication
      await Future.delayed(const Duration(seconds: 2));
      if (username == 'admin' && password == 'password') {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure('Invalid credentials'));
      }
    } catch (e) {
      emit(AuthFailure('Something went wrong'));
    }
  }
}
