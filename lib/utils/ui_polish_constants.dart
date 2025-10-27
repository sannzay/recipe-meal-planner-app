import 'package:flutter/material.dart';

class UIPolishConstants {
  // Consistent spacing and padding
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Consistent border radius
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXL = 16.0;
  static const double radiusFull = 999.0;

  // Consistent elevation
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;

  // Animation durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Safe area padding
  static const EdgeInsets safeAreaPadding = EdgeInsets.all(16.0);
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);

  // Button dimensions
  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightLarge = 56.0;
  static const double fabSize = 56.0;
  static const double fabSizeSmall = 40.0;

  // Icon sizes
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 48.0;

  // Grid and list dimensions
  static const double gridSpacing = 16.0;
  static const double listItemHeight = 72.0;
  static const double cardMinHeight = 200.0;
  static const double imageAspectRatio = 16 / 9;

  // Typography scales
  static const double fontSizeXS = 10.0;
  static const double fontSizeS = 12.0;
  static const double fontSizeM = 14.0;
  static const double fontSizeL = 16.0;
  static const double fontSizeXL = 18.0;
  static const double fontSizeXXL = 24.0;
  static const double fontSizeTitle = 28.0;
  static const double fontSizeHeadline = 32.0;

  // Accessibility
  static const double minTouchTarget = 44.0;
  static const double minContrastRatio = 4.5;

  // Responsive breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;

  // Loading states
  static const Duration loadingDelay = Duration(milliseconds: 200);
  static const Duration skeletonDuration = Duration(milliseconds: 1500);

  // Form validation
  static const Duration validationDelay = Duration(milliseconds: 500);
  static const int maxSearchLength = 100;
  static const int maxDescriptionLength = 500;

  // Error states
  static const Duration errorDisplayDuration = Duration(seconds: 4);
  static const Duration retryDelay = Duration(seconds: 2);

  // Keyboard handling
  static const Duration keyboardAnimationDuration = Duration(milliseconds: 300);
  static const double keyboardPadding = 20.0;

  // Dark mode specific adjustments
  static const double darkModeElevationMultiplier = 1.5;
  static const double darkModeOpacityMultiplier = 0.8;

  // Tablet specific
  static const double tabletMaxWidth = 1200.0;
  static const double tabletSidebarWidth = 300.0;
  static const int tabletGridColumns = 3;
  static const int tabletListColumns = 2;

  // Animation curves
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve fastCurve = Curves.easeOut;
  static const Curve slowCurve = Curves.easeIn;
  static const Curve bounceCurve = Curves.elasticOut;

  // Button states
  static const Duration buttonPressDuration = Duration(milliseconds: 100);
  static const double buttonPressScale = 0.95;
  static const double buttonDisabledOpacity = 0.6;

  // Card states
  static const Duration cardHoverDuration = Duration(milliseconds: 200);
  static const double cardHoverScale = 1.02;
  static const double cardHoverElevation = 8.0;

  // List animations
  static const Duration listItemAnimationDuration = Duration(milliseconds: 300);
  static const Duration listItemStaggerDelay = Duration(milliseconds: 50);

  // Page transitions
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Duration heroAnimationDuration = Duration(milliseconds: 500);

  // Snackbar and toast
  static const Duration snackbarDuration = Duration(seconds: 3);
  static const Duration toastDuration = Duration(seconds: 2);

  // Pull to refresh
  static const Duration pullToRefreshDuration = Duration(milliseconds: 1000);
  static const double pullToRefreshThreshold = 100.0;

  // Search and filter
  static const Duration searchDebounceDelay = Duration(milliseconds: 300);
  static const Duration filterAnimationDuration = Duration(milliseconds: 200);

  // Modal and dialog
  static const Duration modalAnimationDuration = Duration(milliseconds: 300);
  static const Duration dialogAnimationDuration = Duration(milliseconds: 250);
  static const double modalMaxWidth = 500.0;
  static const double dialogMaxWidth = 400.0;

  // Bottom sheet
  static const Duration bottomSheetAnimationDuration = Duration(milliseconds: 300);
  static const double bottomSheetMaxHeight = 0.9;
  static const double bottomSheetMinHeight = 0.3;

  // Tab bar
  static const Duration tabAnimationDuration = Duration(milliseconds: 200);
  static const double tabIndicatorHeight = 3.0;

  // Progress indicators
  static const Duration progressAnimationDuration = Duration(milliseconds: 1000);
  static const double progressIndicatorSize = 24.0;
  static const double progressIndicatorSizeLarge = 48.0;

  // Skeleton loading
  static const Duration skeletonShimmerDuration = Duration(milliseconds: 1500);
  static const double skeletonBorderRadius = 4.0;
  static const double skeletonHeight = 20.0;

  // Image loading
  static const Duration imageFadeInDuration = Duration(milliseconds: 300);
  static const Duration imageCacheDuration = Duration(days: 7);
  static const int imageMaxRetries = 3;

  // Gesture handling
  static const Duration longPressDuration = Duration(milliseconds: 500);
  static const Duration doubleTapDuration = Duration(milliseconds: 300);
  static const double swipeThreshold = 50.0;

  // Accessibility
  static const Duration accessibilityAnnouncementDelay = Duration(milliseconds: 100);
  static const double accessibilityMinFontSize = 14.0;
  static const double accessibilityMaxFontSize = 24.0;

  // Performance
  static const int maxListItems = 100;
  static const int maxSearchResults = 50;
  static const Duration cacheExpiration = Duration(hours: 1);

  // Error boundaries
  static const Duration errorRetryDelay = Duration(seconds: 2);
  static const int maxRetryAttempts = 3;
  static const Duration errorDisplayTimeout = Duration(seconds: 5);
}
