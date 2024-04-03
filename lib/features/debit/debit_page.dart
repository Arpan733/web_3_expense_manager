import 'package:expense_manager/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:expense_manager/features/dashboard/bloc/dashboard_event.dart';
import 'package:expense_manager/models/transaction_model.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:flutter/material.dart';

class DebitPage extends StatefulWidget {
  final DashboardBloc dashboardBloc;
  const DebitPage({super.key, required this.dashboardBloc});

  @override
  State<DebitPage> createState() => _DebitPageState();
}

class _DebitPageState extends State<DebitPage> {
  final amountController = TextEditingController();
  final reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accentColor,
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Debit Details',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                hintText: 'Enter the amount',
              ),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: 'Enter the reason',
              ),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                widget.dashboardBloc.add(
                  DashboardDebitEvent(
                    transactionModel: TransactionModel(
                      address: '',
                      amount: int.parse(amountController.text),
                      reason: reasonController.text,
                      timestamp: DateTime.now(),
                    ),
                  ),
                );

                Navigator.pop(context);
              },
              child: Container(
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "+ Debit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
