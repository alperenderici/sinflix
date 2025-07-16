# Sinflix Flutter Project Makefile
# Comprehensive development automation for Flutter applications
# Author: Sinflix Development Team
# Version: 1.0.0

# Colors for output
RED=\033[0;31m
GREEN=\033[0;32m
YELLOW=\033[1;33m
BLUE=\033[0;34m
PURPLE=\033[0;35m
CYAN=\033[0;36m
WHITE=\033[1;37m
NC=\033[0m # No Color

# Project configuration
PROJECT_NAME=sinflix
FLUTTER_VERSION=3.24.0
DART_VERSION=3.5.0

# Build configuration
BUILD_NAME=1.0.0
BUILD_NUMBER=1
ANDROID_COMPILE_SDK=34
ANDROID_MIN_SDK=21
ANDROID_TARGET_SDK=34

# Directories
BUILD_DIR=build
COVERAGE_DIR=coverage
REPORTS_DIR=reports

.PHONY: help setup clean install run test build deploy

# Default target
help: ## Show this help message
	@echo "$(CYAN)Sinflix Flutter Development Makefile$(NC)"
	@echo "$(WHITE)Available commands:$(NC)"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  $(GREEN)%-20s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# =============================================================================
# SETUP AND DEPENDENCIES
# =============================================================================

setup: ## Complete project setup (install dependencies, generate code, etc.)
	@echo "$(BLUE)Setting up Sinflix project...$(NC)"
	@$(MAKE) install
	@$(MAKE) generate
	@$(MAKE) l10n
	@echo "$(GREEN)✅ Project setup completed!$(NC)"

install: ## Install Flutter dependencies
	@echo "$(BLUE)Installing Flutter dependencies...$(NC)"
	@flutter pub get
	@echo "$(GREEN)✅ Dependencies installed$(NC)"

upgrade: ## Upgrade Flutter dependencies
	@echo "$(BLUE)Upgrading Flutter dependencies...$(NC)"
	@flutter pub upgrade
	@echo "$(GREEN)✅ Dependencies upgraded$(NC)"

outdated: ## Check for outdated dependencies
	@echo "$(BLUE)Checking for outdated dependencies...$(NC)"
	@flutter pub outdated

# =============================================================================
# DEVELOPMENT
# =============================================================================

run: ## Run the app in debug mode
	@echo "$(BLUE)Running Sinflix in debug mode...$(NC)"
	@flutter run

run-release: ## Run the app in release mode
	@echo "$(BLUE)Running Sinflix in release mode...$(NC)"
	@flutter run --release

run-profile: ## Run the app in profile mode
	@echo "$(BLUE)Running Sinflix in profile mode...$(NC)"
	@flutter run --profile

hot-reload: ## Trigger hot reload (use when app is running)
	@echo "$(BLUE)Triggering hot reload...$(NC)"
	@echo "r" | flutter run

hot-restart: ## Trigger hot restart (use when app is running)
	@echo "$(BLUE)Triggering hot restart...$(NC)"
	@echo "R" | flutter run

devices: ## List available devices
	@echo "$(BLUE)Available devices:$(NC)"
	@flutter devices

# =============================================================================
# CODE GENERATION
# =============================================================================

generate: ## Generate code (JSON serialization, etc.)
	@echo "$(BLUE)Generating code...$(NC)"
	@flutter packages pub run build_runner build --delete-conflicting-outputs
	@echo "$(GREEN)✅ Code generation completed$(NC)"

generate-watch: ## Watch for changes and generate code automatically
	@echo "$(BLUE)Watching for changes and generating code...$(NC)"
	@flutter packages pub run build_runner watch --delete-conflicting-outputs

generate-clean: ## Clean generated files and regenerate
	@echo "$(BLUE)Cleaning and regenerating code...$(NC)"
	@flutter packages pub run build_runner clean
	@flutter packages pub run build_runner build --delete-conflicting-outputs
	@echo "$(GREEN)✅ Clean code generation completed$(NC)"

# =============================================================================
# LOCALIZATION
# =============================================================================

l10n: ## Generate localization files
	@echo "$(BLUE)Generating localization files...$(NC)"
	@flutter gen-l10n
	@echo "$(GREEN)✅ Localization files generated$(NC)"

l10n-watch: ## Watch for localization changes
	@echo "$(BLUE)Watching for localization changes...$(NC)"
	@while true; do \
		inotifywait -e modify lib/l10n/*.arb 2>/dev/null || sleep 2; \
		$(MAKE) l10n; \
	done

# =============================================================================
# CODE QUALITY
# =============================================================================

analyze: ## Analyze code for issues
	@echo "$(BLUE)Analyzing code...$(NC)"
	@flutter analyze
	@echo "$(GREEN)✅ Code analysis completed$(NC)"

format: ## Format code
	@echo "$(BLUE)Formatting code...$(NC)"
	@dart format .
	@echo "$(GREEN)✅ Code formatted$(NC)"

format-check: ## Check if code is properly formatted
	@echo "$(BLUE)Checking code formatting...$(NC)"
	@dart format --set-exit-if-changed .

lint: ## Run linter
	@echo "$(BLUE)Running linter...$(NC)"
	@flutter analyze --fatal-infos
	@echo "$(GREEN)✅ Linting completed$(NC)"

metrics: ## Generate code metrics
	@echo "$(BLUE)Generating code metrics...$(NC)"
	@mkdir -p $(REPORTS_DIR)
	@flutter analyze --write=$(REPORTS_DIR)/analysis.txt
	@echo "$(GREEN)✅ Code metrics generated in $(REPORTS_DIR)/$(NC)"

# =============================================================================
# TESTING
# =============================================================================

test: ## Run all tests
	@echo "$(BLUE)Running all tests...$(NC)"
	@flutter test
	@echo "$(GREEN)✅ All tests completed$(NC)"

test-unit: ## Run unit tests only
	@echo "$(BLUE)Running unit tests...$(NC)"
	@flutter test test/unit/
	@echo "$(GREEN)✅ Unit tests completed$(NC)"

test-widget: ## Run widget tests only
	@echo "$(BLUE)Running widget tests...$(NC)"
	@flutter test test/widget/
	@echo "$(GREEN)✅ Widget tests completed$(NC)"

test-integration: ## Run integration tests
	@echo "$(BLUE)Running integration tests...$(NC)"
	@flutter test integration_test/
	@echo "$(GREEN)✅ Integration tests completed$(NC)"

test-coverage: ## Run tests with coverage report
	@echo "$(BLUE)Running tests with coverage...$(NC)"
	@mkdir -p $(COVERAGE_DIR)
	@flutter test --coverage
	@genhtml coverage/lcov.info -o $(COVERAGE_DIR)/html
	@echo "$(GREEN)✅ Coverage report generated in $(COVERAGE_DIR)/html/$(NC)"

test-watch: ## Watch for changes and run tests automatically
	@echo "$(BLUE)Watching for changes and running tests...$(NC)"
	@flutter test --watch

# =============================================================================
# BUILD
# =============================================================================

build-android-debug: ## Build Android APK (debug)
	@echo "$(BLUE)Building Android APK (debug)...$(NC)"
	@flutter build apk --debug
	@echo "$(GREEN)✅ Android debug APK built$(NC)"

build-android-release: ## Build Android APK (release)
	@echo "$(BLUE)Building Android APK (release)...$(NC)"
	@flutter build apk --release
	@echo "$(GREEN)✅ Android release APK built$(NC)"

build-android-bundle: ## Build Android App Bundle (release)
	@echo "$(BLUE)Building Android App Bundle (release)...$(NC)"
	@flutter build appbundle --release
	@echo "$(GREEN)✅ Android App Bundle built$(NC)"

build-ios: ## Build iOS app
	@echo "$(BLUE)Building iOS app...$(NC)"
	@flutter build ios --release
	@echo "$(GREEN)✅ iOS app built$(NC)"

build-ios-simulator: ## Build iOS app for simulator
	@echo "$(BLUE)Building iOS app for simulator...$(NC)"
	@flutter build ios --debug --simulator
	@echo "$(GREEN)✅ iOS simulator app built$(NC)"

build-all: ## Build for all platforms
	@echo "$(BLUE)Building for all platforms...$(NC)"
	@$(MAKE) build-android-release
	@$(MAKE) build-android-bundle
	@$(MAKE) build-ios
	@echo "$(GREEN)✅ All platform builds completed$(NC)"

# =============================================================================
# ASSETS AND ICONS
# =============================================================================

icons: ## Generate app icons
	@echo "$(BLUE)Generating app icons...$(NC)"
	@flutter pub run flutter_launcher_icons:main
	@echo "$(GREEN)✅ App icons generated$(NC)"

splash: ## Generate splash screens
	@echo "$(BLUE)Generating splash screens...$(NC)"
	@flutter pub run flutter_native_splash:create
	@echo "$(GREEN)✅ Splash screens generated$(NC)"

assets: ## Generate assets (icons, splash, etc.)
	@echo "$(BLUE)Generating all assets...$(NC)"
	@$(MAKE) icons
	@$(MAKE) splash
	@echo "$(GREEN)✅ All assets generated$(NC)"

# =============================================================================
# FIREBASE
# =============================================================================

firebase-login: ## Login to Firebase
	@echo "$(BLUE)Logging into Firebase...$(NC)"
	@firebase login

firebase-init: ## Initialize Firebase in project
	@echo "$(BLUE)Initializing Firebase...$(NC)"
	@firebase init

firebase-deploy: ## Deploy to Firebase Hosting
	@echo "$(BLUE)Deploying to Firebase Hosting...$(NC)"
	@firebase deploy

firebase-functions-deploy: ## Deploy Firebase Functions
	@echo "$(BLUE)Deploying Firebase Functions...$(NC)"
	@firebase deploy --only functions

# =============================================================================
# MAINTENANCE
# =============================================================================

clean: ## Clean build artifacts
	@echo "$(BLUE)Cleaning build artifacts...$(NC)"
	@flutter clean
	@rm -rf $(BUILD_DIR)
	@rm -rf $(COVERAGE_DIR)
	@rm -rf $(REPORTS_DIR)
	@echo "$(GREEN)✅ Build artifacts cleaned$(NC)"

deep-clean: ## Deep clean (including pub cache)
	@echo "$(BLUE)Performing deep clean...$(NC)"
	@$(MAKE) clean
	@flutter pub cache clean
	@rm -rf .dart_tool
	@rm -rf .packages
	@echo "$(GREEN)✅ Deep clean completed$(NC)"

reset: ## Reset project to clean state
	@echo "$(BLUE)Resetting project...$(NC)"
	@$(MAKE) deep-clean
	@$(MAKE) setup
	@echo "$(GREEN)✅ Project reset completed$(NC)"

doctor: ## Run Flutter doctor
	@echo "$(BLUE)Running Flutter doctor...$(NC)"
	@flutter doctor -v

version: ## Show version information
	@echo "$(CYAN)Sinflix Project Information:$(NC)"
	@echo "Project: $(PROJECT_NAME)"
	@echo "Build Name: $(BUILD_NAME)"
	@echo "Build Number: $(BUILD_NUMBER)"
	@echo ""
	@echo "$(CYAN)Flutter Environment:$(NC)"
	@flutter --version

# =============================================================================
# UTILITIES
# =============================================================================

logs-android: ## Show Android logs
	@echo "$(BLUE)Showing Android logs...$(NC)"
	@adb logcat | grep flutter

logs-ios: ## Show iOS logs
	@echo "$(BLUE)Showing iOS logs...$(NC)"
	@xcrun simctl spawn booted log stream --predicate 'eventMessage contains "flutter"'

screenshot: ## Take screenshot of running app
	@echo "$(BLUE)Taking screenshot...$(NC)"
	@mkdir -p screenshots
	@adb exec-out screencap -p > screenshots/screenshot_$(shell date +%Y%m%d_%H%M%S).png
	@echo "$(GREEN)✅ Screenshot saved to screenshots/$(NC)"

# =============================================================================
# DEVELOPMENT WORKFLOW
# =============================================================================

dev-setup: ## Complete development environment setup
	@echo "$(BLUE)Setting up development environment...$(NC)"
	@$(MAKE) doctor
	@$(MAKE) setup
	@$(MAKE) test
	@echo "$(GREEN)✅ Development environment ready!$(NC)"

pre-commit: ## Run pre-commit checks
	@echo "$(BLUE)Running pre-commit checks...$(NC)"
	@$(MAKE) format
	@$(MAKE) analyze
	@$(MAKE) test
	@echo "$(GREEN)✅ Pre-commit checks passed$(NC)"

ci: ## Run CI pipeline locally
	@echo "$(BLUE)Running CI pipeline...$(NC)"
	@$(MAKE) clean
	@$(MAKE) install
	@$(MAKE) generate
	@$(MAKE) l10n
	@$(MAKE) analyze
	@$(MAKE) test-coverage
	@$(MAKE) build-android-release
	@echo "$(GREEN)✅ CI pipeline completed$(NC)"

release-prep: ## Prepare for release
	@echo "$(BLUE)Preparing for release...$(NC)"
	@$(MAKE) clean
	@$(MAKE) setup
	@$(MAKE) test-coverage
	@$(MAKE) build-all
	@$(MAKE) assets
	@echo "$(GREEN)✅ Release preparation completed$(NC)"
