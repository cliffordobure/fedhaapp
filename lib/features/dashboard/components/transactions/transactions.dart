import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/transactions/bloc.dart';
import 'package:fedha/features/common_widgets/DefaultInputField.dart';
import 'package:fedha/features/dashboard/components/home/widgets/home_donut.dart';
import 'package:fedha/features/dashboard/components/transactions/widgets/filter_bottom_sheet.dart';
import 'package:fedha/features/dashboard/components/transactions/widgets/statement_import_sheet.dart';
import 'package:fedha/features/dashboard/components/transactions/widgets/transactions_list.dart';
import 'package:fedha/services/route_service.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool concealed = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? keyword = '';

  @override
  void initState() {
    super.initState();
    final bloc = context.read<TransactionsBloc>();

    bloc.add(ClearTransactions()); // Clean the screen when focus changes

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        logger.info("User scrolled to the end. Emitting LoadNextPageEvent.");
        bloc.add(LoadNextPageEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TransactionsBloc>();
    if (bloc.state.status == ServiceStatus.initial) {
      bloc.add(StartTransactions());
    }

    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: () async {
          bloc.add(RefreshTransactions());
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () => context.pushNamed(Routes.analytics),
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: HomeDonut(),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              sliver: SliverToBoxAdapter(child: _buildSearchField(context)),
            ),
            SliverToBoxAdapter(child: _buildTransactionsList(context)),
            SliverFillRemaining(
              hasScrollBody:
                  false, // Ensures it doesn't scroll when the content is small
              child:
                  Container(), // Or add any other content that you want at the end
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(
        "Transactions",
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 18,
              color: AppColors.darkBlueColor,
              fontWeight: FontWeight.w700,
            ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          tooltip: 'Import statement',
          onPressed: () => showStatementImportSheet(context),
          icon: const Icon(Icons.upload_file_outlined),
        ),
        IconButton(
          onPressed: () {
            showModalBottomSheet(
              useRootNavigator: true,
              useSafeArea: true,
              showDragHandle: true,
              enableDrag: true,
              context: context,
              builder: (context) => const FilterBottomSheet(),
            );
          },
          icon: const Icon(Icons.tune),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return DefaultInputField(
      textEditingController: _searchController,
      hasTitle: false,
      node: _focusNode,
      inputtype: TextInputType.text,
      inputAction: TextInputAction.search,
      hide: false,
      onChanged: (value) {
        context
            .read<TransactionsBloc>()
            .add(FilterTransactions(keyword: value));
        setState(() {
          keyword = value;
        });
      },
      borderRadius: BorderRadius.circular(20.r),
      hintText: "Search all transactions",
      suffix: Padding(
        padding: EdgeInsets.only(right: 5.h),
        child: IconButton(
          icon: Icon(
            keyword?.trim().isEmpty ?? true ? Icons.search : Icons.close,
            size: 25.h,
            color: const Color(0xff919191),
          ),
          onPressed: () {
            _searchController.clear();
            setState(() {});
          },
        ),
      ),
    );
  }

  Widget _buildTransactionsList(BuildContext context) {
    return BlocBuilder<TransactionsBloc, TransactionsState>(
      builder: (context, state) {
        if (state.status == ServiceStatus.loading) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        }
        if (state.status == ServiceStatus.loadingFailure) {
          return const Center(
            child: Text("Failed to load transactions"),
          );
        }
        return const TransactionsList();
      },
    );
  }
}
