# Encrypted Raspberry PI (openelec)

This note describes how to do the encrypted Raspberry Pi setup.

### What this accomplishes?

It provides the ability to mount encrypted videos on the Raspberry Pi (openelec), which can get decrypted and played automatically.

The software used:
   * openelec
   * encfs - encrypting file system
   * RSA Private/Public keys

## Software Setup

You can use `Linux` or `Windows` to do the software setup and perform the installation steps

### Linux

If you are going to use Linux to do the setup, then the following software is necessary

* openssl
* encfs

```
sudo apt-get install openssl encfs
```

### Windows

For Windows, you need the following Software.

* Download the [EncFS Windows](http://encfsmp.sourceforge.net/download.html)
* Download the [OpenSSL Windows](https://www.openssl.org/related/binaries.html) or you can simply download all of the GnuWin32 at this [url](http://gnuwin32.sourceforge.net/)
* Download the Ext2 Filesystem Mounter for Windows at this [url](http://sourceforge.net/projects/ext2fsd/)


## Installation 

The installation and setup is covered in the following steps:

1. Create RSA Keys 
  * This is typically a one-time activity. But needs to be done for every Pi, if you wish to use different RSA keys for different Pi.
2. Install software on Pi
  * Download the Openelec image and install on the MicroSD card
  * Copy the appropriate RSA Public keys on the MicroSD card
3. Create Encrypted Videos
  * Use appropriate RSA Private keys.
  * Create encrypted video files
  * Copy the encrypted video files to the Pendrive

### Create RSA Keys (Notes)

You create RSA keys, which is used for encrypting the password. When you create RSA keys - one public key and one private key is created. 
The private key is always kept with you (PCC - ashram), while the public key is copied to the Pi MicroSD card.

Please note that:
  * You copy the Public Key into the Pi MicroSD card
  * You encrypt the Video using the Private Key that you have (the Private Key never leaves your hand)

How many RSA keys should be created? That entirely depends on how you would like to use and setup the Pi environment.

* In a simple setup, you would just create one RSA key and use that key for all encryption. If this is so, any encrypted Video will work with any Pi.
* In an elaborate case, you could create
   * One RSA key for each RPi
   * One RSA key for all Uyir Nokkam Teachers
   * One RSA key for all Satsang Teachers
   * One RSA key for each Zone

How you model is completely upto you. You can copy multiple RSA public keys to each Pi. As long as you encrypt the Video with the corresponding private key, that 
exists in the Pi - the Video will play.

Given in an example, if you create four keys A,B,C,D and copy three (public) keys A,B,C to the Pi. If you encrypt the Video using the (private) key B - the video will 
play in the Pi. But if you encrypt with the key D, it won't play in the Pi - because the corresponding key is not there in the Pi.

### Create RSA Keys (HowTO)

Run the following command, from the command prompt. The command can be download at these URLs:  [linux script](create_keys.sh) and [windows batch](create_keys.bat)

In Linux:

```
sh create_keys.sh uyirnokkam
sh create_keys.sh teacher
sh create_keys.sh saidapet
```

In Windows:

```
create_keys.bat uyirnokkam
```


### Install Software on Pi

This only talks about fresh installation on Pi, which is done on directly copying files on the MicroSD card.

* Download the Latest OpenElec Image, created for Isha at this [url](not.yet.created)
* Follow the [steps](http://wiki.openelec.tv/index.php/HOW-TO:Installing_OpenELEC/Writing_The_Disk_Image#tab=Windows) to write the Image onto the MicroSD card. 
In the steps, do not download the Image from the OpenElec site (instead the Isha specific image is already obtained from the step above)

Once this is done, remove the MicroSD card and insert it again. Copy the Public Keys as follows.

* Open the Ext2 software installed (Windows). It should recognize the second partition on the MicroSD card
* Create a directory ".keys" in that Ext2 partition and Copy the relevant (desired) Public keys to that `.keys` folder.
* Please note that all Public Keys are with the extention `.enc`. In the example above, you would have got filename as `uyirnokkam.enc`
* Unmount the MicroSD card. It can now be inserted into the RPi


### Create Encrypted Videos







