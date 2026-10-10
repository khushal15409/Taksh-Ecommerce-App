import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taksh_e_commerce/core/di/injector.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_state.dart';
import 'package:taksh_e_commerce/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:taksh_e_commerce/features/wishlist/presentation/cubit/wishlist_state.dart';

/// Small round heart button for product cards.
///
/// Uses the app-wide [WishlistCubit] (the same instance the product details
/// page and wishlist page use). Guests are sent to login first.
class WishlistHeartButton extends StatelessWidget {
  final int productId;

  const WishlistHeartButton({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final cubit = getIt<WishlistCubit>();

    return BlocBuilder<WishlistCubit, WishlistState>(
      bloc: cubit,
      builder: (context, state) {
        final isWishlisted = cubit.isWishlisted(productId);
        final isLoading =
            (state is AddingToWishlist && state.productId == productId) ||
            (state is RemovingFromWishlist && state.productId == productId);

        return Semantics(
          button: true,
          label: isWishlisted ? 'Remove from wishlist' : 'Add to wishlist',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: isLoading ? null : () => _onTap(context, cubit),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.92),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: isLoading
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(
                      isWishlisted
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 18,
                      color: isWishlisted ? Colors.red : AppColors.grey700,
                    ),
            ),
          ),
        );
      },
    );
  }

  void _onTap(BuildContext context, WishlistCubit cubit) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) {
      final current = GoRouterState.of(context).uri.toString();
      context.push(
        '${AppRoutes.login}?redirectAfter=${Uri.encodeComponent(current)}',
      );
      return;
    }
    cubit.toggleWishlist(productId: productId);
  }
}
