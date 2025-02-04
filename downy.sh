#!/bin/bash

# -------------------------------------------------------------------------------------------------------------
this_dir=$(dirname "$0")
version="4th Feb 2025"
# -------------------------------------------------------------------------------------------------------------

print_banner ()
{
	echo -e "                                                                                     
\e[1;32mAuthor:\e[0m\tBaibs Fararano<baibs.fararano@gmail.com>
\e[1;32mGithub:\e[0m\tnf4r4r4n"
}

check_pkg_status ()
{
	local pkg=$1
	local pkg_exits=$(which "$pkg")

	if [[ $pkg_exits = "" ]]; then
		echo -e "❌ - $pkg"
	elif [[ $pkg = "ffmpeg" && $pkg_exits != "" ]]; then
		echo -e "✅ - $pkg (Version: $("$pkg" -version | grep ffmpeg | awk '{printf $3}'))"
	else 
		echo -e "✅ - $pkg (Version: $("$pkg" --version))"
	fi
}

check_pkg ()
{
	local pkg=$1
	local pkg_exits=$(which "$pkg")

	if [[ $pkg_exits = "" ]]; then echo 1; else echo 0; fi
}

go_on ()
{
	local url=$1
	local name=$2
	echo -e "Go on:\t\e[1;31m$url\e[0m for $name installation guide"
}

check_requirements ()
{
	local is_okay=0
	local python_pkg="python3"
	local python_install_url="https://www.python.org/downloads"
	local pip_pkg="pip3"
	local pip_install_url="https://pypi.org/project/pip"
	local ytdtlp_pkg="yt-dlp"
	local ytdlp_install_url="https://github.com/yt-dlp/yt-dlp/wiki/Installation"
	local ffmpeg_pkg="ffmpeg"

	print_title "Checking requirements"
	check_pkg_status $python_pkg
	check_pkg_status $pip_pkg
	check_pkg_status $ytdtlp_pkg
	check_pkg_status $ffmpeg_pkg
	if [[ $(check_pkg "$python_pkg") != "0" ]]; then 
		go_on $python_install_url $python_pkg
		is_okay=1
	fi
	if [[ $(check_pkg "$pip_pkg") != "0" ]]; then
		go_on $pip_install_url $pip_pkg
		is_okay=1
	fi
	if [[ $(check_pkg "$ytdtlp_pkg") != "0" ]]; then
		go_on $ytdlp_install_url $ytdtlp_pkg
		is_okay=1
	fi
	if [[ $(check_pkg "$ffmpeg_pkg") != "0" ]]; then
		is_okay=1
	fi
	if [[ $is_okay -ne 0 ]]; then
		echo -e "\n\e[1;31mRequirement is not filled\e[0m"
		exit 1
	fi
}

print_format ()
{
	local number=$1
	local format=$2

	echo -e "\e[1;32m[$number]\e[0m - $format"
}

print_title ()
{
	local msg=$1

	echo -e "\n\e[1;97m>>> $msg <<<\e[0m"
}

print_version ()
{
	local green="\e[1;32m"
	local white="\e[1;97m"
	local nc="\e[0m"

	echo -e "${green}Downy version:${nc}\t ${white}${version}${nc}"
	echo -e "${green}Usage:${nc}\t ${white}downy${nc}"
}

upgrade_downy ()
{
	local this_dir=$(dirname "$0")

	echo "Upgrading..."
	git -C $this_dir pull origin main > /dev/null 2>&1
	print_version
}

# -------------------------------------------------------------------------------------------------------------
if [[ $1 = "--version" || $1 = "-V" ]]; then print_version; exit 0; fi
if [[ $1 = "--upgrade" || $1 = "-U" ]]; then upgrade_downy; exit 0; fi

print_banner
# -------------------------------------------------------------------------------------------------------------

# Check if the system has all required packages
check_requirements

# -------------------------------------------------------------------------------------------------------------
print_title "These are the possible choice"
print_format "1" "Audio"
print_format "2" "Video"
echo
read -p ">> (default is 1) " media
if [[ $media != "1" && $media != "2" ]]; then media="1"; fi
if [[ $media = "1" ]]; then echo -e "\e[1;32mMedia:\e[0m\tAudio"; else echo -e "\e[1;32mMedia:\e[0m\tVideo"; fi

# -------------------------------------------------------------------------------------------------------------
print_title "Media URL"
read -p ">> " media_url
# check_url $media_url

# -------------------------------------------------------------------------------------------------------------
case "$media" in
	"1") # Audio
		audio_format="mp3"
		yt-dlp --extract-audio --audio-format "$audio_format" $media_url #> /dev/null 2>&1
	;;
	"2") # Video
		video_format="mp4"
		yt-dlp --format "bestvideo[ext=$video_format]+bestaudio[ext=m4a]/best[ext=$video_format]/best" $media_url #> /dev/null 2>&1
	;;
	*) exit 0
	;;
esac

