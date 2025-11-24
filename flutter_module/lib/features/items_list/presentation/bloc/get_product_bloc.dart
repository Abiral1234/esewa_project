// lib/bloc/product_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/product_repository.dart';
import 'get_product_event.dart';
import 'get_product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc(this.repository) : super(ProductInitial()) {
    on<FetchProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await repository.fetchProducts();
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}
