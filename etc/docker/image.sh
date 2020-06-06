if ! [ -n "$GRAMCLI" ]; then
  echo "Run scripts using 'gram \$command'"; gram help
  exit 1
fi
art
DOCKERPLATFORM=$ARG1
DOCKERBUILDOPTIONS=$ARG2
SUPPORTED_DOCKER_PLATFORMS="(test|release|ubuntu_20.04|ubuntu_19.10|centos_7|centos_8|fedora_33|fedora_32|debian_buster-slim|debian_bullseye-slim)"

if ! [[ "$DOCKERPLATFORM" =~ $SUPPORTED_DOCKER_PLATFORMS ]]; then
  fail "docker image build" "invalid platform $DOCKERPLATFORM ${SUPPORTED_DOCKER_PLATFORMS}"
fi

if [ "$DOCKERPLATFORM" == "release" ]; then
  if ! [ -n "$UBUNTU" ] || ! [ "$VERSION_ID" == "20.04" ]; then
    fail "docker image build" "For release docker builds, you must be on Linux Ubuntu 20.04"
  fi
  ec "Cleaning everything and re-building to ensure a perfect release"
  git clean -fdX
  source gram build-docker-image
fi

test -w $GRAMCORE/Dockerfile && rm -f $GRAMCORE/Dockerfile
if [ "$DOCKERPLATFORM" == "test" ] || [ "$DOCKERPLATFORM" == "release" ]; then
  cp $GRAMCORE/dockerfiles/$DOCKERPLATFORM.dockerfile $GRAMCORE/Dockerfile
else
  echo "FROM ${DOCKERPLATFORM//_/:}" >> $GRAMCORE/Dockerfile
  cat $GRAMCORE/dockerfiles/_template.dockerfile >> $GRAMCORE/Dockerfile
fi

test -w $GRAMCORE/.dockerignore && rm -f $GRAMCORE/.dockerignore
cat $GRAMCORE/dockerfiles/test.dockerignore >> $GRAMCORE/.dockerignore
if [ "$DOCKERPLATFORM" != "test" ]; then
  cat $GRAMCORE/dockerfiles/debug.dockerignore >> $GRAMCORE/.dockerignore
fi
if [ "$DOCKERPLATFORM" == "release" ]; then
  cat $GRAMCORE/dockerfiles/release.dockerignore >> $GRAMCORE/.dockerignore
fi
docker build -t gram-net/gram-${DOCKERPLATFORM}:local --build-arg CACHEBUST=$(date +%s) $GRAMCORE $DOCKERBUILDOPTIONS