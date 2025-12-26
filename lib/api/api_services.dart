import 'package:flutter_application_1/api/api_models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://admin.stage.indiaretailing.com';
  static const String endpoint =
      '/api/method/go1_cms.go1_cms.api.get_page_content_with_pagination';

  Future<PageContentResponse> getPageContent({String route = 'home'}) async {
    try {
      final String url = '$baseUrl$endpoint?route=$route';

      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Request timeout'),
          );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return PageContentResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load page content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching page content: $e');
    }
  }

  List<dynamic> extractInFocusArticles(PageContentResponse response) {
    final pageContent = response.message['page_content'] as List?;
    if (pageContent != null) {
      for (var section in pageContent) {
        try {
          if (section['section_name'] == 'Three column Location') {
            final data = section['data'] as Map<String, dynamic>?;
            if (data != null) {
              // Find the "in-focus" component data (usually the first one with key 1696664971847)
              for (var entry in data.entries) {
                if (entry.value is Map<String, dynamic>) {
                  final componentData = entry.value as Map<String, dynamic>;
                  if (componentData['data'] is List) {
                    final articles = componentData['data'] as List;
                    if (articles.isNotEmpty) {
                      return articles;
                    }
                  }
                }
              }
            }
          }
        } catch (e) {
          print('Error extracting in-focus articles: $e');
        }
      }
    }
    return [];
  }

  List<dynamic> extractLatestNewsArticles(PageContentResponse response) {
    final pageContent = response.message['page_content'] as List?;
    if (pageContent != null) {
      for (var section in pageContent) {
        try {
          if (section['section_name'] == 'Three column Location') {
            final data = section['data'] as Map<String, dynamic>?;
            if (data != null) {
              // Find the "latest-news" component data (usually the second entry)
              final entries = data.entries.toList();
              if (entries.length >= 2) {
                final secondEntry = entries[1].value;
                if (secondEntry is Map<String, dynamic> &&
                    secondEntry['data'] is List) {
                  return secondEntry['data'] as List;
                }
              }
            }
          }
        } catch (e) {
          print('Error extracting latest-news articles: $e');
        }
      }
    }
    return [];
  }

  List<Article> parseArticlesFromResponse(PageContentResponse response) {
    List<Article> articles = [];

    try {
      final pageContent = response.message['page_content'] as List?;
      if (pageContent != null) {
        for (var section in pageContent) {
          try {
            final data = section['data'] as Map<String, dynamic>?;
            if (data != null) {
              data.forEach((key, value) {
                try {
                  if (value is Map<String, dynamic> && value['data'] is List) {
                    final sectionArticles =
                        (value['data'] as List)
                            .where((article) => article is Map<String, dynamic>)
                            .map(
                              (article) => Article.fromJson(
                                article as Map<String, dynamic>,
                              ),
                            )
                            .toList();
                    articles.addAll(sectionArticles);
                  }
                } catch (e) {
                  print('Error parsing article in section: $e');
                }
              });
            }
          } catch (e) {
            print('Error parsing section: $e');
          }
        }
      }
    } catch (e) {
      print('Error parsing page content: $e');
    }

    return articles;
  }
}
