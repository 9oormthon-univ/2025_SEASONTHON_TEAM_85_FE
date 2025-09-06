import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/view/finance/asset_registration_screen.dart';
import 'package:futurefinder_flutter/view/finance/asset_verification_screen.dart';
import 'package:futurefinder_flutter/view/finance/finance_screen.dart';
import 'package:futurefinder_flutter/view/home_screen.dart';
import 'package:futurefinder_flutter/view/jobs_screen.dart';
import 'package:futurefinder_flutter/view/login_screen.dart';
import 'package:futurefinder_flutter/view/settings_screen.dart';
import 'package:futurefinder_flutter/view/shell_screen.dart';
import 'package:futurefinder_flutter/view/subscription_screen.dart';
import 'package:go_router/go_router.dart';

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
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/finance',
              builder: (context, state) => const FinanceScreen(),
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
