#!/bin/bash

# Configure App Drawer folders for organized application layout

echo "Configuring App Drawer folders..."

# Define folder children
gsettings set org.gnome.desktop.app-folders folder-children "['Install-Update', 'LibreOffice', 'Utilities', 'Xtra', 'Web-Apps']"

# Install & Update folder
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Install-Update/ name 'Install & Update'
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Install-Update/ apps "['software-properties-drivers.desktop', 'org.gnome.Software.desktop', 'snap-store_snap-store.desktop', 'firmware-updater_firmware-updater.desktop', 'software-properties-gtk.desktop', 'update-manager.desktop']"

# LibreOffice folder
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/LibreOffice/ name 'LibreOffice'
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/LibreOffice/ apps "['libreoffice-startcenter.desktop', 'libreoffice-base.desktop', 'libreoffice-calc.desktop', 'libreoffice-draw.desktop', 'libreoffice-impress.desktop', 'libreoffice-math.desktop', 'libreoffice-writer.desktop']"

# Utilities folder
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utilities/ name 'Utilities'
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utilities/ apps "['org.gnome.Papers.desktop', 'org.gnome.font-viewer.desktop', 'org.gnome.Loupe.desktop']"

# Xtra folder (system utilities)
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Xtra/ name 'Xtra'
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Xtra/ apps "['org.gnome.Yelp.desktop', 'gnome-language-selector.desktop', 'org.gnome.Logs.desktop', 'org.gnome.PowerStats.desktop', 'org.gnome.Sysprof.desktop']"

# Web Apps folder
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Web-Apps/ name 'Web Apps'
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Web-Apps/ apps "['webapp-WhatsApp.desktop', 'whatsapp-linux-desktop_whatsapp-linux-desktop.desktop']"

echo "✓ App Drawer folders configured"
