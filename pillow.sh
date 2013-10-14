#!/bin/bash

echo "  _____ _____ _      _      ______          __
 |  __ \_   _| |    | |    / __ \ \        / /
 | |__) || | | |    | |   | |  | \ \  /\  / / 
 |  ___/ | | | |    | |   | |  | |\ \/  \/ /  
 | |    _| |_| |____| |___| |__| | \  /\  /   
 |_|   |_____|______|______\____/   \/  \/
"

read -ep "Please enter your first and last names (e.g. John Doe):" NAME
read -ep "Now please tell us the email your registered with Github:" EMAIL
echo "PILLOW WILL PREPARE YOUR SYSTEM AND INSTALL NECESSARY SOFTWARE FOR YOU!"
read -p "Are you sure you want this? (Y/N) " -r

if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo ""
    exit 1
fi

echo "[Pillow] Updating your system..."
sudo apt-get -y -qq update
echo "[Pillow] Upgrading your system...(this may take a while)"
sudo apt-get -y -qq upgrade
echo "[Pillow] Cleaning up unnecessary software..."
sudo apt-get -y -qq autoremove

echo "Now relax and go grab yourself a cup of coffee or a cold beer."
echo "When your system is ready, Pillow will let you know!"
echo ""

echo "[Pillow] Installing Git..."
sudo apt-get -y -qq install git
echo "[Pillow] Configuring Git..."
git config --global user.name "$NAME"
git config --global user.email "$EMAIL"

echo "[Pillow] Installing MySQL..."
sudo apt-get -y -qq install mysql-client

echo "[Pillow] Downloading Oracle's JDK 7..."
wget --no-cookies --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com" "http://download.oracle.com/otn-pub/java/jdk/7u40-b43/jdk-7u40-linux-x64.tar.gz"

echo "[Pillow] Installing Oracle's JDK 7..."
tar -xf jdk-7u40-linux-x64.tar.gz
rm -rf jdk-7u40-linux-x64.tar.gz
sudo mkdir -p /usr/lib/jvm
sudo mv jdk1.7.0_40 /usr/lib/jvm/oracle-jdk-7

sudo sh -c "echo '\n' >> .bashrc"
sudo sh -c "echo 'JAVA_HOME=/usr/lib/jvm/oracle-jdk-7' >> .bashrc"
sudo sh -c "echo 'PATH=$PATH:$HOME/bin:$JAVA_HOME/bin' >> .bashrc"
sudo sh -c "echo 'export JAVA_HOME' >> .bashrc"
sudo sh -c "echo 'export PATH' >> .bashrc"

sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/oracle-jdk-7/jre/bin/java" 1
sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/oracle-jdk-7/bin/javac" 1
sudo update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jvm/oracle-jdk-7/bin/javaws" 1

sudo update-alternatives --set java /usr/lib/jvm/oracle-jdk-7/jre/bin/java
sudo update-alternatives --set javac /usr/lib/jvm/oracle-jdk-7/bin/javac
sudo update-alternatives --set javaws /usr/lib/jvm/oracle-jdk-7/bin/javaws

sudo sh -c "echo 'JAVA_OPTS=\"-server -Xms256m -Xmx1024m -XX:PermSize=384m\"' >> .bashrc"
sudo sh -c "echo 'export JAVA_OPTS' >> .bashrc"

echo "[Pillow] Installing Maven..."
sudo apt-get -y -qq install maven

echo "[Pillow] Configuring Maven..."
sudo sh -c "echo 'MAVEN_OPTS=\$JAVA_OPTS' >> .bashrc"
sudo sh -c "echo 'export MAVEN_OPTS' >> .bashrc"

echo "[Pillow] Downloading Eclipse IDE..."
wget http://eclipse.dcc.fc.up.pt/technology/epp/downloads/release/kepler/SR1/eclipse-java-kepler-SR1-linux-gtk-x86_64.tar.gz

echo "[Pillow] Installing Eclipse IDE..."
tar -xf eclipse-java-kepler-SR1-linux-gtk-x86_64.tar.gz
rm -rf eclipse-java-kepler-SR1-linux-gtk-x86_64.tar.gz
mkdir -p software

mv eclipse software

wget https://raw.github.com/FenixEdu/fenix/master/EclipseFenixCodeSyle.xml
mv EclipseFenixCodeSyle.xml software/eclipse/

echo "[Pillow] Setting up your workspace..."
mkdir -p workspace
cd workspace
wget https://raw.github.com/davidmartinho/pillow/develop/eclipse-workspace-metadata.tar.gz
tar -xf eclipse-workspace-metadata.tar.gz
rm -rf eclipse-workspace-metadata.tar.gz
cd ..

mkdir -p software/eclipse/configuration/.settings
touch software/eclipse/configuration/.settings/org.eclipse.ui.ide.prefs
echo "MAX_RECENT_WORKSPACES=5" >> software/eclipse/configuration/.settings/org.eclipse.ui.ide.prefs
echo "RECENT_WORKSPACES=$HOME/workspace" >> software/eclipse/configuration/.settings/org.eclipse.ui.ide.prefs
echo "RECENT_WORKSPACES_PROTOCOL=3" >> software/eclipse/configuration/.settings/org.eclipse.ui.ide.prefs
echo "SHOW_WORKSPACE_SELECTION_DIALOG=false" >> software/eclipse/configuration/.settings/org.eclipse.ui.ide.prefs
echo "eclipse.preferences.version=1" >> software/eclipse/configuration/.settings/org.eclipse.ui.ide.prefs

chown -R $SUDO_USER:$SUDO_USER .bashrc
chown -R $SUDO_USER:$SUDO_USER workspace
chown -R $SUDO_USER:$SUDO_USER software

echo "Congratulations!"
echo "Pillow has now finished setting up your system for development!"