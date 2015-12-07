SHELL=D:/dev/msys64/usr/bin/bash.exe

watch:
	gulp watch&
	@pid=$!
	cd semantic && gulp watch
	kill $pid

dev:
	hugo serve -w --bind="0.0.0.0" --appendPort=true -b http://192.168.0.2
