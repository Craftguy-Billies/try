import 'package:flutter/material.dart';
import '../state/app_state.dart';

class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(Object error, VoidCallback retry)? errorBuilder;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  late final ErrorWidgetBuilder _originalBuilder;

  @override
  void initState() {
    super.initState();
    _originalBuilder = ErrorWidget.builder;
    ErrorWidget.builder = (FlutterErrorDetails details) {
      final appState = AppState();
      appState.log('ERROR', details.exceptionAsString(),
          {'summary': details.summary.toString()});

      if (_error == null && mounted) {
        setState(() => _error = details.exception);
      }

      return widget.errorBuilder?.call(
                details.exception,
                () {
                  if (mounted) {
                    setState(() => _error = null);
                  }
                },
              ) ??
          _DefaultErrorWidget(
            error: details.exceptionAsString(),
            onRetry: () {
              if (mounted) {
                setState(() => _error = null);
              }
            },
          );
    };
  }

  @override
  void dispose() {
    ErrorWidget.builder = _originalBuilder;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder?.call(
            _error!,
            () {
              if (mounted) {
                setState(() => _error = null);
              }
            },
          ) ??
          _DefaultErrorWidget(
            error: _error.toString(),
            onRetry: () {
              if (mounted) {
                setState(() => _error = null);
              }
            },
          );
    }

    return widget.child;
  }
}

class _DefaultErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _DefaultErrorWidget({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF44336).withAlpha(25),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFF44336),
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Something went wrong',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withAlpha(120),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Text(
                  error,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withAlpha(180),
                    height: 1.4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              style: FilledButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
