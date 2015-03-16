#!/bin/bash

# For ADD, This script checks 
# a) checks if there are files in /storage/.keys Else exit
# b) checks if the device is mounted, and waits for 10 secs, before timing out
# c) checks if there is a directory by name .ishamedia and files ".encpasswd" / ".encfs6.xml" within that folder
# d) checks if the media is already mounted. if yes, exit
# e) Decrypt the public key. For each of the keys, see if the encrypted password can be decrypted. If none, exit
# f) Mount the .ishamedia on IshaMedia

# For REMOVE,
# a) checks if the encfs is already mounted. if no, exit
# b) unmount the encfs

DEV=`basename $DEVNAME`

# check if the public keys are present
# returns 0 if keys are not found. 1 if found
public_keys_present () {
	if [ -d "/storage/.keys" ]; then
		if ls /storage/.keys/*.enc 1> /dev/null 2>&1; then
			return 1
		else
			return 0
		fi
	fi
	return 0
}

# b) checks if the device is mounted, and waits for 10 secs, before timing out
# returns 1 if mounted, 0 if not
device_mounted () {
	LINE=`mount | grep "^$DEVNAME"`
	! [ -z "$LINE" ] && return 1   # Already mounted
	#if ! [ -z "$LINE" ]; then return 1; fi   # Already mounted

	x=1
	while [ $x -le 10 ]
	do
		LINE=`mount | grep "^$DEVNAME"`
		! [ -z "$LINE" ] && return 1   # mounted
		# if ! [ -z "$LINE" ]; then return 1; fi   # mounted
		sleep 1
		x=$[$x +1]
	done

	# Not mounted
	return 0
}

# c) checks if there is a directory by name .ishamedia and files ".encpasswd" / ".encfs6.xml" within that folder
ishamedia_exists () {
	MOUNTPOINT=`mount | grep "^$DEVNAME"| awk '{print $3}'`

	if [ -d "$MOUNTPOINT/.ishamedia" ] && [ -f "$MOUNTPOINT/.ishamedia/.encfs6.xml" ] && [ -f "$MOUNTPOINT/.ishamedia/.encpasswd" ]; then return 1; fi
	return 0
}

# d) checks if the media is already mounted. if yes, exit
# returns 1 if mounted, 0 if not
ishamedia_mounted () {
	MOUNTPOINT=`mount | grep "^$DEVNAME"| awk '{print $3}'`
	LINE=`mount | grep "encfs on $MOUNTPOINT/IshaMedia type fuse"`
	#echo "check  $LINE"
	[ -z "$LINE" ] && return 0
	#echo "checked  $LINE"
	return 1

	if [ -z "$LINE" ]; then return 0; else return 1; fi
}

# e) Decrypt the public key. For each of the keys, see if the encrypted password can be decrypted. If none, exit
# returns passwd, else empty string
get_password () {

	MOUNTPOINT=`mount | grep "^$DEVNAME"| awk '{print $3}'`

	for encpub in "/storage/.keys/*.enc" ; do
		rm -f /tmp/n.pub
		openssl enc -aes-256-cbc -d -a -in $encpub -out "/tmp/n.pub" -k 2048 2>/dev/null
		if [ -s "/tmp/n.pub" ]; then
			break
		fi
		rm -f /tmp/n.pub
	done

	if ! [ -s "/tmp/n.pub" ]; then 
		rm -f /tmp/n.pub
		return 0
	fi

	PASSWD=`cat "$MOUNTPOINT/.ishamedia/.encpasswd" | openssl rsautl -verify -pubin -inkey /tmp/n.pub 2>/dev/null`
	echo $PASSWD
	return 1
}

# f) Mount the .ishamedia on IshaMedia
mount_ishamedia () {
	MOUNTPOINT=`mount | grep "^$DEVNAME"| awk '{print $3}'`

	echo $1 | encfs -S "$MOUNTPOINT/.ishamedia" "$MOUNTPOINT/IshaMedia"
}


# g) Unmount IshaMedia
unmount_ishamedia () {
	MOUNTPOINT=`mount | grep "^$DEVNAME"| awk '{print $3}'`

	if [ -z "$MOUNTPOINT" ]; then return 0; fi

	umount "$MOUNTPOINT/IshaMedia"
}

#### Main
if [ $ACTION = "ADD" ]; then

	echo "1"
	res=$(public_keys_present)
	if [ $? == "0" ] ; then exit; fi
	#if public_keys_present == 0 ; then exit; fi

	echo "2"
	res=$(device_mounted)
	if [ $? == "0" ] ; then exit; fi
	# if device_mounted ; then exit; fi

	echo "3"
	res=$(ishamedia_exists)
	if [ $? == "0" ] ; then exit; fi
	# if ishamedia_exists == 0 ; then exit; fi

	echo "4"
	res=$(ishamedia_mounted)
	if [ $? == "1" ] ; then exit; fi

	#if ishamedia_mounted ; then exit; fi
	#RET=$(ishamedia_mounted)
	#echo "--$RET--"
	#if ! [ -z "$RET" ] ; then exit; fi
	#echo "41"


	echo "5"
	PASSWD=$(get_password)

	echo "6 $PASSWD"
	if [ -z "$PASSWD" ]; then exit; fi

	echo "7"
	mount_ishamedia $PASSWD

	echo "8"
fi

if [ $ACTION = "REMOVE" ]; then
	res=$(ishamedia_mounted)
	if [ $? == "0" ] ; then exit; fi
	#if ishamedia_mounted == 0 ; then exit; fi

	unmount_ishamedia
fi
