SHELL=D:/dev/msys64/usr/bin/bash.exe

watch:
	gulp watch&
	@pid=$!
	cd semantic && gulp watch
	kill $pid

dev:
	hugo serve -w --bind="0.0.0.0" --appendPort=true -b http://192.168.0.2

build:
	hugo

deploy:build
	cp -r public/* .deploy
	cd .deploy
	git add -A
	git commit -m "Site updated at $$(date)"
	git push origin master
