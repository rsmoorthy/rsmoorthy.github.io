# Create keys
if [ -z "$1" ]; then
	echo "usage: $0 <name of the key>"
	exit
fi

if [ -e "$1.pem" ]; then
	echo "Key file created for $1 already"
	exit
fi

openssl genrsa -out $1.pem 1024
openssl rsa -in $1.pem -pubout > $1.pub
openssl enc -aes-256-cbc -a -in $1.pub -out $1.enc -k 2048
openssl enc -aes-256-cbc -d -a -in $1.enc -out n.pub -k 2048
