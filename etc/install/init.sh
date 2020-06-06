if ! [ -n "$GRAMCLI" ]; then
  echo "Run scripts using 'gram \$command'"; gram help
  exit 1
fi
art

if [ -n "$LINUX" ]; then
  # TODO add more Chinese mirrors
  if ! [ -n "$(grep cn.archive.ubuntu.com /etc/apt/sources.list)" ]; then
    if [ -n "$UBUNTU" ] && [ "$DOCKERBUILD" == "" ]; then
      ec "If you want to use a Chinese mirror, your sources list will need to change"
      echo "You can type 'yes' below to do this automatically"
      echo "archive.ubuntu.com will be changed to cn.archive.ubuntu in /etc/apt/sources.list"
      echo "THE CHANGE IS PERMANENT (type yes/no), leave blank for no"
      read USECHINAMIRROR
    fi
    if [ -n "$APT" ] && [ -n "$DOCKERBUILD" ] || [ "$USECHINAMIRROR" == "yes" ]; then
      sed -i'' -e "s/http:\/\/archive.ubuntu.com/http:\/\/cn.archive.ubuntu.com/g" /etc/apt/sources.list
    fi
  fi
  DEPSGLOBAL="vim tar git curl tmux chrony ca-certificates gnupg"
  DEPSDNF="python2"
  DEPSYUM="python2"
  DEPSAPT="build-essential python"

  ec "Updating Linux packages, upgrading Linux and installing essential packages"
  if [ -n "$DNF" ]; then
    dnf clean all
    dnf update -y
    dnf upgrade -y
    dnf  --setopt=install_weak_deps=False --best install -y $DEPSDNF $DEPSGLOBAL
  elif [ -n "$YUM" ]; then
    yum clean all
    yum update -y
    yum upgrade -y
    yum install -y $DEPSYUM $DEPSGLOBAL
  elif [ -n "$APT" ]; then
    export DEBIAN_FRONTEND=noninteractive
    export DEBCONF_FRONTEND=noninteractive
    apt-get update -y
    apt-get autoremove -y
    if [ -x dist-upgrade ]; then
      dist-upgrade -y
    else
      apt-get upgrade -y
    fi
    apt-get install -y --no-install-recommends python $DEPSAPT $DEPSGLOBAL
  else
    ec "Unknown Linux package manager configuration. Exiting..."
    exit 1;
  fi

  service chrony start || systemctl start chrony || systemctl start chronyd || : 
  service chronyd start || systemctl enable chrony || systemctl enable chronyd || : 

  ec "Setting file watcher limit"
  echo fs.inotify.max_user_watches=524288 | tee /etc/sysctl.d/40-max-user-watches.conf || :
  sysctl --system || : 
fi

if [ -n "$OSX" ]; then
  if ! [ $(command -v brew) ];then
    ec "Installing Homebrew"
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash -
  fi

  # Install python and tmux, and test that brew is working
  brew install python tmux || echo "brew install ugly false exit"
  brew upgrade python tmux
fi

source $GRAMCORE/bin/gram nodejs

ec "GRAM has been installed. Exit your login shell and reconnect, then run 'gram deploy' or 'gram help'"