import 'package:flutter/material.dart';
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
import 'package:futurefinder_flutter/viewmodel/search_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../view/SignUp_screen.dart';
import '../view/SignUpAccount_screen.dart';
import '../view/sign_up_complete_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    // ✅ 1단계: 이름/생년월일
    GoRoute(
      path: '/signup',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SignUpScreen(),
      routes: [
        // 2단계(아이디/비번/이메일)
        GoRoute(
          path: 'account',              // => /signup/account
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const SignUpAccountScreen(),
        ),
        // ✅ 완료 화면
        GoRoute(
          path: 'complete',             // => /signup/complete
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const SignUpCompleteScreen(),
        ),
      ],
    ),
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
