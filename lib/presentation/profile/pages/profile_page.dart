import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection_container.dart';
import '../../../domain/entities/movie.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../../core/navigation/navigation_service.dart';
import '../../movie/bloc/movie_bloc.dart';
import '../../movie/bloc/movie_event.dart';
import '../../movie/bloc/movie_state.dart';
import '../widgets/limited_offer_bottom_sheet.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late MovieBloc _movieBloc;

  @override
  void initState() {
    super.initState();
    _movieBloc = sl<MovieBloc>();
    _movieBloc.add(LoadFavoriteMovies());
  }

  @override
  void dispose() {
    _movieBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: _movieBloc)],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            NavigationService.goToLogin();
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Profil Detayı',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            centerTitle: true,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                child: ElevatedButton(
                  onPressed: () {
                    _showLimitedOfferBottomSheet(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.favorite, size: 16),
                      const SizedBox(width: 4),
                      const Text(
                        'Sınırlı Teklif',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Profile Header
                _buildProfileHeader(context),

                const SizedBox(height: 32),

                // Liked Movies Section
                _buildLikedMoviesSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String userName = 'Ayça Aydoğan';
        String userId = 'ID: 245677';

        if (state is AuthAuthenticated) {
          userName = state.user.name;
          // You can add user ID to your user model if needed
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // Profile Picture
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade700, width: 2),
                ),
                child: ClipOval(
                  child: Container(
                    color: Colors.grey.shade800,
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // User Name
              Text(
                userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              // User ID
              Text(
                userId,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              ),

              const SizedBox(height: 20),

              // Add Photo Button
              ElevatedButton(
                onPressed: () {
                  NavigationService.goToUploadPhoto();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Fotoğraf Ekle',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLikedMoviesSection(BuildContext context) {
    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title
              const Text(
                'Beğendiğim Filmler',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              // Show movies grid or empty state
              if (state is FavoriteMoviesLoaded &&
                  state.favoriteMovies.isNotEmpty) ...[
                // Movies Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio:
                        0.7, // Adjust for movie poster aspect ratio
                  ),
                  itemCount: state.favoriteMovies.length > 4
                      ? 4
                      : state.favoriteMovies.length,
                  itemBuilder: (context, index) {
                    return _buildFavoriteMovieCard(state.favoriteMovies[index]);
                  },
                ),
              ] else ...[
                // Empty state - just show empty space
                const SizedBox(
                  height: 100,
                ), // Add some space where movies would be
              ],

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFavoriteMovieCard(Movie movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Movie Poster
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                movie.posterUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade800,
                    child: const Icon(
                      Icons.movie,
                      color: Colors.white54,
                      size: 40,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey.shade800,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Movie Title
        Text(
          movie.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        // Movie Description (if available)
        if (movie.description.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            movie.description,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  void _showLimitedOfferBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LimitedOfferBottomSheet(),
    );
  }
}
