@echo off
rem Create keys
if "%1"=="" (
	echo "usage: create_keys <name of the key>"
	GOTO:EOF
)

if exist "%1.pem" (
	echo "Key file created for %1 already"
	GOTO:EOF
)

openssl genrsa -out %1.pem 1024
openssl rsa -in %1.pem -pubout > %1.pub
openssl enc -aes-256-cbc -a -in %1.pub -out %1.enc -k 2048
