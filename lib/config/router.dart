import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/new_project_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/project/new',
      builder: (context, state) => const NewProjectScreen(),
    ),
    // /project/result — 팀원 담당 (생성 결과 표시)
  ],
);
