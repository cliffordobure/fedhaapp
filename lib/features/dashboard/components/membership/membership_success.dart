import 'package:fedha/features/app/blocs/dashboard/bloc.dart';
import 'package:fedha/services/route_service.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MemberShipSuccess extends StatefulWidget {
  const MemberShipSuccess({Key? key}) : super(key: key);

  @override
  State<MemberShipSuccess> createState() => _MemberShipSuccessState();
}

class _MemberShipSuccessState extends State<MemberShipSuccess> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
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
            leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios)),
            title: Text(
              "Membership Success",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 18,
                  color: AppColors.darkBlueColor,
                  fontWeight: FontWeight.w700),
            ),
            centerTitle: true,
          ),
          body: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: AppBar().preferredSize.height,
                ),
                Text(
                  "Success!!",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text("Thanks for choosing Premium"),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    context.goNamed(Routes.home);
                    context
                        .read<DashboardControllerBloc>()
                        .add(const PositionEvent(0));
                  },
                  child: Text(
                    "Let's go!",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
