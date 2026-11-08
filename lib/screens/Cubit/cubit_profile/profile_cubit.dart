import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_1/api_remote/Auth_remote_data_source.dart';
import 'package:otlop_1/api_remote/address_remote_api.dart';
import 'package:otlop_1/models/address_model.dart';
import 'package:otlop_1/models/user_model.dart';
import 'package:otlop_1/screens/Cubit/cubit_profile/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRemoteDataSource _authApi = AuthRemoteDataSource();
  final AddressRemoteApi _addressApi = AddressRemoteApi();

  ProfileCubit() : super(ProfileInitialState());

  UserModel? _currentUser;
  AddressModel? _currentAddress;

  UserModel? get currentUser => _currentUser;
  AddressModel? get currentAddress => _currentAddress;

  Future<void> loadProfile() async {
    emit(ProfileLoadingState());
    try {
      _currentUser = await _authApi.getCurrentUser();
    } catch (_) {}

    try {
      _currentAddress = await _addressApi.getAddress();
    } catch (_) {}

    emit(ProfileSuccessState(user: _currentUser, address: _currentAddress));
  }

  Future<void> updateAddress(AddressModel address) async {
    emit(ProfileLoadingState());
    try {
      final updated = await _addressApi.updateAddress(address);
      _currentAddress = updated;
      emit(ProfileSuccessState(user: _currentUser, address: _currentAddress));
    } catch (e) {
      emit(ProfileFailureState(e.toString()));
    }
  }
}
