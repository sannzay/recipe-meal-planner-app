import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/ui_polish_constants.dart';
import '../utils/ui_helpers.dart';

class PolishedScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool extendBodyBehindAppBar;
  final bool extendBody;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;

  const PolishedScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.extendBodyBehindAppBar = false,
    this.extendBody = false,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: appBar,
        body: SafeArea(
          child: body,
        ),
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        extendBody: extendBody,
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      ),
    );
  }
}

class PolishedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Color? color;
  final VoidCallback? onTap;
  final bool enabled;

  const PolishedCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.borderRadius,
    this.color,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      margin: margin ?? const EdgeInsets.all(UIPolishConstants.spacingS),
      child: Material(
        elevation: elevation ?? (isDark ? UIPolishConstants.elevationMedium * UIPolishConstants.darkModeElevationMultiplier : UIPolishConstants.elevationLow),
        borderRadius: borderRadius ?? BorderRadius.circular(UIPolishConstants.radiusL),
        color: color ?? theme.cardColor,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: borderRadius ?? BorderRadius.circular(UIPolishConstants.radiusL),
          child: Container(
            padding: padding ?? UIPolishConstants.cardPadding,
            child: child,
          ),
        ),
      ),
    );
  }
}

class PolishedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final bool isLoading;
  final bool isFullWidth;
  final double? height;
  final EdgeInsets? padding;

  const PolishedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.style,
    this.isLoading = false,
    this.isFullWidth = false,
    this.height,
    this.padding,
  });

  @override
  State<PolishedButton> createState() => _PolishedButtonState();
}

class _PolishedButtonState extends State<PolishedButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: UIPolishConstants.buttonPressDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: UIPolishConstants.buttonPressScale,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: UIPolishConstants.defaultCurve,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _animationController.forward();
      HapticFeedback.lightImpact();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.isFullWidth ? double.infinity : null,
              height: widget.height ?? UIPolishConstants.buttonHeight,
              padding: widget.padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(UIPolishConstants.radiusM),
                color: widget.onPressed != null && !widget.isLoading
                    ? theme.primaryColor
                    : theme.disabledColor,
              ),
              child: Center(
                child: widget.isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      )
                    : DefaultTextStyle(
                        style: TextStyle(
                          color: widget.onPressed != null && !widget.isLoading
                              ? theme.colorScheme.onPrimary
                              : theme.disabledColor,
                          fontWeight: FontWeight.w500,
                          fontSize: UIPolishConstants.fontSizeL,
                        ),
                        child: widget.child,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PolishedTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;

  const PolishedTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
  });

  @override
  State<PolishedTextField> createState() => _PolishedTextFieldState();
}

class _PolishedTextFieldState extends State<PolishedTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: UIPolishConstants.fontSizeM,
              fontWeight: FontWeight.w500,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: UIPolishConstants.spacingS),
        ],
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(UIPolishConstants.radiusM),
            border: Border.all(
              color: _isFocused ? theme.primaryColor : theme.dividerColor,
              width: _isFocused ? 2 : 1,
            ),
            color: widget.enabled ? theme.cardColor : theme.disabledColor,
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            validator: widget.validator,
            onChanged: widget.onChanged,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            decoration: InputDecoration(
              hintText: widget.hint,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: UIPolishConstants.spacingM,
                vertical: UIPolishConstants.spacingM,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PolishedLoadingIndicator extends StatelessWidget {
  final String? message;
  final double size;
  final Color? color;

  const PolishedLoadingIndicator({
    super.key,
    this.message,
    this.size = UIPolishConstants.progressIndicatorSize,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? theme.primaryColor,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: UIPolishConstants.spacingM),
            Text(
              message!,
              style: TextStyle(
                fontSize: UIPolishConstants.fontSizeM,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class PolishedEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String actionText;
  final VoidCallback? onAction;

  const PolishedEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: UIPolishConstants.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: UIPolishConstants.iconSizeXL * 2,
              color: theme.disabledColor,
            ),
            const SizedBox(height: UIPolishConstants.spacingL),
            Text(
              title,
              style: TextStyle(
                fontSize: UIPolishConstants.fontSizeXL,
                fontWeight: FontWeight.w500,
                color: theme.textTheme.headlineSmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: UIPolishConstants.spacingS),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: UIPolishConstants.fontSizeM,
                color: theme.textTheme.bodyMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null) ...[
              const SizedBox(height: UIPolishConstants.spacingXL),
              PolishedButton(
                onPressed: onAction,
                child: Text(actionText),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class PolishedErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  const PolishedErrorState({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: UIPolishConstants.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: UIPolishConstants.iconSizeXL * 2,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: UIPolishConstants.spacingL),
            Text(
              message,
              style: TextStyle(
                fontSize: UIPolishConstants.fontSizeL,
                color: theme.textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: UIPolishConstants.spacingXL),
              PolishedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
