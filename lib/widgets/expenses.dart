import 'package:expense/main.dart';
import 'package:expense/widgets/expenses_list/expenses_list.dart';
import 'package:expense/models/expense.dart';
import 'package:expense/widgets/new_expense.dart';
import 'package:flutter/material.dart';



class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesStatement();
  }
}

class _ExpensesStatement extends State<Expenses> {
  final List<Expense> _registeredExpenses = [];
  
  get expenses => null;
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
    
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
     ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 4),
      content: const Text("Expense deleted."),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          setState(() {
            _registeredExpenses.insert(expenseIndex, expense);
          });
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text("No expenses found. Start adding some!"),
    );
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
          expenses: _registeredExpenses, onRemoveExpense: _removeExpense);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense tracker"),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
            color: kColorScheme.primaryContainer,
          ),
        ],
      ),
      body: Column(
        children: [
          //const Text("the chart"),
          const Text("Expenses list"),
          //Chart(expenses:_registeredExpenses),
          Expanded(
            child: mainContent,
            /*child: ExpensesList(
            expenses: _registeredExpenses,
            onRemoveExpense: _removeExpense,
            )*/
          ),
        ],
      ),
    );
  }
}
