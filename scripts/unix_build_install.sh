#!/usr/bin/env bash

# Check if all the needed tools are installed

which qmake6 &> /dev/null
if [[ "$?" != "0" ]]
then
	echo -e "\033[31mError:\033[0m QMake is not installed"
	exit 1
fi

which make &> /dev/null
if [[ "$?" != "0" ]]
then
	echo -e "\033[31mError:\033[0m Make is not installed"
	exit 1
fi

# Store the current path

current_path=$(pwd)

# Setup helper variables for the paths

project_root="$(dirname $(dirname $(realpath $0)))"
build_path="$project_root/build"
source_path="$project_root/scrumdown"
resources_path="$project_root/resources"
binaries_path="$HOME/.local/bin"
application_path="$HOME/.local/share/ScrumDown"
desktop_path="$HOME/.local/share/applications"

# Move into the root project directory

cd "$project_root"

# Create a build folder and step into

test -d "$build_path" && rm -rf "$build_path"

mkdir "$build_path" && cd "$build_path"

# Prepare the build files

echo -e "\033[94m-=>\033[0m \033[1mPreparing build files\033[0m"

DESKTOP_ENVIRONMENT="$1" qmake6 "$source_path" -config release

if [[ "$?" != "0" ]]
then
	echo -e "\033[31mError:\033[0m Failed to prepare build files"
	exit 1
fi

# Build the project

echo -e "\033[94m-=>\033[0m \033[1mBuilding project\033[0m"

make

if [[ "$?" != "0" ]]
then
	echo -e "\033[31mError:\033[0m Failed to build project"
	exit 1
fi

# Install the binary

echo -e "\033[94m-=>\033[0m \033[1mInstalling binary in: '$binaries_path'\033[0m"

mkdir -p "$binaries_path"

cp -fp "ScrumDown" "$binaries_path/scrumdown"

if [[ "$?" != "0" ]]
then
	echo -e "\033[31mError:\033[0m Failed to install binary"
	exit 1
fi

chmod +x "$binaries_path/scrumdown"

if [[ "$?" != "0" ]]
then
	echo -e "\033[31mError:\033[0m Failed to make the binary executable"
	"$binaries_path/scrumdown"
	exit 1
fi

# Install the resources

echo -e "\033[94m-=>\033[0m \033[1mInstalling resources in: '$application_path'\033[0m"

cd "$resources_path"

mkdir -p "$application_path"

cp -fp "ScrumDown.png" "$application_path/ScrumDown.png"

if [[ "$?" != "0" ]]
then
	echo -e "\033[31mError:\033[0m Failed to copy resources"
fi

# Install the menu entry

echo -e "\033[94m-=>\033[0m \033[1mInstalling menu entry in: '$desktop_path'\033[0m"

sed "s|Icon=|Icon=${HOME}|g" "ScrumDown.desktop" > "$desktop_path/ScrumDown.desktop"

if [[ "$?" != "0" ]]
then
	echo -e "\033[31mError:\033[0m Failed to create menu entry"
fi

# Installation finished

cd "$current_path"
