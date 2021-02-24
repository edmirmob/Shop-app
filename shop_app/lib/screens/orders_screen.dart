import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routName ='/orders';

//   @override
//   _OrdersScreenState createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
//   var _isLoaded=false;
//   @override
//   void initState() {
    // Future.delayed(Duration.zero).then((_) async{
      //  setState(() {
        // _isLoaded=true;
      // });
    //   Provider.of<Orders>(context,listen: false).fetchAndSetOrders().then((_){
    //   setState(() {
    //   _isLoaded=false;
    // });
    //   });
    // });
   
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    // final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(future:Provider.of<Orders>(context,listen: false).fetchAndSetOrders() ,builder: (ctx,dataSnaphot){
        if(dataSnaphot.connectionState==ConnectionState.waiting){
        Center(child:CircularProgressIndicator());
        }if(dataSnaphot.error != null){
          //ovdje upisujemo greške ako ih ima
          return Center(child: Text('Greška se desila'),);
        }else{
          return Consumer<Orders>(builder: (ctx,ordersData,child)=>ListView.builder(
        itemCount: ordersData.orders.length,
        itemBuilder: (ctx, i) => OrderItem(ordersData.orders[i]),) 
      );
        }
      }),);
  }
}
