if ! [ -n "$GRAMCLI" ]; then
  echo "Run scripts using 'gram \$command'"; gram help
  exit 1
fi
if [ -n "$DOCKERBUILD" ]; then
  fail "Deploy" "cannot use this script when building docker images"
fi
art
ZEROSTATESCRIPT=$ARG1
# source gram shutdown || : 

OLD_NODETYPE=$NODETYPE
# blank env file
if ! [ -e $GRAMCORE/.env ]; then
  source gram env
elif ! [ -n "$DOCKERBUILD" ]; then
  ec "Current Environment:"
  cat $GRAMCORE/.env
  ENVUPDATE=
  while [ "$ENVUPDATE" != "yes" ] && [ "$ENVUPDATE" != "no" ]; do
    ec "Do you wish to update your environment? yes/no (press enter for no)"
    read ENVUPDATE
    if ! [ -n "$ENVUPDATE" ]; then ENVUPDATE="no"; fi
  done
  if [ "$ENVUPDATE" == "yes" ]; then
    source gram env
  fi
fi
if [ "$OLD_NODETYPE" != "$NODETYPE" ]; then
  ec "Switching node type to ${NODETYPE} requires new key generation"
  test -e $PROFILE/.profile-done && rm -f $PROFILE/.profile-done
  if [ "$NODETYPE" == "regtest" ]; then
    ec "Switching node type to regtest requires clearing TONDB" 
    CLEARTONDB="yes"
  fi
fi

if [ -n "$RUNVALIDATOR" ]; then
  if [ -e $GRAMCORE/.compile-done ]; then
    while [ "$COMPILEUPDATE" != "yes" ] && [ "$COMPILEUPDATE" != "no" ]; do
      ec "Do you wish to re-compile TON binaries? yes/no (press enter for no)"
      read COMPILEUPDATE
      if ! [ -n "$COMPILEUPDATE" ]; then COMPILEUPDATE="no"; fi
    done
  fi
  if [ "$COMPILEUPDATE" == "yes" ] || ! [ -e $GRAMCORE/.compile-done ]; then
    ec "Compiling TON binaries"
    if [ -n "$LINUX" ]; then source gram linux; fi
    if [ -n "$OSX" ]; then source gram osx; fi
    source gram compile release_fresh
    echo "DONE" >> $GRAMCORE/.compile-done
  fi
fi
if [ -e $PROFILE/.profile-done ]; then
  while [ "$PROFILEUPDATE" != "yes" ] && [ "$PROFILEUPDATE" != "no" ]; do
    ec "Do you wish to clear your profile and keys? yes/no (press enter for no)"
    read PROFILEUPDATE
    if ! [ -n "$PROFILEUPDATE" ]; then PROFILEUPDATE="no"; fi
  done
fi

if [ "$DEPLOYTYPE" == "metal" ]; then
  source gram build-api esmodules
  BUILDNAV=
  while [ "$BUILDNAV" != "yes" ] && [ "$BUILDNAV" != "no" ]; do
    ec "Do you wish to re-build GRAM navigator? yes/no (press enter for no)"
    read BUILDNAV
    if ! [ -n "$BUILDNAV" ]; then BUILDNAV="no"; fi
  done
  if [ "$BUILDNAV" == "yes" ]; then # || ! [ -e $GRAMCORE/navigator/src-cordova/www/index.html ]
    source gram build-api navigator
  else
    source gram build-api navigator dev
  fi

  if [ "$PROFILEUPDATE" == "yes" ] || ! [ -e $PROFILE/.profile-done ]; then
    if [ "$NODETYPE" == "regtest" ]; then
      ec "Rebuilding regtest profile requires clearing TONDB" 
      CLEARTONDB="yes"
    fi  
    test -d $PROFILE && rm -rf $PROFILE
    source gram ${NODETYPE} $ZEROSTATESCRIPT
    rm -rf **/*-e > /dev/null 2>&1
    echo "DONE" >> $PROFILE/.profile-done  
  fi
fi
if [ -e $TONDB/config.json ]; then
  while [ "$CLEARTONDB" != "yes" ] && [ "$CLEARTONDB" != "no" ]; do
    ec "Do you wish to clear blockchain database? yes/no (press enter for no)"
    read CLEARTONDB
    if ! [ -n "$CLEARTONDB" ]; then CLEARTONDB="no"; fi
  done
fi
if [ "$CLEARTONDB" == "yes" ] && [ -e $TONDB/config.json ]; then
  test -d $GRAMCORE/tondb-tmp && rm -rf $GRAMCORE/tondb-tmp
  mkdir $GRAMCORE/tondb-tmp
  cp -r $TONDB/config.json $GRAMCORE/tondb-tmp
  cp -r $TONDB/keyring $GRAMCORE/tondb-tmp
  cp -r $TONDB/static $GRAMCORE/tondb-tmp
  test -d $TONDB && rm -rf $TONDB
  cp -r $GRAMCORE/tondb-tmp $TONDB
  rm -rf $GRAMCORE/tondb-tmp
fi

# pull latest image
if [[ "$IMAGEURI" =~ (gitlab|github|http) ]]; then
  ec "Pulling image"
  docker pull $IMAGEURI
fi

# check build
if [ "$DEPLOYTYPE" == "compose" ]; then
  docker-compose up -d
elif [ "$DEPLOYTYPE" == "swarm" ]; then
  source gram deploystack Force $GRAMCORE/docker-compose.yml
elif [ "$DEPLOYTYPE" == "metal" ]; then
  source gram launch
else
  fail "Deploy" "Unknown DEPLOYTYPE"
fi
echo "http://${GRAM_IP}:${DOCS_PORT}/#/ for Docs"
echo "http://${GRAM_IP}:${NAV_PORT} for GRAM Navigator"
echo "'gram mux' for terminal logs"