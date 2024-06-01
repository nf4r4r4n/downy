#!/bin/bash

# -------------------------------------------------------------------------------------------------------------
this_dir=$(dirname "$0")
source "${this_dir}/spinner.sh"
# -------------------------------------------------------------------------------------------------------------

print_banner ()
{
	echo -e "\e[1;32m
██████   ██████  ██     ██ ███    ██ ██    ██ 
██   ██ ██    ██ ██     ██ ████   ██  ██  ██  
██   ██ ██    ██ ██  █  ██ ██ ██  ██   ████   
██   ██ ██    ██ ██ ███ ██ ██  ██ ██    ██    
██████   ██████   ███ ███  ██   ████    ██  \e[0m
                                                                                      
\e[1;32mAuthor:\e[0m\tBaibs Fararano<baibs.fararano@gmail.com>
\e[1;32mGithub:\e[0m\tnf4r4r4n
\e[1;32mSpinner:\e[0m\tTasos Latsas"
}

check_pkg_status ()
{
	local pkg=$1
	local pkg_exits=$(which "$pkg")

	if [[ $pkg_exits = "" ]]; then
		echo -e "❌ - $pkg"
	elif [[ $pkg = "ffmpeg" && $pkg_exits != "" ]]; then
		echo -e "✅ - $pkg (Version: $("$pkg" -version))"
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

check_url ()
{
	local url=$1
	local status_code=$(curl --write-out '%{http_code}' --silent --output /dev/null "${media_url}")

	echo "Checking the URL..."
	# Check the URL if it's valid
	if [[ $status_code -ge 200 && $status_code -le 299 ]]; then
		echo -e "\e[1;32m[OK]\e[0m\tURL is valid"
	else
		echo -e "\e[1;31m[WARN]\e[0m\tURL is not valid"
		exit 1
	fi
}

print_format ()
{
	local number=$1
	local format=$2

	echo -e "\e[1;32m[$number]\e[0m - $format"
}

print_audio_format ()
{
	print_format "1" "mp3"
	print_format "2" "m4a"
	print_format "3" "ogg"
	print_format "4" "flac"
	print_format "5" "wav"
	print_format "6" "aac"
}

print_video_format ()
{
	print_format "1" "mp4"
	print_format "2" "webm"
	print_format "3" "avi"
	print_format "4" "mkv"
	print_format "5" "mov"
	print_format "6" "flv"
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

	echo -e "${green}Downy version:${nc}\t ${white}2024.05.12${nc}"
	echo -e "${green}Usage:${nc}\t ${white}downy${nc}"
}

upgrade_downy ()
{
	local this_dir=$(dirname "$0")

	start_spinner "\e[1;32mUpgrading downy\e[0m"
	git -C $this_dir pull origin main > /dev/null 2>&1
	stop_spinner 0
	print_version
}

# -------------------------------------------------------------------------------------------------------------
if [[ $1 = "--version" || $1 = "-V" ]]; then print_version; exit 0; fi
if [[ $1 = "--upgrade" || $1 = "-U" ]]; then upgrade_downy; exit 0; fi
clear
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
		# print_title "Choose the audio format"
		# print_audio_format
		# read -p ">> (default is 1) " audio_format
		# case "$audio_format" in
		# 	"1") audio_format="mp3";;
		# 	"2") audio_format="m4a";;
		# 	"3") audio_format="ogg";;
		# 	"4") audio_format="flac";;
		# 	"5") audio_format="wav";;
		# 	"6") audio_format="aac";;
		# 	*) audio_format="mp3";;
		# esac
		yt-dlp --extract-audio --audio-format "$audio_format" $media_url #> /dev/null 2>&1
		stop_spinner 0
	;;
	"2") # Video
		video_format="mp4"
		# print_title "Choose the video format"
		# print_video_format
		# read -p ">> (default is 1) " video_format
		# case "$video_format" in
		# 	"1") video_format="mp4";;
		# 	"2") video_format="webm";;
		# 	"3") video_format="avi";;
		# 	"4") video_format="mkv";;
		# 	"5") video_format="mov";;
		# 	"6") video_format="flv";;
		# 	*) video_format="mp4";;
		# esac
		yt-dlp --format "bestvideo[ext=$video_format]+bestaudio[ext=m4a]/best[ext=$video_format]/best" $media_url #> /dev/null 2>&1
	;;
	*) exit 0
	;;
esac

