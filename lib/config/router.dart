import 'package:gemini_hackathon/features/home/pages/home_page.dart';
import 'package:go_router/go_router.dart';

import '../screens/home_screen.dart';
import '../screens/new_project_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/project/new',
      builder: (context, state) => const NewProjectScreen(),
    ),
    GoRoute(
      path: '/project/result',
      builder: (context, state) =>
          HomePage(initialHtml: state.extra as String?),
    ),
  ],
);
