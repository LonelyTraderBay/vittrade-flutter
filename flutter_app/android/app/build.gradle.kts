import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val releaseKeystorePropertiesFile = rootProject.file("key.properties")
val releaseKeystoreProperties = Properties()
if (releaseKeystorePropertiesFile.exists()) {
    releaseKeystorePropertiesFile.inputStream().use {
        releaseKeystoreProperties.load(it)
    }
}

fun releaseSigningValue(propertyName: String, environmentName: String): String? {
    return releaseKeystoreProperties.getProperty(propertyName)
        ?: System.getenv(environmentName)
}

val releaseStoreFile = releaseSigningValue("storeFile", "VITTRADE_KEYSTORE_PATH")
val releaseStorePassword = releaseSigningValue(
    "storePassword",
    "VITTRADE_KEYSTORE_PASSWORD",
)
val releaseKeyAlias = releaseSigningValue("keyAlias", "VITTRADE_KEY_ALIAS")
val releaseKeyPassword = releaseSigningValue("keyPassword", "VITTRADE_KEY_PASSWORD")
val hasReleaseSigning = listOf(
    releaseStoreFile,
    releaseStorePassword,
    releaseKeyAlias,
    releaseKeyPassword,
).all { !it.isNullOrBlank() }

android {
    namespace = "com.vittrade.vit_trade_flutter"
    // flutter_secure_storage 11 requires Android API 37 at compile time.
    // Keep min/target SDK controlled by the Flutter toolchain below.
    compileSdk = 37
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.vittrade.vit_trade_flutter"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // CI-D6 (DEC-ios: Android-only). Flavor chỉ đổi identity đóng gói
    // (applicationId suffix); cấu hình phía Dart vẫn đi qua --dart-define
    // (AppConfig.fromDartDefines đọc APP_ENV/API_BASE_URL/ENABLE_MOCK_DATA).
    // Lệnh build chuẩn:
    //   dev:     flutter build apk --flavor dev --debug
    //   staging: flutter build apk --flavor staging --dart-define=APP_ENV=staging
    //   prod:    flutter build appbundle --flavor prod --release \
    //              --dart-define=APP_ENV=production   (bắt buộc có release signing)
    flavorDimensions += "env"
    productFlavors {
        create("dev") {
            dimension = "env"
            applicationIdSuffix = ".dev"
        }
        create("staging") {
            dimension = "env"
            applicationIdSuffix = ".staging"
        }
        create("prod") {
            dimension = "env"
        }
    }

    signingConfigs {
        create("release") {
            if (hasReleaseSigning) {
                storeFile = file(releaseStoreFile!!)
                storePassword = releaseStorePassword
                keyAlias = releaseKeyAlias
                keyPassword = releaseKeyPassword
            }
        }
    }

    buildTypes {
        release {
            if (hasReleaseSigning) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }
}

flutter {
    source = "../.."
}

gradle.taskGraph.whenReady {
    val requestsReleaseArtifact = allTasks.any {
        it.name.contains("Release")
    }
    if (requestsReleaseArtifact && !hasReleaseSigning) {
        throw GradleException(
            "Release signing is required. Configure android/key.properties "
                + "with storeFile, storePassword, keyAlias, and keyPassword, "
                + "or set VITTRADE_KEYSTORE_PATH, VITTRADE_KEYSTORE_PASSWORD, "
                + "VITTRADE_KEY_ALIAS, and VITTRADE_KEY_PASSWORD.",
        )
    }
}
