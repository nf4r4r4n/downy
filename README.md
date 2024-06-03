# Downy
Downy is a simple script that aims to simplify downloading audio or video by using **yt-dlp** package.
This tools is easy to use.

## Some requirements
- python3
- pip3
- yt-dlp
- ffmpeg

## Install Downy
### Source
- clone this repo
```sh
git clone https://github.com/nf4r4r4n/downy
```
- put an alias for the downy script in your **~/.zshrc** or **~/.bashrc** file:
```sh
alias downy="path/to/downy/repo/downy.sh"
```
### Release
- Download the released package

Then you can use **downy**

## Usage
- get version:
```sh
downy --version
#or
downy -V
```
- upgrade:
```sh
downy --upgrade
# or
downy -U
```
- or simply use it for download:
```sh
downy
```
