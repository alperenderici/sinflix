# 🎬 SinFlix - Premium Movie Streaming App

SinFlix, modern Flutter teknolojileri kullanılarak geliştirilmiş premium film akış uygulamasıdır. Clean Architecture prensiplerine uygun olarak tasarlanmış, kullanıcı dostu arayüzü ve performanslı yapısıyla öne çıkan bir mobil uygulamadır.

## 📱 Ekran Görüntüleri

> **Not:** Ekran görüntüleri ve demo videoları yakında eklenecektir.

<!--
Buraya ekran görüntüleri eklenecek:
- Splash Screen
- Login/Register Screens
- Home Page with Infinite Scroll
- Profile Page
- Limited Offer Bottom Sheet
- Movie Details
-->

## ✨ Özellikler

### 🔐 Kimlik Doğrulama
- [x] Kullanıcı girişi (Login)
- [x] Kullanıcı kaydı (Register)
- [x] Güvenli token yönetimi (Flutter Secure Storage)
- [x] Otomatik oturum kontrolü
- [x] Başarılı girişte ana sayfa yönlendirmesi

### 🏠 Ana Sayfa (Keşfet)
- [x] Sonsuz kaydırma (Infinite Scroll)
- [x] Sayfa başına 5 film gösterimi
- [x] Otomatik yükleme göstergesi
- [x] Pull-to-refresh özelliği
- [x] Favori film işlemlerinde anlık UI güncellemesi
- [x] Film kartları ile grid görünümü
- [x] Öne çıkan film bölümü

### 👤 Profil Sayfası
- [x] Kullanıcı bilgilerinin görüntülenmesi
- [x] Favori filmler listesi
- [x] Profil fotoğrafı yükleme özelliği
- [x] Kullanıcı çıkışı

### 🎯 Sınırlı Teklif Bottom Sheet
- [x] Özel tasarım ile premium paket sunumu
- [x] Animasyonlu geçişler
- [x] Paket seçenekleri ve fiyatlandırma

### 🧭 Navigasyon
- [x] **2 Buton Navigation** - Üst kısımda Anasayfa/Profil butonları
- [x] Ana sayfa state yönetimi ve korunması
- [x] Go Router ile modern routing
- [x] Navigation Service ile merkezi yönetim
- [x] **Custom Navigation Design** - Görseldeki tasarıma uygun buton yapısı

## 🏗️ Teknik Yapı

### Mimari
- [x] **Clean Architecture** - Katmanlı mimari yapısı
- [x] **MVVM Pattern** - Model-View-ViewModel deseni
- [x] **BLoC State Management** - Reactive state yönetimi

### Kullanılan Teknolojiler

#### 🎯 State Management
- [x] **Flutter BLoC** (^8.1.6) - Reactive state management
- [x] **Equatable** (^2.0.5) - Value equality

#### 🌐 Network & API
- [x] **Dio** (^5.7.0) - HTTP client
- [x] **JSON Serialization** - API response handling

#### 🗂️ Dependency Injection
- [x] **GetIt** (^8.0.2) - Service locator

#### 🧭 Navigation
- [x] **Go Router** (^14.6.2) - Declarative routing
- [x] **Navigation Service** - Centralized navigation

#### 💾 Storage
- [x] **Flutter Secure Storage** (^9.2.2) - Secure token storage

#### 🌍 Localization
- [x] **Flutter Localizations** - Multi-language support
- [x] **Türkçe** ve **İngilizce** dil desteği
- [x] **Intl** (^0.20.2) - Internationalization

#### 🖼️ UI & Media
- [x] **Cached Network Image** (^3.4.1) - Image caching
- [x] **Image Picker** (^1.1.2) - Photo upload
- [x] **Flutter SVG** (^2.0.10+1) - SVG support
- [x] **Lottie** (^3.2.0) - Animations

#### 🔧 Development Tools
- [x] **Logger** (^2.4.0) - Comprehensive logging
- [x] **Build Runner** (^2.4.13) - Code generation
- [x] **Flutter Gen** - Asset generation
- [x] **Freezed** (^2.5.7) - Immutable data classes

#### 🎨 Design & Theme
- [x] **Custom Dark Theme** - Modern dark UI
- [x] **Material 3** design system
- [x] **Custom Color Palette**
- [x] **Responsive Design**

#### 📱 App Configuration
- [x] **Flutter Native Splash** - Custom splash screen
- [x] **Flutter Launcher Icons** - Custom app icons
- [x] **Adaptive Icons** - Android adaptive icons

## 🚀 Kurulum ve Çalıştırma

### Gereksinimler
- Flutter SDK (^3.8.1)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Kurulum Adımları

1. **Projeyi klonlayın:**
```bash
git clone <repository-url>
cd sinflix
```

2. **Bağımlılıkları yükleyin:**
```bash
flutter pub get
```

3. **Code generation çalıştırın:**
```bash
flutter packages pub run build_runner build
```

4. **Splash screen ve ikonları oluşturun:**
```bash
flutter pub run flutter_native_splash:create
flutter pub run flutter_launcher_icons:main
```

5. **Uygulamayı çalıştırın:**
```bash
flutter run
```

## 📁 Proje Yapısı

```
lib/
├── core/                    # Core functionality
│   ├── constants/          # App constants
│   ├── di/                 # Dependency injection
│   ├── error/              # Error handling
│   ├── gen/                # Generated files
│   ├── network/            # Network configuration
│   ├── services/           # Core services
│   ├── usecases/           # Base use cases
│   └── utils/              # Utilities
├── data/                   # Data layer
│   ├── datasources/        # Remote & local data sources
│   ├── models/             # Data models
│   └── repositories/       # Repository implementations
├── domain/                 # Domain layer
│   ├── entities/           # Business entities
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Business use cases
├── presentation/           # Presentation layer
│   ├── auth/               # Authentication screens
│   ├── core/               # Core UI components
│   ├── home/               # Home screen
│   ├── profile/            # Profile screen
│   ├── shared_widgets/     # Shared UI components
│   └── movie/              # Movie related screens
├── l10n/                   # Localization files
└── main.dart               # App entry point
```

## 📊 Değerlendirme Kriterleri

### ✅ Tamamlanan Özellikler

#### 🔐 Kimlik Doğrulama
- [x] **Kullanıcı girişi ve kayıt** - Tam implementasyon
- [x] **Güvenli token saklama** - Flutter Secure Storage ile
- [x] **Otomatik yönlendirme** - Başarılı girişte ana sayfaya

#### 🏠 Ana Sayfa Özellikleri
- [x] **Sonsuz kaydırma** - Infinite scroll implementasyonu
- [x] **Sayfalama** - Her sayfada 5 film gösterimi
- [x] **Yükleme göstergesi** - Loading indicators
- [x] **Pull-to-refresh** - Yenileme özelliği
- [x] **Favori işlemleri** - Anlık UI güncellemesi

#### 👤 Profil Sayfası
- [x] **Kullanıcı bilgileri** - Profil görüntüleme
- [x] **Favori filmler** - Kullanıcının favori listesi
- [x] **Fotoğraf yükleme** - Profil resmi güncelleme

#### 🧭 Navigasyon
- [x] **Bottom Navigation** - Ana navigasyon sistemi
- [x] **State korunması** - Sayfa geçişlerinde state management
- [x] **Modern routing** - Go Router implementasyonu

#### 🏗️ Kod Yapısı
- [x] **Clean Architecture** - Katmanlı mimari
- [x] **MVVM Pattern** - Model-View-ViewModel
- [x] **BLoC State Management** - Reactive programming

### 🎯 Bonus Özellikler

#### ✅ Tamamlanan Bonus Özellikler
- [x] **Custom Theme** - Dark theme implementasyonu
- [x] **Navigation Service** - Merkezi navigasyon yönetimi
- [x] **Localization Service** - Türkçe/İngilizce dil desteği
- [x] **Logger Service** - Kapsamlı loglama sistemi
- [x] **Splash Screen** - Custom splash screen
- [x] **App Icons** - Custom uygulama ikonları
- [x] **Güvenli Token Yönetimi** - Secure storage

#### 🔄 Kısmen Tamamlanan
- [/] **Firebase Integration** - Mock servisler olarak çalışıyor
  - [/] **Crashlytics** - Mock service aktif (gerçek Firebase devre dışı)
  - [/] **Analytics** - Mock service aktif (gerçek Firebase devre dışı)
- [/] **Animasyonlar** - Lottie hazır, kullanımda değil

#### ⏳ Gelecek Güncellemeler
- [ ] **Arama Özelliği** - Search functionality
- [ ] **Film Detay Sayfası** - Movie details screen
- [ ] **Favoriler Sayfası** - Dedicated favorites page
- [ ] **Premium Satın Alma** - In-app purchases
- [ ] **Offline Mod** - Offline viewing capability

## 🎨 UI/UX Tasarım

### Tasarım Prensipleri
- **Material 3** design system
- **Dark Theme** odaklı modern tasarım
- **Responsive** layout yapısı
- **Accessibility** friendly components
- **Smooth animations** ve geçişler

### Implemented Optimizations
- [x] **Image Caching** - Cached Network Image kullanımı
- [x] **Lazy Loading** - Infinite scroll ile
- [x] **State Management** - Efficient BLoC pattern
- [x] **Memory Management** - Proper disposal patterns
- [x] **Network Optimization** - Dio interceptors

### Best Practices
- [x] **Clean Code** - Readable ve maintainable kod
- [x] **Error Handling** - Comprehensive error management
- [x] **Logging** - Detailed logging system
- [x] **Type Safety** - Strong typing with Dart
- [x] **Code Generation** - Automated code generation

## 🧪 Test Yapısı

### Test Kategorileri
- [ ] **Unit Tests** - Business logic testing
- [ ] **Widget Tests** - UI component testing
- [ ] **Integration Tests** - End-to-end testing

## 📚 API Entegrasyonu

### Kullanılan Endpoints
- **Base URL:** `https://caseapi.servicelabs.tech`
- **Auth:** `/user/login`, `/user/register`
- **Profile:** `/user/profile`, `/user/upload_photo`
- **Movies:** `/movie/list`, `/movie/favorites`
- **Favorites:** `/movie/favorite/:id`

### API Features
- [x] **Authentication** - JWT token based
- [x] **Pagination** - Server-side pagination
- [x] **Error Handling** - Comprehensive error responses
- [x] **Image Upload** - Profile photo upload

## 🔒 Güvenlik

### Security Measures
- [x] **Secure Storage** - Token encryption
- [x] **HTTPS** - Secure API communication
- [x] **Input Validation** - Form validation
- [x] **Error Masking** - Secure error messages

## 📱 Platform Desteği

### Supported Platforms
- [x] **Android** (API 21+)
- [x] **iOS** (iOS 12+)

### Device Compatibility
- [x] **Phones** - All screen sizes
- [x] **Tablets** - Responsive design
- [x] **Portrait Mode** - Optimized for portrait

## 🚀 Deployment

### Build Commands
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

### Release Configuration
- [x] **Splash Screen** - Custom splash
- [x] **App Icons** - Adaptive icons
- [x] **Signing** - Ready for store deployment

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için `LICENSE` dosyasına bakınız.