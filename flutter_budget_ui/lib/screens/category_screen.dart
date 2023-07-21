import 'package:app_budget/helpers/color_helper.dart';
import 'package:app_budget/models/category_model.dart';
import 'package:app_budget/models/expense_model.dart';
import 'package:app_budget/widgets/radial_painter.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {

  final Category category;

  CategoryScreen({required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  _buildExpense(){
    List<Widget> expenseList = [];
    widget.category.expenses.forEach((Expense expense) {
      expenseList.add(Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        height: 80,
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
          ]
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                expense.name,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold ,
                ),
              ),
              Text('-\$${expense.cost.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600 ,
                  color: Colors.red
                ),)
        
            ],
          ),
        ),
      ));
     });
     return Column(
      children: expenseList,
     );
  }

  @override
  Widget build(BuildContext context) {

    double totalAmountSpent = 0;
    widget.category.expenses.forEach((Expense expense){
      totalAmountSpent += expense.cost;
    });
    final double amountLeft = widget.category.maxAmount - totalAmountSpent;
    final double percent = amountLeft / widget.category.maxAmount;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Align(
          alignment: Alignment.center,
          child: Text(widget.category.name),
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.add), iconSize: 30.0,),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250.0,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(20.0),
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
                ]
              ),
              child: CustomPaint(
                foregroundPainter: RadialPainter(
                  bgColor: Color.fromARGB(255, 239, 238, 238),
                  lineColor: getColor(context, percent), 
                  percent: percent, 
                  width: 15.0),
                child: Center(
                  child: Text('\$${amountLeft.toStringAsFixed(2)} / \$${widget.category.maxAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      
                    ),
                  ),
                ),
              ),
            ),
            _buildExpense(),
          ],
        ),
      ),
    );
  }
}