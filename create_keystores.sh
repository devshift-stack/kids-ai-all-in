#!/bin/bash

# KeyStore Creation Script für Alanko, Lianko und ParentsDash
# Dieses Skript hilft Ihnen beim Erstellen der KeyStores für alle drei Apps

echo "=========================================="
echo "KeyStore Creation für Play Store"
echo "=========================================="
echo ""
echo "Dieses Skript erstellt KeyStores für:"
echo "  1. Alanko (com.alanko.ai)"
echo "  2. Lianko (com.lianko.ai)"
echo "  3. ParentsDash (com.kidsai.parent.kids_ai_parent)"
echo ""
echo "WICHTIG: Bewahren Sie die Passwörter sicher auf!"
echo ""

# Funktion zum Erstellen eines KeyStores
create_keystore() {
    local APP_NAME=$1
    local APP_ID=$2
    local KEYSTORE_NAME=$3
    local ALIAS=$4
    
    echo ""
    echo "=========================================="
    echo "Erstelle KeyStore für: $APP_NAME"
    echo "Application ID: $APP_ID"
    echo "=========================================="
    echo ""
    
    cd "apps/$APP_NAME/android/app" || exit 1
    
    echo "Sie werden jetzt nach folgenden Informationen gefragt:"
    echo "  1. KeyStore-Passwort (für die gesamte Datei)"
    echo "  2. Key-Passwort (für den einzelnen Schlüssel)"
    echo "  3. Name, Organisation, Standort, etc."
    echo ""
    echo "TIPP: Sie können das gleiche Passwort für KeyStore und Key verwenden"
    echo ""
    
    read -p "Drücken Sie Enter, um fortzufahren..."
    
    keytool -genkey -v \
        -keystore "$KEYSTORE_NAME" \
        -keyalg RSA \
        -keysize 2048 \
        -validity 10000 \
        -alias "$ALIAS"
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ KeyStore erfolgreich erstellt: $KEYSTORE_NAME"
        echo ""
        
        # Erstelle key.properties Template
        echo "Erstelle key.properties Template..."
        cd ../../.. || exit 1
        
        cat > "apps/$APP_NAME/android/key.properties.template" << EOF
# KeyStore Konfiguration für $APP_NAME
# Kopieren Sie diese Datei zu key.properties und füllen Sie die Passwörter aus
# WICHTIG: key.properties sollte NICHT in Git committed werden!

storePassword=IHHR_KEYSTORE_PASSWORT_HIER
keyPassword=IHHR_KEY_PASSWORT_HIER
keyAlias=$ALIAS
storeFile=app/$KEYSTORE_NAME
EOF
        
        echo "✅ Template erstellt: apps/$APP_NAME/android/key.properties.template"
        echo ""
        echo "Nächste Schritte:"
        echo "  1. Kopieren Sie key.properties.template zu key.properties"
        echo "  2. Ersetzen Sie IHHR_KEYSTORE_PASSWORT_HIER mit Ihrem KeyStore-Passwort"
        echo "  3. Ersetzen Sie IHHR_KEY_PASSWORT_HIER mit Ihrem Key-Passwort"
        echo ""
    else
        echo ""
        echo "❌ Fehler beim Erstellen des KeyStores!"
        exit 1
    fi
    
    cd ../../.. || exit 1
}

# Prüfe ob keytool verfügbar ist
if ! command -v keytool &> /dev/null; then
    echo "❌ Fehler: keytool wurde nicht gefunden!"
    echo "Bitte installieren Sie Java JDK (Version 17 oder höher)"
    exit 1
fi

echo "Java keytool gefunden: $(which keytool)"
echo ""

# Frage ob alle KeyStores erstellt werden sollen
read -p "Möchten Sie alle drei KeyStores jetzt erstellen? (j/n): " CREATE_ALL

if [ "$CREATE_ALL" != "j" ] && [ "$CREATE_ALL" != "J" ] && [ "$CREATE_ALL" != "y" ] && [ "$CREATE_ALL" != "Y" ]; then
    echo ""
    echo "Sie können die KeyStores auch einzeln erstellen:"
    echo ""
    echo "Alanko:"
    echo "  cd apps/alanko/android/app"
    echo "  keytool -genkey -v -keystore alanko-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias alanko"
    echo ""
    echo "Lianko:"
    echo "  cd apps/lianko/android/app"
    echo "  keytool -genkey -v -keystore lianko-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias lianko"
    echo ""
    echo "ParentsDash:"
    echo "  cd apps/parent/android/app"
    echo "  keytool -genkey -v -keystore parent-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias parent"
    echo ""
    exit 0
fi

# Erstelle alle drei KeyStores
create_keystore "alanko" "com.alanko.ai" "alanko-release-key.jks" "alanko"
create_keystore "lianko" "com.lianko.ai" "lianko-release-key.jks" "lianko"
create_keystore "parent" "com.kidsai.parent.kids_ai_parent" "parent-release-key.jks" "parent"

echo ""
echo "=========================================="
echo "✅ Alle KeyStores wurden erstellt!"
echo "=========================================="
echo ""
echo "Nächste Schritte:"
echo ""
echo "1. Für jede App:"
echo "   cd apps/[APP_NAME]/android"
echo "   cp key.properties.template key.properties"
echo ""
echo "2. Bearbeiten Sie key.properties und fügen Sie Ihre Passwörter ein"
echo ""
echo "3. Erstellen Sie die AAB-Dateien:"
echo "   cd apps/alanko && flutter build appbundle --release"
echo "   cd apps/lianko && flutter build appbundle --release"
echo "   cd apps/parent && flutter build appbundle --release"
echo ""
echo "Die AAB-Dateien finden Sie unter:"
echo "   apps/[APP_NAME]/build/app/outputs/bundle/release/app-release.aab"
echo ""

