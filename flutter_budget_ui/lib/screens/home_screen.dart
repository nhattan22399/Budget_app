

import 'package:app_budget/data/data.dart';
import 'package:app_budget/helpers/color_helper.dart';
import 'package:app_budget/models/category_model.dart';
import 'package:app_budget/models/expense_model.dart';
import 'package:app_budget/screens/category_screen.dart';
import 'package:app_budget/widgets/bar_chart.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  _buildCategory(Category category, double totalAmountSpent){
    return GestureDetector(
      onTap: () =>Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryScreen(category: category),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        padding: const EdgeInsets.all(20.0),
        height: 100.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(category.name, style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),),
                Text('\$${(category.maxAmount - totalAmountSpent).toStringAsFixed(2)} / \$${category.maxAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
              ],    
            ),
            const SizedBox(height: 10.0,),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints){
                final double maxBarWidth = constraints.maxWidth;
                final double percent = (category.maxAmount - totalAmountSpent) / category.maxAmount;
                final double barWidth = maxBarWidth * percent;
    
                if(barWidth < 0 ){
                  // ignore: unused_local_variable
                  double  barWidth = 0;
                }
                return Stack(
                  children: [
                    Container(
                      height: 20.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    Container(
                      height: 20.0,
                      width: barWidth,
                      decoration:  BoxDecoration(
                        color: getColor(context, percent),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            forceElevated: true,
            floating: true,
            expandedHeight: 100.0,
            backgroundColor: Theme.of(context).primaryColor,
            leading: 
              IconButton(
                onPressed: (){},
                icon: const Icon(Icons.settings),
                iconSize: 30.0,
             ),
             flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
              title: Text('Simple Budget'),
             ),
             actions: [
              IconButton(onPressed: (){}, icon: const Icon(Icons.add), iconSize: 30.0,)
             ],
          ),
          SliverList(delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index){
              if(index == 0){
                return Container(
                  margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      )
                    ],
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: BarChart(weeklySpending),
                  );
                } else{
                  final Category category = categories[index - 1];
                  double  totalAmountSpent = 0;
                  category.expenses.forEach((Expense expense) {
                    totalAmountSpent += expense.cost;
                   });
                  return _buildCategory(category, totalAmountSpent);
                } 
              },
            childCount: 1 + categories.length,
          ),
          )
        ],
      ),
    );
  }
}