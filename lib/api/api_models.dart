class PageContentResponse {
  final Map<String, dynamic> message;

  PageContentResponse({required this.message});

  factory PageContentResponse.fromJson(Map<String, dynamic> json) {
    return PageContentResponse(message: json['message'] ?? {});
  }
}

class PageContent {
  final String className;
  final String contentType;
  final int dynamicData;
  final int isFullWidth;
  final String layoutJson;
  final int loginRequired;
  final String section;
  final String sectionId;
  final String sectionName;
  final String sectionType;
  final Map<String, dynamic> data;

  PageContent({
    required this.className,
    required this.contentType,
    required this.dynamicData,
    required this.isFullWidth,
    required this.layoutJson,
    required this.loginRequired,
    required this.section,
    required this.sectionId,
    required this.sectionName,
    required this.sectionType,
    required this.data,
  });

  factory PageContent.fromJson(Map<String, dynamic> json) {
    return PageContent(
      className: json['class_name'] ?? '',
      contentType: json['content_type'] ?? '',
      dynamicData: json['dynamic_data'] ?? 0,
      isFullWidth: json['is_full_width'] ?? 0,
      layoutJson: json['layout_json'] ?? '',
      loginRequired: json['login_required'] ?? 0,
      section: json['section'] ?? '',
      sectionId: json['section_id'] ?? '',
      sectionName: json['section_name'] ?? '',
      sectionType: json['section_type'] ?? '',
      data: json['data'] ?? {},
    );
  }
}

class Article {
  final String name;
  final String title;
  final String route;
  final String? thumbnailImage;
  final String? image;
  final String? blogIntro;
  final String? primaryText;
  final String? secondaryText;
  final String? publisher;
  final List<Tag> tags;

  Article({
    required this.name,
    required this.title,
    required this.route,
    this.thumbnailImage,
    this.image,
    this.blogIntro,
    this.primaryText,
    this.secondaryText,
    this.publisher,
    required this.tags,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    List<Tag> tagList = [];
    if (json['tags'] != null) {
      tagList = (json['tags'] as List).map((tag) => Tag.fromJson(tag)).toList();
    }

    // Handle publisher - can be String or List
    String? publisherString;
    final publisher = json['publisher'];
    if (publisher is String) {
      publisherString = publisher;
    } else if (publisher is List && publisher.isNotEmpty) {
      publisherString = publisher.join(', ');
    }

    return Article(
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      route: json['route'] ?? '',
      thumbnailImage: json['thumbnail_imagee'] ?? json['thumbnail_image'],
      image: json['image'],
      blogIntro: json['blog_intro'],
      primaryText: json['primary_text'],
      secondaryText: json['secondary_text'],
      publisher: publisherString,
      tags: tagList,
    );
  }
}

class Tag {
  final String route;
  final String tag;

  Tag({required this.route, required this.tag});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(route: json['route'] ?? '', tag: json['tag'] ?? '');
  }
}
