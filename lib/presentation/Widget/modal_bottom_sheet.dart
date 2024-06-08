import 'package:flutter/material.dart';

class BottomSheetPage<T> extends Page<T> {
  final WidgetBuilder builder;

  const BottomSheetPage({
    required this.builder,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return ModalBottomSheetRoute(
      settings: this,
      builder: builder,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height,
      ),
      useSafeArea: true,
      showDragHandle: true,
    );
  }
}
