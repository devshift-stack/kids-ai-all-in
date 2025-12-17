#!/bin/bash

# Setup key.properties für alle Apps
# Dieses Skript hilft beim Erstellen der key.properties-Dateien

echo "=========================================="
echo "Key Properties Setup"
echo "=========================================="
echo ""
echo "Dieses Skript erstellt key.properties-Dateien für alle Apps"
echo ""

# Funktion zum Erstellen von key.properties
setup_key_properties() {
    local APP_NAME=$1
    local KEYSTORE_NAME=$2
    local ALIAS=$3
    
    local KEYSTORE_PATH="apps/$APP_NAME/android/app/$KEYSTORE_NAME"
    local PROPERTIES_PATH="apps/$APP_NAME/android/key.properties"
    
    # Prüfe ob KeyStore existiert
    if [ ! -f "$KEYSTORE_PATH" ]; then
        echo "⚠️  KeyStore nicht gefunden: $KEYSTORE_PATH"
        echo "   Bitte erstellen Sie zuerst den KeyStore mit create_keystores.sh"
        return 1
    fi
    
    echo ""
    echo "=========================================="
    echo "Setup für: $APP_NAME"
    echo "=========================================="
    echo ""
    
    # Prüfe ob key.properties bereits existiert
    if [ -f "$PROPERTIES_PATH" ]; then
        echo "⚠️  key.properties existiert bereits!"
        read -p "Möchten Sie sie überschreiben? (j/n): " OVERWRITE
        if [ "$OVERWRITE" != "j" ] && [ "$OVERWRITE" != "J" ] && [ "$OVERWRITE" != "y" ] && [ "$OVERWRITE" != "Y" ]; then
            echo "Überspringe $APP_NAME..."
            return 0
        fi
    fi
    
    echo "Bitte geben Sie Ihre KeyStore-Daten ein:"
    echo ""
    
    read -sp "KeyStore-Passwort: " STORE_PASSWORD
    echo ""
    read -sp "Key-Passwort (Enter für gleiches wie KeyStore): " KEY_PASSWORD
    echo ""
    
    # Wenn Key-Passwort leer, verwende KeyStore-Passwort
    if [ -z "$KEY_PASSWORD" ]; then
        KEY_PASSWORD="$STORE_PASSWORD"
    fi
    
    # Erstelle key.properties
    cat > "$PROPERTIES_PATH" << EOF
storePassword=$STORE_PASSWORD
keyPassword=$KEY_PASSWORD
keyAlias=$ALIAS
storeFile=app/$KEYSTORE_NAME
EOF
    
    # Setze sichere Berechtigungen
    chmod 600 "$PROPERTIES_PATH"
    
    echo ""
    echo "✅ key.properties erstellt für $APP_NAME"
    echo "   Pfad: $PROPERTIES_PATH"
    echo ""
}

# Prüfe ob alle KeyStores existieren
check_keystores() {
    local ALL_EXIST=true
    
    if [ ! -f "apps/alanko/android/app/alanko-release-key.jks" ]; then
        echo "❌ Alanko KeyStore nicht gefunden"
        ALL_EXIST=false
    fi
    
    if [ ! -f "apps/lianko/android/app/lianko-release-key.jks" ]; then
        echo "❌ Lianko KeyStore nicht gefunden"
        ALL_EXIST=false
    fi
    
    if [ ! -f "apps/parent/android/app/parent-release-key.jks" ]; then
        echo "❌ Parent KeyStore nicht gefunden"
        ALL_EXIST=false
    fi
    
    if [ "$ALL_EXIST" = false ]; then
        echo ""
        echo "Bitte erstellen Sie zuerst alle KeyStores mit:"
        echo "  ./create_keystores.sh"
        exit 1
    fi
}

# Prüfe KeyStores
check_keystores

echo "Alle KeyStores gefunden. Starte Setup..."
echo ""

# Setup für alle Apps
setup_key_properties "alanko" "alanko-release-key.jks" "alanko"
setup_key_properties "lianko" "lianko-release-key.jks" "lianko"
setup_key_properties "parent" "parent-release-key.jks" "parent"

echo ""
echo "=========================================="
echo "✅ Alle key.properties-Dateien erstellt!"
echo "=========================================="
echo ""
echo "Sie können jetzt die AAB-Dateien erstellen:"
echo ""
echo "  cd apps/alanko && flutter build appbundle --release"
echo "  cd apps/lianko && flutter build appbundle --release"
echo "  cd apps/parent && flutter build appbundle --release"
echo ""

