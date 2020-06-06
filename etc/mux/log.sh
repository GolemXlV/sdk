if ! [ -n "$GRAMCLI" ] || ! [ -n "$GRAMMUX" ]; then
  echo "Run mux scripts using 'gram console log"
  exit 1
fi

export SRCDIR=$GRAMCORE/

declare -a muxpanes

if [ "$DEPLOYTYPE" == "compose" ]; then
  PREFIX=gram
  SUFFIX=_1
  DOCKERPREFIX="docker exec -it ${PREFIX}_gram$SUFFIX"
elif [ "$DEPLOYTYPE" == "swarm" ]; then
  PREFIX=GRAM1
  SUFFIX=
  DOCKERPREFIX="docker exec -it ${PREFIX}_gram$SUFFIX"
fi

muxpanes+=("gram config-helper; gram help; ${DOCKERPREFIX} gram log/sync")
if [ -n "$RUNVALIDATOR" ]; then
  muxpanes+=("${DOCKERPREFIX} gram log/validator")
fi   
if [ -n "$RUNAPI" ]; then
  muxpanes+=("${DOCKERPREFIX} gram log/api")
fi   
if [ "$DEPLOYTYPE" != "metal" ]; then
  muxpanes+=("gram log/docker")
else
  muxpanes+=("${DOCKERPREFIX} watch -n 15 'pm2 ls'")
fi

export muxpanes

export LAYOUT="main-vertical"