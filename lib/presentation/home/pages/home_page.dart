import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/gen/assets.gen.dart';
import '../../../domain/entities/movie.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/navigation/navigation_service.dart';
import '../bloc/movies_bloc.dart';
import '../bloc/movies_event.dart';
import '../bloc/movies_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MoviesBloc>()..add(const MoviesLoadRequested()),
      child: const _HomePageContent(),
    );
  }
}

class _HomePageContent extends StatefulWidget {
  const _HomePageContent();

  @override
  State<_HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<_HomePageContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<MoviesBloc>().add(const MoviesLoadMoreRequested());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Assets.images.sinflixLogo.image(height: 40, fit: BoxFit.contain),
          ],
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // TODO: Navigate to search page
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              // TODO: Show notifications
            },
          ),
          if (kDebugMode)
            IconButton(
              icon: const Icon(Icons.bug_report, color: Colors.white),
              onPressed: () {
                NavigationService.push(AppRoutes.firebaseTest);
              },
              tooltip: 'Firebase Test',
            ),
        ],
      ),
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<MoviesBloc>().add(
                const MoviesLoadRequested(isRefresh: true),
              );
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Featured Section
                SliverToBoxAdapter(child: _buildFeaturedSection()),

                // Movies Grid
                if (state is MoviesLoaded) ...[
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index >= state.movies.length) {
                            return state.isLoadingMore
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : const SizedBox.shrink();
                          }
                          return _buildMovieCard(state.movies[index]);
                        },
                        childCount:
                            state.movies.length + (state.isLoadingMore ? 1 : 0),
                      ),
                    ),
                  ),
                ] else if (state is MoviesLoading) ...[
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ] else if (state is MoviesError) ...[
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Hata: ${state.message}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<MoviesBloc>().add(
                                const MoviesLoadRequested(),
                              );
                            },
                            child: const Text('Tekrar Dene'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return Container(
      height: 300,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
        ),
        image: const DecorationImage(
          image: NetworkImage(
            'https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg', // Placeholder movie poster
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Öne Çıkan Film',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Günün en popüler filmi',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('İzle'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Listem'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to movie details
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Movie Poster
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    image: DecorationImage(
                      image: NetworkImage(movie.posterUrl),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {
                        // Fallback to placeholder
                      },
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Favorite button
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              movie.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: movie.isFavorite
                                  ? Colors.red
                                  : Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              // TODO: Implement favorite toggle
                              // context.read<MoviesBloc>().add(
                              //   MovieFavoriteToggleRequested(
                              //     movieId: movie.id,
                              //     isFavorite: !movie.isFavorite,
                              //   ),
                              // );
                            },
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Movie Info
              Container(
                color: AppColors.surface,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          movie.voteAverage?.toStringAsFixed(1) ?? '0.0',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.onSurface,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '2023',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
