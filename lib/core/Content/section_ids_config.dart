/// Configuration for Section IDs for each page
class SectionIdsConfig {
  static const Set<String> _knownServicePageIds = {
    'corporate-leasing', 'retail-leasing', 'medical-leasing', 'facility-management',
    'franchise-investment', 'primary-investment', 'marketing', 'consultation',
  };

  static bool _isKnownServicePageId(String pageId) => _knownServicePageIds.contains(pageId);

  /// Get available section IDs for a specific page
  static List<SectionIdOption> getSectionIdsForPage(String pageId) {
    switch (pageId) {
      case 'corporate-leasing':
        return [
          SectionIdOption('hero-title-1', 'العنوان الأول (CORPORATE)', 'text'),
          SectionIdOption('hero-title-2', 'العنوان الثاني (LEASING)', 'text'),
          SectionIdOption('hero-subtitle', 'النص الفرعي', 'text'),
          SectionIdOption('background-image', 'الصورة الخلفية', 'image'),
          SectionIdOption('experience-text', 'نص الخبرة', 'text'),
          SectionIdOption('locations-text', 'نص المواقع', 'text'),
          SectionIdOption('service-1', 'الخدمة الأولى', 'text'),
          SectionIdOption('service-2', 'الخدمة الثانية', 'text'),
          SectionIdOption('service-3', 'الخدمة الثالثة', 'text'),
          SectionIdOption('service-4', 'الخدمة الرابعة', 'text'),
        ];
      
      case 'retail-leasing':
        return [
          SectionIdOption('hero-title-1', 'العنوان الأول (RETAIL)', 'text'),
          SectionIdOption('hero-title-2', 'العنوان الثاني (LEASING SERVICE)', 'text'),
          SectionIdOption('hero-subtitle', 'النص الفرعي', 'text'),
          SectionIdOption('background-image', 'الصورة الخلفية', 'image'),
          SectionIdOption('description-1', 'الوصف الأول', 'text'),
          SectionIdOption('description-2', 'الوصف الثاني', 'text'),
          SectionIdOption('services-title', 'عنوان الخدمات', 'text'),
          SectionIdOption('services-include', 'نص INCLUDES', 'text'),
          SectionIdOption('service-1', 'الخدمة الأولى', 'text'),
          SectionIdOption('service-2', 'الخدمة الثانية', 'text'),
          SectionIdOption('service-3', 'الخدمة الثالثة', 'text'),
          SectionIdOption('service-4', 'الخدمة الرابعة', 'text'),
          SectionIdOption('service-5', 'الخدمة الخامسة', 'text'),
        ];
      
      case 'medical-leasing':
        return [
          SectionIdOption('hero-title-1', 'Hero Title 1 (MEDICAL)', 'text'),
          SectionIdOption('hero-title-2', 'Hero Title 2 (SERVICE)', 'text'),
          SectionIdOption('hero-subtitle', 'Hero Subtitle', 'text'),
          SectionIdOption('background-image', 'Background Image', 'image'),
          SectionIdOption('description-1', 'Description 1', 'text'),
          SectionIdOption('description-2', 'Description 2', 'text'),
          SectionIdOption('services-title', 'Services Title', 'text'),
          SectionIdOption('service-1', 'Service 1', 'text'),
          SectionIdOption('service-2', 'Service 2', 'text'),
          SectionIdOption('service-3', 'Service 3', 'text'),
        ];
      
      case 'facility-management':
        return [
          SectionIdOption('hero-title-1', 'Hero Title 1 (FACILITY)', 'text'),
          SectionIdOption('hero-title-2', 'Hero Title 2 (MANAGEMENT)', 'text'),
          SectionIdOption('hero-subtitle', 'Hero Subtitle', 'text'),
          SectionIdOption('background-image', 'Background Image', 'image'),
          SectionIdOption('description-1', 'Description 1', 'text'),
          SectionIdOption('description-2', 'Description 2', 'text'),
          SectionIdOption('services-title', 'Services Title', 'text'),
          SectionIdOption('service-1', 'Service 1', 'text'),
          SectionIdOption('service-2', 'Service 2', 'text'),
          SectionIdOption('service-3', 'Service 3', 'text'),
        ];
      
      case 'franchise-investment':
        return [
          SectionIdOption('hero-title-1', 'Hero Title 1 (FRANCHISE)', 'text'),
          SectionIdOption('hero-title-2', 'Hero Title 2 (INVESTMENT SERVICE)', 'text'),
          SectionIdOption('hero-subtitle', 'Hero Subtitle', 'text'),
          SectionIdOption('background-image', 'Background Image', 'image'),
          SectionIdOption('description-1', 'Description 1', 'text'),
          SectionIdOption('description-2', 'Description 2', 'text'),
          SectionIdOption('description-3', 'Description 3', 'text'),
          SectionIdOption('services-title', 'Services Title', 'text'),
          SectionIdOption('service-1', 'Service 1', 'text'),
        ];
      
      case 'primary-investment':
        return [
          SectionIdOption('hero-title-1', 'Hero Title 1 (PRIMARY INVESTMENT)', 'text'),
          SectionIdOption('hero-title-2', 'Hero Title 2 (SERVICE)', 'text'),
          SectionIdOption('hero-subtitle', 'Hero Subtitle', 'text'),
          SectionIdOption('background-image', 'Background Image', 'image'),
          SectionIdOption('description-1', 'Description 1', 'text'),
          SectionIdOption('description-2', 'Description 2', 'text'),
          SectionIdOption('services-title', 'Services Title', 'text'),
          SectionIdOption('service-1', 'Service 1', 'text'),
        ];
      
      case 'marketing':
        return [
          SectionIdOption('hero-title-1', 'العنوان الأول (MARKETING)', 'text'),
          SectionIdOption('hero-title-2', 'العنوان الثاني (SERVICE)', 'text'),
          SectionIdOption('hero-subtitle', 'النص الفرعي', 'text'),
          SectionIdOption('background-image', 'الصورة الخلفية', 'image'),
          SectionIdOption('description-1', 'الوصف الأول', 'text'),
          SectionIdOption('description-2', 'الوصف الثاني', 'text'),
          SectionIdOption('services-title', 'عنوان الخدمات', 'text'),
          SectionIdOption('service-1', 'الخدمة الأولى', 'text'),
          SectionIdOption('service-2', 'الخدمة الثانية', 'text'),
          SectionIdOption('service-3', 'الخدمة الثالثة', 'text'),
        ];
      
      case 'consultation':
        return [
          SectionIdOption('hero-title-1', 'العنوان الأول (CONSULTATION)', 'text'),
          SectionIdOption('hero-title-2', 'العنوان الثاني (SERVICE)', 'text'),
          SectionIdOption('hero-subtitle', 'النص الفرعي', 'text'),
          SectionIdOption('background-image', 'الصورة الخلفية', 'image'),
          SectionIdOption('description-1', 'الوصف الأول', 'text'),
          SectionIdOption('description-2', 'الوصف الثاني', 'text'),
          SectionIdOption('services-title', 'عنوان الخدمات', 'text'),
          SectionIdOption('services-include', 'نص INCLUDES', 'text'),
          SectionIdOption('service-1', 'الخدمة الأولى', 'text'),
          SectionIdOption('service-2', 'الخدمة الثانية', 'text'),
          SectionIdOption('service-3', 'الخدمة الثالثة', 'text'),
          SectionIdOption('service-4', 'الخدمة الرابعة', 'text'),
          SectionIdOption('service-5', 'الخدمة الخامسة', 'text'),
        ];
      
      case 'home':
        return [
          SectionIdOption('search-title', 'عنوان البحث (EXPLORE INCM WORLD)', 'text'),
          SectionIdOption('search-subtitle', 'النص الفرعي للبحث', 'text'),
          SectionIdOption('search-placeholder', 'نص البحث (Search...)', 'text'),
          SectionIdOption('home-background-video-web', 'فيديو خلفية الصفحة الرئيسية (ويب) - رابط', 'video'),
          SectionIdOption('home-background-video-mobile', 'فيديو خلفية الصفحة الرئيسية (موبايل) - رابط', 'video'),
          SectionIdOption('home-media-section', 'صورة/فيديو تحت قسم البحث', 'video'),
          SectionIdOption('about-section-title', 'عنوان قسم "من نحن"', 'text'),
          SectionIdOption('about-section-text', 'نص قسم "من نحن"', 'text'),
          SectionIdOption('services-section-title', 'عنوان قسم "الخدمات"', 'text'),
        ];
      
      case 'about':
        return [
          SectionIdOption('who-are-we-title', 'عنوان "من نحن"', 'text'),
          SectionIdOption('who-are-we-text', 'نص "من نحن"', 'text'),
          SectionIdOption('company-profile-file', 'رابط ملف الشركة', 'link'),
          SectionIdOption('mission-title', 'عنوان "مهمتنا"', 'text'),
          SectionIdOption('mission-text', 'نص المهمة', 'text'),
          SectionIdOption('vision-title', 'عنوان "رؤيتنا"', 'text'),
          SectionIdOption('vision-text', 'نص الرؤية', 'text'),
          SectionIdOption('latest-news-title', 'عنوان قسم Latest News & Events', 'text'),
          SectionIdOption('latest-news-item-1-title', 'خبر 1 - العنوان', 'text'),
          SectionIdOption('latest-news-item-1-description', 'خبر 1 - الوصف', 'text'),
          SectionIdOption('latest-news-item-1-image', 'خبر 1 - الصورة', 'image'),
          SectionIdOption('latest-news-item-2-title', 'خبر 2 - العنوان', 'text'),
          SectionIdOption('latest-news-item-2-description', 'خبر 2 - الوصف', 'text'),
          SectionIdOption('latest-news-item-2-image', 'خبر 2 - الصورة', 'image'),
          SectionIdOption('latest-news-item-3-title', 'خبر 3 - العنوان', 'text'),
          SectionIdOption('latest-news-item-3-description', 'خبر 3 - الوصف', 'text'),
          SectionIdOption('latest-news-item-3-image', 'خبر 3 - الصورة', 'image'),
          SectionIdOption('latest-news-item-4-title', 'خبر 4 - العنوان', 'text'),
          SectionIdOption('latest-news-item-4-description', 'خبر 4 - الوصف', 'text'),
          SectionIdOption('latest-news-item-4-image', 'خبر 4 - الصورة', 'image'),
          SectionIdOption('about-background', 'صورة الخلفية', 'image'),
        ];
      
      case 'contacts':
        return [
          SectionIdOption('contact-title', 'عنوان الصفحة', 'text'),
          SectionIdOption('contact-subtitle', 'النص الفرعي', 'text'),
          SectionIdOption('contact-background', 'صورة الخلفية', 'image'),
          SectionIdOption('address-text', 'النص العنوان', 'text'),
          SectionIdOption('phone-text', 'رقم الهاتف', 'text'),
          SectionIdOption('email-text', 'البريد الإلكتروني', 'text'),
        ];
      
      case 'career':
        return [
          SectionIdOption('career-title', 'عنوان قسم Welcome', 'text'),
          SectionIdOption('career-subtitle', 'عنوان قسم Join', 'text'),
          SectionIdOption('career-background', 'صورة الخلفية', 'image'),
          SectionIdOption('career-welcome-image', 'صورة قسم Welcome', 'image'),
          SectionIdOption('career-benefits-title', 'عنوان قسم المميزات', 'text'),
          SectionIdOption('career-benefit-1', 'الميزة 1', 'text'),
          SectionIdOption('career-benefit-2', 'الميزة 2', 'text'),
          SectionIdOption('career-benefit-3', 'الميزة 3', 'text'),
          SectionIdOption('career-benefit-4', 'الميزة 4', 'text'),
          SectionIdOption('career-benefit-5', 'الميزة 5', 'text'),
          SectionIdOption('career-benefit-6', 'الميزة 6', 'text'),
          SectionIdOption('career-benefit-7', 'الميزة 7', 'text'),
          SectionIdOption('career-benefit-8', 'الميزة 8', 'text'),
          SectionIdOption('career-benefit-9', 'الميزة 9', 'text'),
          SectionIdOption('career-benefit-10', 'الميزة 10', 'text'),
          SectionIdOption('career-benefit-11', 'الميزة 11', 'text'),
          SectionIdOption('career-benefit-12', 'الميزة 12', 'text'),
          SectionIdOption('career-family-members-title', 'عنوان قسم أفراد العائلة', 'text'),
          SectionIdOption('career-family-member-1-title', 'عضو العائلة 1 - العنوان', 'text'),
          SectionIdOption('career-family-member-1-image', 'عضو العائلة 1 - الصورة', 'image'),
          SectionIdOption('career-family-member-2-title', 'عضو العائلة 2 - العنوان', 'text'),
          SectionIdOption('career-family-member-2-image', 'عضو العائلة 2 - الصورة', 'image'),
          SectionIdOption('career-family-member-3-title', 'عضو العائلة 3 - العنوان', 'text'),
          SectionIdOption('career-family-member-3-image', 'عضو العائلة 3 - الصورة', 'image'),
        ];
      
      case 'buy':
        return [
          SectionIdOption('buy-title', 'عنوان الصفحة', 'text'),
          SectionIdOption('buy-subtitle', 'النص الفرعي', 'text'),
          SectionIdOption('buy-background', 'صورة الخلفية', 'image'),
        ];
      
      case 'sell':
        return [
          SectionIdOption('sell-title', 'عنوان الصفحة', 'text'),
          SectionIdOption('sell-subtitle', 'النص الفرعي', 'text'),
          SectionIdOption('sell-background', 'صورة الخلفية', 'image'),
        ];
      
      case 'lease':
        return [
          SectionIdOption('lease-title', 'عنوان الصفحة', 'text'),
          SectionIdOption('lease-subtitle', 'النص الفرعي', 'text'),
          SectionIdOption('lease-background', 'صورة الخلفية', 'image'),
        ];
      
      case 'services':
        return [
          SectionIdOption('services-title', 'عنوان الصفحة', 'text'),
          SectionIdOption('services-subtitle', 'النص الفرعي', 'text'),
          SectionIdOption('services-background', 'صورة الخلفية', 'image'),
        ];
      
      case 'exclusive-leasing-projects':
        return [
          // UMC Project
          SectionIdOption('umc-title', 'UMC - العنوان', 'text'),
          SectionIdOption('umc-description', 'UMC - الوصف', 'text'),
          SectionIdOption('umc-logo', 'UMC - اللوجو', 'image'),
          SectionIdOption('umc-image-0', 'UMC - الصورة الأولى', 'image'),
          SectionIdOption('umc-image-1', 'UMC - الصورة الثانية', 'image'),
          SectionIdOption('umc-image-2', 'UMC - الصورة الثالثة', 'image'),
          SectionIdOption('umc-image-3', 'UMC - الصورة الرابعة', 'image'),
          SectionIdOption('umc-image-4', 'UMC - الصورة الخامسة', 'image'),
          SectionIdOption('umc-image-5', 'UMC - الصورة السادسة', 'image'),
          SectionIdOption('umc-image-6', 'UMC - الصورة السابعة', 'image'),
          SectionIdOption('umc-image-7', 'UMC - الصورة الثامنة', 'image'),
          SectionIdOption('umc-image-8', 'UMC - الصورة التاسعة', 'image'),
          SectionIdOption('umc-image-9', 'UMC - الصورة العاشرة', 'image'),
          // Park Mall Project
          SectionIdOption('park-mall-title', 'PARK MALL - العنوان', 'text'),
          SectionIdOption('park-mall-description', 'PARK MALL - الوصف', 'text'),
          SectionIdOption('park-mall-logo', 'PARK MALL - اللوجو', 'image'),
          SectionIdOption('park-mall-image-0', 'PARK MALL - الصورة الأولى', 'image'),
          SectionIdOption('park-mall-image-1', 'PARK MALL - الصورة الثانية', 'image'),
          SectionIdOption('park-mall-image-2', 'PARK MALL - الصورة الثالثة', 'image'),
          SectionIdOption('park-mall-image-3', 'PARK MALL - الصورة الرابعة', 'image'),
          SectionIdOption('park-mall-image-4', 'PARK MALL - الصورة الخامسة', 'image'),
          SectionIdOption('park-mall-image-5', 'PARK MALL - الصورة السادسة', 'image'),
          SectionIdOption('park-mall-image-6', 'PARK MALL - الصورة السابعة', 'image'),
          SectionIdOption('park-mall-image-7', 'PARK MALL - الصورة الثامنة', 'image'),
          SectionIdOption('park-mall-image-8', 'PARK MALL - الصورة التاسعة', 'image'),
          SectionIdOption('park-mall-image-9', 'PARK MALL - الصورة العاشرة', 'image'),
          // Terrace Project
          SectionIdOption('terrace-title', 'TERRACE - العنوان', 'text'),
          SectionIdOption('terrace-description', 'TERRACE - الوصف', 'text'),
          SectionIdOption('terrace-logo', 'TERRACE - اللوجو', 'image'),
          SectionIdOption('terrace-image-0', 'TERRACE - الصورة الأولى', 'image'),
          SectionIdOption('terrace-image-1', 'TERRACE - الصورة الثانية', 'image'),
          SectionIdOption('terrace-image-2', 'TERRACE - الصورة الثالثة', 'image'),
          SectionIdOption('terrace-image-3', 'TERRACE - الصورة الرابعة', 'image'),
          SectionIdOption('terrace-image-4', 'TERRACE - الصورة الخامسة', 'image'),
          SectionIdOption('terrace-image-5', 'TERRACE - الصورة السادسة', 'image'),
          SectionIdOption('terrace-image-6', 'TERRACE - الصورة السابعة', 'image'),
          SectionIdOption('terrace-image-7', 'TERRACE - الصورة الثامنة', 'image'),
          SectionIdOption('terrace-image-8', 'TERRACE - الصورة التاسعة', 'image'),
          SectionIdOption('terrace-image-9', 'TERRACE - الصورة العاشرة', 'image'),
          // Point 90 Project
          SectionIdOption('point90-title', 'POINT 90 - العنوان', 'text'),
          SectionIdOption('point90-description', 'POINT 90 - الوصف', 'text'),
          SectionIdOption('point90-logo', 'POINT 90 - اللوجو', 'image'),
          SectionIdOption('point90-image-0', 'POINT 90 - الصورة الأولى', 'image'),
          SectionIdOption('point90-image-1', 'POINT 90 - الصورة الثانية', 'image'),
          SectionIdOption('point90-image-2', 'POINT 90 - الصورة الثالثة', 'image'),
          SectionIdOption('point90-image-3', 'POINT 90 - الصورة الرابعة', 'image'),
          SectionIdOption('point90-image-4', 'POINT 90 - الصورة الخامسة', 'image'),
          SectionIdOption('point90-image-5', 'POINT 90 - الصورة السادسة', 'image'),
          SectionIdOption('point90-image-6', 'POINT 90 - الصورة السابعة', 'image'),
          SectionIdOption('point90-image-7', 'POINT 90 - الصورة الثامنة', 'image'),
          SectionIdOption('point90-image-8', 'POINT 90 - الصورة التاسعة', 'image'),
          SectionIdOption('point90-image-9', 'POINT 90 - الصورة العاشرة', 'image'),
          // Kernel Project
          SectionIdOption('kernel-title', 'KERNEL - العنوان', 'text'),
          SectionIdOption('kernel-description', 'KERNEL - الوصف', 'text'),
          SectionIdOption('kernel-logo', 'KERNEL - اللوجو', 'image'),
          SectionIdOption('kernel-image-0', 'KERNEL - الصورة الأولى', 'image'),
          SectionIdOption('kernel-image-1', 'KERNEL - الصورة الثانية', 'image'),
          SectionIdOption('kernel-image-2', 'KERNEL - الصورة الثالثة', 'image'),
          SectionIdOption('kernel-image-3', 'KERNEL - الصورة الرابعة', 'image'),
          SectionIdOption('kernel-image-4', 'KERNEL - الصورة الخامسة', 'image'),
          SectionIdOption('kernel-image-5', 'KERNEL - الصورة السادسة', 'image'),
          SectionIdOption('kernel-image-6', 'KERNEL - الصورة السابعة', 'image'),
          SectionIdOption('kernel-image-7', 'KERNEL - الصورة الثامنة', 'image'),
          SectionIdOption('kernel-image-8', 'KERNEL - الصورة التاسعة', 'image'),
          SectionIdOption('kernel-image-9', 'KERNEL - الصورة العاشرة', 'image'),
          // City Square Project
          SectionIdOption('city-square-title', 'CITY SQUARE - العنوان', 'text'),
          SectionIdOption('city-square-description', 'CITY SQUARE - الوصف', 'text'),
          SectionIdOption('city-square-logo', 'CITY SQUARE - اللوجو', 'image'),
          SectionIdOption('city-square-image-0', 'CITY SQUARE - الصورة الأولى', 'image'),
          SectionIdOption('city-square-image-1', 'CITY SQUARE - الصورة الثانية', 'image'),
          SectionIdOption('city-square-image-2', 'CITY SQUARE - الصورة الثالثة', 'image'),
          SectionIdOption('city-square-image-3', 'CITY SQUARE - الصورة الرابعة', 'image'),
          SectionIdOption('city-square-image-4', 'CITY SQUARE - الصورة الخامسة', 'image'),
          SectionIdOption('city-square-image-5', 'CITY SQUARE - الصورة السادسة', 'image'),
          SectionIdOption('city-square-image-6', 'CITY SQUARE - الصورة السابعة', 'image'),
          SectionIdOption('city-square-image-7', 'CITY SQUARE - الصورة الثامنة', 'image'),
          SectionIdOption('city-square-image-8', 'CITY SQUARE - الصورة التاسعة', 'image'),
          SectionIdOption('city-square-image-9', 'CITY SQUARE - الصورة العاشرة', 'image'),
          // Vitali Project
          SectionIdOption('vitali-title', 'VITALI - العنوان', 'text'),
          SectionIdOption('vitali-description', 'VITALI - الوصف', 'text'),
          SectionIdOption('vitali-logo', 'VITALI - اللوجو', 'image'),
          SectionIdOption('vitali-image-0', 'VITALI - الصورة الأولى', 'image'),
          SectionIdOption('vitali-image-1', 'VITALI - الصورة الثانية', 'image'),
          SectionIdOption('vitali-image-2', 'VITALI - الصورة الثالثة', 'image'),
          SectionIdOption('vitali-image-3', 'VITALI - الصورة الرابعة', 'image'),
          SectionIdOption('vitali-image-4', 'VITALI - الصورة الخامسة', 'image'),
          SectionIdOption('vitali-image-5', 'VITALI - الصورة السادسة', 'image'),
          SectionIdOption('vitali-image-6', 'VITALI - الصورة السابعة', 'image'),
          SectionIdOption('vitali-image-7', 'VITALI - الصورة الثامنة', 'image'),
          SectionIdOption('vitali-image-8', 'VITALI - الصورة التاسعة', 'image'),
          SectionIdOption('vitali-image-9', 'VITALI - الصورة العاشرة', 'image'),
          // Seashell Project
          SectionIdOption('seashell-title', 'SEASHELL - العنوان', 'text'),
          SectionIdOption('seashell-description', 'SEASHELL - الوصف', 'text'),
          SectionIdOption('seashell-logo', 'SEASHELL - اللوجو', 'image'),
          SectionIdOption('seashell-image-0', 'SEASHELL - الصورة الأولى', 'image'),
          SectionIdOption('seashell-image-1', 'SEASHELL - الصورة الثانية', 'image'),
          SectionIdOption('seashell-image-2', 'SEASHELL - الصورة الثالثة', 'image'),
          SectionIdOption('seashell-image-3', 'SEASHELL - الصورة الرابعة', 'image'),
          SectionIdOption('seashell-image-4', 'SEASHELL - الصورة الخامسة', 'image'),
          SectionIdOption('seashell-image-5', 'SEASHELL - الصورة السادسة', 'image'),
          SectionIdOption('seashell-image-6', 'SEASHELL - الصورة السابعة', 'image'),
          SectionIdOption('seashell-image-7', 'SEASHELL - الصورة الثامنة', 'image'),
          SectionIdOption('seashell-image-8', 'SEASHELL - الصورة التاسعة', 'image'),
          SectionIdOption('seashell-image-9', 'SEASHELL - الصورة العاشرة', 'image'),
        ];
      
      default:
        // Custom services (unknown pageIds) use facility-management template
        if (!_isKnownServicePageId(pageId)) {
          return [
            SectionIdOption('hero-title-1', 'Hero Title 1', 'text'),
            SectionIdOption('hero-title-2', 'Hero Title 2', 'text'),
            SectionIdOption('hero-subtitle', 'Hero Subtitle', 'text'),
            SectionIdOption('background-image', 'Background Image', 'image'),
            SectionIdOption('description-1', 'Description 1', 'text'),
            SectionIdOption('description-2', 'Description 2', 'text'),
            SectionIdOption('services-title', 'Services Title', 'text'),
            SectionIdOption('service-1', 'Service 1', 'text'),
            SectionIdOption('service-2', 'Service 2', 'text'),
            SectionIdOption('service-3', 'Service 3', 'text'),
          ];
        }
        return [
          SectionIdOption('title', 'العنوان', 'text'),
          SectionIdOption('subtitle', 'النص الفرعي', 'text'),
          SectionIdOption('description', 'الوصف', 'text'),
          SectionIdOption('background-image', 'صورة الخلفية', 'image'),
        ];
    }
  }
}

/// Model for Section ID option
class SectionIdOption {
  final String id;
  final String label;
  final String suggestedType; // 'text' or 'image'

  SectionIdOption(this.id, this.label, this.suggestedType);
}

