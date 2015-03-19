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

* Download the Latest OpenElec Image, created for Isha at this [http://ojai.rsmoorthy.net/pi/](http://ojai.rsmoorthy.net/pi/)
* Follow the [steps](http://wiki.openelec.tv/index.php/HOW-TO:Installing_OpenELEC/Writing_The_Disk_Image#tab=Windows) to write the Image onto the MicroSD card. 
In the steps, do not download the Image from the OpenElec site (instead the Isha specific image is already obtained from the step above)

Once this is done, remove the MicroSD card and insert it again. Copy the Public Keys as follows.

* Open the Ext2 software installed (Windows). It should recognize the second partition on the MicroSD card
* Create a directory ".keys" in that Ext2 partition and Copy the relevant (desired) Public keys to that `.keys` folder.
* Please note that all Public Keys are with the extention `.enc`. In the example above, you would have got filename as `uyirnokkam.enc`
* Unmount the MicroSD card. It can now be inserted into the RPi

For the sake of simplicity, few standard keys are already created and copied on the MicroSD card. 


### Create Encrypted Videos

To create the encrypted videos, you need the following:

   * A Pendrive
   * A Private key that should be used for encrypting the Videos
   * A random password (for now manually specified for encryption)

This is accomplished in the two steps.

#### Step 1 - Using Windows

* In your PC, Launch EncFSMP software installed
* Click on 'Create New EncFS' button to create a new enc fs volume
* Specify a Mount name (any name for your own recognition), Specify the EncFS Path (this is where the Encrypted files will be present), 
  Specify any random password (but please do remember this). Let us say the EncFS Path is c:\encfolder
* Mount the volume that you just created
* Once you create the new EncFS volume, you will have the following:
    1. Encrypted Files will be stored in the EncFS path that you specified above
	2. A Drive letter which will contain the unencrypted files

* Once you have the setup, place all your Video files in the Drive created by EncFSMP. You will notice that EncFS path is now having several files (one file matching for each Video or any other file that you copied)
* After completion, Unmount the Drive.
* Now the EncFS path (c:\encfolder) that you chose is ready to be copied to the Pendrive

#### Step 1 - Using Linux

* Ensure that ubuntu or the Pi has "encfs" software installed
* Create two directories as follows:

```
mkdir /tmp/enc
mkdir /tmp/data
```

* Mount the files as follows: (which will ask you few questions. Password is the important thing, remember this password. Rest you can specify the defaults)

```
sudo encfs /tmp/enc /tmp/data
```

* Now copy all the Video files to /tmp/data directory.
* Once you are done, unmount as follows:

```
sudo umount /tmp/data
```

* Now `/tmp/enc` is the folder ready to be copied to the Pendrive


#### Step 2 - Creating .encpasswd file

You can accomplish this in Windows or Linux or the Pi. Execute the following command:

```
echo <passwd> | openssl rsautl -sign -inkey <privatekey.pem> > .encpasswd
```

As an example, if the password is `1234`, and the private key used is `uyirnokkam.pem` file that you created above, it will be like:

```
echo "1234" | openssl rsautl -sign -inkey uyirnokkam.pem > .encpasswd
```

* Copy the .encpasswd file to the EncFS path (c:\encfolder) that you created above.
* In that path, you should also see a file by name `.encfs6.xml`


#### Step 3 - Copy to Pendrive


* In the root folder of Pendrive, create a folder by named `.ishamedia`
* Copy all the files in the Enc FS path (c:\encfolder) to this folder `.ishamedia`
* That's it done


#### Checking in Pi

* When you insert the Pendrive in Pi, the decrypted normal files are available in the Path `/storage/IshaMedia`
* In Pi, within Xbmc, please look for this path to locate your videos. In Videos menu, there is an entry `IshaMedia` available, which is actually pointing to this folder.
* You can play the videos from this location
