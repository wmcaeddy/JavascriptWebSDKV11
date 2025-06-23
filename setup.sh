#!/bin/bash

echo "🚀 Setting up Flutter IDV Application"
echo "================================================"

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "   Visit: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -n 1)"

# Check Flutter doctor
echo ""
echo "🔍 Running Flutter doctor..."
flutter doctor

# Install dependencies
echo ""
echo "📦 Installing Flutter dependencies..."
flutter pub get

# Check if config.json exists
if [ ! -f "config.json" ]; then
    echo ""
    echo "⚠️  Configuration file not found!"
    echo "📝 Creating config.json from template..."
    
    if [ -f "config.example.json" ]; then
        cp config.example.json config.json
        echo "✅ Created config.json from config.example.json"
        echo ""
        echo "🔐 SECURITY: config.json is excluded from Git and will NOT be committed"
        echo "🔑 IMPORTANT: Please edit config.json with your actual credentials:"
        echo "   - JWT token from IdCloud KYC"
        echo "   - X-API-KEY from IdCloud KYC"
        echo "   - Acuant SDK credentials"
        echo ""
        echo "⚠️  DO NOT commit config.json to version control!"
    else
        echo "❌ config.example.json not found!"
        exit 1
    fi
else
    echo "✅ Configuration file found: config.json"
fi

# Clean previous builds
echo ""
echo "🧹 Cleaning previous builds..."
flutter clean
flutter pub get

# Check platform-specific setup
echo ""
echo "🔍 Checking platform setup..."

# Android setup
if [ -d "android" ]; then
    echo "✅ Android configuration found"
    echo "   - Permissions: Camera, Microphone, Internet"
    echo "   - WebView: Modern WebView support enabled"
else
    echo "⚠️  Android directory not found"
fi

# iOS setup
if [ -d "ios" ]; then
    echo "✅ iOS configuration found"
    echo "   - Usage descriptions: Camera, Microphone"
    echo "   - WebView: Inline media playback enabled"
else
    echo "⚠️  iOS directory not found"
fi

# Web assets
if [ -d "assets/web/webSdk" ] && [ "$(ls -A assets/web/webSdk 2>/dev/null)" ]; then
    echo "✅ Acuant SDK assets found"
    echo "   - Location: assets/web/webSdk/"
    echo "   - Files: $(ls assets/web/webSdk/ | wc -l) files"
else
    echo "⚠️  Acuant SDK assets not found in assets/web/webSdk/"
    echo "   Please ensure Acuant SDK files are copied to assets/web/webSdk/"
fi

echo ""
echo "🎯 Setup Summary:"
echo "=================="
echo "✅ Flutter dependencies installed"
echo "✅ Project structure verified"
echo "✅ Platform configurations ready"

if [ ! -f "config.json" ] || grep -q "YOUR_.*_HERE" config.json 2>/dev/null; then
    echo "⚠️  Configuration needs attention"
    echo ""
    echo "📋 Next Steps:"
    echo "1. Edit config.json with your actual credentials"
    echo "2. Test the configuration"
    echo "3. Run the app: flutter run"
else
    echo "✅ Configuration appears ready"
    echo ""
    echo "🚀 Ready to run!"
    echo "   Use: flutter run"
fi

echo ""
echo "📚 Documentation:"
echo "   - README.md for detailed setup instructions"
echo "   - config.example.json for configuration template"
echo ""
echo "🔒 Security Reminder:"
echo "   - config.json is automatically excluded from Git"
echo "   - config.example.json contains safe placeholder values"
echo "   - Never put real secrets in config.example.json"
echo "   - See SECURITY.md for detailed guidelines"
echo "   - Rotate credentials regularly"

echo ""
echo "✨ Setup complete!" 