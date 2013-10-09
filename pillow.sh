#!/bin/bash

echo "  _____ _____ _      _      ______          __
 |  __ \_   _| |    | |    / __ \ \        / /
 | |__) || | | |    | |   | |  | \ \  /\  / / 
 |  ___/ | | | |    | |   | |  | |\ \/  \/ /  
 | |    _| |_| |____| |___| |__| | \  /\  /   
 |_|   |_____|______|______\____/   \/  \/
"

echo "Please enter your first and last names (e.g. John Doe):"
read NAME
echo "Now please tell us the email your registered with Github:"
read EMAIL
echo "PILLOW WILL PREPARE YOUR SYSTEM AND INSTALL NECESSARY SOFTWARE FOR YOU!"
read -p "Are you sure you want this? (Y/N) " -r

if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo ""
    exit 1
fi

echo "Updating your system..."
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y autoremove
echo "Now relax and go grab yourself a cup of coffee or a cold beer."
echo "When your system is ready, Pillow will let you know!"

echo "Installing Git..."
sudo apt-get -y install git
echo "Configuring Git..."
git config --global user.name="$NAME"
git config --global user.email="$EMAIL"

echo "Installing MySQL..."
sudo apt-get -y install mysql-client mysql-server

echo "Downloading Oracle's JDK 7..."
wget --no-cookies --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com" "http://download.oracle.com/otn-pub/java/jdk/7u40-b43/jdk-7u40-linux-x64.tar.gz"

echo "Installing Oracle's JDK 7..."
tar -xf jdk-7u40-linux-x64.tar.gz
sudo mkdir -p /usr/lib/jvm
sudo mv jdk1.7.0_40 /usr/lib/jvm/oracle-jdk-7

sudo sh -c "echo '\n' >> /etc/profile"
sudo sh -c "echo 'JAVA_HOME=/usr/lib/jvm/oracle-jdk-7' >> /etc/profile"
sudo sh -c "echo 'PATH=$PATH:$HOME/bin:$JAVA_HOME/bin' >> /etc/profile"
sudo sh -c "echo 'export JAVA_HOME' >> /etc/profile"
sudo sh -c "echo 'export PATH' >> /etc/profile"

sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/oracle-jdk-7/jre/bin/java" 1
sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/oracle-jdk-7/bin/javac" 1
sudo update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jvm/oracle-jdk-7/bin/javaws" 1

sudo update-alternatives --set java /usr/lib/jvm/oracle-jdk-7/jre/bin/java
sudo update-alternatives --set javac /usr/lib/jvm/oracle-jdk-7/bin/javac
sudo update-alternatives --set javaws /usr/lib/jvm/oracle-jdk-7/bin/javaws

sudo sh -c "echo 'JAVA_OPTS=\"-server -Xms256m -Xmx1024m -XX:PermSize=384m\"' >> /etc/profile"
sudo sh -c "echo 'export JAVA_OPTS' >> /etc/profile"

echo "Installing Maven..."
sudo apt-get -y install maven

echo "Configuring Maven..."
sudo sh -c "echo 'MAVEN_OPTS=$JAVA_OPTS' >> /etc/profile"
sudo sh -c "echo 'export MAVEN_OPTS' >> /etc/profile"

source /etc/profile

echo "Downloading Eclipse IDE..."
wget http://eclipse.dcc.fc.up.pt/technology/epp/downloads/release/kepler/SR1/eclipse-standard-kepler-SR1-linux-gtk-x86_64.tar.gz

echo "Installing Eclipse IDE..."
tar -xf eclipse-standard-kepler-SR1-linux-gtk-x86_64.tar.gz
mkdir -p software

wget https://raw.github.com/FenixEdu/fenix/master/EclipseFenixCodeSyle.xml
mv EclipseFenixCodeSyle.xml eclipse/

echo "Setting up your workspace..."
mkdir -p workspace
cd workspace
wget https://raw.github.com/davidmartinho/pillow/develop/eclipse-workspace-metadata.tar.gz
tar -xf eclipse-workspace-metadata.tar.gz
rm -rf eclipse-workspace-metadata.tar.gz
cd ..

mkdir -p eclipse/configuration/.settings
touch eclipse/configuration/.settings/org.eclipse.ui.ide.prefs
echo "MAX_RECENT_WORKSPACES=5" >> eclipse/configuration/.settings/org.eclipse.ui.ide.prefs
echo "RECENT_WORKSPACES=$HOME/workspace" >> eclipse/configuration/.settings/org.eclipse.ui.ide.prefs
echo "RECENT_WORKSPACES_PROTOCOL=3" >> eclipse/configuration/.settings/org.eclipse.ui.ide.prefs
echo "SHOW_WORKSPACE_SELECTION_DIALOG=false" >> eclipse/configuration/.settings/org.eclipse.ui.ide.prefs
echo "eclipse.preferences.version=1" >> eclipse/configuration/.settings/org.eclipse.ui.ide.prefs

mv eclipse software

echo "Congratulations!"
echo "Pillow has now finished setting up your system for development!"