import 'package:flutter/material.dart';
import '../state/app_state.dart';

class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final String pageName;
  const ErrorBoundary({super.key, required this.child, this.pageName = 'Unknown'});

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  ErrorWidgetBuilder? _originalBuilder;

  @override
  void initState() {
    super.initState();
    _originalBuilder = ErrorWidget.builder;
  }

  @override
  void dispose() {
    if (_originalBuilder != null) {
      ErrorWidget.builder = _originalBuilder!;
    }
    super.dispose();
  }

  Widget _buildErrorUI(FlutterErrorDetails details) {
    final message = details.exceptionAsString();
    final short = message.length > 200 ? '${message.substring(0, 200)}...' : message;
    appState.log('ERROR', '${widget.pageName}: $short', color: Colors.red);

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
            Text(short,
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
              onPressed: () {
                appState.log('ERROR', 'Retry pressed on ${widget.pageName}', color: Colors.orange);
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (FlutterErrorDetails details) => _buildErrorUI(details);
    return widget.child;
  }
}
