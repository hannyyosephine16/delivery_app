plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.delivery_app"
    compileSdk = flutter.compileSdkVersion;
//    ndkVersion = flutter.ndkVersion
//    ndkVersion = "27.0.12077973"
    ndkVersion = "25.1.8937393";
    compileSdk = 35;
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8;
        targetCompatibility = JavaVersion.VERSION_1_8;
        coreLibraryDesugaringEnabled true;
    }

    kotlinOptions {
//        jvmTarget = JavaVersion.VERSION_1_8;
        jvmTarget = "1.8"
    }

    sourceSets {
//        main.java.srcDirs += 'src/main/kotlin';
        getByName("main").java.srcDirs("src/main/kotlin")
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.delivery_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
//        minSdk = 21  // Required for some plugins
//        minSdk = flutter.minSdkVersion
//        targetSdk = flutter.targetSdkVersion
//        versionCode = flutter.versionCode
//        versionName = flutter.versionName

        // Enable multidex for large apps
//        multiDexEnabled = true
        minSdk = 21
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"
        multiDexEnabled = true
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }

    packagingOptions {
        pickFirst("**/libc++_shared.so")
        pickFirst("**/libjsc.so")
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Core library desugaring
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")

    // MultiDex support
    implementation("androidx.multidex:multidex:2.0.1")
}