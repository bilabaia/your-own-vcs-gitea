#!/bin/bash

echo
printf '%.s=' $(seq 1 $(tput cols))
echo
echo This script is about to get Gitea installed and running on your system
echo To successfully run this task few things need to be checked beforehand:
echo	1: curl should be installed
echo	2: wget should be installed
echo	3: SQLite3 should be installed - after this script execution your gitea will be ready to work with SQLite3.
echo 					 If other database should be used make sure it is installed and running before proceeding with gitea setup.
echo				         It that case additional options should be enabled in .service file, check it after setup for more info.
echo	4: this script should be running with sudo
echo
printf '%.s=' $(seq 1 $(tput cols))
echo

while true; do

read -p "Are you ready to proceed? (y/n)  " yn

case $yn in
	[yY] ) echo ok, lets move on;
		break;;
	[nN] ) echo exiting...;
		exit;;
	* ) echo response is not clear;;
esac
done

echo Adding gitea user to the system..
sudo adduser --system --group --disabled-password --home /opt/git --shell /bin/bash --gecos 'GitTea Version Control' gitea
echo OK gitea user ready.

echo Preparing work directories for gitea...
sudo mkdir -p /var/lib/gitea/{custom,data,indexers,public,log}
sudo chown git: /var/lib/gitea/{data,indexers,log}
sudo chmod 750 /var/lib/gitea/{data,indexers,log}

sudo mkdir /etc/gitea
sudo chown root:git /etc/gitea
sudo chmod 770 /etc/gitea
echo OK work directories ready.

# right now by deafault only amd64  version will be downloaded, to add other version option this section should be modified
echo getting last gitea version from repository...
curl -s https://api.github.com/repos/go-gitea/gitea/releases/latest |grep browser_download_url | cut -d '"' -f 4 | grep '\linux-amd64$' | wget -O /tmp/gitea -i -

sudo mv /tmp/gitea /usr/local/bin/gitea
sudo chmod +x /usr/local/bin/gitea
echo OK gitea files are ready.

# this is most basic example of gitea service file; 
# it should work without modifications if your database of choice is SQLite3;
# in case if other database should be used or your gitea will work with large amount of data please open this file with editor and uncomment necessary options
echo getting gitea service file...
sudo wget https://raw.githubusercontent.com/go-gitea/gitea/master/contrib/systemd/gitea.service -P /etc/systemd/system/
echo OK gitea service file ready

sudo systemctl daemon-reload
sudo systemctl start gitea
sudo systemctl enable gitea
echo OK gitea service enabled.
echo
echo To complete the setup next thing to do might be:
echo 	1: Check if your firewall ok with localhost and port :3000
echo	2: to go on localhost and via gitea welcome page connect to your database
echo
echo Cheers!
echo
