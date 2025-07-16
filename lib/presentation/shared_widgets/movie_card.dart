import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../domain/entities/movie.dart';
import 'loading_widget.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final bool isFavorite;
  final bool showFavoriteButton;

  const MovieCard({
    super.key,
    required this.movie,
    this.onTap,
    this.onFavoriteToggle,
    this.isFavorite = false,
    this.showFavoriteButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            Expanded(
              flex: 3,
              child: _buildPoster(),
            ),
            
            // Movie Info
            Expanded(
              flex: 1,
              child: _buildMovieInfo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPoster() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(12),
        ),
        child: movie.posterPath != null
            ? CachedNetworkImage(
                imageUrl: movie.fullPosterUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.surfaceVariant,
                  child: const Center(
                    child: LoadingWidget(size: 24),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.surfaceVariant,
                  child: const Icon(
                    Icons.movie,
                    size: 48,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              )
            : Container(
                color: AppColors.surfaceVariant,
                child: const Icon(
                  Icons.movie,
                  size: 48,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
      ),
    );
  }

  Widget _buildMovieInfo() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movie.title,
            style: AppTextStyles.titleSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (movie.voteAverage != null) ...[
                const Icon(
                  Icons.star,
                  size: 16,
                  color: Colors.amber,
                ),
                const SizedBox(width: 4),
                Text(
                  movie.voteAverage!.toStringAsFixed(1),
                  style: AppTextStyles.bodySmall,
                ),
              ],
              const Spacer(),
              if (showFavoriteButton && onFavoriteToggle != null)
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 20,
                    color: isFavorite ? AppColors.primary : null,
                  ),
                  onPressed: onFavoriteToggle,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class MovieListTile extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final bool isFavorite;

  const MovieListTile({
    super.key,
    required this.movie,
    this.onTap,
    this.onFavoriteToggle,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 60,
            height: 90,
            child: movie.posterPath != null
                ? CachedNetworkImage(
                    imageUrl: movie.fullPosterUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.surfaceVariant,
                      child: const Icon(Icons.movie),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.surfaceVariant,
                      child: const Icon(Icons.movie),
                    ),
                  )
                : Container(
                    color: AppColors.surfaceVariant,
                    child: const Icon(Icons.movie),
                  ),
          ),
        ),
        title: Text(
          movie.title,
          style: AppTextStyles.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (movie.overview != null) ...[
              Text(
                movie.overview!,
                style: AppTextStyles.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
            ],
            if (movie.voteAverage != null)
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    movie.voteAverage!.toStringAsFixed(1),
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
          ],
        ),
        trailing: onFavoriteToggle != null
            ? IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppColors.primary : null,
                ),
                onPressed: onFavoriteToggle,
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
