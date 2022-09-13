import 'package:extra_alignments/extra_alignments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/animate.dart';
import 'package:flutter_animate/effects/effects.dart';
import 'package:flutter_animate/num_duration_extensions.dart';
import 'package:gap/gap.dart';
import 'package:flutter_intro_screen/default_text_color.dart';
import 'package:flutter_intro_screen/indicator.dart';

class IntroDurations {
  final Duration fast;
  final Duration med;
  final Duration slow;
  final Duration pageTransition;

  const IntroDurations({
    this.fast = const Duration(milliseconds: 300),
    this.med = const Duration(milliseconds: 600),
    this.slow = const Duration(milliseconds: 900),
    this.pageTransition = const Duration(milliseconds: 200),
  });
}

class IntroMessages {
  final String swap;
  final String navigate;

  const IntroMessages({
    this.swap = "Swap left to continue",
    this.navigate = "Navigate",
  });
}

class IntroText {
  final TextStyle body;
  final TextStyle bodySmall;

  const IntroText({
    this.body = const TextStyle(),
    this.bodySmall = const TextStyle(),
  });
}

class IntroColors {
  final Color text;
  final Color button;
  final Color background;

  const IntroColors({
    this.background = Colors.black,
    this.text = Colors.white,
    this.button = Colors.white,
  });
}

class IntroInsets {
  final double xxs;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  const IntroInsets({
    this.xxs = 4,
    this.xs = 8,
    this.sm = 16,
    this.md = 24,
    this.lg = 32,
    this.xl = 48,
    this.xxl = 56,
  });
}

class IntroScreen extends StatefulWidget {
  final List<IntroPageData> pageData;
  final IntroMessages messages;
  final IntroText texts;
  final IntroInsets insets;
  final IntroDurations durations;
  final IntroColors colors;
  final VoidCallback onNextPressed;

  final Widget appLogo;
  final Widget centerWidget;

  const IntroScreen({
    Key? key,
    required this.appLogo,
    required this.centerWidget,
    required this.pageData,
    required this.onNextPressed,
    this.messages = const IntroMessages(),
    this.insets = const IntroInsets(),
    this.durations = const IntroDurations(),
    this.colors = const IntroColors(),
    this.texts = const IntroText(),
  }) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  static const double _imageSize = 264;
  static const double _logoHeight = 126;
  static const double _textHeight = 155;
  static const double _pageIndicatorHeight = 55;

  late final PageController _pageController = PageController()
    ..addListener(_handlePageChanged);
  final ValueNotifier<int> _currentPage = ValueNotifier(0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleIntroCompletePressed() {
    // context.go(ScreenPaths.home);
    // settingsLogic.hasCompletedOnboarding.value = true;
  }

  void _handlePageChanged() {
    int newPage = _pageController.page?.round() ?? 0;
    _currentPage.value = newPage;
  }

  void _handleSemanticSwipe(int dir) {
    _pageController.animateToPage((_pageController.page ?? 0).round() + dir,
        duration: widget.durations.fast, curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    // This view uses a full screen PageView to enable swipe navigation.
    // However, we only want the title / description to actually swipe,
    // so we stack a PageView with that content over top of all the other
    // content, and line up their layouts.

    final List<Widget> pages =
        widget.pageData.map((e) => _Page(data: e)).toList();

    final Widget content = Stack(children: [
      // page view with title & description:
      MergeSemantics(
        child: Semantics(
          onIncrease: () => _handleSemanticSwipe(1),
          onDecrease: () => _handleSemanticSwipe(-1),
          child: PageView(
            physics: const BouncingScrollPhysics(),
            controller: _pageController,
            children: pages,
            onPageChanged: (_) {},
          ),
        ),
      ),

      IgnorePointer(
        ignoringSemantics: false,
        child: Column(children: [
          const Spacer(),

          // logo:
          Semantics(
            header: true,
            child: Container(
              height: _logoHeight,
              alignment: Alignment.center,
              child: widget.appLogo,
            ),
          ),

          // masked image:
          SizedBox(
            height: _imageSize,
            width: _imageSize,
            child: ValueListenableBuilder<int>(
              valueListenable: _currentPage,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: widget.durations.slow,
                  child: KeyedSubtree(
                    key: ValueKey(
                        value), // so AnimatedSwitcher sees it as a different child.
                    child: IntroPageImage(data: widget.pageData[value]),
                  ),
                );
              },
            ),
          ),

          // placeholder gap for text:
          const Gap(_IntroScreenState._textHeight),

          // page indicator:
          Container(
            height: _pageIndicatorHeight,
            alignment: const Alignment(0.0, -0.75),
            child: AppPageIndicator(
              count: widget.pageData.length,
              controller: _pageController,
              color: widget.colors.background,
            ),
          ),

          const Spacer(flex: 2),
        ]),
      ),

      // finish button:
      Positioned(
        right: widget.insets.lg,
        bottom: widget.insets.lg,
        child: _buildFinishBtn(context),
      ),

      // nav help text:
      BottomCenter(
        child: Padding(
          padding: EdgeInsets.only(bottom: widget.insets.lg),
          child: _buildNavText(context),
        ),
      ),
    ]);

    return DefaultTextColor(
      color: widget.colors.text,
      child: Container(
        color: widget.colors.background,
        child: SafeArea(child: content.animate().fadeIn(delay: 500.ms)),
      ),
    );
  }

  Widget _buildFinishBtn(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _currentPage,
      builder: (_, pageIndex, __) {
        return AnimatedOpacity(
          opacity: pageIndex == widget.pageData.length - 1 ? 1 : 0,
          duration: widget.durations.fast,
          child: FloatingActionButton.small(
            elevation: 0,
            onPressed: _handleIntroCompletePressed,
            tooltip: widget.messages.swap,
            backgroundColor: widget.colors.button,
            child: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        );
      },
    );
  }

  Widget _buildNavText(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _currentPage,
      builder: (_, pageIndex, __) {
        return AnimatedOpacity(
          opacity: pageIndex == widget.pageData.length - 1 ? 0 : 1,
          duration: widget.durations.fast,
          child: Semantics(
            onTapHint: widget.messages.swap,
            onTap: () {
              final int current = _pageController.page!.round();
              _pageController.animateToPage(
                current + 1,
                duration: 250.ms,
                curve: Curves.easeIn,
              );
            },
            child: widget.centerWidget,
          ),
        );
      },
    );
  }
}

@immutable
class IntroPageData {
  const IntroPageData({
    required this.title,
    required this.description,
    required this.image,
    this.mask,
  });

  final Widget title;
  final Widget description;
  final Widget image;
  final Widget? mask;
}

class _Page extends StatelessWidget {
  const _Page({Key? key, required this.data}) : super(key: key);

  final IntroPageData data;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Column(
        children: [
          const Spacer(),
          const Gap(
              _IntroScreenState._imageSize + _IntroScreenState._logoHeight),
          SizedBox(
            height: _IntroScreenState._textHeight,
            width: _IntroScreenState._imageSize,
            child: IntroStaticTextScale(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  data.title,
                  const Gap(12),
                  data.description,
                ],
              ),
            ),
          ),
          const Gap(_IntroScreenState._pageIndicatorHeight),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

class IntroPageImage extends StatelessWidget {
  const IntroPageImage({
    Key? key,
    required this.data,
  }) : super(key: key);

  final IntroPageData data;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: data.image,
        ),
        if (data.mask != null)
          Positioned.fill(
            child: data.mask!,
          ),
      ],
    );
  }
}

class IntroStaticTextScale extends StatelessWidget {
  const IntroStaticTextScale({
    Key? key,
    required this.child,
    this.scale = 1,
  }) : super(key: key);
  final Widget child;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
      child: child,
    );
  }
}
