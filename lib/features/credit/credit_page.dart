import 'package:expense_manager/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:expense_manager/features/dashboard/bloc/dashboard_event.dart';
import 'package:expense_manager/models/transaction_model.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:flutter/material.dart';

class CreditPage extends StatefulWidget {
  final DashboardBloc dashboardBloc;
  const CreditPage({super.key, required this.dashboardBloc});

  @override
  State<CreditPage> createState() => _CreditPageState();
}

class _CreditPageState extends State<CreditPage> {
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
              'Credit Details',
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
                  DashboardCreditEvent(
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
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "+ Credit",
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
