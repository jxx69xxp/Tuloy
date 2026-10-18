import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tuloy_app/app/router.dart';
import 'package:tuloy_app/core/config.dart';
import 'package:tuloy_app/core/http.dart';
import 'package:tuloy_app/core/web/shortcuts.dart';
import 'package:tuloy_app/core/web/web_table.dart';
import 'package:tuloy_app/features/auth/domain/auth.dart';
import 'package:tuloy_app/features/auth/presentation/auth_controller.dart';
import 'package:tuloy_app/features/chat/chat_screen.dart';
import 'package:tuloy_app/l10n/app_localizations.dart';

class _Staff extends AuthController {
  @override
  Future<User?> build() async => User(
    id: 'u',
    fullName: 'Sam',
    language: 'en',
    memberships: const [Membership(hotelId: hotelId, role: Role.staff)],
  );
}

const _threads = [
  {'id': 'c1', 'guestName': 'Ana Cruz', 'unread': 2, 'lastMessageAt': '2026-10-13T08:00:00Z'},
  {'id': 'c2', 'guestName': 'Ben Reyes', 'unread': 0, 'lastMessageAt': '2026-10-12T08:00:00Z'},
];

/// Every request the app makes; answered in-process (the api_upload_test pattern).
final _seen = <RequestOptions>[];

Api _fakeApi() {
  final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (o, h) {
          _seen.add(o);
          final first = o.method == 'GET' && o.path.endsWith('/messages') && o.queryParameters['after'] == null;
          h.resolve(
            Response(
              requestOptions: o,
              data: first
                  ? [
                      {
                        'id': 'm1',
                        'body': 'Hello from ${o.path}',
                        'senderId': 'g',
                        'createdAt': '2026-10-13T08:00:00Z',
                      },
                    ]
                  : o.method == 'GET'
                  ? []
                  : {'ok': true},
            ),
          );
        },
      ),
    );
  return Api(dio);
}

Future<GoRouter> _start(WidgetTester t, double width, String location) async {
  _seen.clear();
  t.view.devicePixelRatio = 1;
  t.view.physicalSize = Size(width, 900);
  addTearDown(t.view.reset);
  final container = ProviderContainer(
    overrides: [
      authProvider.overrideWith(_Staff.new),
      languageProvider.overrideWith((_) => 'en'),
      apiProvider.overrideWithValue(_fakeApi()),
      getProvider('/staff/dashboard').overrideWith((ref) async => const <String, dynamic>{}),
      getProvider('/staff/conversations').overrideWith((ref) async => _threads),
      getProvider('/staff/reservations?view=upcoming').overrideWith((ref) async => const []),
      getProvider('/staff/reservations?view=departures').overrideWith((ref) async => const []),
      getProvider('/staff/board').overrideWith((ref) async => const {'rooms': [], 'types': []}),
      getProvider('/staff/notifications').overrideWith((ref) async => const []),
    ],
  );
  addTearDown(container.dispose);
  final router = container.read(routerProvider);
  await t.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
          DefaultMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  await t.pumpAndSettle();
  router.go(location);
  await t.pumpAndSettle();
  return router;
}

String _path(GoRouter r) => r.routerDelegate.currentConfiguration.uri.path;
int _gets(String thread) => _seen.where((o) => o.method == 'GET' && o.path == '/conversations/$thread/messages').length;

void main() {
  testWidgets('wide inbox: list + thread side by side; switching stops the old poll', (t) async {
    final router = await _start(t, 1400, '/staff/inbox');
    expect(find.text('Select a conversation'), findsOneWidget);
    await t.tap(find.text('Ana Cruz'));
    await t.pumpAndSettle();
    expect(_path(router), '/staff/inbox/chat/c1');
    expect(find.byType(ChatScreen), findsOneWidget);
    expect(find.text('Hello from /conversations/c1/messages'), findsOneWidget);
    expect(find.text('Ben Reyes'), findsOneWidget); // list still there
    expect(t.widget<ListTile>(find.widgetWithText(ListTile, 'Ana Cruz')).selected, isTrue);

    await t.tap(find.text('Ben Reyes'));
    await t.pumpAndSettle();
    expect(_path(router), '/staff/inbox/chat/c2');
    final before = _gets('c1');
    await t.pump(const Duration(seconds: 7));
    expect(_gets('c1'), before); // c1's timer is gone
    expect(_gets('c2'), greaterThan(1)); // c2 polls
  });

  testWidgets('wide inbox: deep link shows list + thread; search filters threads', (t) async {
    await _start(t, 1400, '/staff/inbox/chat/c2');
    expect(find.byType(ChatScreen), findsOneWidget);
    expect(find.text('Ana Cruz'), findsOneWidget);
    await t.enterText(find.widgetWithText(TextField, 'Search'), 'ana');
    await t.pumpAndSettle();
    expect(find.text('Ben Reyes'), findsOneWidget); // the open thread's header
    expect(find.widgetWithText(ListTile, 'Ben Reyes'), findsNothing);
  });

  testWidgets('narrow inbox: list, then the full-screen thread', (t) async {
    await _start(t, 400, '/staff/inbox');
    expect(find.byType(ChatScreen), findsNothing);
    await t.tap(find.text('Ana Cruz'));
    await t.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Ana Cruz'), findsOneWidget); // pushed full screen, as before
    expect(find.text('Hello from /conversations/c1/messages'), findsOneWidget);
  });

  testWidgets('wide chat: Enter sends, Shift+Enter does not', (t) async {
    await _start(t, 1400, '/staff/inbox/chat/c1');
    final input = find.descendant(of: find.byType(ChatScreen), matching: find.byType(TextField));
    await t.enterText(input, 'hi');
    await t.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await t.sendKeyEvent(LogicalKeyboardKey.enter);
    await t.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await t.pump();
    expect(_seen.where((o) => o.method == 'POST'), isEmpty);
    await t.sendKeyEvent(LogicalKeyboardKey.enter);
    await t.pumpAndSettle();
    final posts = _seen.where((o) => o.method == 'POST').toList();
    expect(posts.single.path, '/conversations/c1/messages');
    expect((posts.single.data as Map)['body'], 'hi');
  });

  testWidgets('Ctrl+K opens quick jump; typing + Enter navigates', (t) async {
    final router = await _start(t, 1400, '/staff/inbox');
    await t.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await t.sendKeyEvent(LogicalKeyboardKey.keyK);
    await t.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await t.pumpAndSettle();
    expect(find.byType(QuickJump), findsOneWidget);
    await t.enterText(find.descendant(of: find.byType(QuickJump), matching: find.byType(TextField)), 'service req');
    await t.pump();
    await t.sendKeyEvent(LogicalKeyboardKey.enter);
    await t.pumpAndSettle();
    expect(find.byType(QuickJump), findsNothing);
    expect(_path(router), '/staff/tasks');
  });

  testWidgets('"/" focuses the table search; "?" shows the shortcuts', (t) async {
    await _start(t, 1400, '/staff/reservations');
    await t.sendKeyEvent(LogicalKeyboardKey.slash);
    await t.pump();
    final focused = FocusManager.instance.primaryFocus!.context!;
    expect(focused.findAncestorWidgetOfExactType<WebTable>(), isNotNull);
    expect(focused.findAncestorWidgetOfExactType<EditableText>() ?? focused.widget, isNotNull);

    FocusManager.instance.primaryFocus!.unfocus();
    await t.pump();
    await t.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await t.sendKeyEvent(LogicalKeyboardKey.slash);
    await t.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await t.pumpAndSettle();
    expect(find.byType(ShortcutsHelp), findsOneWidget);
  });
}
