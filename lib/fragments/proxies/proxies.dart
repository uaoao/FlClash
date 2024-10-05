import 'package:fl_clash/common/app_localizations.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/fragments/proxies/list.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'icon.dart';
import 'providers.dart';
import 'setting.dart';
import 'tab.dart';

class ProxiesFragment extends StatefulWidget {
  const ProxiesFragment({super.key});

  @override
  State<ProxiesFragment> createState() => _ProxiesFragmentState();
}

class _ProxiesFragmentState extends State<ProxiesFragment> {
  final GlobalKey<ProxiesTabFragmentState> _proxiesTabKey = GlobalKey();

  _initActions(ProxiesType proxiesType, bool hasProvider) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final commonScaffoldState =
          context.findAncestorStateOfType<CommonScaffoldState>();
      commonScaffoldState?.actions = [
        if (hasProvider) ...[
          IconButton(
            onPressed: () {
              showExtendPage(
                isScaffold: true,
                extendPageWidth: 360,
                context,
                body: const Providers(),
                title: appLocalizations.providers,
              );
            },
            icon: const Icon(
              Icons.poll_outlined,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
        ],
        if (proxiesType == ProxiesType.tab) ...[
          IconButton(
            onPressed: () {
              _proxiesTabKey.currentState?.scrollToGroupSelected();
            },
            icon: const Icon(
              Icons.adjust_outlined,
            ),
          ),
          const SizedBox(
            width: 8,
          )
        ] else ...[
          IconButton(
            onPressed: () {
              showSheet(
                title: "图标配置",
                context: context,
                builder: (context) {
                  return const GroupIconSetting();
                },
              );
            },
            icon: const Icon(
              Icons.style_outlined,
            ),
          ),
          const SizedBox(
            width: 8,
          )
        ],
        IconButton(
          onPressed: () {
            showSheet(
              title: appLocalizations.proxiesSetting,
              context: context,
              builder: (context) {
                return const ProxiesSetting();
              },
            );
          },
          icon: const Icon(
            Icons.tune,
          ),
        )
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<Config, ProxiesType>(
      selector: (_, config) => config.proxiesStyle.type,
      builder: (_, proxiesType, __) {
        return ProxiesActionsBuilder(
          builder: (state, child) {
            if (state.isCurrent) {
              _initActions(proxiesType, state.hasProvider);
            }
            return child!;
          },
          child: switch (proxiesType) {
            ProxiesType.tab => ProxiesTabFragment(
                key: _proxiesTabKey,
              ),
            ProxiesType.list => const ProxiesListFragment(),
          },
        );
      },
    );
  }
}
