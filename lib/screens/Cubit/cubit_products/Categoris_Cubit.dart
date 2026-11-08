import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_1/api_remote/Home_remote_api.dart';
import 'package:otlop_1/screens/Cubit/cubit_products/Categoris_State.dart';

class CategorisCubit extends Cubit<CategorisState> {
  CategorisCubit() : super(CategorisLoadingState());
  final HomeRemoteApi homeRemoteApi = HomeRemoteApi();

  Future<void> getCategoris() async {
    emit(CategorisLoadingState());
    try {
      final list = await homeRemoteApi.getCategories();
      emit(CategorisSuccessState(categoris: list));
    } catch (e) {
      emit(CategrisFailureState(erro: e.toString()));
    }
  }
}
