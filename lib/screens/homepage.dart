import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../comon/colos.dart';
import '../failure.dart';
import '../models/item_model.dart';
import '../repo/budget_repo.dart';
import '../widgets/spending_chart.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
    late Future<List<Item>> _futureItems;
    @override
  void initState() {
    // TODO: implement initState
     _futureItems = BudgetRepository().getitems();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Tracker',
        style: TextStyle(color: Colors.black),),
        elevation: 0.0,
        centerTitle: true,

      ),
      body: RefreshIndicator(onRefresh: ()async {
        _futureItems = BudgetRepository().getitems();
         
       },
       child: FutureBuilder(future: _futureItems,
        builder:(context, snapshot) {
         if (snapshot.hasData) {
               final items = snapshot.data!;
               return ListView.builder(itemCount: items.length +1 ,

                itemBuilder: (context, index) {
                  if (index == 0) return SpendingChart(items: items);
                   final item = items[index - 1];
                  return Container(
                     margin: const EdgeInsets.all(8.0),
                     decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      border: Border.all(
                        width: 2.0,
                        color: getCategoryColor(item.category),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        ),
                      ],

                     ),
                     child: ListTile(
                      title: Text(item.name),
                      subtitle: Text('${item.category} • ${DateFormat.yMd().format(item.date)}',),
                      trailing: Text( '-\$${item.price.toStringAsFixed(2)}',),
                     ),
                  );
                 
               },);
           
         }else if (snapshot.hasError) {
              // Show failure error message.
              final failure = snapshot.error as Failure;
              return Center(child: Text(failure.message));
            }
            return  const Center(child: CircularProgressIndicator());

       },
       ),
       ),

    );
  }

 
}