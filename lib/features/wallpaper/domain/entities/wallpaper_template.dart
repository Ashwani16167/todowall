enum WallpaperTemplate {
  minimal,
  modern,
  amoled,
  glass;

  String get label {
    switch (this) {
      case WallpaperTemplate.minimal:
        return 'Minimal';
      case WallpaperTemplate.modern:
        return 'Modern Productivity';
      case WallpaperTemplate.amoled:
        return 'Dark AMOLED';
      case WallpaperTemplate.glass:
        return 'Glassmorphism';
    }
  }
}
