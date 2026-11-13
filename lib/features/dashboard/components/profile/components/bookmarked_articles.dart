import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/articles/bloc.dart';
import 'package:fedha/features/common_widgets/DefaultInputField.dart';
import 'package:fedha/features/dashboard/components/articles/widgets/article_card.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookmarkedArticles extends StatefulWidget {
  const BookmarkedArticles({Key? key}) : super(key: key);

  @override
  State<BookmarkedArticles> createState() => _BookmarkedArticlesState();
}

class _BookmarkedArticlesState extends State<BookmarkedArticles> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    if (context.read<ArticlesBloc>().state.bookMarkedStatus ==
        ServiceStatus.initial) {
      context.read<ArticlesBloc>().add(StartBookMarkedArticles());
    }

    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              'assets/Images/Background.png',
            ),
            fit: BoxFit.cover),
      ),
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Center(
                child: Text(
                  "Bookmarked Articles",
                  style: theme.titleMedium!.copyWith(
                      fontSize: 18,
                      color: AppColors.darkBlueColor,
                      fontWeight: FontWeight.w700),
                ),
              ),
              leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_ios)),
              actions: const [],
            ),
            body: CustomScrollView(
              slivers: [
                // Search field
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverToBoxAdapter(
                    child: DefaultInputField(
                      inputAction: TextInputAction.done,
                      textEditingController: _searchController,
                      hasTitle: false,
                      title: "",
                      hide: false,
                      validator: (onValidateVal) {},
                      onSaved: (String? onSavedVal) {},
                      onChanged: (value) {
                        context
                            .read<ArticlesBloc>()
                            .add(SearchBookmarked(keyword: value));
                      },
                      borderRadius: BorderRadius.circular(20.r),
                      hintText: "Search Articles",
                      suffix: Padding(
                        padding: EdgeInsets.only(right: 5.h),
                        child: IconButton(
                          icon: Icon(
                            Icons.search,
                            size: 25.h,
                            color: const Color(0xff919191),
                          ),
                          onPressed: () {
                            // Clear search field
                            _searchController.text = "";
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: BlocBuilder<ArticlesBloc, ArticlesState>(
                    builder: (context, state) {
                      if (state.bookMarkedStatus ==
                          ServiceStatus.loadingFailure) {
                        return SliverToBoxAdapter(
                          child: Center(
                            child: Text(
                                state.message?.message ?? "An error occured"),
                          ),
                        );
                      }
                      if (state.bookMarkedStatus == ServiceStatus.loading) {
                        return SliverToBoxAdapter(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        );
                      }
                      return state.bookmarked.isNotEmpty
                          ? SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (context, index) => ArticleCard(
                                        article: state.bookmarked[index],
                                        bookmarked: true,
                                      ),
                                  childCount: state.bookmarked.length),
                            )
                          : const SliverToBoxAdapter(
                              child: Center(
                                child: Text("No saved articles saved"),
                              ),
                            );
                    },
                  ),
                )
              ],
            )),
      ),
    );
  }
}
