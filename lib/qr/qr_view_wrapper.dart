// Platforma göre doğru QR view implementasyonunu yönlendirir:
export 'qr_view_mobile.dart' // Varsayılan olarak mobil implementasyonu kullan
  if (dart.library.html) 'qr_view_web.dart'; // Web platformunda web stub'ını kullan
