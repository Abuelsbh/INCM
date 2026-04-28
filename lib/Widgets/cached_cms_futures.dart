import 'package:flutter/material.dart';

import '../core/Content/content_helper.dart';

/// Hero background from CMS — one [Future] per [pageId]/[isMobile]/[fit], not per rebuild.
class CachedHeroDecorationScope extends StatefulWidget {
  final String pageId;
  final bool isMobile;
  final BoxFit fit;
  final Widget Function(BuildContext context, DecorationImage? image) builder;

  const CachedHeroDecorationScope({
    super.key,
    required this.pageId,
    required this.isMobile,
    required this.fit,
    required this.builder,
  });

  @override
  State<CachedHeroDecorationScope> createState() => _CachedHeroDecorationScopeState();
}

class _CachedHeroDecorationScopeState extends State<CachedHeroDecorationScope> {
  Future<DecorationImage?>? _future;

  Future<DecorationImage?> _load() {
    return ContentHelper.getHeroDecorationImage(
      context,
      widget.pageId,
      isMobile: widget.isMobile,
      fit: widget.fit,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _load();
  }

  @override
  void didUpdateWidget(CachedHeroDecorationScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageId != widget.pageId ||
        oldWidget.isMobile != widget.isMobile ||
        oldWidget.fit != widget.fit) {
      _future = _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DecorationImage?>(
      future: _future,
      builder: (context, snapshot) => widget.builder(context, snapshot.data),
    );
  }
}

/// Home services carousel strip background — stable [Future] across [setState] (timers/animation).
class CachedServicesCarouselDecorationScope extends StatefulWidget {
  final Widget Function(BuildContext context, DecorationImage? image) builder;

  const CachedServicesCarouselDecorationScope({
    super.key,
    required this.builder,
  });

  @override
  State<CachedServicesCarouselDecorationScope> createState() =>
      _CachedServicesCarouselDecorationScopeState();
}

class _CachedServicesCarouselDecorationScopeState
    extends State<CachedServicesCarouselDecorationScope> {
  Future<DecorationImage?>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= ContentHelper.getServicesCarouselBackground(context, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DecorationImage?>(
      future: _future,
      builder: (context, snapshot) => widget.builder(context, snapshot.data),
    );
  }
}

/// Loads `services-title` + `services-include` once per page id (paired CMS strings).
class CachedDualCmsStrings extends StatefulWidget {
  final String pageId;
  final String sectionIdFirst;
  final String sectionIdSecond;
  final String defaultFirst;
  final String defaultSecond;
  final Widget Function(BuildContext context, String first, String second) builder;

  const CachedDualCmsStrings({
    super.key,
    required this.pageId,
    this.sectionIdFirst = 'services-title',
    this.sectionIdSecond = 'services-include',
    this.defaultFirst = 'OUR_SERVICES',
    this.defaultSecond = 'INCLUDE',
    required this.builder,
  });

  @override
  State<CachedDualCmsStrings> createState() => _CachedDualCmsStringsState();
}

class _CachedDualCmsStringsState extends State<CachedDualCmsStrings> {
  Future<List<String>>? _future;

  Future<List<String>> _load() {
    return Future.wait([
      ContentHelper.getText(
        context,
        widget.pageId,
        widget.sectionIdFirst,
        defaultValue: widget.defaultFirst,
      ),
      ContentHelper.getText(
        context,
        widget.pageId,
        widget.sectionIdSecond,
        defaultValue: widget.defaultSecond,
      ),
    ]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _load();
  }

  @override
  void didUpdateWidget(CachedDualCmsStrings oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageId != widget.pageId ||
        oldWidget.sectionIdFirst != widget.sectionIdFirst ||
        oldWidget.sectionIdSecond != widget.sectionIdSecond ||
        oldWidget.defaultFirst != widget.defaultFirst ||
        oldWidget.defaultSecond != widget.defaultSecond) {
      _future = _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _future,
      builder: (context, snapshot) {
        final list = snapshot.data;
        final a = list != null ? list[0] : widget.defaultFirst;
        final b = list != null ? list[1] : widget.defaultSecond;
        return widget.builder(context, a, b);
      },
    );
  }
}

/// Single CMS text — stable [Future] across rebuilds (replaces uncached [FutureBuilder] + [getText]).
class CachedCmsString extends StatefulWidget {
  final String pageId;
  final String sectionId;
  final String defaultValue;
  final Widget Function(BuildContext context, String text) builder;

  const CachedCmsString({
    super.key,
    required this.pageId,
    required this.sectionId,
    required this.defaultValue,
    required this.builder,
  });

  @override
  State<CachedCmsString> createState() => _CachedCmsStringState();
}

class _CachedCmsStringState extends State<CachedCmsString> {
  Future<String>? _future;

  Future<String> _load() {
    return ContentHelper.getText(
      context,
      widget.pageId,
      widget.sectionId,
      defaultValue: widget.defaultValue,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _load();
  }

  @override
  void didUpdateWidget(CachedCmsString oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageId != widget.pageId ||
        oldWidget.sectionId != widget.sectionId ||
        oldWidget.defaultValue != widget.defaultValue) {
      _future = _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _future,
      builder: (context, snapshot) {
        final text = snapshot.data ?? widget.defaultValue;
        return widget.builder(context, text);
      },
    );
  }
}
