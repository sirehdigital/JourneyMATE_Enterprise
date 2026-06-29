import 'package:flutter/material.dart';

import 'router.dart';

class JourneyMATEApp extends StatelessWidget {
  const JourneyMATEApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'JourneyMATE Enterprise',
      routerConfig: appRouter,
    );
  }
}
