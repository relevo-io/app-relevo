// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(socketConnectionManager)
final socketConnectionManagerProvider = SocketConnectionManagerProvider._();

final class SocketConnectionManagerProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  SocketConnectionManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'socketConnectionManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$socketConnectionManagerHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return socketConnectionManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$socketConnectionManagerHash() =>
    r'1cb72ce5f4f0783d6dbfb48bd649db6f3fb6bc6a';

@ProviderFor(ChatsList)
final chatsListProvider = ChatsListProvider._();

final class ChatsListProvider
    extends $AsyncNotifierProvider<ChatsList, List<Chat>> {
  ChatsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatsListHash();

  @$internal
  @override
  ChatsList create() => ChatsList();
}

String _$chatsListHash() => r'57319a5ebbb21190d74d968916291ee1d81e2d4b';

abstract class _$ChatsList extends $AsyncNotifier<List<Chat>> {
  FutureOr<List<Chat>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Chat>>, List<Chat>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Chat>>, List<Chat>>,
              AsyncValue<List<Chat>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ChatRoomMessages)
final chatRoomMessagesProvider = ChatRoomMessagesFamily._();

final class ChatRoomMessagesProvider
    extends $AsyncNotifierProvider<ChatRoomMessages, List<Message>> {
  ChatRoomMessagesProvider._({
    required ChatRoomMessagesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatRoomMessagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatRoomMessagesHash();

  @override
  String toString() {
    return r'chatRoomMessagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChatRoomMessages create() => ChatRoomMessages();

  @override
  bool operator ==(Object other) {
    return other is ChatRoomMessagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatRoomMessagesHash() => r'23be428414f7309d7c028a0734696890f1847a57';

final class ChatRoomMessagesFamily extends $Family
    with
        $ClassFamilyOverride<
          ChatRoomMessages,
          AsyncValue<List<Message>>,
          List<Message>,
          FutureOr<List<Message>>,
          String
        > {
  ChatRoomMessagesFamily._()
    : super(
        retry: null,
        name: r'chatRoomMessagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChatRoomMessagesProvider call(String chatId) =>
      ChatRoomMessagesProvider._(argument: chatId, from: this);

  @override
  String toString() => r'chatRoomMessagesProvider';
}

abstract class _$ChatRoomMessages extends $AsyncNotifier<List<Message>> {
  late final _$args = ref.$arg as String;
  String get chatId => _$args;

  FutureOr<List<Message>> build(String chatId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Message>>, List<Message>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Message>>, List<Message>>,
              AsyncValue<List<Message>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(ChatRoomTyping)
final chatRoomTypingProvider = ChatRoomTypingFamily._();

final class ChatRoomTypingProvider
    extends $NotifierProvider<ChatRoomTyping, bool> {
  ChatRoomTypingProvider._({
    required ChatRoomTypingFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatRoomTypingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatRoomTypingHash();

  @override
  String toString() {
    return r'chatRoomTypingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChatRoomTyping create() => ChatRoomTyping();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChatRoomTypingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatRoomTypingHash() => r'd252cf1b0489c2765317f9cb32c74ebd88768dd7';

final class ChatRoomTypingFamily extends $Family
    with $ClassFamilyOverride<ChatRoomTyping, bool, bool, bool, String> {
  ChatRoomTypingFamily._()
    : super(
        retry: null,
        name: r'chatRoomTypingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChatRoomTypingProvider call(String chatId) =>
      ChatRoomTypingProvider._(argument: chatId, from: this);

  @override
  String toString() => r'chatRoomTypingProvider';
}

abstract class _$ChatRoomTyping extends $Notifier<bool> {
  late final _$args = ref.$arg as String;
  String get chatId => _$args;

  bool build(String chatId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(ChatRoomPresence)
final chatRoomPresenceProvider = ChatRoomPresenceFamily._();

final class ChatRoomPresenceProvider
    extends $NotifierProvider<ChatRoomPresence, bool> {
  ChatRoomPresenceProvider._({
    required ChatRoomPresenceFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatRoomPresenceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatRoomPresenceHash();

  @override
  String toString() {
    return r'chatRoomPresenceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChatRoomPresence create() => ChatRoomPresence();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChatRoomPresenceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatRoomPresenceHash() => r'a8449580533351ccf8060c865b683ac41fcaa7c4';

final class ChatRoomPresenceFamily extends $Family
    with $ClassFamilyOverride<ChatRoomPresence, bool, bool, bool, String> {
  ChatRoomPresenceFamily._()
    : super(
        retry: null,
        name: r'chatRoomPresenceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChatRoomPresenceProvider call(String chatId) =>
      ChatRoomPresenceProvider._(argument: chatId, from: this);

  @override
  String toString() => r'chatRoomPresenceProvider';
}

abstract class _$ChatRoomPresence extends $Notifier<bool> {
  late final _$args = ref.$arg as String;
  String get chatId => _$args;

  bool build(String chatId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(notificationManager)
final notificationManagerProvider = NotificationManagerProvider._();

final class NotificationManagerProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  NotificationManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationManagerHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return notificationManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$notificationManagerHash() =>
    r'c6f0e714c4d29897e4142dc896cc4746779797d1';

@ProviderFor(unreadChatsCount)
final unreadChatsCountProvider = UnreadChatsCountProvider._();

final class UnreadChatsCountProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  UnreadChatsCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unreadChatsCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unreadChatsCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return unreadChatsCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$unreadChatsCountHash() => r'4c6da48cdf1eda78538b54c78fff0e5cb899e88d';

@ProviderFor(myChatRating)
final myChatRatingProvider = MyChatRatingFamily._();

final class MyChatRatingProvider
    extends $FunctionalProvider<AsyncValue<Rating?>, Rating?, FutureOr<Rating?>>
    with $FutureModifier<Rating?>, $FutureProvider<Rating?> {
  MyChatRatingProvider._({
    required MyChatRatingFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'myChatRatingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$myChatRatingHash();

  @override
  String toString() {
    return r'myChatRatingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Rating?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Rating?> create(Ref ref) {
    final argument = this.argument as String;
    return myChatRating(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MyChatRatingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$myChatRatingHash() => r'5adeefaeef82d3837e2699f91e48999474c5146a';

final class MyChatRatingFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Rating?>, String> {
  MyChatRatingFamily._()
    : super(
        retry: null,
        name: r'myChatRatingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MyChatRatingProvider call(String chatId) =>
      MyChatRatingProvider._(argument: chatId, from: this);

  @override
  String toString() => r'myChatRatingProvider';
}

@ProviderFor(userRatings)
final userRatingsProvider = UserRatingsProvider._();

final class UserRatingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<MyRatingsResponse>,
          MyRatingsResponse,
          FutureOr<MyRatingsResponse>
        >
    with
        $FutureModifier<MyRatingsResponse>,
        $FutureProvider<MyRatingsResponse> {
  UserRatingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userRatingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userRatingsHash();

  @$internal
  @override
  $FutureProviderElement<MyRatingsResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MyRatingsResponse> create(Ref ref) {
    return userRatings(ref);
  }
}

String _$userRatingsHash() => r'ff598e13bae5ebab71cfccc0c4d17aa93953861f';
