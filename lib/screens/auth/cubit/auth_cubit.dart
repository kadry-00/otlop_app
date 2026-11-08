import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_1/api_remote/Auth_remote_data_source.dart';
import 'package:otlop_1/screens/auth/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRemoteDataSource _authRemoteDataSource = AuthRemoteDataSource();
  AuthCubit() : super(AuthInitialState());

  Future<void> login(String email, String password) async {
    emit(AuthLoadingState());
    try {
      final user = await _authRemoteDataSource.login(
        email: email,
        password: password,
      );
      emit(AuthSuccessState(user));
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    emit(AuthLoadingState());
    try {
      final user = await _authRemoteDataSource.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      emit(AuthSuccessState(user));
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }
}
