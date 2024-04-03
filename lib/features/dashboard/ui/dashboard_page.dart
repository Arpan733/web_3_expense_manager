import 'package:expense_manager/features/credit/credit_page.dart';
import 'package:expense_manager/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:expense_manager/features/dashboard/bloc/dashboard_event.dart';
import 'package:expense_manager/features/dashboard/bloc/dashboard_state.dart';
import 'package:expense_manager/features/debit/debit_page.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardBloc dashboardBloc = DashboardBloc();

  @override
  void initState() {
    dashboardBloc.add(DashboardInitialFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accentColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "web 3 Bank",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.accentColor,
      ),
      body: BlocConsumer<DashboardBloc, DashboardState>(
        bloc: dashboardBloc,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case DashboardLoadingState:
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            case DashboardErrorState:
              return const Center(
                child: Text(
                  "Error!!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            case DashboardSuccessState:
              final successState = state as DashboardSuccessState;

              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/ethereum.png',
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              "${successState.balance.toString()} ETH",
                              style: const TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DebitPage(
                                dashboardBloc: dashboardBloc,
                              ),
                            ),
                          ),
                          child: Container(
                            height: 50,
                            width: (MediaQuery.of(context).size.width - 60) / 2,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "- Debit",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CreditPage(
                                dashboardBloc: dashboardBloc,
                              ),
                            ),
                          ),
                          child: Container(
                            height: 50,
                            width: (MediaQuery.of(context).size.width - 60) / 2,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "+ Credit",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Transactions",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: successState.transactions.length,
                        itemBuilder: (context, index) => Container(
                          padding:
                              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/ethereum.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "${successState.transactions[index].amount} ETH",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                successState.transactions[index].address,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                successState.transactions[index].reason,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            default:
              return Container();
          }
        },
      ),
    );
  }
}
