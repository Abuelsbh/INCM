/// Maps route paths to Firebase page IDs for content loading
class RoutePageMapping {
  static const Set<String> _knownServicePageIds = {
    'consultation', 'retail-leasing', 'medical-leasing', 'corporate-leasing',
    'facility-management', 'franchise-investment', 'primary-investment', 'marketing',
  };

  static const Map<String, String> _routeToPageId = {
    '/': 'home',
    '/about': 'about',
    '/contacts': 'contacts',
    '/career': 'career',
    '/buy': 'buy',
    '/sell': 'sell',
    '/lease': 'lease',
    '/services': 'services',
    '/services/consultation': 'consultation',
    '/services/retail-leasing': 'retail-leasing',
    '/services/medical-leasing': 'medical-leasing',
    '/services/corporate-leasing': 'corporate-leasing',
    '/services/facility-management': 'facility-management',
    '/services/franchise-investment': 'franchise-investment',
    '/services/primary-investment': 'primary-investment',
    '/services/marketing': 'marketing',
    '/exclusive-leasing-projects': 'exclusive-leasing-projects',
  };

  /// Get pageId for a route path (normalized - removes query params)
  /// For /services/:pageId, returns the pageId (supports custom services)
  static String? getPageIdForRoute(String location) {
    final path = location.split('?').first;
    final explicit = _routeToPageId[path];
    if (explicit != null) return explicit;
    // Dynamic service route: /services/xxx
    if (path.startsWith('/services/') && path.length > '/services/'.length) {
      return path.substring('/services/'.length);
    }
    return null;
  }

  /// Check if pageId is a known built-in service
  static bool isKnownService(String pageId) => _knownServicePageIds.contains(pageId);

  /// Check if route requires content loading (has Firebase content)
  static bool isContentRoute(String location) {
    return getPageIdForRoute(location) != null;
  }
}
