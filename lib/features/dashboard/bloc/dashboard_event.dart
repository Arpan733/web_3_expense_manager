import 'package:expense_manager/models/transaction_model.dart';
import 'package:flutter/material.dart';

@immutable
sealed class DashboardEvent {}

class DashboardInitialFetchEvent extends DashboardEvent {}

class DashboardCreditEvent extends DashboardEvent {
  final TransactionModel transactionModel;

  DashboardCreditEvent({required this.transactionModel});
}

class DashboardDebitEvent extends DashboardEvent {
  final TransactionModel transactionModel;

  DashboardDebitEvent({required this.transactionModel});
}
