// lib/utils/cloudinary_config.dart
class CloudinaryConfig {
  // Replace these with your actual Cloudinary credentials
  static const String cloudName = 'dnfeo5ce9';
  static const String apiKey = '262367665752528';
  static const String apiSecret = 'xpnLEFUJHLJjRdDemkn9LG2ViXs';
 // static const String uploadPreset = 'your_upload_preset';

  // Optional: Configure folders for better organization
  static const String solutionsFolder = 'jenga_solutions';
  static const String profilesFolder = 'user_profiles';

  // Image transformation presets
  static const String thumbnailTransformation = 'w_150,h_150,c_fill,q_auto,f_auto';
  static const String mediumTransformation = 'w_400,h_400,c_fill,q_auto,f_auto';
  static const String largeTransformation = 'w_800,h_800,c_fill,q_auto,f_auto';
}

// Environment variables helper
class CloudinaryEnvironment {
  static String get cloudName =>
      const String.fromEnvironment('CLOUDINARY_CLOUD_NAME',
          defaultValue: CloudinaryConfig.cloudName);

  static String get apiKey =>
      const String.fromEnvironment('CLOUDINARY_API_KEY',
          defaultValue: CloudinaryConfig.apiKey);

  static String get apiSecret =>
      const String.fromEnvironment('CLOUDINARY_API_SECRET',
          defaultValue: CloudinaryConfig.apiSecret);

  // static String get uploadPreset =>
  //     const String.fromEnvironment('CLOUDINARY_UPLOAD_PRESET',
  //         defaultValue: CloudinaryConfig.uploadPreset);
}