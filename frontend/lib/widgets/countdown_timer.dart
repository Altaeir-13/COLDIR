import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime startTime;
  final TextStyle? textStyle;

  const CountdownTimer({
    super.key,
    required this.startTime,
    this.textStyle,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration _remaining;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _remaining = _calcRemaining();
    _startTicker();
  }

  @override
  void didUpdateWidget(covariant CountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startTime != widget.startTime) {
      _remaining = _calcRemaining();
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _startTicker() {
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final next = _calcRemaining();
      if (!mounted) return;

      setState(() => _remaining = next);

      if (next == Duration.zero) {
        _ticker?.cancel();
      }
    });
  }

  Duration _calcRemaining() {
    final now = DateTime.now();
    final diff = widget.startTime.difference(now);
    return diff.isNegative ? Duration.zero : diff;
  }

  String _format(Duration d) {
    if (d.inHours >= 24) {
      return '${d.inDays}d';
    }
    final hh = d.inHours.toString().padLeft(2, '0');
    final mm = (d.inMinutes % 60).toString().padLeft(2, '0');
    final ss = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _format(_remaining),
      style: widget.textStyle ?? Theme.of(context).textTheme.titleMedium,
    );
  }
}
