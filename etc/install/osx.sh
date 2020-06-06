if ! [ -n "$GRAMCLI" ]; then
  echo "Run scripts using 'gram \$command'"; gram help
  exit 1
fi
art
ec "Installing Brew and GRAM Basic Dependencies"

if ! [ $(command -v brew) ];then
  ec "Installing Homebrew"
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash -
fi

# these linux package names have different names in brew, but they are covered below:
# libghc-zlib-dev libreadline-dev libmicrohttpd-dev  libssl-dev libgflags-dev

# RedHat needs this weird double install for linuxbrew GCC
brew install gcc || : 
brew install gcc
brew upgrade gcc

# we break up the installation into individual pieces so we can read potential errors more easily
DEPSLIST="python tmux make cmake ccache vim tcpdump watch wget coreutils lzlib openssl zlib libmicrohttpd gperf gperftools gflags"

IFS=' ' # space is set as delimiter
read -ra TARG <<< "$DEPSLIST" # str is read into an array as tokens separated by IFS
for i in "${TARG[@]}"; do # access each element of array
  brew install $i || : 
  brew upgrade $i
done

ec "Done installing dependencies with brew"