$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
Push-Location -LiteralPath $projectRoot
try {
    # A split build avoids nesting the Flutter compiler under a reused Gradle daemon.
    & flutter pub get
    if ($LASTEXITCODE -ne 0) { throw 'Dependency resolution failed.' }
    & flutter --no-version-check -v assemble --output=build/app/intermediates/flutter/debug '-dTargetFile=lib/main.dart' '-dTargetPlatform=android' '-dBuildMode=debug' '-dTrackWidgetCreation=true' debug_android_application
    if ($LASTEXITCODE -ne 0) { throw 'Flutter asset compilation failed; packaging was not run.' }
    & ./android/gradlew.bat --no-daemon --max-workers=2 -p android '-Ptarget-platform=android-arm,android-arm64,android-x64' '-Ptarget=lib/main.dart' '-Pbase-application-name=android.app.Application' '-Pdart-obfuscation=false' '-Ptrack-widget-creation=true' '-Ptree-shake-icons=false' assembleDebug -x :app:compileFlutterBuildDebug
    if ($LASTEXITCODE -ne 0) { throw 'Android packaging failed.' }
    Write-Output 'Built Android debug APK from the freshly compiled Flutter assets.'
} finally {
    Pop-Location
}
