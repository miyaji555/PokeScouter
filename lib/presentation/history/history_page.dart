import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:poke_scouter/constants/route_path.dart';
import 'package:poke_scouter/presentation/history/battle_history_page.dart';
import 'package:poke_scouter/presentation/history/party_list_page.dart';

class HistoryPage extends HookWidget {
  const HistoryPage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    final List<Tab> tabs = <Tab>[
      const Tab(
        text: kPageNameBattleHistory,
      ),
      const Tab(
        text: kPageNamePartyList,
      ),
    ];
    final tabController = useTabController(
        initialLength: tabs.length, initialIndex: initialIndex);
    return Scaffold(
      appBar: AppBar(
        title: const Text(kPageNameHistory),
        bottom: TabBar(
          tabs: tabs,
          controller: tabController,
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: const [
          BattleHistoryPage(),
          PartyListPage(),
        ],
      ),
    );
  }
}

/// [TabBar]をwrapして背景色を変更するWidget
class ColoredTabBar extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSizeWidget tabBar;
  final Color color;

  // コンストラクタでchildとなる[TabBar]と背景色を指定
  const ColoredTabBar({super.key, required this.tabBar, required this.color});

  @override
  Widget build(BuildContext context) {
    // [Ink]でwrapして背景色を指定
    return Ink(
      color: color,
      child: tabBar,
    );
  }

  // [AppBar]のbottomに指定するためには[PreferredSizeWidget]である必要があり、そのためにこのmethodをoverrideします。
  // 実態はchildである[TabBar]のpreferredSizeをそのまま使えばOK
  @override
  Size get preferredSize => tabBar.preferredSize;
}
