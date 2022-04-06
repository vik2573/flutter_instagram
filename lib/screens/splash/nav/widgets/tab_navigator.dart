import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_instagram/repositories/repositories.dart';
import 'package:flutter_instagram/screens/profile/features/profile/presentation/bloc/profile_bloc.dart';

import '../../../../config/custom_router.dart';
import '../../../../enums/bottom_nav_item.dart';
import '../../../create_post/create_post_screen.dart';
import '../../../feed/feed_screen.dart';
import '../../../notifications/notifications_screen.dart';
import '../../../profile/profile_screen.dart';
import '../../../search/search_screen.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';
  const TabNavigator({
    Key? key,
    required this.navigatorKey,
    required this.item,
  }) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders();
    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoot,
      onGenerateInitialRoutes: (_, initialRoute) {
        return [
          MaterialPageRoute(
            settings: const RouteSettings(name: tabNavigatorRoot),
            builder: (context) => routeBuilders[initialRoute]!(context),
          ),
        ];
      },
      onGenerateRoute: CustomRouter.onGenerateNestedRoute,
    );
  }

  Map<String, WidgetBuilder> _routeBuilders() {
    return {tabNavigatorRoot: ((context) => _getScreen(context, item))};
  }

  Widget _getScreen(BuildContext context, BottomNavItem item) {
    switch (item) {
      case BottomNavItem.feed:
        return FeedScreen();
      case BottomNavItem.search:
        return SearchScreen();
      case BottomNavItem.create:
        return CreatePostScreen();
      case BottomNavItem.notifications:
        return NotificationsScreen();
      case BottomNavItem.profile:
        return BlocProvider<ProfileBloc>(
            create: (_) => ProfileBloc(
                userRepository: context.read<UserRepository>(),
                authBloc: context.read<AuthBloc>())
              ..add(ProfileLoadUser(
                  userId: context.read<AuthBloc>().state.user.id)),
            child: ProfileScreen());
      default:
        return Scaffold();
    }
  }
}
