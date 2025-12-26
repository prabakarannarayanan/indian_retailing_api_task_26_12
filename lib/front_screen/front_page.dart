import 'package:flutter/material.dart';
import 'package:flutter_application_1/api/api_services.dart';
import 'package:flutter_application_1/front_screen/card.dart';
import 'package:flutter_application_1/widgets/infocus.dart';
import 'package:flutter_application_1/widgets/latest.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ApiService apiService;
  late Future<Map<String, dynamic>> futureData;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const _HomeContent(),
    const Center(child: Text('IR Prime')),
    const Center(child: Text('Events')),
    const Center(child: Text('Book Store')),
    const Center(child: Text('Trending')),
  ];

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    futureData = _loadPageData();
  }

  Future<Map<String, dynamic>> _loadPageData() async {
    final response = await apiService.getPageContent(route: 'home');

    final inFocusArticles = apiService.extractInFocusArticles(response);
    final latestNewsArticles = apiService.extractLatestNewsArticles(response);
    final allArticles = apiService.parseArticlesFromResponse(response);

    return {
      'inFocus': inFocusArticles,
      'latestNews': latestNewsArticles,
      'allArticles': allArticles,
    };
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("assets/images/grp.png"),
              Icon(Icons.search),
            ],
          ),
        ),
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.blue),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'India Retailing',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.trending_up),
              title: const Text('Trending'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(4);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: const Text('Saved Articles'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Categories'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body:
          _selectedIndex == 0
              ? FutureBuilder<Map<String, dynamic>>(
                future: futureData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error: ${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  futureData = _loadPageData();
                                });
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('No data found'));
                  }

                  final data = snapshot.data!;
                  final inFocusArticles = data['inFocus'] as List<dynamic>;
                  final latestNewsArticles =
                      data['latestNews'] as List<dynamic>;
                  final allArticles = data['allArticles'] as List<dynamic>;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (allArticles.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 110,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  itemCount: allArticles.length,
                                  itemBuilder: (context, index) {
                                    final article = allArticles[index];
                                    return Container(
                                      width: 300,
                                      margin: const EdgeInsets.only(
                                        top: 10,
                                        right: 12,
                                      ),
                                      child: Card(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Opening: ${article.title}',
                                                ),
                                              ),
                                            );
                                          },
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (article.image != null &&
                                                  article.image!.isNotEmpty)
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(12),
                                                        topRight:
                                                            Radius.circular(12),
                                                      ),
                                                  child: Image.network(
                                                    _buildImageUrl(
                                                      article.image!,
                                                    ),
                                                    height: 110,
                                                    width: 90,
                                                    fit: BoxFit.values.first,
                                                    errorBuilder: (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return Container(
                                                        height: 100,
                                                        color: Colors.grey[300],
                                                        child: const Icon(
                                                          Icons
                                                              .image_not_supported,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              8.0,
                                                            ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              margin:
                                                                  EdgeInsets.all(
                                                                    5,
                                                                  ),
                                                              child: Text(
                                                                article
                                                                    .primaryText!
                                                                    .toUpperCase(),
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              article.title,
                                                              style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(height: 24),

                        // In Focus Section
                        if (inFocusArticles.isNotEmpty)
                          InFocusSection(articles: inFocusArticles),

                        const SizedBox(height: 24),

                        // Latest News Section
                        if (latestNewsArticles.isNotEmpty)
                          LatestNewsSection(articles: latestNewsArticles),

                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              )
              : _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'IR Prime'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Book Store'),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Trending',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  String _buildImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath;
    }
    return 'https://cdn.indiaretailing.com$imagePath';
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  late ApiService apiService;
  late Future<Map<String, dynamic>> futureData;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    futureData = _loadPageData();
  }

  Future<Map<String, dynamic>> _loadPageData() async {
    final response = await apiService.getPageContent(route: 'home');
    final inFocusArticles = apiService.extractInFocusArticles(response);
    final latestNewsArticles = apiService.extractLatestNewsArticles(response);
    final allArticles = apiService.parseArticlesFromResponse(response);

    return {
      'inFocus': inFocusArticles,
      'latestNews': latestNewsArticles,
      'allArticles': allArticles,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data found'));
        }

        final data = snapshot.data!;
        final inFocusArticles = data['inFocus'] as List<dynamic>;
        final latestNewsArticles = data['latestNews'] as List<dynamic>;
        final allArticles = data['allArticles'] as List<dynamic>;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // In Focus Section
              if (inFocusArticles.isNotEmpty)
                InFocusSection(articles: inFocusArticles),

              const SizedBox(height: 24),

              // Latest News Section
              if (latestNewsArticles.isNotEmpty)
                LatestNewsSection(articles: latestNewsArticles),

              const SizedBox(height: 24),

              // All Articles Section (Vertical)
              if (allArticles.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'All Articles',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: allArticles.length,
                      itemBuilder: (context, index) {
                        return ArticleCard(
                          article: allArticles[index] as dynamic,
                        );
                      },
                    ),
                  ],
                ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
