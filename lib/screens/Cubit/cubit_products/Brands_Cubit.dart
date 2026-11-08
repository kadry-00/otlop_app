import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_1/api_remote/Home_remote_api.dart';
import 'package:otlop_1/screens/Cubit/cubit_products/Brands_State.dart';

class BrandsCubit extends Cubit<BrandsState> {
  BrandsCubit() : super(BrandsLoadingState());
  final HomeRemoteApi homeRemoteApi = HomeRemoteApi();

  Future<void> getBrands() async {
    emit(BrandsLoadingState());
    try {
      final list = await homeRemoteApi.getBrands();
      emit(BrandsSuccessState(brands: list));
    } catch (e) {
      emit(BrandsFailureState(erro: e.toString()));
    }
  }
}
