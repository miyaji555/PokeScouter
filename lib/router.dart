import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poke_scouter/constants/provider_name.dart';
import 'package:poke_scouter/constants/remote_config.dart';
import 'package:poke_scouter/presentation/Widget/tab.dart';
import 'package:poke_scouter/presentation/battle_memo/battle_memo_page.dart';
import 'package:poke_scouter/presentation/battle_start/battle_start_page.dart';
import 'package:poke_scouter/presentation/battle_suggest/battle_suggest_page.dart';
import 'package:poke_scouter/presentation/force_update/force_update.dart';
import 'package:poke_scouter/presentation/history/history_page.dart';
import 'package:poke_scouter/presentation/login/login_page.dart';
import 'package:poke_scouter/presentation/my_page/my_page.dart';
import 'package:poke_scouter/presentation/party_register/party_register_page.dart';
import 'package:poke_scouter/presentation/scouter/scouter_page.dart';
import 'package:poke_scouter/providers/remote_config_provider.dart';
import 'package:poke_scouter/providers/version_provider.dart';

import 'constants/route_path.dart';

final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: kPagePathBattleStart,
    redirect: (context, state) {
      final minimumVersion =
          ref.read(remoteConfigProvider).getInt(kRemoteConfig);
      final appVersion = int.parse(ref.read(versionProvider).buildNumber);
      if (appVersion < minimumVersion) {
        return kPagePathUpdate;
      }
      return null;
    },
    routes: [
      ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (BuildContext context, GoRouterState state, Widget child) {
            return ScaffoldWithNavBar(child: child);
          },
          routes: [
            GoRoute(
                name: kPageNameBattleStart,
                path: kPagePathBattleStart,
                builder: (BuildContext context, GoRouterState state) {
                  return const BattleStartPage();
                }),
            GoRoute(
              name: kPageNameHistory,
              path: kPagePathHistory,
              builder: (BuildContext context, GoRouterState state) {
                final id = state.params['id'];
                if (id == null) {
                  return const HistoryPage();
                }
                final index = int.parse(id);
                return HistoryPage(
                  initialIndex: index,
                );
              },
              routes: <GoRoute>[
                GoRoute(
                    name: kPageNamePartyRegister,
                    path: kPagePathSubPartyRegister,
                    builder: (BuildContext context, GoRouterState state) {
                      return const PartyRegisterPage();
                    }),
              ],
            ),
            GoRoute(
              name: kPageNameMy,
              path: kPagePathMy,
              builder: (BuildContext context, GoRouterState state) {
                return const MyPage();
              },
            ),
          ]),
      GoRoute(
          name: kPageNameLogin,
          path: kPagePathLogin,
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPage();
          }),
      GoRoute(
        name: kPageNameBattleSuggest,
        path: kPagePathBattleSuggest,
        builder: (BuildContext context, GoRouterState state) {
          return const BattleSuggestPage();
        },
      ),
      GoRoute(
        name: kPageNameScouter,
        path: kPagePathScouter,
        builder: (BuildContext context, GoRouterState state) {
          return const ScouterPage();
        },
      ),
      GoRoute(
          name: kPageNameBattleMemo,
          path: kPagePathBattleMemo,
          builder: (BuildContext context, GoRouterState state) {
            return const BattleMemoPage();
          }),
      GoRoute(
          name: kPageNameUpdate,
          path: kPagePathUpdate,
          builder: (BuildContext context, GoRouterState state) {
            return const ForceUpdatePage();
          }),
    ],
  );
}, name: kProviderNameRouter);
