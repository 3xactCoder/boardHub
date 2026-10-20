import 'package:flutter/material.dart';

import '../utils/responsive.dart';

/// Прокручуваний контейнер сторінки з адаптивними відступами.
class PageContainer extends StatelessWidget {
  final List<Widget> children;

  const PageContainer({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final padding = context.isDesktop
        ? const EdgeInsets.fromLTRB(40, 40, 40, 40)
        : const EdgeInsets.fromLTRB(20, 32, 20, 24);

    return SingleChildScrollView(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
