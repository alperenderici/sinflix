import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import '../../core/navigation/navigation_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          NavigationService.goToLogin();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: AppColors.background,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                NavigationService.goToSettings();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Header
              _buildProfileHeader(context),
              
              const SizedBox(height: 32),
              
              // Profile Options
              _buildProfileOptions(context),
              
              const SizedBox(height: 32),
              
              // Logout Button
              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String userName = 'User';
        String userEmail = 'user@example.com';
        
        if (state is AuthAuthenticated) {
          userName = state.user.name ?? 'User';
          userEmail = state.user.email;
        }
        
        return Column(
          children: [
            // Profile Picture
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.surfaceVariant,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.background,
                        width: 2,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: AppColors.onPrimary,
                      ),
                      onPressed: () {
                        // TODO: Implement profile picture upload
                      },
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // User Name
            Text(
              userName,
              style: AppTextStyles.headlineSmall,
            ),
            
            const SizedBox(height: 4),
            
            // User Email
            Text(
              userEmail,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileOptions(BuildContext context) {
    return Column(
      children: [
        _buildOptionTile(
          icon: Icons.edit,
          title: 'Edit Profile',
          onTap: () {
            NavigationService.goToEditProfile();
          },
        ),
        _buildOptionTile(
          icon: Icons.favorite,
          title: 'My Favorites',
          onTap: () {
            NavigationService.goToFavorites();
          },
        ),
        _buildOptionTile(
          icon: Icons.language,
          title: 'Language',
          onTap: () {
            // TODO: Show language selection dialog
          },
        ),
        _buildOptionTile(
          icon: Icons.dark_mode,
          title: 'Theme',
          onTap: () {
            // TODO: Show theme selection dialog
          },
        ),
        _buildOptionTile(
          icon: Icons.help,
          title: 'Help & Support',
          onTap: () {
            // TODO: Navigate to help page
          },
        ),
        _buildOptionTile(
          icon: Icons.info,
          title: 'About',
          onTap: () {
            // TODO: Show about dialog
          },
        ),
      ],
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: AppColors.primary,
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyLarge,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.onSurfaceVariant,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLogoutLoading;
        
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: isLoading
                ? null
                : () {
                    _showLogoutDialog(context);
                  },
            icon: isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.logout),
            label: Text(isLoading ? 'Logging out...' : 'Logout'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(const AuthLogoutRequested());
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
