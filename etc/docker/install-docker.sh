if ! [ -n "$GRAMCLI" ]; then
  echo "Run scripts using 'gram \$command'"; gram help
  exit 1
fi

# Block Windows and OSX from using this script
if ! [ -n "$LINUX" ]; then
  ec "This script is used for Linux distributions. Refer to the main README.md for installation on other platforms"
  exit 1;
fi

if ! [ -n "$APT" ]; then
  ec "This script does not support your Linux distribution. You need to install Docker on your own."
  exit 1;
fi

# > OR on other distros: `add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable edge test"`
#Next, update the package database with the Docker packages from the newly added repo:
apt-get update

apt-get install software-properties-common

# Add the GPG key for the official Docker repository to the system:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Add the Docker repository to APT sources:
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable edge"

# Make sure you are about to install from the Docker repo instead of the default repo:
apt-cache policy docker-ce

# install docker-ce
apt-get install -y docker-ce

# # allow docker to run without sudo
# groupadd docker
# usermod -aG docker $USER
# newgrp docker

# Download the Docker Compose binary into the /usr/local/bin directory with the following curl command:
curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose

#Once the download is complete, apply executable permissions to the Compose binary:
chmod +x /usr/bin/docker-compose

# Verify the installation by running the following command which will display the Compose version:
docker-compose --version

ec "REBOOT YOUR COMPUTER"