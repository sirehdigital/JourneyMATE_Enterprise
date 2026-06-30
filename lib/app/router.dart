import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/ai_command_center/presentation/screens/ai_command_center_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/showcase/presentation/screens/showcase_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/dashboard',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),

    GoRoute(
      path: '/ai',
      builder: (context, state) => const AICommandCenterScreen(),
    ),

    GoRoute(
      path: '/showcase',
      builder: (context, state) => const ShowcaseScreen(),
    ),

    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
  ],
);
