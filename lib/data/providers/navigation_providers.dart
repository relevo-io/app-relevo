import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainNavigationIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int value) {
    state = value;
  }
}

final mainNavigationIndexProvider = NotifierProvider<MainNavigationIndexNotifier, int>(
  MainNavigationIndexNotifier.new,
);

class InboxActiveTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setTab(int value) {
    state = value;
  }
}

final inboxActiveTabProvider = NotifierProvider<InboxActiveTabNotifier, int>(
  InboxActiveTabNotifier.new,
);
