#!/bin/bash

# Kolory do formatowania output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo "🚀 Rozpoczynam tworzenie projektu ChatSPA..."

# Tworzenie struktury katalogów
create_directory_structure() {
    mkdir -p ChatSPA/app/src/{androidTest,main,test}/java/com/example/chatspa
    mkdir -p ChatSPA/app/src/main/res/{drawable,mipmap,values}
    mkdir -p ChatSPA/app/src/main/java/com/example/chatspa/theme

    echo -e "${GREEN}✓ Utworzono strukturę katalogów${NC}"
}

# Tworzenie plików projektu
create_project_files() {
# Root build.gradle.kts
cat << 'END_BUILD' > ChatSPA/build.gradle.kts
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.1.0")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.0")
    }
}

tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}
END_BUILD

# App build.gradle.kts
cat << 'END_APP_BUILD' > ChatSPA/app/build.gradle.kts
plugins {
    id("com.android.application")
    id("kotlin-android")
}

android {
    namespace = "com.example.chatspa"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.chatspa"
        minSdk = 24
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        vectorDrawables {
            useSupportLibrary = true
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }
    buildFeatures {
        compose = true
    }
    composeOptions {
        kotlinCompilerExtensionVersion = "1.5.1"
    }
    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
}

dependencies {
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.7.0")
    implementation("androidx.activity:activity-compose:1.8.2")
    implementation("androidx.compose.ui:ui:1.6.0")
    implementation("androidx.compose.ui:ui-graphics:1.6.0")
    implementation("androidx.compose.ui:ui-tooling-preview:1.6.0")
    implementation("androidx.compose.material3:material3:1.2.0")
    implementation("androidx.compose.runtime:runtime-livedata:1.6.0")

    testImplementation("junit:junit:4.13.2")
    androidTestImplementation("androidx.test.ext:junit:1.1.5")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.5.1")
    androidTestImplementation("androidx.compose.ui:ui-test-junit4:1.6.0")
    debugImplementation("androidx.compose.ui:ui-tooling:1.6.0")
}
END_APP_BUILD

# settings.gradle.kts
cat << 'END_SETTINGS' > ChatSPA/settings.gradle.kts
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "ChatSPA"
include(":app")
END_SETTINGS

# AndroidManifest.xml
cat << 'END_MANIFEST' > ChatSPA/app/src/main/AndroidManifest.xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.INTERNET" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher"
        android:supportsRtl="true"
        android:theme="@style/Theme.ChatSPA">
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:theme="@style/Theme.ChatSPA">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
END_MANIFEST

    echo -e "${GREEN}✓ Utworzono pliki konfiguracyjne${NC}"
}

# Tworzenie plików źródłowych
create_source_files() {
# MainActivity.kt
cat << 'END_MAIN_ACTIVITY' > ChatSPA/app/src/main/java/com/example/chatspa/MainActivity.kt
import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import android.speech.tts.TextToSpeech
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import java.util.*

class MainActivity : ComponentActivity(), TextToSpeech.OnInitListener {
    private lateinit var textToSpeech: TextToSpeech
    private lateinit var speechRecognizer: SpeechRecognizer

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        textToSpeech = TextToSpeech(this, this)
        speechRecognizer = SpeechRecognizer.createSpeechRecognizer(this)

        requestPermissions()

        setContent {
            ChatApp()
        }
    }

    private fun requestPermissions() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO)
            != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this,
                arrayOf(Manifest.permission.RECORD_AUDIO),
                PERMISSION_REQUEST_CODE)
        }
    }

    override fun onInit(status: Int) {
        if (status == TextToSpeech.SUCCESS) {
            textToSpeech.language = Locale.getDefault()
        }
    }

    companion object {
        private const val PERMISSION_REQUEST_CODE = 1
    }
}
END_MAIN_ACTIVITY

# ChatApp.kt
cat << 'END_CHAT_APP' > ChatSPA/app/src/main/java/com/example/chatspa/ChatApp.kt
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@Composable
fun ChatApp() {
    var messages by remember { mutableStateOf(listOf<ChatMessage>()) }
    var currentInput by remember { mutableStateOf("") }
    var expandedImageUrl by remember { mutableStateOf<String?>(null) }

    MaterialTheme {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp)
        ) {
            CategorySection(
                categories = listOf("General", "Support", "FAQ", "Products"),
                onCategorySelected = { category ->
                    messages = messages + ChatMessage(
                        text = "Selected category: $category",
                        type = MessageType.SYSTEM
                    )
                }
            )

            ChatMessages(
                messages = messages,
                expandedImageUrl = expandedImageUrl,
                onImageClick = { url ->
                    expandedImageUrl = if (expandedImageUrl == url) null else url
                }
            )

            ChatInput(
                value = currentInput,
                onValueChange = { currentInput = it },
                onSend = {
                    if (currentInput.isNotEmpty()) {
                        messages = messages + ChatMessage(
                            text = currentInput,
                            type = MessageType.USER
                        )
                        currentInput = ""
                    }
                },
                onVoiceInput = {
                    // Implement voice input logic
                }
            )
        }
    }
}
END_CHAT_APP

# Components.kt
cat << 'END_COMPONENTS' > ChatSPA/app/src/main/java/com/example/chatspa/Components.kt
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@Composable
fun CategorySection(
    categories: List<String>,
    onCategorySelected: (String) -> Unit
) {
    LazyRow(
        horizontalArrangement = Arrangement.spacedBy(8.dp),
        contentPadding = PaddingValues(vertical = 8.dp)
    ) {
        items(categories) { category ->
            Button(onClick = { onCategorySelected(category) }) {
                Text(category)
            }
        }
    }
}

@Composable
fun ChatMessages(
    messages: List<ChatMessage>,
    expandedImageUrl: String?,
    onImageClick: (String) -> Unit
) {
    LazyColumn(
        modifier = Modifier.weight(1f),
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        items(messages) { message ->
            ChatMessageItem(
                message = message,
                isExpanded = message.imageUrl == expandedImageUrl,
                onImageClick = onImageClick
            )
        }
    }
}

@Composable
fun ChatInput(
    value: String,
    onValueChange: (String) -> Unit,
    onSend: () -> Unit,
    onVoiceInput: () -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 8.dp),
        horizontalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        TextField(
            value = value,
            onValueChange = onValueChange,
            modifier = Modifier.weight(1f)
        )

        IconButton(onClick = onSend) {
            Icon(Icons.Default.Send, contentDescription = "Send")
        }

        IconButton(onClick = onVoiceInput) {
            Icon(Icons.Default.Mic, contentDescription = "Voice Input")
        }
    }
}
END_COMPONENTS

# Models.kt
cat << 'END_MODELS' > ChatSPA/app/src/main/java/com/example/chatspa/Models.kt
data class ChatMessage(
    val text: String,
    val type: MessageType,
    val imageUrl: String? = null,
    val timestamp: Long = System.currentTimeMillis()
)

enum class MessageType {
    USER,
    SYSTEM,
    BOT
}
END_MODELS

# VoiceManager.kt
cat << 'END_VOICE_MANAGER' > ChatSPA/app/src/main/java/com/example/chatspa/VoiceManager.kt
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import android.speech.tts.TextToSpeech
import java.util.*

class VoiceManager(
    private val context: Context,
    private val textToSpeech: TextToSpeech,
    private val speechRecognizer: SpeechRecognizer
) {
    fun speak(text: String) {
        textToSpeech.speak(text, TextToSpeech.QUEUE_FLUSH, null, null)
    }

    fun startListening(onResult: (String) -> Unit) {
        val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
                    putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL,
                            RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
                    putExtra(RecognizerIntent.EXTRA_LANGUAGE, Locale.getDefault())
                }

                speechRecognizer.setRecognitionListener(object : RecognitionListener {
                    override fun onResults(results: Bundle?) {
                        val matches = results?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
                        if (!matches.isNullOrEmpty()) {
                            onResult(matches[0])
                        }
                    }

                    override fun onReadyForSpeech(params: Bundle?) {}
                    override fun onBeginningOfSpeech() {}
                    override fun onRmsChanged(rmsdB: Float) {}
                    override fun onBufferReceived(buffer: ByteArray?) {}
                    override fun onEndOfSpeech() {}
                    override fun onError(error: Int) {}
                    override fun onPartialResults(partialResults: Bundle?) {}
                    override fun onEvent(eventType: Int, params: Bundle?) {}
                })

                speechRecognizer.startListening(intent)
            }

            fun stopListening() {
                speechRecognizer.stopListening()
            }
        }
END_VOICE_MANAGER

# Tworzenie plików zasobów
# values/strings.xml
cat << 'END_STRINGS' > ChatSPA/app/src/main/res/values/strings.xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">ChatSPA</string>
    <string name="send_message">Send</string>
    <string name="voice_input">Voice Input</string>
    <string name="message_hint">Type a message...</string>
</resources>
END_STRINGS

# values/colors.xml
cat << 'END_COLORS' > ChatSPA/app/src/main/res/values/colors.xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="purple_200">#FFBB86FC</color>
    <color name="purple_500">#FF6200EE</color>
    <color name="purple_700">#FF3700B3</color>
    <color name="teal_200">#FF03DAC5</color>
    <color name="teal_700">#FF018786</color>
    <color name="black">#FF000000</color>
    <color name="white">#FFFFFFFF</color>
</resources>
END_COLORS

# values/themes.xml
cat << 'END_THEMES' > ChatSPA/app/src/main/res/values/themes.xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="Theme.ChatSPA" parent="android:Theme.Material.Light.NoActionBar" />
</resources>
END_THEMES

# theme/Color.kt
cat << 'END_COLOR_KT' > ChatSPA/app/src/main/java/com/example/chatspa/theme/Color.kt
package com.example.chatspa.theme

import androidx.compose.ui.graphics.Color

val Purple80 = Color(0xFFD0BCFF)
val PurpleGrey80 = Color(0xFFCCC2DC)
val Pink80 = Color(0xFFEFB8C8)

val Purple40 = Color(0xFF6650a4)
val PurpleGrey40 = Color(0xFF625b71)
val Pink40 = Color(0xFF7D5260)
END_COLOR_KT

# theme/Theme.kt
cat << 'END_THEME_KT' > ChatSPA/app/src/main/java/com/example/chatspa/theme/Theme.kt
package com.example.chatspa.theme

import android.app.Activity
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.platform.LocalView
import androidx.core.view.WindowCompat

private val DarkColorScheme = darkColorScheme(
    primary = Purple80,
    secondary = PurpleGrey80,
    tertiary = Pink80
)

private val LightColorScheme = lightColorScheme(
    primary = Purple40,
    secondary = PurpleGrey40,
    tertiary = Pink40
)

@Composable
fun ChatSPATheme(
    darkTheme: Boolean = false,
    content: @Composable () -> Unit
) {
    val colorScheme = when {
        darkTheme -> DarkColorScheme
        else -> LightColorScheme
    }
    val view = LocalView.current
    if (!view.isInEditMode) {
        SideEffect {
            val window = (view.context as Activity).window
            window.statusBarColor = colorScheme.primary.toArgb()
            WindowCompat.getInsetsController(window, view).isAppearanceLightStatusBars = darkTheme
        }
    }

    MaterialTheme(
        colorScheme = colorScheme,
        typography = Typography,
        content = content
    )
}
END_THEME_KT

# theme/Type.kt
cat << 'END_TYPE_KT' > ChatSPA/app/src/main/java/com/example/chatspa/theme/Type.kt
package com.example.chatspa.theme

import androidx.compose.material3.Typography
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.sp

val Typography = Typography(
    bodyLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Normal,
        fontSize = 16.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.5.sp
    )
)
END_TYPE_KT

    echo -e "${GREEN}✓ Utworzono pliki źródłowe${NC}"
}

# Uruchomienie wszystkich funkcji
main() {
    create_directory_structure
    create_project_files
    create_source_files

    echo -e "\n${GREEN}✅ Projekt został utworzony pomyślnie!${NC}"
    echo "
Aby uruchomić projekt:
1. Otwórz Android Studio
2. Wybierz 'Open an existing Project'
3. Wskaż lokalizację folderu ChatSPA
4. Poczekaj na zakończenie synchronizacji Gradle
5. Uruchom aplikację używając przycisku 'Run' (zielona strzałka)
"
}

# Uruchomienie skryptu
main

EOF

chmod +x gen.sh

echo "
Skrypt instalacyjny został utworzony. Aby utworzyć projekt:

1. Otwórz terminal
2. Przejdź do katalogu, gdzie chcesz utworzyć projekt
3. Uruchom skrypt komendą:
   ./setup_project.sh
"
