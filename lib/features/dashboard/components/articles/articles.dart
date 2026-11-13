import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/articles/bloc.dart';
import 'package:fedha/features/dashboard/components/articles/widgets/article_card.dart';
import 'package:fedha/features/dashboard/components/articles/widgets/category_button.dart';
import 'package:fedha/features/dashboard/components/articles/widgets/highlight_card.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Articles extends StatefulWidget {
  const Articles({Key? key}) : super(key: key);

  @override
  State<Articles> createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (context.read<ArticlesBloc>().state.status == ServiceStatus.initial) {
      context.read<ArticlesBloc>().add(StartArticlesBloc());
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: BlocBuilder<ArticlesBloc, ArticlesState>(
          builder: (context, state) {
            if (state.status == ServiceStatus.loading) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            }
            if (state.status == ServiceStatus.loadingFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.wifiOff,
                          size: 36, color: AppColors.fadeBlackColor),
                      const SizedBox(height: 12),
                      Text(
                        'Could not load articles',
                        style: TextStyle(
                          color: AppColors.darkBlueColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => context
                            .read<ArticlesBloc>()
                            .add(StartArticlesBloc()),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state.status != ServiceStatus.loadingSuccess) {
              return const SizedBox.shrink();
            }

            final articles = state.selected?.articles ?? const [];

            return CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(context)),
                SliverToBoxAdapter(child: _buildSearch(context)),
                const SliverToBoxAdapter(child: SizedBox(height: 14)),
                SliverToBoxAdapter(child: _buildCategories(state)),
                const SliverToBoxAdapter(child: SizedBox(height: 18)),
                SliverToBoxAdapter(
                  child: _sectionLabel(
                    context,
                    title: 'Featured',
                    subtitle: state.selected?.name ?? 'All topics',
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 248,
                    child: articles.isEmpty
                        ? _emptyInline('No featured articles in this category')
                        : ListView.builder(
                            padding: const EdgeInsets.only(left: 16, right: 4),
                            scrollDirection: Axis.horizontal,
                            itemCount: articles.length,
                            itemBuilder: (context, index) => HighLightCard(
                              article: articles[index],
                            ),
                          ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 22)),
                SliverToBoxAdapter(
                  child: _sectionLabel(
                    context,
                    title: 'Most popular',
                    subtitle: '${articles.length} articles',
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                if (articles.isEmpty)
                  SliverToBoxAdapter(
                    child: _emptyInline('No articles under this category'),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            ArticleCard(article: articles[index]),
                        childCount: articles.length,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                size: 18, color: AppColors.darkBlueColor),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Financial Articles',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.darkBlueColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Guides to grow and protect your money',
                  style: TextStyle(
                    color: AppColors.fadeBlackColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {});
          context.read<ArticlesBloc>().add(SearchEvent(keyword: value));
        },
        style: TextStyle(color: AppColors.darkColor, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search articles',
          hintStyle: TextStyle(color: AppColors.fadeBlackColor, fontSize: 14),
          prefixIcon: Icon(LucideIcons.search,
              size: 18, color: AppColors.fadeBlackColor),
          suffixIcon: _searchController.text.isEmpty
              ? null
              : IconButton(
                  icon: Icon(Icons.close_rounded,
                      size: 18, color: AppColors.fadeBlackColor),
                  onPressed: () {
                    _searchController.clear();
                    context
                        .read<ArticlesBloc>()
                        .add(SearchEvent(keyword: ''));
                    setState(() {});
                  },
                ),
          filled: true,
          fillColor: AppColors.whiteColor,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: AppColors.greyColor.withValues(alpha: 0.45),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: AppColors.greyColor.withValues(alpha: 0.45),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 1.4),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories(ArticlesState state) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: state.articles.length,
        itemBuilder: (context, index) {
          final category = state.articles[index];
          return CategoryButton(
            onTapCallBack: () {
              context
                  .read<ArticlesBloc>()
                  .add(UpdateSelected(category: category));
            },
            text: category.name,
            selected: category.id == state.selected?.id,
          );
        },
      ),
    );
  }

  Widget _sectionLabel(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.darkBlueColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: AppColors.fadeBlackColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyInline(String message) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyColor.withValues(alpha: 0.4)),
      ),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.fadeBlackColor),
        ),
      ),
    );
  }
}
