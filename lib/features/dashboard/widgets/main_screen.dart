import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:fedha/features/dashboard/components/home/widgets/home_net_worth_card.dart';
import 'package:fedha/features/dashboard/components/transactions/widgets/transaction_bottomsheet.dart';
import 'package:fedha/constants/global_keys.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Match HomeDesign.greenDeep used in heroes + side menu.
  static const _active = HomeDesign.greenDeep;
  static const _inactive = Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/Images/Background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: widget.navigationShell,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 62,
              child: Row(
                children: [
                  _buildNavItem(0, LucideIcons.home, 'Home', homeMenuKey),
                  _buildNavItem(
                    1,
                    LucideIcons.calendarDays,
                    'Planning',
                    planningMenuKey,
                  ),
                  Expanded(child: Center(child: _buildPlusButton())),
                  _buildNavItem(
                    3,
                    LucideIcons.activity,
                    'Analytics',
                    analyticsMenuKey,
                  ),
                  _buildNavItem(4, LucideIcons.user, 'Profile', profileMenuKey),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, Key? key) {
    final isSelected = widget.navigationShell.currentIndex == index;
    final color = isSelected ? _active : _inactive;

    return Expanded(
      child: InkWell(
        onTap: () => _onTap(index),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, key: key, size: 22, color: color),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: HomeDesign.text(
                size: 10,
                weight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: color,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: isSelected ? 14 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: _active,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlusButton() {
    // Aligned with peer icons: sits in the row (not floating high),
    // slightly larger so it peeks above the bar like the mock.
    return Transform.translate(
      offset: const Offset(0, -6),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            showDragHandle: true,
            useRootNavigator: true,
            isScrollControlled: true,
            useSafeArea: true,
            context: context,
            builder: (context) => const FractionallySizedBox(
              heightFactor: 1,
              child: TransactionBottomSheet(),
            ),
          );
        },
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: _active,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _active.withValues(alpha: 0.28),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            LucideIcons.plus,
            key: transactionsMenuKey,
            size: 26,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _onTap(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}
