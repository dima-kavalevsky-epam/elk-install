# Installing Logstash

Logstash requires Java 8 or Java 11. Use the official Oracle distribution or an open-source distribution such as OpenJDK.

To check your Java version, run the following command:

java -version
On systems with Java installed, this command produces output similar to the following:

java version "11.0.1" 2018-10-16 LTS
Java(TM) SE Runtime Environment 18.9 (build 11.0.1+13-LTS)
Java HotSpot(TM) 64-Bit Server VM 18.9 (build 11.0.1+13-LTS, mixed mode)
On some Linux systems, you may also need to have the JAVA_HOME environment exported before attempting the install, particularly if you installed Java from a tarball. This is because Logstash uses Java during installation to automatically detect your environment and install the correct startup method (SysV init scripts, Upstart, or systemd). If Logstash is unable to find the JAVA_HOME environment variable during package installation time, you may get an error message, and Logstash will be unable to start properly.

Installing from a Downloaded Binaryedit
The Logstash binaries are available from https://www.elastic.co/downloads. Download the Logstash installation file for your host environment—​TARG.GZ, DEB, ZIP, or RPM.

Unpack the file. Do not install Logstash into a directory path that contains colon (:) characters.

These packages are free to use under the Elastic license. They contain open source and free commercial features and access to paid commercial features. Start a 30-day trial to try out all of the paid commercial features. See the Subscriptions page for information about Elastic license levels.

Alternatively, you can download an oss package, which contains only features that are available under the Apache 2.0 license.

On supported Linux operating systems, you can use a package manager to install Logstash.

Installing from Package Repositoriesedit
We also have repositories available for APT and YUM based distributions. Note that we only provide binary packages, but no source packages, as the packages are created as part of the Logstash build.

We have split the Logstash package repositories by version into separate urls to avoid accidental upgrades across major versions. For all 7.x.y releases use 7.x as version number.

We use the PGP key D88E42B4, Elastic’s Signing Key, with fingerprint

4609 5ACC 8548 582C 1A26 99A9 D27D 666C D88E 42B4
to sign all our packages. It is available from https://pgp.mit.edu.

APTedit
Download and install the Public Signing Key:

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
You may need to install the apt-transport-https package on Debian before proceeding:

sudo apt-get install apt-transport-https
Save the repository definition to /etc/apt/sources.list.d/elastic-7.x.list:

echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
Use the echo method described above to add the Logstash repository. Do not use add-apt-repository as it will add a deb-src entry as well, but we do not provide a source package. If you have added the deb-src entry, you will see an error like the following:

Unable to find expected entry 'main/source/Sources' in Release file (Wrong sources.list entry or malformed file)
Just delete the deb-src entry from the /etc/apt/sources.list file and the installation should work as expected.

Run sudo apt-get update and the repository is ready for use. You can install it with:

sudo apt-get update && sudo apt-get install logstash
See Running Logstash for details about managing Logstash as a system service.

YUMedit
Download and install the public signing key:

rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
Add the following in your /etc/yum.repos.d/ directory in a file with a .repo suffix, for example logstash.repo

[logstash-7.x]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
And your repository is ready for use. You can install it with:

sudo yum install logstash
The repositories do not work with older rpm based distributions that still use RPM v3, like CentOS5.

See the Running Logstash document for managing Logstash as a system service.

Installing Logstash on macOS with Homebrewedit
Elastic publishes Homebrew formulae so you can install Logstash with the Homebrew package manager.

To install with Homebrew, you first need to tap the Elastic Homebrew repository:

brew tap elastic/tap
After you’ve tapped the Elastic Homebrew repo, you can use brew install to install the default distribution of Logstash:

brew install elastic/tap/logstash-full
This installs the most recently released default distribution of Logstash. To install the OSS distribution, specify elastic/tap/logstash-oss.

Starting Logstash with Homebrewedit
To have launchd start elastic/tap/logstash-full now and restart at login, run:

brew services start elastic/tap/logstash-full
To run Logstash, in the foreground, run:


```sh
/usr/share/logstash/bin/logstash --path.settings /etc/logstash 
bin/logstash -f logstash-filter.conf
```

[Сбор и анализ логов с Fluentd](https://habr.com/ru/company/selectel/blog/250969/)