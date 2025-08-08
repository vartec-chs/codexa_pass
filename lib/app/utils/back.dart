import 'package:codexa_pass/app/routing/routes_path.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

void navigateBack(BuildContext context) {
  context.go(AppRoutes.home);
}
