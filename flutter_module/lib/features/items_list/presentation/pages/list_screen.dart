// lib/screens/list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_module/app_config.dart';
import 'package:flutter_module/features/items_list/presentation/bloc/get_product_bloc.dart';
import 'package:flutter_module/features/items_list/presentation/bloc/get_product_event.dart';
import 'package:flutter_module/features/items_list/presentation/bloc/get_product_state.dart';

import '../../data/model/product_model.dart';
import '../../data/repository/product_repository.dart';
import 'detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListScreen extends StatefulWidget {
  final AppConfig config;
  final String title;

  const ListScreen({required this.config, required this.title, super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  void initState() {
    // getDataFromAndroid();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      //color: textColor,
      fontFamily:
          widget.config.fontFamily.isNotEmpty ? widget.config.fontFamily : null,
      fontSize: widget.config.baseSize,
    );

    return BlocProvider(
      create: (_) => ProductBloc(ProductRepository())..add(FetchProducts()),
      child: Scaffold(
        // backgroundColor: backgroundColor,
        appBar: AppBar(title: Text(widget.title, style: textStyle)),
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              return ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (ctx, i) {
                  final Product product = state.products[i];
                  return ListTile(
                    // tileColor: backgroundColor,
                    leading: Image.network(product.image ?? '',
                        width: 50, height: 50),
                    title: Text(product.title ?? '', style: textStyle),
                    subtitle:
                        Text('Price: \$${product.price}', style: textStyle),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            DetailScreen(item: product, config: widget.config),
                      ),
                    ),
                  );
                },
              );
            } else if (state is ProductError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
