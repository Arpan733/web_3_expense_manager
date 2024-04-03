import 'package:expense_manager/models/transaction_model.dart';
import 'package:flutter/material.dart';

@immutable
sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

class DashboardLoadingState extends DashboardState {}

class DashboardErrorState extends DashboardState {}

class DashboardSuccessState extends DashboardState {
  final List<TransactionModel> transactions;
  final int balance;

  DashboardSuccessState({required this.transactions, required this.balance});
}
