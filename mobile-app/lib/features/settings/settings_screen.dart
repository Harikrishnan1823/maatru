import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

// ── Settings Providers ─────────────────────────────────────
final speechRateProvider = StateProvider<double>((ref) => 0.5);
final isDarkModeProvider = StateProvider<bool>((ref) => false);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speechRate = ref.watch(speechRateProvider);
    final isDark = ref.watch(isDarkModeProvider);

    return Scaffold(
      backgroundColor: AppTheme.lightBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppTheme.navy,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // ── Language Section ─────────────────────────────
          _SectionHeader(title: 'Default Language'),
          _SettingsCard(
            children: [
              _LanguageSettingRow(
                label: 'I speak',
                icon: Icons.mic,
                settingsKey: 'defaultFromLang',
                defaultValue: 'Tamil',
              ),
              const Divider(height: 1),
              _LanguageSettingRow(
                label: 'They hear',
                icon: Icons.volume_up,
                settingsKey: 'defaultToLang',
                defaultValue: 'English',
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Speech Section ───────────────────────────────
          _SectionHeader(title: 'Speech'),
          _SettingsCard(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.speed,
                            size: 18, color: AppTheme.navy),
                        const SizedBox(width: 8),
                        const Text(
                          'Speech Rate',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.navy,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          speechRate < 0.35
                              ? 'Slow'
                              : speechRate < 0.65
                                  ? 'Normal'
                                  : 'Fast',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: speechRate,
                      min: 0.1,
                      max: 1.0,
                      divisions: 9,
                      activeColor: AppTheme.primary,
                      onChanged: (val) {
                        ref.read(speechRateProvider.notifier).state = val;
                        Hive.box('settings').put('speechRate', val);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Slow',
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade400)),
                        Text('Normal',
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade400)),
                        Text('Fast',
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade400)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Appearance Section ───────────────────────────
          _SectionHeader(title: 'Appearance'),
          _SettingsCard(
            children: [
              _ToggleRow(
                icon: Icons.dark_mode_outlined,
                label: 'Dark Mode',
                value: isDark,
                onChanged: (val) {
                  ref.read(isDarkModeProvider.notifier).state = val;
                  Hive.box('settings').put('darkMode', val);
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── About Section ────────────────────────────────
          _SectionHeader(title: 'About'),
          _SettingsCard(
            children: [
              _InfoRow(
                icon: Icons.info_outline,
                label: 'App Name',
                value: 'Maatru (மாற்று)',
              ),
              const Divider(height: 1),
              _InfoRow(
                icon: Icons.code,
                label: 'Version',
                value: '1.0.0 (Beta)',
              ),
              const Divider(height: 1),
              _InfoRow(
                icon: Icons.translate,
                label: 'Languages',
                value: '6 Indian Languages',
              ),
              const Divider(height: 1),
              _InfoRow(
                icon: Icons.android,
                label: 'Platform',
                value: 'Android',
              ),
            ],
          ),

          const SizedBox(height: 32),

          // ── Tagline ──────────────────────────────────────
          Center(
            child: Text(
              '"Speak yours. They hear theirs."',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade400,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'மாற்று — Language has no border',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.primary.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Reusable Widgets ───────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade500,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final Function(bool) onChanged;

  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.navy),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppTheme.navy,
            ),
          ),
          const Spacer(),
          Switch(
            value: value,
            activeColor: AppTheme.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.navy),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppTheme.navy,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageSettingRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final String settingsKey;
  final String defaultValue;

  const _LanguageSettingRow({
    required this.label,
    required this.icon,
    required this.settingsKey,
    required this.defaultValue,
  });

  @override
  Widget build(BuildContext context) {
    final saved = Hive.box('settings').get(settingsKey,
        defaultValue: defaultValue) as String;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.navy),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppTheme.navy,
            ),
          ),
          const Spacer(),
          DropdownButton<String>(
            value: AppConstants.languages
                    .any((l) => l['name'] == saved)
                ? saved
                : defaultValue,
            underline: const SizedBox(),
            icon: const Icon(Icons.keyboard_arrow_down,
                color: AppTheme.navy, size: 18),
            style: const TextStyle(
              color: AppTheme.navy,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            items: AppConstants.languages.map((lang) {
              return DropdownMenuItem(
                value: lang['name'],
                child: Text(lang['name']!),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                Hive.box('settings').put(settingsKey, val);
              }
            },
          ),
        ],
      ),
    );
  }
}