// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Sinflix';

  @override
  String get login => 'Giriş Yap';

  @override
  String get register => 'Kayıt Ol';

  @override
  String get email => 'E-posta';

  @override
  String get password => 'Şifre';

  @override
  String get confirmPassword => 'Şifreyi Onayla';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get profile => 'Profil';

  @override
  String get favorites => 'Favoriler';

  @override
  String get movies => 'Filmler';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get pullToRefresh => 'Yenilemek için çekin';

  @override
  String get noMoviesFound => 'Film bulunamadı';

  @override
  String get addToFavorites => 'Favorilere Ekle';

  @override
  String get removeFromFavorites => 'Favorilerden Çıkar';

  @override
  String get logout => 'Çıkış Yap';

  @override
  String get settings => 'Ayarlar';

  @override
  String get language => 'Dil';

  @override
  String get theme => 'Tema';

  @override
  String get error => 'Hata';

  @override
  String get tryAgain => 'Tekrar Dene';

  @override
  String get networkError => 'Ağ hatası oluştu';

  @override
  String get invalidCredentials => 'Geçersiz e-posta veya şifre';

  @override
  String get emailRequired => 'E-posta gerekli';

  @override
  String get passwordRequired => 'Şifre gerekli';

  @override
  String get uploadProfilePicture => 'Profil Fotoğrafı Yükle';
}
