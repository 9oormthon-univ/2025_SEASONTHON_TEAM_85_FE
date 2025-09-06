import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/repository/asset_repository.dart';
import 'package:futurefinder_flutter/repository/search_repository.dart';
import 'package:futurefinder_flutter/view/finance/asset_registration_screen.dart';
import 'package:futurefinder_flutter/view/finance/asset_verification_screen.dart';
import 'package:futurefinder_flutter/view/finance/finance_screen.dart';
import 'package:futurefinder_flutter/view/home/bookmark_screen.dart';
import 'package:futurefinder_flutter/view/home/home_screen.dart';
import 'package:futurefinder_flutter/view/home/search_screen.dart';
import 'package:futurefinder_flutter/view/jobs_screen.dart';
import 'package:futurefinder_flutter/view/login_screen.dart';
import 'package:futurefinder_flutter/view/settings_screen.dart';
import 'package:futurefinder_flutter/view/shell_screen.dart';
import 'package:futurefinder_flutter/view/subscription/interest_area_screen.dart';
import 'package:futurefinder_flutter/view/subscription/subscription_chatbot_screen.dart';
import 'package:futurefinder_flutter/view/subscription/subscription_registration_screen.dart';
import 'package:futurefinder_flutter/view/subscription/subscription_screen.dart';
import 'package:futurefinder_flutter/view/subscription/subscription_verification_screen.dart';
import 'package:futurefinder_flutter/viewmodel/asset_viewmodel.dart';
import 'package:futurefinder_flutter/viewmodel/search_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ShellScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: 'search',
                  builder: (context, state) {
                    return ChangeNotifierProvider<SearchViewModel>(
                      create: (_) =>
                          SearchViewModel(context.read<SearchRepository>()),
                      child: const SearchScreen(),
                    );
                  },
                ),
                GoRoute(
                  path: 'bookmark',
                  builder: (context, state) => const BookmarkScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/finance',
              builder: (context, state) {
                return ChangeNotifierProvider<AssetViewModel>(
                  create: (_) =>
                      AssetViewModel(context.read<AssetRepository>()),
                  child: const FinanceScreen(),
                );
              },
              routes: [
                GoRoute(
                  path: 'asset-registration',
                  builder: (context, state) => const AssetRegistrationScreen(),
                ),
                GoRoute(
                  path: 'asset-verification',
                  builder: (context, state) => const AssetVerificationScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/subscription',
              builder: (context, state) => const SubscriptionScreen(),
              routes: [
                GoRoute(
                  path: 'interest-area',
                  builder: (context, state) => const InterestAreaScreen(),
                ),
                GoRoute(
                  path: 'subscription-registration',
                  builder: (context, state) =>
                      const SubscriptionRegistrationScreen(),
                ),
                GoRoute(
                  path: 'subscription-verification',
                  builder: (context, state) =>
                      const SubscriptionVerificationScreen(),
                ),
                GoRoute(
                  path: 'subscription-chatbot',
                  builder: (context, state) =>
                      const SubscriptionChatbotScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/jobs',
              builder: (context, state) => const JobsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
