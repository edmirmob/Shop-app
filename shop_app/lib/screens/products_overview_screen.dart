import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/product_provider_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _isInit = true;
  var _showOnlyFavorites = false;
  var _isLoaded = false;

  @override
  void initState() {
    //Provider.of<ProductProvider>(context).fetchAndSetProducts(); OVO NEĆE RADITI
    // Future.delayed(Duration.zero).then((_){ NEĆE NI OVO RADITI IAKO MOŽE PROĆI
    //   Provider.of<ProductProvider>(context).fetchAndSetProducts();
    // });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState((){
        _isLoaded = true;
      });

      Provider.of<ProductProvider>(context).fetchAndSetProducts().then((_) {
        setState((){
          _isLoaded = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final productContainer =
    //     Provider.of<ProductProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shopp'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                  //productContainer.showFavorite();
                } else {
                  _showOnlyFavorites = false;
                  //productContainer.showAll();
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Only favorits'), value: FilterOptions.Favorites),
              PopupMenuItem(
                  child: Text('All selected'), value: FilterOptions.All),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) =>
                Badge(child: ch, value: cart.itemCount.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoaded
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductProviderGrid(_showOnlyFavorites),
    );
  }
}
