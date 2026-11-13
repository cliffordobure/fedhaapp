import 'package:fedha/data/models/faqs/faqs.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/help/bloc.dart';
import 'package:fedha/features/common_widgets/DefaultInputField.dart';
import 'package:fedha/features/common_widgets/floating_action_btn.dart';
import 'package:fedha/services/route_service.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (context.read<FaqsBloc>().state.status == ServiceStatus.initial) {
      context.read<FaqsBloc>().add(StartFaqBloc());
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
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios)),
            title: Text("Help Center",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 18,
                    color: AppColors.darkBlueColor,
                    fontWeight: FontWeight.w700)),
            centerTitle: true,
          ),
          body: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.sizeOf(context).height,
            ),
            child: Stack(
              children: [
                BlocBuilder<FaqsBloc, FaqsState>(
                  builder: (context, state) {
                    if (state.status == ServiceStatus.loading) {
                      return Container(
                        constraints: BoxConstraints(
                            minHeight: MediaQuery.sizeOf(context).width -
                                AppBar().preferredSize.height),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      );
                    }
                    if (state.status == ServiceStatus.loadingFailure) {
                      return Container(
                        constraints: BoxConstraints(
                            minHeight: MediaQuery.sizeOf(context).width -
                                AppBar().preferredSize.height),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Center(
                          child: Text("Failed to load Faqs"),
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Form(
                            child: // Search button
                                DefaultInputField(
                              textEditingController: _searchController,
                              inputAction: TextInputAction.done,
                              title: "",
                              hide: false,
                              validator: (onValidateVal) {},
                              onSaved: (String? onSavedVal) {},
                              onChanged: (value) {
                                // Filter faqs
                                context.read<FaqsBloc>().add(SearchFaqs(
                                    keyword: _searchController.text.trim()));
                              },
                              borderRadius: BorderRadius.circular(20.r),
                              hintText: "Search Help Center",
                              suffix: Padding(
                                padding: EdgeInsets.only(right: 5.h),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.search,
                                    size: 25.h,
                                    color: AppColors.fadeBlackColor,
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
                          state.filtered.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: state.filtered.length,
                                  itemBuilder: (context, index) => FaqWidget(
                                    faq: state.filtered[index],
                                  ),
                                )
                              : Container(
                                  constraints: BoxConstraints(
                                      minHeight:
                                          MediaQuery.sizeOf(context).width -
                                              AppBar().preferredSize.height),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: const Center(
                                    child: Text("Nothing found!"),
                                  ),
                                ),
                        ],
                      ),
                    );
                  },
                ),
                Positioned(
                    bottom: AppBar().preferredSize.height + 16,
                    right: 10,
                    child: ActionBtn(
                      onPressed: () {
                        context.pushNamed(Routes.chats);
                      },
                      icon: const Icon(Icons.contact_support),
                    )),
              ],
            ),
          )),
    );
  }
}

class FaqWidget extends StatefulWidget {
  const FaqWidget({super.key, required this.faq});
  final FaQ faq;

  @override
  State<FaqWidget> createState() => _FaqWidgetState();
}

class _FaqWidgetState extends State<FaqWidget> {
  bool isMinimized = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: ExpansionTile(
          shape: const Border(),
          initiallyExpanded: isMinimized,
          backgroundColor: Colors.white,
          onExpansionChanged: (value) {
            if (value) {
              setState(() {
                isMinimized = value;
              });
            }
          },
          tilePadding: EdgeInsets.zero,
          title: Text(
            widget.faq.question,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.bold, color: AppColors.fadeBlackColor),
          ),
          children: [
            Divider(
              color: AppColors.greyColor,
            ),
            Text(
              widget.faq.answer,
            ),
            const SizedBox(
              height: 8,
            )
          ]),
    );
  }
}
