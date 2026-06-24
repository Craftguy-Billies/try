import 'package:flutter/material.dart';

class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final String pageName;
  const ErrorBoundary({super.key, required this.child, this.pageName = 'Unknown'});

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  StackTrace? _stack;

  @override
  void initState() {
    super.initState();
    ErrorWidget.builder = (details) {
      _error = details.exception;
      _stack = details.stack;
      // Re-wrap in our error UI for the specific subtree
      return _buildErrorUI(details.exception.toString());
    };
  }

  Widget _buildErrorUI(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text('Something went wrong in ${widget.pageName}',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(message.length > 200 ? '${message.substring(0, 200)}...' : message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
                fontFamily: 'monospace',
                fontSize: 11,
              ),
              textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              onPressed: () => setState(() { _error = null; _stack = null; }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return _buildErrorUI(_error.toString());
    return widget.child;
  }
}
