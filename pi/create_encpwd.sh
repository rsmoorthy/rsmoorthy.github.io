# Create enc passwd
if [ -z "$1" ] || [ -z "$2" ] ; then
	echo "usage: $0 <name of the key> <passwd>"
	exit
fi

echo $2 | openssl rsautl -sign -inkey $1.pem > .encpasswd
