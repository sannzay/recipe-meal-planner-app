import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccessibilityHelper {
  static void announceToScreenReader(String message) {
    SystemChannels.accessibility.invokeMethod('announce', message);
  }

  static bool isHighContrastMode(BuildContext context) {
    return MediaQuery.of(context).highContrast;
  }

  static bool isReducedMotion(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  static double getAccessibleFontSize(BuildContext context, double baseSize) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return (baseSize * textScaleFactor).clamp(14.0, 24.0);
  }

  static Color getAccessibleColor(BuildContext context, Color baseColor) {
    if (isHighContrastMode(context)) {
      return baseColor.withOpacity(1.0);
    }
    return baseColor;
  }

  static EdgeInsets getAccessiblePadding(BuildContext context, EdgeInsets basePadding) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    if (textScaleFactor > 1.2) {
      return EdgeInsets.all(basePadding.left * textScaleFactor);
    }
    return basePadding;
  }

  static double getMinTouchTarget(BuildContext context) {
    return MediaQuery.of(context).textScaleFactor > 1.2 ? 56.0 : 44.0;
  }
}

class ResponsiveHelper {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 900;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
  }

  static int getGridColumns(BuildContext context) {
    if (isMobile(context)) return 2;
    if (isTablet(context)) return 3;
    return 4;
  }

  static double getCardWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (isMobile(context)) return (width - 48) / 2;
    if (isTablet(context)) return (width - 64) / 3;
    return (width - 80) / 4;
  }

  static EdgeInsets getScreenPadding(BuildContext context) {
    if (isMobile(context)) return const EdgeInsets.all(16);
    if (isTablet(context)) return const EdgeInsets.all(24);
    return const EdgeInsets.all(32);
  }

  static double getMaxContentWidth(BuildContext context) {
    if (isMobile(context)) return double.infinity;
    if (isTablet(context)) return 800;
    return 1200;
  }
}

class AnimationHelper {
  static Widget fadeTransition({
    required Widget child,
    required Animation<double> animation,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  static Widget slideTransition({
    required Widget child,
    required Animation<double> animation,
    Offset begin = const Offset(0, 1),
    Offset end = Offset.zero,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: begin,
        end: end,
      ).animate(animation),
      child: child,
    );
  }

  static Widget scaleTransition({
    required Widget child,
    required Animation<double> animation,
    double begin = 0.8,
    double end = 1.0,
  }) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: begin,
        end: end,
      ).animate(animation),
      child: child,
    );
  }

  static Widget staggeredList({
    required List<Widget> children,
    Duration staggerDelay = const Duration(milliseconds: 50),
  }) {
    return Column(
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * staggerDelay.inMilliseconds)),
          tween: Tween(begin: 0.0, end: 1.0),
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
}

class LoadingStateHelper {
  static Widget buildSkeletonCard({
    double? width,
    double? height,
    BorderRadius? borderRadius,
  }) {
    return Container(
      width: width,
      height: height ?? 200,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static Widget buildSkeletonList({
    int itemCount = 5,
    double itemHeight = 72,
  }) {
    return Column(
      children: List.generate(itemCount, (index) {
        return Container(
          height: itemHeight,
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }

  static Widget buildShimmerEffect({
    required Widget child,
    bool isLoading = true,
  }) {
    if (!isLoading) return child;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey[300]!,
            Colors.grey[100]!,
            Colors.grey[300]!,
          ],
          stops: const [0.0, 0.5, 1.0],
          begin: const Alignment(-1.0, -0.3),
          end: const Alignment(1.0, 0.3),
        ),
      ),
      child: child,
    );
  }
}

class ErrorStateHelper {
  static Widget buildErrorCard({
    required String message,
    VoidCallback? onRetry,
    IconData icon = Icons.error_outline,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static Widget buildEmptyState({
    required String message,
    required String actionText,
    required VoidCallback onAction,
    IconData icon = Icons.inbox_outlined,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onAction,
            child: Text(actionText),
          ),
        ],
      ),
    );
  }
}

class KeyboardHelper {
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static void showKeyboard(BuildContext context, FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  static Widget buildKeyboardAwareScaffold({
    required Widget body,
    PreferredSizeWidget? appBar,
    Widget? floatingActionButton,
    Widget? bottomNavigationBar,
  }) {
    return Scaffold(
      appBar: appBar,
      body: KeyboardDismissOnTap(
        child: body,
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class KeyboardDismissOnTap extends StatelessWidget {
  final Widget child;

  const KeyboardDismissOnTap({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => KeyboardHelper.hideKeyboard(context),
      child: child,
    );
  }
}
