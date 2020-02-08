# Install Elasticsearch with RPM (https://www.elastic.co/guide/en/elasticsearch/reference/current/rpm.html)
The RPM for Elasticsearch can be downloaded from our website or from our RPM repository. It can be used to install Elasticsearch on any RPM-based system such as OpenSuSE, SLES, Centos, Red Hat, and Oracle Enterprise.

RPM install is not supported on distributions with old versions of RPM, such as SLES 11 and CentOS 5. Please see Install Elasticsearch from archive on Linux or MacOS instead.

This package is free to use under the Elastic license. It contains open source and free commercial features and access to paid commercial features. Start a 30-day trial to try out all of the paid commercial features. See the Subscriptions page for information about Elastic license levels.

The latest stable version of Elasticsearch can be found on the Download Elasticsearch page. Other versions can be found on the Past Releases page.

Elasticsearch includes a bundled version of OpenJDK from the JDK maintainers (GPLv2+CE). To use your own version of Java, see the JVM version requirements

```sh
su -c "yum install java-1.8.0-openjdk"
```
### Import the Elasticsearch PGP Keyedit
We sign all of our packages with the Elasticsearch Signing Key (PGP key D88E42B4, available from https://pgp.mit.edu) with fingerprint:

4609 5ACC 8548 582C 1A26 99A9 D27D 666C D88E 42B4
Download and install the public signing key:

rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
Installing from the RPM repositoryedit
Create a file called elasticsearch.repo in the /etc/yum.repos.d/ directory for RedHat based distributions, or in the /etc/zypp/repos.d/ directory for OpenSuSE based distributions, containing:

[elasticsearch]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=0
autorefresh=1
type=rpm-md


And your repository is ready for use. You can now install Elasticsearch with one of the following commands:

sudo yum install --enablerepo=elasticsearch elasticsearch 
sudo dnf install --enablerepo=elasticsearch elasticsearch 
sudo zypper modifyrepo --enable elasticsearch && \
  sudo zypper install elasticsearch; \
  sudo zypper modifyrepo --disable elasticsearch 

Use yum on CentOS and older Red Hat based distributions.


Use dnf on Fedora and other newer Red Hat distributions.


Use zypper on OpenSUSE based distributions

The configured repository is disabled by default. This eliminates the possibility of accidentally upgrading elasticsearch when upgrading the rest of the system. Each install or upgrade command must explicitly enable the repository as indicated in the sample commands above.

An alternative package which contains only features that are available under the Apache 2.0 license is also available. To install it, use the following baseurl in your elasticsearch.repo file:

baseurl=https://artifacts.elastic.co/packages/oss-7.x/yum
Download and install the RPM manuallyedit
The RPM for Elasticsearch v7.5.0 can be downloaded from the website and installed as follows:

wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.5.0-x86_64.rpm
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.5.0-x86_64.rpm.sha512
shasum -a 512 -c elasticsearch-7.5.0-x86_64.rpm.sha512 
sudo rpm --install elasticsearch-7.5.0-x86_64.rpm

Compares the SHA of the downloaded RPM and the published checksum, which should output elasticsearch-{version}-x86_64.rpm: OK.

Alternatively, you can download the following package, which contains only features that are available under the Apache 2.0 license: https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-7.5.0-x86_64.rpm

On systemd-based distributions, the installation scripts will attempt to set kernel parameters (e.g., vm.max_map_count); you can skip this by masking the systemd-sysctl.service unit.

Enable automatic creation of system indicesedit
Some commercial features automatically create system indices within Elasticsearch. By default, Elasticsearch is configured to allow automatic index creation, and no additional steps are required. However, if you have disabled automatic index creation in Elasticsearch, you must configure action.auto_create_index in elasticsearch.yml to allow the commercial features to create the following indices:

action.auto_create_index: .monitoring*,.watches,.triggered_watches,.watcher-history*,.ml*
If you are using Logstash or Beats then you will most likely require additional index names in your action.auto_create_index setting, and the exact value will depend on your local configuration. If you are unsure of the correct value for your environment, you may consider setting the value to * which will allow automatic creation of all indices.

SysV init vs systemdedit
Elasticsearch is not started automatically after installation. How to start and stop Elasticsearch depends on whether your system uses SysV init or systemd (used by newer distributions). You can tell which is being used by running this command:

ps -p 1
Running Elasticsearch with SysV initedit
Use the chkconfig command to configure Elasticsearch to start automatically when the system boots up:

sudo chkconfig --add elasticsearch
Elasticsearch can be started and stopped using the service command:

sudo -i service elasticsearch start
sudo -i service elasticsearch stop
If Elasticsearch fails to start for any reason, it will print the reason for failure to STDOUT. Log files can be found in /var/log/elasticsearch/.

Running Elasticsearch with systemdedit
To configure Elasticsearch to start automatically when the system boots up, run the following commands:

sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
Elasticsearch can be started and stopped as follows:

sudo systemctl start elasticsearch.service
sudo systemctl stop elasticsearch.service
These commands provide no feedback as to whether Elasticsearch was started successfully or not. Instead, this information will be written in the log files located in /var/log/elasticsearch/.

By default the Elasticsearch service doesn’t log information in the systemd journal. To enable journalctl logging, the --quiet option must be removed from the ExecStart command line in the elasticsearch.service file.

When systemd logging is enabled, the logging information are available using the journalctl commands:

To tail the journal:

sudo journalctl -f
To list journal entries for the elasticsearch service:

sudo journalctl --unit elasticsearch
To list journal entries for the elasticsearch service starting from a given time:

sudo journalctl --unit elasticsearch --since  "2016-10-30 18:17:16"
Check man journalctl or https://www.freedesktop.org/software/systemd/man/journalctl.html for more command line options.

Checking that Elasticsearch is runningedit
You can test that your Elasticsearch node is running by sending an HTTP request to port 9200 on localhost:

GET /
Copy as cURL
View in Console

```sh
 curl localhost:9200
```
which should give you a response something like this:

{
  "name" : "Cp8oag6",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "AT69_T_DTp-1qgIJlatQqA",
  "version" : {
    "number" : "7.5.0",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "f27399d",
    "build_date" : "2016-03-30T09:51:41.449Z",
    "build_snapshot" : false,
    "lucene_version" : "8.3.0",
    "minimum_wire_compatibility_version" : "1.2.3",
    "minimum_index_compatibility_version" : "1.2.3"
  },
  "tagline" : "You Know, for Search"
}
Configuring Elasticsearchedit
Elasticsearch defaults to using /etc/elasticsearch for runtime configuration. The ownership of this directory and all files in this directory are set to root:elasticsearch on package installation and the directory has the setgid flag set so that any files and subdirectories created under /etc/elasticsearch are created with this ownership as well (e.g., if a keystore is created using the keystore tool). It is expected that this be maintained so that the Elasticsearch process can read the files under this directory via the group permissions.

Elasticsearch loads its configuration from the /etc/elasticsearch/elasticsearch.yml file by default. The format of this config file is explained in Configuring Elasticsearch.

The RPM also has a system configuration file (/etc/sysconfig/elasticsearch), which allows you to set the following parameters:

JAVA_HOME

Set a custom Java path to be used.

MAX_OPEN_FILES

Maximum number of open files, defaults to 65535.

MAX_LOCKED_MEMORY

Maximum locked memory size. Set to unlimited if you use the bootstrap.memory_lock option in elasticsearch.yml.

MAX_MAP_COUNT

Maximum number of memory map areas a process may have. If you use mmapfs as index store type, make sure this is set to a high value. For more information, check the linux kernel documentation about max_map_count. This is set via sysctl before starting Elasticsearch. Defaults to 262144.

ES_PATH_CONF

Configuration file directory (which needs to include elasticsearch.yml, jvm.options, and log4j2.properties files); defaults to /etc/elasticsearch.

ES_JAVA_OPTS

Any additional JVM system properties you may want to apply.

RESTART_ON_UPGRADE

Configure restart on package upgrade, defaults to false. This means you will have to restart your Elasticsearch instance after installing a package manually. The reason for this is to ensure, that upgrades in a cluster do not result in a continuous shard reallocation resulting in high network traffic and reducing the response times of your cluster.

Distributions that use systemd require that system resource limits be configured via systemd rather than via the /etc/sysconfig/elasticsearch file. See Systemd configuration for more information.

Directory layout of RPMedit
The RPM places config files, logs, and the data directory in the appropriate locations for an RPM-based system:

Type	Description	Default Location	Setting
home

Elasticsearch home directory or $ES_HOME

/usr/share/elasticsearch

 
bin

Binary scripts including elasticsearch to start a node and elasticsearch-plugin to install plugins

/usr/share/elasticsearch/bin

 
conf

Configuration files including elasticsearch.yml

/etc/elasticsearch

ES_PATH_CONF

conf

Environment variables including heap size, file descriptors.

/etc/sysconfig/elasticsearch

 
data

The location of the data files of each index / shard allocated on the node. Can hold multiple locations.

/var/lib/elasticsearch

path.data

jdk

The bundled Java Development Kit used to run Elasticsearch. Can be overriden by setting the JAVA_HOME environment variable in /etc/sysconfig/elasticsearch.

/usr/share/elasticsearch/jdk

 
logs

Log files location.

/var/log/elasticsearch

path.logs

plugins

Plugin files location. Each plugin will be contained in a subdirectory.

/usr/share/elasticsearch/plugins

 
repo

Shared file system repository locations. Can hold multiple locations. A file system repository can be placed in to any subdirectory of any directory specified here.

Not configured

path.repo

Next stepsedit
You now have a test Elasticsearch environment set up. Before you start serious development or go into production with Elasticsearch, you must do some additional setup:
