import 'package:otlop_1/models/address_model.dart';
import 'package:otlop_1/models/user_model.dart';

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {
  final UserModel? user;
  final AddressModel? address;

  ProfileSuccessState({this.user, this.address});
}

class ProfileFailureState extends ProfileState {
  final String error;
  ProfileFailureState(this.error);
}
