if ! [ -n "$GRAMCLI" ]; then
  echo "Run scripts using 'gram \$command'"; gram help
  exit 1
fi
  
if ! [ -n "$LINUX" ]; then
  fail "Installing linux deps" "not on Linux operating system"
fi

if ! [ -n "$DOCKERBUILD" ] && ! [ -e /swapfile ]; then
  ec "Creating a 4GB swap file"
  dd if=/dev/zero of=/swapfile bs=4096 count=1048576
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
fi

ec "Installing Linux dependencies"
# notice that some packages are per-platform and are managed in the IF blocks
# That means right now, it's very likely that YUM/DNF versions do not actually work
DEPSINSTALL="vim git curl tmux"
DEPSGLOBAL="tar chrony make wget cmake gcc vim tmux tcpdump net-tools"
DEPSDNF="zlib-devel glibc-headers readline-devel libmicrohttpd openssl-devel gperftools-devel gflags-devel"
DEPSYUM="zlib-devel glibc-headers readline-devel libmicrohttpd openssl-devel gperftools-devel gflags-devel"
DEPSAPT="build-essential libghc-zlib-dev libreadline-dev libmicrohttpd-dev libssl-dev libgflags-dev gperf"
# stuff we have not figured out:
# ccache

export DEBIAN_FRONTEND=noninteractive
export DEBCONF_FRONTEND=noninteractive

if [ -n "$AMZN" ]; then
  amazon-linux-extras install -y epel
fi

if [ -n "$DNF" ]; then
  dnf install -y --setopt=install_weak_deps=False --best dnf-plugins-core
  dnf install -y --setopt=install_weak_deps=False https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
  # if you're on RHEL, you might want to add this
  # subscription-manager repos --enable "codeready-builder-for-rhel-8-*-rpms"
  dnf config-manager --set-enabled PowerTools
  dnf --setopt=install_weak_deps=False --best install -y ${DEPSINSTALL} ${DEPSGLOBAL} ${DEPSDNF}
elif [ -n "$YUM" ]; then
  yum install -y epel-release
  if ! [ -n "$AMZN" ]; then
    yum config-manager --set-enabled PowerTools
  fi
  yum install -y ${DEPSINSTALL} ${DEPSGLOBAL} ${DEPSYUM}
elif [ -n "$APT" ]; then
  apt-get install -y --no-install-recommends ${DEPSINSTALL} ${DEPSGLOBAL} ${DEPSAPT}
fi
