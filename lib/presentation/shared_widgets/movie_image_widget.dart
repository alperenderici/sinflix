import 'package:flutter/material.dart';
import '../../core/services/image_cache_service.dart';
import '../../domain/entities/movie.dart';

/// Reusable widget for displaying movie images with consistent caching and styling
class MovieImageWidget extends StatelessWidget {
  final Movie movie;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool showFavoriteButton;
  final VoidCallback? onFavoriteToggle;

  const MovieImageWidget({
    super.key,
    required this.movie,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.showFavoriteButton = false,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    // Determine which image URL to use
    String imageUrl = _getImageUrl();

    Widget imageWidget = ImageCacheService.buildMoviePosterImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      placeholder: placeholder,
      errorWidget: errorWidget,
    );

    // Add favorite button if needed
    if (showFavoriteButton && onFavoriteToggle != null) {
      imageWidget = Stack(
        children: [
          imageWidget,
          Positioned(
            top: 8,
            right: 8,
            child: _buildFavoriteButton(),
          ),
        ],
      );
    }

    return imageWidget;
  }

  /// Get the appropriate image URL from movie entity
  String _getImageUrl() {
    // Priority: posterUrl > fullPosterUrl > posterPath
    if (movie.posterUrl.isNotEmpty) {
      return movie.posterUrl;
    }
    
    if (movie.posterPath != null && movie.posterPath!.isNotEmpty) {
      return movie.fullPosterUrl;
    }
    
    return '';
  }

  /// Build favorite button overlay
  Widget _buildFavoriteButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          movie.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: movie.isFavorite ? Colors.red : Colors.white,
          size: 20,
        ),
        onPressed: onFavoriteToggle,
        padding: const EdgeInsets.all(4),
        constraints: const BoxConstraints(),
      ),
    );
  }
}

/// Specialized widget for movie poster cards
class MoviePosterCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final bool showFavoriteButton;

  const MoviePosterCard({
    super.key,
    required this.movie,
    this.onTap,
    this.onFavoriteToggle,
    this.showFavoriteButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Movie Image
              Expanded(
                flex: 4,
                child: MovieImageWidget(
                  movie: movie,
                  width: double.infinity,
                  height: double.infinity,
                  showFavoriteButton: showFavoriteButton,
                  onFavoriteToggle: onFavoriteToggle,
                ),
              ),
              
              // Movie Info
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.black87,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (movie.description.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          movie.description,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Specialized widget for favorite movie cards in profile
class FavoriteMovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;

  const FavoriteMovieCard({
    super.key,
    required this.movie,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
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
              child: MovieImageWidget(
                movie: movie,
                width: double.infinity,
                height: double.infinity,
                borderRadius: BorderRadius.circular(12),
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
      ),
    );
  }
}

/// Specialized widget for profile image
class ProfileImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final VoidCallback? onTap;

  const ProfileImageWidget({
    super.key,
    this.imageUrl,
    this.size = 80,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade700, width: 2),
        ),
        child: ClipOval(
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? ImageCacheService.buildProfileImage(
                  imageUrl: imageUrl!,
                  width: size,
                  height: size,
                  borderRadius: BorderRadius.circular(size / 2),
                )
              : Container(
                  color: Colors.grey.shade800,
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
