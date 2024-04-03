import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:expense_manager/features/dashboard/bloc/dashboard_event.dart';
import 'package:expense_manager/features/dashboard/bloc/dashboard_state.dart';
import 'package:expense_manager/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardInitialFetchEvent>(dashboardInitialFetchEvent);
    on<DashboardCreditEvent>(dashboardCreditEvent);
    on<DashboardDebitEvent>(dashboardDebitEvent);
  }

  List<TransactionModel> transactions = [];
  Web3Client? web3client;

  late ContractAbi _abiCode;
  late EthereumAddress _contractAddress;
  late EthPrivateKey _cred;

  late DeployedContract _deployedContract;
  late ContractFunction _credit;
  late ContractFunction _debit;
  late ContractFunction _getBalance;
  late ContractFunction _getAllTransactions;

  int balance = 0;

  Future<FutureOr<void>> dashboardInitialFetchEvent(
      DashboardInitialFetchEvent event, Emitter<DashboardState> emit) async {
    emit(DashboardLoadingState());

    try {
      const String rpcUrl = 'http://192.168.53.30:7545';
      const String socketUrl = 'ws://192.168.53.30:7545';
      const String privateKey =
          '0x167898a1c0658fca27b7f9f901159fbc5c0b51e230cc7dcd7c30bc238debe062';

      web3client = Web3Client(
        rpcUrl,
        http.Client(),
        socketConnector: () {
          return IOWebSocketChannel.connect(socketUrl).cast<String>();
        },
      );

      debugPrint("1");

      String abiFile =
          await rootBundle.loadString('build/contracts/ExpenseManagerContract.json');
      var jsonDecoded = jsonDecode(abiFile);

      debugPrint("2");

      _abiCode =
          ContractAbi.fromJson(jsonEncode(jsonDecoded["abi"]), 'ExpenseManagerContract');
      _contractAddress =
          EthereumAddress.fromHex("0x8d7925911d87fc68F3e8B35901725B3579c03c37");
      _cred = EthPrivateKey.fromHex(privateKey);

      debugPrint("3");

      _deployedContract = DeployedContract(_abiCode, _contractAddress);
      _credit = _deployedContract.function("deposit");
      _debit = _deployedContract.function("withdraw");
      _getBalance = _deployedContract.function("getBalance");
      _getAllTransactions = _deployedContract.function("getAllTransactions");

      debugPrint("4");

      final transactionsData = await web3client!.call(
        contract: _deployedContract,
        function: _getAllTransactions,
        params: [],
      );
      debugPrint(transactionsData.toString());

      final balanceData = await web3client!.call(
        contract: _deployedContract,
        function: _getBalance,
        params: [EthereumAddress.fromHex('0x9631aFaE0b9f250CE8F4F34f1aA05292304BACea')],
      );
      debugPrint(balanceData.toString());

      List<TransactionModel> trans = [];

      for (int i = 0; i < transactionsData[0].length; i++) {
        TransactionModel transactionModel = TransactionModel(
          address: transactionsData[0][i].toString(),
          amount: transactionsData[1][i].toInt(),
          reason: transactionsData[2][i],
          timestamp: DateTime.fromMicrosecondsSinceEpoch(transactionsData[3][i].toInt()),
        );

        trans.add(transactionModel);
      }

      transactions = trans;
      int bal = balanceData[0].toInt();
      balance = bal;

      emit(DashboardSuccessState(transactions: transactions, balance: balance));
    } catch (e) {
      debugPrint("Error: $e");
      emit(DashboardErrorState());
    }
  }

  FutureOr<void> dashboardCreditEvent(
      DashboardCreditEvent event, Emitter<DashboardState> emit) async {
    try {
      final transaction = Transaction.callContract(
        from: EthereumAddress.fromHex('0x9631aFaE0b9f250CE8F4F34f1aA05292304BACea'),
        contract: _deployedContract,
        function: _credit,
        parameters: [
          BigInt.from(event.transactionModel.amount),
          event.transactionModel.reason,
        ],
        value: EtherAmount.inWei(BigInt.from(event.transactionModel.amount)),
      );

      final result = await web3client!.sendTransaction(
        _cred,
        transaction,
        chainId: 1337,
        fetchChainIdFromNetworkId: false,
      );

      debugPrint(result.toString());
      add(DashboardInitialFetchEvent());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  FutureOr<void> dashboardDebitEvent(
      DashboardDebitEvent event, Emitter<DashboardState> emit) async {
    try {
      final transaction = Transaction.callContract(
        from: EthereumAddress.fromHex("0x9631aFaE0b9f250CE8F4F34f1aA05292304BACea"),
        contract: _deployedContract,
        function: _debit,
        parameters: [
          BigInt.from(event.transactionModel.amount),
          event.transactionModel.reason
        ],
      );

      final result = await web3client!.sendTransaction(
        _cred,
        transaction,
        chainId: 1337,
        fetchChainIdFromNetworkId: false,
      );

      debugPrint(result.toString());
      add(DashboardInitialFetchEvent());
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
