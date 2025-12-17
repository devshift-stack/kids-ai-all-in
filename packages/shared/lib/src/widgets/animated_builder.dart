import 'package:flutter/material.dart';

/// A wrapper around [AnimatedWidget] that uses a builder function.
/// 
/// Similar to [AnimatedBuilder] but with a simpler API.
/// Use this when you need to rebuild a widget tree in response to animation changes.
/// 
/// Example:
/// ```dart
/// KidsAnimatedBuilder(
///   listenable: _controller,
///   builder: (context, child) {
///     return Transform.scale(
///       scale: _animation.value,
///       child: child,
///     );
///   },
///   child: const Text('Animated!'),
/// )
/// ```
class KidsAnimatedBuilder extends AnimatedWidget {
  /// Builder function called when the animation changes.
  /// 
  /// The [child] parameter is the same widget passed to the constructor,
  /// useful for optimization when parts of the widget tree don't depend on the animation.
  final Widget Function(BuildContext context, Widget? child) builder;
  
  /// Optional child widget that doesn't depend on the animation.
  /// 
  /// Pass a child widget here if it doesn't change when the animation changes.
  /// This optimizes rebuilds by not recreating the child widget.
  final Widget? child;

  const KidsAnimatedBuilder({
    super.key,
    required super.listenable,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) => builder(context, child);
}
