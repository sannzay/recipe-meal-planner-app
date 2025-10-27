import 'package:flutter/material.dart';
import '../utils/ui_polish_constants.dart';

class PageTransitions {
  static Route<T> slideTransition<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
    Duration duration = UIPolishConstants.pageTransitionDuration,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = UIPolishConstants.defaultCurve;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static Route<T> fadeTransition<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
    Duration duration = UIPolishConstants.pageTransitionDuration,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  static Route<T> scaleTransition<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
    Duration duration = UIPolishConstants.pageTransitionDuration,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
    );
  }

  static Route<T> heroTransition<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
    Duration duration = UIPolishConstants.heroAnimationDuration,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return Hero(
          tag: 'page-${page.runtimeType}',
          child: child,
        );
      },
    );
  }
}

class AnimationWidgets {
  static Widget fadeIn({
    required Widget child,
    Duration duration = UIPolishConstants.animationNormal,
    Duration delay = Duration.zero,
    Curve curve = UIPolishConstants.defaultCurve,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: 0.0, end: 1.0),
      curve: curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget slideIn({
    required Widget child,
    Duration duration = UIPolishConstants.animationNormal,
    Duration delay = Duration.zero,
    Offset begin = const Offset(0, 1),
    Offset end = Offset.zero,
    Curve curve = UIPolishConstants.defaultCurve,
  }) {
    return TweenAnimationBuilder<Offset>(
      duration: duration,
      tween: Tween(begin: begin, end: end),
      curve: curve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: value,
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget scaleIn({
    required Widget child,
    Duration duration = UIPolishConstants.animationNormal,
    Duration delay = Duration.zero,
    double begin = 0.8,
    double end = 1.0,
    Curve curve = UIPolishConstants.defaultCurve,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: begin, end: end),
      curve: curve,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget staggeredList({
    required List<Widget> children,
    Duration staggerDelay = UIPolishConstants.listItemStaggerDelay,
    Duration itemDuration = UIPolishConstants.listItemAnimationDuration,
    Curve curve = UIPolishConstants.defaultCurve,
  }) {
    return Column(
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        return TweenAnimationBuilder<double>(
          duration: Duration(
            milliseconds: itemDuration.inMilliseconds + (index * staggerDelay.inMilliseconds),
          ),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: curve,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: child,
        );
      }).toList(),
    );
  }

  static Widget shimmer({
    required Widget child,
    bool isLoading = true,
    Duration duration = UIPolishConstants.skeletonShimmerDuration,
  }) {
    if (!isLoading) return child;

    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: -1.0, end: 1.0),
      builder: (context, value, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey[300]!,
                Colors.grey[100]!,
                Colors.grey[300]!,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(value - 0.3, -0.3),
              end: Alignment(value + 0.3, 0.3),
            ),
          ),
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget bounceIn({
    required Widget child,
    Duration duration = UIPolishConstants.animationSlow,
    Duration delay = Duration.zero,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: 0.0, end: 1.0),
      curve: UIPolishConstants.bounceCurve,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget rotateIn({
    required Widget child,
    Duration duration = UIPolishConstants.animationNormal,
    Duration delay = Duration.zero,
    double begin = -0.5,
    double end = 0.0,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: begin, end: end),
      curve: UIPolishConstants.defaultCurve,
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value * 2 * 3.14159,
          child: child,
        );
      },
      child: child,
    );
  }
}

class LoadingAnimations {
  static Widget pulse({
    required Widget child,
    Duration duration = UIPolishConstants.skeletonShimmerDuration,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: 0.5, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget spin({
    required Widget child,
    Duration duration = UIPolishConstants.progressAnimationDuration,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value * 2 * 3.14159,
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget wave({
    required Widget child,
    Duration duration = UIPolishConstants.skeletonShimmerDuration,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: -1.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(value * 10, 0),
          child: child,
        );
      },
      child: child,
    );
  }
}

class InteractiveAnimations {
  static Widget hoverScale({
    required Widget child,
    double scale = UIPolishConstants.cardHoverScale,
    Duration duration = UIPolishConstants.cardHoverDuration,
  }) {
    return MouseRegion(
      child: AnimatedContainer(
        duration: duration,
        curve: UIPolishConstants.defaultCurve,
        transform: Matrix4.identity()..scale(scale),
        child: child,
      ),
    );
  }

  static Widget pressScale({
    required Widget child,
    double scale = UIPolishConstants.buttonPressScale,
    Duration duration = UIPolishConstants.buttonPressDuration,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTapDown: (_) {
        // Scale down animation would go here
      },
      onTapUp: (_) {
        // Scale back up animation would go here
      },
      onTap: onTap,
      child: child,
    );
  }

  static Widget ripple({
    required Widget child,
    Color? rippleColor,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(UIPolishConstants.radiusM),
        child: child,
      ),
    );
  }
}

class SkeletonLoaders {
  static Widget card({
    double? width,
    double? height,
    BorderRadius? borderRadius,
  }) {
    return Container(
      width: width,
      height: height ?? UIPolishConstants.cardMinHeight,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: borderRadius ?? BorderRadius.circular(UIPolishConstants.skeletonBorderRadius),
      ),
      child: LoadingAnimations.pulse(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(UIPolishConstants.skeletonBorderRadius),
            gradient: LinearGradient(
              colors: [
                Colors.grey[300]!,
                Colors.grey[100]!,
                Colors.grey[300]!,
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget list({
    int itemCount = 5,
    double itemHeight = UIPolishConstants.listItemHeight,
  }) {
    return Column(
      children: List.generate(itemCount, (index) {
        return Container(
          height: itemHeight,
          margin: const EdgeInsets.symmetric(vertical: UIPolishConstants.spacingS),
          child: card(
            height: itemHeight,
            borderRadius: BorderRadius.circular(UIPolishConstants.radiusM),
          ),
        );
      }),
    );
  }

  static Widget text({
    double? width,
    double height = UIPolishConstants.skeletonHeight,
    BorderRadius? borderRadius,
  }) {
    return card(
      width: width,
      height: height,
      borderRadius: borderRadius ?? BorderRadius.circular(UIPolishConstants.skeletonBorderRadius),
    );
  }

  static Widget circle({
    double size = UIPolishConstants.iconSizeXL,
  }) {
    return card(
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
    );
  }
}
