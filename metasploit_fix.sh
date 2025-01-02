#!/bin/bash

# ASCII Banner
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}"
cat << "EOF"

 _____ ______   _______  _________  ________  ________  ________  ___       ________  ___  _________        ________ ___     ___    ___         
|\   _ \  _   \|\  ___ \|\___   ___\\   __  \|\   ____\|\   __  \|\  \     |\   __  \|\  \|\___   ___\     |\  _____\\  \   |\  \  /  /|        
\ \  \\\__\ \  \ \   __/\|___ \  \_\ \  \|\  \ \  \___|\ \  \|\  \ \  \    \ \  \|\  \ \  \|___ \  \_|     \ \  \__/\ \  \  \ \  \/  / /        
 \ \  \\|__| \  \ \  \_|/__  \ \  \ \ \   __  \ \_____  \ \   ____\ \  \    \ \  \\\  \ \  \   \ \  \       \ \   __\\ \  \  \ \    / /         
  \ \  \    \ \  \ \  \_|\ \  \ \  \ \ \  \ \  \|____|\  \ \  \___|\ \  \____\ \  \\\  \ \  \   \ \  \       \ \  \_| \ \  \  /     \/          
   \ \__\    \ \__\ \_______\  \ \__\ \ \__\ \__\____\_\  \ \__\    \ \_______\ \_______\ \__\   \ \__\       \ \__\   \ \__\/  /\   \          
    \|__|     \|__|\|_______|   \|__|  \|__|\|__|\_________\|__|     \|_______|\|_______|\|__|    \|__|        \|__|    \|__/__/ /\ __\         
                                                \|_________|                                                                |__|/ \|__|         
                                                                                                                                                
                                                                                                                                                
        ________      ___    ___      ___  _________  ________                 ___  ___  ________  ___  _________  ___  ___  __    ________     
       |\   __  \    |\  \  /  /|    |\  \|\___   ___\\   ____\               |\  \|\  \|\   __  \|\  \|\___   ___\\  \|\  \|\  \ |\   __  \    
       \ \  \|\ /_   \ \  \/  / /    \ \  \|___ \  \_\ \  \___|_  ____________\ \  \\\  \ \  \|\  \ \  \|___ \  \_\ \  \ \  \/  /|\ \  \|\  \   
        \ \   __  \   \ \    / /      \ \  \   \ \  \ \ \_____  \|\____________\ \   __  \ \   _  _\ \  \   \ \  \ \ \  \ \   ___  \ \   __  \  
         \ \  \|\  \   \/  /  /        \ \  \   \ \  \ \|____|\  \|____________|\ \  \ \  \ \  \\  \\ \  \   \ \  \ \ \  \ \  \\ \  \ \  \ \  \ 
          \ \_______\__/  / /           \ \__\   \ \__\  ____\_\  \              \ \__\ \__\ \__\\ _\\ \__\   \ \__\ \ \__\ \__\\ \__\ \__\ \__\
           \|_______|\___/ /             \|__|    \|__| |\_________\              \|__|\|__|\|__|\|__|\|__|    \|__|  \|__|\|__| \|__|\|__|\|__|
                    \|___|/                             \|_________|                                                                            
                                                                                                                                                
                                                                                                                                                
EOF

echo -e "${NC}"
# Check if running with sudo privileges
if [ "$EUID" -ne 0 ]; then
    echo "This script needs to be run with sudo privileges."
    read -p "Do you want to escalate? (y/n): " choice
    if [ "$choice" == "y" ]; then
        sudo "$0" "$@"  # Execute this script with sudo
    else
        echo "Script execution aborted."
        exit 1
    fi
fi

echo "Running with sudo privileges!"

echo "Checking Dependencies..."

Checking_Dependencies()
	{
 		# Function to check if a command exists
			command_exists() {
    			command -v "$1" >/dev/null 2>&1
			}

		# Check for apktool
			if command_exists apktool; then
    			 echo "apktool is already installed."
			else
   			 echo "apktool is not installed. Installing..."
    			sudo apt update && sudo apt install apktool -y
			fi

		# Check for zipalign
			if command_exists zipalign; then
   			 echo "zipalign is already installed."
			else
   			 echo "zipalign is not installed. Installing..."
    			 sudo apt update && sudo apt install zipalign -y
			fi
 	}
echo "Fetching ZipAlign..."

fixing_zipalign() 
	{
    		sudo apt update && sudo apt install -y google-android-build-tools-35.0.0-installer
      		echo "ZipAlign Fixed Succesfully..."
	}

echo "Fetching ApkTool"

fixing_apktool() 
	{
 		cd /usr/bin
		
  		sudo rm apktool
    		
      		# Fetch the latest release from GitHub API
		LATEST_RELEASE_URL=$(curl -s https://api.github.com/repos/iBotPeaches/Apktool/releases/latest | jq -r .assets[0].browser_download_url)

		# Download the APKTool jar file
		wget $LATEST_RELEASE_URL -O apktool
		sudo chmod 755 apktool
  		echo "ApkTool Installed Succesfully...."
	}


echo "Done !"

# Function Calls
Checking_Dependencies
fixing_zipalign
fixing_apktool
