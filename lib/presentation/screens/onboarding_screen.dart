import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/routes.dart';

class _OnboardingSlide {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String body;

  const _OnboardingSlide({
    required this.icon,
    this.iconColor,
    required this.title,
    required this.body,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  final List<_OnboardingSlide> _slides = const [
    _OnboardingSlide(
      icon: Icons.bolt,
      iconColor: Color(0xFF0F9D58),
      title: 'Borrow instantly',
      body: 'Run out of prepaid electricity? Borrow a token the moment you need it — no paperwork.',
    ),
    _OnboardingSlide(
      icon: Icons.phone_iphone,
      iconColor: Color(0xFF4285F4),
      title: 'Get your token',
      body: 'Your electricity token lands on your phone immediately, and by SMS as backup.',
    ),
    _OnboardingSlide(
      icon: Icons.credit_card,
      iconColor: Color(0xFFF4B400),
      title: 'Repay later',
      body: 'Settle what you borrowed later through any supported payment method.',
    ),
    _OnboardingSlide(
      icon: Icons.rocket_launch,
      iconColor: Color(0xFF0F9D58),
      title: "You're all set",
      body: 'No sign-up, no passwords. Just verify your number when you\'re ready to boost.',
    ),
  ];

  int _index = 0;

  void _next() {
    if (_index < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finish();
    }
  }

  void _finish() => Get.offAllNamed(AppRoutes.home);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finish,
                child: const Text('Skip'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final slide = _slides[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: (slide.iconColor!).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Icon(
                            slide.icon,
                            size: 64,
                            color: slide.iconColor,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          slide.title,
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: scheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          slide.body,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: scheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_slides.length, (i) {
                  final active = i == _index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    width: active ? 22 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: active ? scheme.primary : scheme.outlineVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              child: FilledButton(
                onPressed: _next,
                child: Text(_index == _slides.length - 1 ? 'Get started' : 'Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
