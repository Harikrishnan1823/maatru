import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

// ── Providers ──────────────────────────────────────────────
final fromLangProvider = StateProvider<Map<String, String>>((ref) => AppConstants.languages[0]);
final toLangProvider = StateProvider<Map<String, String>>((ref) => AppConstants.languages[1]);
final selectedScenarioProvider = StateProvider<String>((ref) => 'hospital');
final isRecordingProvider = StateProvider<bool>((ref) => false);

// ── Home Screen ────────────────────────────────────────────
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedScenarioId = ref.watch(selectedScenarioProvider);
    final scenario = AppConstants.scenarios.firstWhere((s) => s['id'] == selectedScenarioId);
    final scenarioColor = Color(scenario['color'] as int);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.6),
            radius: 1.2,
            colors: [
              scenarioColor.withOpacity(0.15),
              Colors.white,
            ],
            stops: const [0.0, 0.6],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context, ref),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _ScenarioDropdown(),
                      const SizedBox(height: 60),
                      _AnimatedMicButton(scenarioColor: scenarioColor),
                      const SizedBox(height: 40),
                      _ResultCards(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, WidgetRef ref) {
    final fromLang = ref.watch(fromLangProvider);
    final toLang = ref.watch(toLangProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () {},
          ),
          Row(
            children: [
              Text(
                fromLang['name']!,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.arrow_right_alt, color: Colors.black54, size: 20),
              ),
              Text(
                toLang['name']!,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.swap_horiz, color: Colors.black87),
            onPressed: () {
              final from = ref.read(fromLangProvider);
              final to = ref.read(toLangProvider);
              ref.read(fromLangProvider.notifier).state = to;
              ref.read(toLangProvider.notifier).state = from;
            },
          ),
        ],
      ),
    );
  }
}

// ── Scenario Dropdown ──────────────────────────────────────
class _ScenarioDropdown extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedScenarioProvider);
    final scenario = AppConstants.scenarios.firstWhere((s) => s['id'] == selectedId);
    final color = Color(scenario['color'] as int);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedId,
          icon: Icon(Icons.keyboard_arrow_down, color: color),
          isDense: true,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(16),
          items: AppConstants.scenarios.map((s) {
            final sColor = Color(s['color'] as int);
            return DropdownMenuItem<String>(
              value: s['id'] as String,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(s['icon'] as String, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text(
                    s['name'] as String,
                    style: TextStyle(
                      color: sColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              ref.read(selectedScenarioProvider.notifier).state = val;
            }
          },
        ),
      ),
    );
  }
}

// ── Mic Button & Waveform ──────────────────────────────────
class _AnimatedMicButton extends ConsumerStatefulWidget {
  final Color scenarioColor;

  const _AnimatedMicButton({required this.scenarioColor});

  @override
  ConsumerState<_AnimatedMicButton> createState() => _AnimatedMicButtonState();
}

class _AnimatedMicButtonState extends ConsumerState<_AnimatedMicButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRecording = ref.watch(isRecordingProvider);
    
    // Use addPostFrameCallback to safely start/stop animation without modifying providers during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isRecording && !_controller.isAnimating) {
        _controller.repeat(reverse: true);
      } else if (!isRecording && _controller.isAnimating) {
        _controller.stop();
        _controller.value = 0.5; // Neutral state
      }
    });

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isRecording) ...[
              _buildWaveform(true).animate().fade().scale(),
              const SizedBox(width: 20),
            ],
            GestureDetector(
              onTapDown: (_) => ref.read(isRecordingProvider.notifier).state = true,
              onTapUp: (_) => ref.read(isRecordingProvider.notifier).state = false,
              onTapCancel: () => ref.read(isRecordingProvider.notifier).state = false,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isRecording ? 130 : 120,
                height: isRecording ? 130 : 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.scenarioColor.withOpacity(0.6),
                      widget.scenarioColor,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.scenarioColor.withOpacity(isRecording ? 0.6 : 0.3),
                      blurRadius: isRecording ? 40 : 20,
                      spreadRadius: isRecording ? 10 : 0,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.mic,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
            if (isRecording) ...[
              const SizedBox(width: 20),
              _buildWaveform(false).animate().fade().scale(),
            ],
          ],
        ),
        const SizedBox(height: 24),
        Text(
          isRecording ? 'Listening...' : 'Tap & Speak',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Release to translate',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildWaveform(bool isLeft) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            // Create some fake wave animation math
            final offset = isLeft ? index : 4 - index;
            final height = 15.0 + 20.0 * math.sin((_controller.value * math.pi * 2) + offset);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 4,
              height: height.abs() + 5,
              decoration: BoxDecoration(
                color: widget.scenarioColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        );
      },
    );
  }
}

// ── Result Cards ───────────────────────────────────────────
class _ResultCards extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scenarioId = ref.watch(selectedScenarioProvider);
    final scenario = AppConstants.scenarios.firstWhere((s) => s['id'] == scenarioId);
    final color = Color(scenario['color'] as int);

    return Column(
      children: [
        _ResultCard(
          label: 'You said (Tamil)',
          text: 'எனக்கு நெஞ்சு வலி இருக்கிறது',
          icon: Icons.volume_up_outlined,
          color: color,
        ),
        const SizedBox(height: 16),
        _ResultCard(
          label: 'Translated (English)',
          text: 'I have chest pain',
          icon: Icons.copy_outlined,
          color: color,
          isTranslated: true,
        ),
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String label;
  final String text;
  final IconData icon;
  final Color color;
  final bool isTranslated;

  const _ResultCard({
    required this.label,
    required this.text,
    required this.icon,
    required this.color,
    this.isTranslated = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (!isTranslated)
                Icon(icon, size: 20, color: Colors.grey.shade400)
              else
                Row(
                  children: [
                    Icon(icon, size: 20, color: Colors.grey.shade400),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: isTranslated ? 22 : 18,
              fontWeight: isTranslated ? FontWeight.bold : FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          if (isTranslated) ...[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.play_arrow, color: Colors.white, size: 24),
                ),
                Expanded(
                  child: Container(
                    height: 30,
                    margin: const EdgeInsets.only(left: 16),
                    child: CustomPaint(
                      painter: _StaticWaveformPainter(color: color),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StaticWaveformPainter extends CustomPainter {
  final Color color;

  _StaticWaveformPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.5)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final random = math.Random(42);
    final count = (size.width / 6).floor();

    for (int i = 0; i < count; i++) {
      final height = 10 + random.nextDouble() * 20;
      final x = i * 6.0;
      canvas.drawLine(
        Offset(x, size.height / 2 - height / 2),
        Offset(x, size.height / 2 + height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}