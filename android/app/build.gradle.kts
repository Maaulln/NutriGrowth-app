plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android plugin.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.nutrigrowth.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.nutrigrowth.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Sebelum submit ke Play Store: buat keystore & ganti ke signingConfig release.
            // Panduan: keytool -genkey -v -keystore nutrigrowth.jks -keyalg RSA -keysize 2048 -validity 10000 -alias nutrigrowth
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
